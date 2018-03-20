//
//  MRNotifyingObject.m
//  MRBase
//
//  Created by Federico Gasperini on 13/10/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "MRNotifyingObject.h"
#import <objc/message.h>

NSString* const kWidlcard = @"*";

@implementation MRNotifyingObject
{
    NSMutableDictionary* _observers;
}

-(instancetype) init
{
    self = [super init];
    if (self)
    {
        _observers = [NSMutableDictionary new];
        for (NSString* key in [[self class] allPropertyNames])
        {
            [self addObserver:self
                   forKeyPath:key
                      options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                      context:(__bridge void * _Nullable)(self)];
        }
    }
    return self;
}

+ (NSArray *)allPropertyNames
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList(self, &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
    
    free(properties);
    
    return rv;
}

-(void)stopNotify:(id)obj onChange:(NSString*)key
{
    NSHashTable* ht = _observers[key];
    [ht removeObject:obj];
}

-(void)notify:(id)obj onChange:(NSString*)key
{
    [self notify:obj onChange:key suppressOnRegistration:NO];
}

-(void)notify:(id)obj onChange:(NSString*)key suppressOnRegistration:(BOOL)suppress
{
    NSAssert([obj respondsToSelector:[self selectorForKeyChange:key]],
             @"%@ does not implement %@",
             NSStringFromClass([obj class]),
             NSStringFromSelector([self selectorForKeyChange:key]));
    if ([obj respondsToSelector:[self selectorForKeyChange:key]])
    {
        NSHashTable* ht = _observers[key];
        if (nil == ht)
        {
            ht = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality
                                             capacity:10];
            _observers[key] = ht;
        }
        if (![ht containsObject:obj])
        {
            [ht addObject:obj];
            if (!suppress)
                [self notify:obj forKey:key];
        }
    }
}

-(void)onAnyChangeHook:(NSString*)key
{
    
}

-(void)notify:(id)obj forKey:(NSString*)key
{
    [self onAnyChangeHook:key];
    typedef void(*NotifySignature)(id, SEL, id);
    static NotifySignature notify = (NotifySignature)objc_msgSend;
    notify(obj, [self selectorForKeyChange:key], self);
}

-(void)stopNotifyOnChange:(id)obj
{
    [self stopNotify:obj onChange:kWidlcard];
}

-(void)notifyOnChange:(id)obj
{
    [self notify:obj onChange:kWidlcard suppressOnRegistration:NO];
}

-(void)notifyOnChange:(id)obj suppressOnRegistration:(BOOL)suppress
{
    [self notify:obj onChange:kWidlcard suppressOnRegistration:suppress];
}

-(SEL)selectorForKeyChange:(NSString*)key
{
    if (key == kWidlcard)
        return NSSelectorFromString([NSString stringWithFormat:@"propertyOf%@DidChange:", NSStringFromClass(self.class)]);

    return NSSelectorFromString([NSString stringWithFormat:@"%@DidChange:", key]);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == (__bridge void * _Nullable)(self))
    {
        id oldValue = change[NSKeyValueChangeOldKey];
        id newValue = change[NSKeyValueChangeNewKey];
        if (nil != change[NSKeyValueChangeIndexesKey] ||
            (((nil != oldValue) ^ (nil != newValue)) ||
            ![newValue isEqual:oldValue]))
        {
            NSMutableSet* notified = [[NSMutableSet alloc] init];
            for (id obj in _observers[keyPath])
            {
                [self notify:obj forKey:keyPath];
                [notified addObject:obj];
            }
            for (id obj in _observers[kWidlcard])
                if (![notified containsObject:obj])
                    [self notify:obj forKey:kWidlcard];
        }
    }
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

-(void)dealloc
{
    @try {
        for (NSString* key in [[self class] allPropertyNames])
            [self removeObserver:self
                      forKeyPath:key
                         context:(__bridge void * _Nullable)(self)];
    } @catch (NSException *exception) {
    } @finally {
    }
}

@end
