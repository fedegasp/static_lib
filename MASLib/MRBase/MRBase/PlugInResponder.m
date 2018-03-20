//
//  PlugInResponder.m
//  dpr
//
//  Created by Federico Gasperini on 23/12/15.
//  Copyright © 2015 Federico Gasperini. All rights reserved.
//

#import "PlugInResponder.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface UIViewController (plug_in_responder_private)

-(UIResponder*)originalNextResponder;

@end


@interface PlugInResponder ()

@property (weak, nonatomic) UIViewController* pluggedViewController;

@end


@implementation PlugInResponder

@synthesize pluggedViewController = _pluggedViewController;
@synthesize nextResponder = _nextResponder;

-(void)setNextResponder:(UIResponder *)nextResponder
{
   _nextResponder = nextResponder;
   if (self.pluggedViewController && [self.nextResponder respondsToSelector:_cmd])
      [(id)[self nextResponder] setPluggedViewController:self.pluggedViewController];
}

-(UIResponder*)nextResponder
{
   if ([_nextResponder isKindOfClass:[PlugInResponder class]])
      return _nextResponder;
   return [self.pluggedViewController originalNextResponder];
}

-(void)setPluggedViewController:(UIViewController *)pluggedViewController
{
   _pluggedViewController = pluggedViewController;
   if ([self.nextResponder respondsToSelector:_cmd])
      [(id)[self nextResponder] setPluggedViewController:pluggedViewController];
}

-(UIViewController*)pluggedViewController
{
   return _pluggedViewController;
}

@end



@implementation UIViewController (plug_in_responder)

static const char* prefix = "_plugged_responder_";

-(void)setUndoPluggedActionBlock:(UndoPluggedActionBlock)undoPluggedActionBlock
{
   objc_setAssociatedObject(self, @selector(undoPluggedActionBlock), undoPluggedActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(UndoPluggedActionBlock)undoPluggedActionBlock
{
   return objc_getAssociatedObject(self, @selector(undoPluggedActionBlock));
}

-(void)setNextResponder:(PlugInResponder *)nextResponder
{
   if ([nextResponder isKindOfClass:[PlugInResponder class]])
   {
      [self pluggedResponderSubclass];
      objc_setAssociatedObject(self, @selector(nextResponder), nextResponder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
      nextResponder.pluggedViewController = self;
   }
}

-(void)pluggedResponderSubclass
{
   NSString* className = NSStringFromClass(object_getClass(self));
   if ([className rangeOfString:@(prefix)].location != NSNotFound)
      return;

   NSString * subclassName = [NSString stringWithFormat:@"%s%s", prefix, object_getClassName(self)];
   Class subclass = NSClassFromString(subclassName);
   
   if (subclass == nil) {
      subclass = objc_allocateClassPair(object_getClass(self), [subclassName UTF8String], 0);
      if (subclass != nil) {

         NSString* s = @"@@:";
         IMP plugged_method = class_getMethodImplementation([self class], @selector(plugged_nextResponder));
         class_addMethod(subclass, @selector(nextResponder), plugged_method, s.UTF8String);
         
         s = [NSString stringWithFormat:@"%s@:",@encode(Class)];
         plugged_method = class_getMethodImplementation([self class], @selector(original_class));
         class_addMethod(subclass, @selector(class), plugged_method, s.UTF8String);
         
         plugged_method = class_getMethodImplementation([self class], @selector(original_classForCoder));
         class_addMethod(subclass, @selector(classForCoder), plugged_method, s.UTF8String);
         
         objc_registerClassPair(subclass);
      }
   }
   
   if (subclass != nil) {
      objc_setAssociatedObject(self,
                               @selector(pluggedResponderSubclass),
                               object_getClass(self),
                               OBJC_ASSOCIATION_ASSIGN);
      object_setClass(self, subclass);
   }
}

-(void)undoPluggedAction:(id)sender
{
   if (self.undoPluggedActionBlock)
      self.undoPluggedActionBlock(sender);
}

-(UIResponder*)plugged_nextResponder
{
   UIResponder* r = objc_getAssociatedObject(self, @selector(nextResponder));
   return r ?: [self originalNextResponder];
}

typedef UIView*(*SuperNextResponder)(struct objc_super*, SEL);
static SuperNextResponder superNextResponder = (SuperNextResponder)objc_msgSendSuper;

-(UIResponder*)originalNextResponder
{
   struct objc_super superInfo =  {
      self,
      objc_getAssociatedObject(self,
                               @selector(pluggedResponderSubclass))
   };
   UIResponder* nextResponder = superNextResponder(&superInfo, @selector(nextResponder));
   return nextResponder;
}

-(Class)original_class
{
   return objc_getAssociatedObject(self,
                                   @selector(pluggedResponderSubclass));
}

-(Class)original_classForCoder
{
   return objc_getAssociatedObject(self,
                                   @selector(pluggedResponderSubclass));
}

@end
