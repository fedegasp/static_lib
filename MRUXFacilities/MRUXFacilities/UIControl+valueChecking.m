//
//  UIControl+valueChecking.m
//  ikframework
//
//  Created by Federico Gasperini on 13/03/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import "UIControl+valueChecking.h"
#import <objc/runtime.h>
#import "UIView+errorStateView.h"
#import <MRBase/MRWeakWrapper.h>


@interface UIControl ()

-(id)_valueToAssign;

@end


static void const* _errorColor_ = &_errorColor_;
static void const* _key_ = &_key_;
static void const* _tBlock_ = &_tBlock_;
static void const* _weakTable_ = &_weakTable_;

NSString* const _weakKeyForBean_ = @"_weakKeyForBean_";
NSString* const _weakKeyForErrorStateView_ = @"_weakKeyForErrorStateView_";

@implementation UIControl (valueChecking)

-(id)valueToAssign:(NSError* __autoreleasing*)error
{
   if ([self respondsToSelector:@selector(_valueToAssign)])
   {
      if (self.transformBlock)
         return self.transformBlock([self _valueToAssign], error);
      return [self _valueToAssign];
   }
   return nil;
}

-(UIControlEvents)designedControlEvent
{
   return UIControlEventAllEditingEvents;
}

#pragma mark - Properties

-(void)setCurrentError:(NSError *)currentError
{
   objc_setAssociatedObject(self, @selector(currentError), currentError, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSError*)currentError
{
   return objc_getAssociatedObject(self, @selector(currentError));
}

-(void)setErrorColor:(UIColor *)errorColor
{
   objc_setAssociatedObject(self, _errorColor_, errorColor, OBJC_ASSOCIATION_RETAIN);
}

-(UIColor*)errorColor
{
   UIColor* color = objc_getAssociatedObject(self, _errorColor_);
   if (!color)
      color = [UIColor redColor];
   return color;
}

-(void)setTransformBlock:(ValueToAssignTransformBlock)transformBlock
{
   objc_setAssociatedObject(self, _tBlock_, transformBlock, OBJC_ASSOCIATION_COPY);
}

-(ValueToAssignTransformBlock)transformBlock
{
   return objc_getAssociatedObject(self, _tBlock_);
}

-(void)setBean:(NSObject *)bean
{
   NSMapTable* mTable = objc_getAssociatedObject(self, _weakTable_);
   if (!mTable && bean)
   {
      mTable = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory
                                     valueOptions:NSPointerFunctionsWeakMemory];
      objc_setAssociatedObject(self, _weakTable_, mTable, OBJC_ASSOCIATION_RETAIN);
   }
   if (bean)
      [mTable setObject:bean forKey:_weakKeyForBean_];
   else
      [mTable removeObjectForKey:_weakKeyForBean_];
}

-(NSObject*)bean
{
   NSMapTable* mTable = objc_getAssociatedObject(self, _weakTable_);
   return [mTable objectForKey:_weakKeyForBean_];
}

-(void)setErrorStateView:(UIView<ErrorStateView> *)errorStateView
{
    
   [errorStateView clearErrorState];
   objc_setAssociatedObject(self, @selector(errorStateView),
                            [MRWeakWrapper weakWrapperWithObject:errorStateView],
                            OBJC_ASSOCIATION_RETAIN);
}

-(UIView<ErrorStateView>*)errorStateView
{
   MRWeakWrapper* w = objc_getAssociatedObject(self, @selector(errorStateView));
   return [w object];
}

-(void)setKey:(NSString *)key
{
   objc_setAssociatedObject(self, _key_, key, OBJC_ASSOCIATION_RETAIN);
}

-(NSString*)key
{
   return objc_getAssociatedObject(self, _key_);
}

@end


#pragma mark - [UITextField _valueToAssign]

@implementation UITextField (private_valueChecking)

-(id)_valueToAssign
{
   NSString* v = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
   v = v.length > 0 ? v : nil;
   return v;
}

-(UIControlEvents)designedControlEvent
{
   return UIControlEventEditingDidEnd;
}

@end


#pragma mark - [UITextView _valueToAssign]

@implementation UITextView (private_valueChecking)

-(id)_valueToAssign
{
   NSString* v = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
   v = v.length > 0 ? v : nil;
   return v;
}

-(UIControlEvents)designedControlEvent
{
   return UIControlEventAllEditingEvents;
}

@end


#pragma mark - [UIButton _valueToAssign]

@implementation UIButton (private_valueChecking)

-(id)_valueToAssign
{
   return [[self titleForState:UIControlStateNormal] copy];
}

-(UIControlEvents)designedControlEvent
{
   return UIControlEventTouchUpInside;
}

@end
