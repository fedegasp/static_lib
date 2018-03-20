//
//  UIView+nonModalBehaviour.m
//  dpr
//
//  Created by Federico Gasperini on 03/12/15.
//  Copyright © 2015 Federico Gasperini. All rights reserved.
//

#import "UIView+nonModalBehaviour.h"

#define SWIZZLING 0

#if SWIZZLING
#import <JRSwizzle.h>
#else
#import <objc/message.h>
#endif

#import <objc/runtime.h>
#import <CoreGraphics/CoreGraphics.h>


@implementation UIView (nonModalBehaviour)

#if SWIZZLING

+(void)load
{
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      [self jr_swizzleMethod:@selector(hitTest:withEvent:)
                  withMethod:@selector(nonModal_hitTest:withEvent:)
                       error:NULL];
   });
}

-(void)setNonModal:(BOOL)nonModal
{
   objc_setAssociatedObject(self, @selector(nonModal), @(nonModal), OBJC_ASSOCIATION_RETAIN);
}

-(BOOL)nonModal
{
   return [objc_getAssociatedObject(self, @selector(nonModal)) boolValue];
}

-(UIView*)nonModal_hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
   UIView* v = [self nonModal_hitTest:point withEvent:event];
   if (self.nonModal)
   {
      if (v && v != self)
         return v;
      return nil;
   }
   return v;
}

#else

static const char * prefix = "NonModal_runtime_extension_";

typedef UIView*(*SuperHitTest)(struct objc_super*, SEL, CGPoint, UIEvent*);
static SuperHitTest superHitTest = (SuperHitTest)objc_msgSendSuper;

-(void)setNonModal:(BOOL)nonModal
{
    if (nonModal)
        [self nonModalSubclass];
    objc_setAssociatedObject(self, @selector(nonModal),
                             @(nonModal), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)nonModal
{
   return [objc_getAssociatedObject(self, @selector(nonModal)) boolValue];
}

-(UIView*)nonModal_hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
   struct objc_super superInfo =  {
      self,
      [self nonModal_baseclass]
   };
   UIView* v = superHitTest(&superInfo, @selector(hitTest:withEvent:), point, event);
   if (self.nonModal)
   {
      if (v != self)
         return v;
   }
   else
      return v;

   return nil;
}

-(void)restoreSuperclass
{
   NSString* className = NSStringFromClass([self class]);
   if ([className containsString:@(prefix)])
      object_setClass(self, [self nonModal_baseclass]);
}

-(Class)nonModal_baseclass
{
   return objc_getAssociatedObject(self, @selector(nonModal_baseclass));
}

-(void)nonModalSubclass
{
   if (objc_getAssociatedObject(self, @selector(nonModal_baseclass)))
      return;
   
   NSString * subclassName = [NSString stringWithFormat:@"%s%s", prefix, object_getClassName(self)];
   Class subclass = NSClassFromString(subclassName);
   
   if (subclass == nil) {
      subclass = objc_allocateClassPair(object_getClass(self), [subclassName UTF8String], 0);
      if (subclass != nil) {
         IMP nonModal_method = class_getMethodImplementation([self class], @selector(nonModal_hitTest:withEvent:));
         NSString* s = [NSString stringWithFormat:@"@@:%s@",@encode(CGPoint)];
         class_addMethod(subclass, @selector(hitTest:withEvent:), nonModal_method, s.UTF8String);
         
         nonModal_method = class_getMethodImplementation([self class], @selector(nonModal_class));
         s = [NSString stringWithFormat:@"%s@:",@encode(Class)];
         class_addMethod(subclass, @selector(class), nonModal_method, s.UTF8String);

         nonModal_method = class_getMethodImplementation([self class], @selector(nonModal_classForCoder));
         class_addMethod(subclass, @selector(classForCoder), nonModal_method, s.UTF8String);

         objc_registerClassPair(subclass);
      }
   }
   
   if (subclass != nil)
   {
      objc_setAssociatedObject(self, @selector(nonModal_baseclass),
                               self.class, OBJC_ASSOCIATION_ASSIGN);
      object_setClass(self, subclass);
   }
}

-(Class)nonModal_class
{
   return class_getSuperclass(object_getClass(self));
}

-(Class)nonModal_classForCoder
{
   return class_getSuperclass(object_getClass(self));
}

#endif

@end
