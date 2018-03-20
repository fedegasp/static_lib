//
//  MRNotifyingObject.h
//  MRBase
//
//  Created by Federico Gasperini on 13/10/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ARRAY_ACCESSORS(P, CP) \
- (NSUInteger)countOf ## CP \
{\
    return [_ ## P count];\
}\
\
- (id)objectIn ## CP ## AtIndex:(NSUInteger)index\
{\
    return [_ ## P objectAtIndex:index];\
}\
\
- (void)insertObject:(id)obj in ## CP ## AtIndex:(NSUInteger)index {\
    if (NSNotFound == index) \
        index = _ ## P.count;\
    [(NSMutableArray*)_ ## P insertObject:obj atIndex:index];\
}\
-(void)insert ## CP:(NSArray *)array atIndexes:(NSIndexSet *)indexes {\
    NSUInteger currentIndex = MIN([indexes indexGreaterThanOrEqualToIndex:0], array.count);\
    \
    for (id obj in array)\
    {\
        [(NSMutableArray*)_ ## P insertObject:obj atIndex:currentIndex];\
        currentIndex = MIN([indexes indexGreaterThanIndex:currentIndex], _ ## P.count);\
    }\
}\
\
- (void)removeObjectFrom ## CP ## AtIndex:(NSUInteger)index {\
    if (index < _ ## P.count)\
        [(NSMutableArray*)_ ## P removeObjectAtIndex:index];\
}\
\
- (void)replaceObjectIn ## CP ## AtIndex:(NSUInteger)index withObject:(id)obj {\
    if (index < _ ## P.count)\
        [(NSMutableArray*)_ ## P replaceObjectAtIndex:index withObject:obj];\
}\
\
- (void)insert ## CP:(id)obj {\
    [self insertObject:(id)obj in ## CP ## AtIndex:0]; \
}\
\
- (void)delete ## CP:(id)obj {\
    NSUInteger idx = [_ ## P indexOfObject:obj];\
    if (idx != NSNotFound)\
        [self removeObjectFrom ## CP ## AtIndex:idx];\
}\
\
- (void)clear ## CP {\
    [self willChange:NSKeyValueChangeRemoval \
    valuesAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [_ ## P count])] \
forKey:NSStringFromSelector(@selector( P ))];\
    [(NSMutableArray*)_ ## P  removeAllObjects]; \
    [self didChange:NSKeyValueChangeRemoval \
    valuesAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [_ ## P count])] \
forKey:NSStringFromSelector(@selector( P ))];\
}

#define DECL_ARRAY_ACCESSORS(CLASS, P, CP)\
@property (nonatomic, readonly, nonnull) NSArray<CLASS*>* P;\
- (void)insert ## CP:(CLASS* _Nonnull)P;\
- (void)delete ## CP:(CLASS* _Nonnull)P;

@interface MRNotifyingObject : NSObject

-(void)stopNotify:(id)obj onChange:(NSString*)key;
-(void)notify:(id)obj onChange:(NSString*)key;
-(void)notify:(id)obj onChange:(NSString*)key suppressOnRegistration:(BOOL)suppress;

-(void)stopNotifyOnChange:(id)obj;
-(void)notifyOnChange:(id)obj;
-(void)notifyOnChange:(id)obj suppressOnRegistration:(BOOL)suppress;

-(void)onAnyChangeHook:(NSString*)key;

-(void)stopNotifyOnChange:(id)obj;
-(void)notifyOnChange:(id)obj;

-(void)onAnyChangeHook:(NSString*)key;

@end

