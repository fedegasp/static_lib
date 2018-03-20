//
//  MRFormPluginLogic.m
//  ikframework
//
//  Created by Federico Gasperini on 13/03/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import "MRFormPluginLogic.h"
#import <MRBase/UIControl+currentFirstResponder.h>
#import <MRBase/MRMacros.h>

@interface MRFormPluginLogic ()

@property CGFloat originalY;
@property CGFloat tmpTextFieldY;

@end

@implementation MRFormPluginLogic
{
   NSMutableArray<UIControl*>* _fields;
}

-(instancetype)init
{
    self = [super init];
    if (self)
        self->_editable = YES;
    return self;
}

-(void)setSubmit:(UIButton *)submit
{
    _submit = submit;
    _submit.enabled = NO;
}

-(void)setFields:(NSMutableArray *)fields
{
   for (UIButton* control in self.fields)
      if ([control isKindOfClass:[UIButton class]])
         [control removeObserver:self forKeyPath:@"titleLabel.text"];

   _fields = fields;
   
   __block UIWindow* w = [UIApplication sharedApplication].keyWindow;
   [_fields sortUsingComparator:^NSComparisonResult(UIView* obj1, UIView* obj2) {
      CGRect r1 = [w convertRect:obj1.bounds fromView:obj1];
      CGRect r2 = [w convertRect:obj2.bounds fromView:obj2];
      if (r2.origin.y > r1.origin.y)
         return NSOrderedAscending;
      
      if (r1.origin.y > r2.origin.y)
         return NSOrderedDescending;
      
      if (r2.origin.x > r1.origin.x)
         return NSOrderedAscending;
      
      if (r1.origin.x > r2.origin.x)
         return NSOrderedDescending;
      
      return NSOrderedSame;
   }];
   
   for (UIControl* control in self.fields)
   {
       control.enabled = self.editable;
       
       UIControlEvents events = UIControlEventEditingDidEnd;
       if (self.checkAsYouType) {
           events = UIControlEventAllEditingEvents;
       }
       
      [control addTarget:self
                  action:@selector(assignValue:)
        forControlEvents:events //[control designedControlEvent]
       ];
      
      if ([control isKindOfClass:[UIButton class]] &&
          [control designedControlEvent] == UIControlEventTouchUpInside)
      {
         UIButton *button = (UIButton *)control;
         [button addObserver:self
                  forKeyPath:@"titleLabel.text"
                     options:NSKeyValueObservingOptionNew |
          NSKeyValueObservingOptionOld
                     context:nil];
      }
   }
   [self _clearErrorState];
}

-(void)setEditable:(BOOL)editable
{
    _editable = editable;
    [self.fields setValue:@(editable) forKey:@"enabled"];
}

-(void)setBean:(NSObject *)bean
{
   _bean = bean;
   [self _clearErrorState];
}

-(void)_clearErrorState
{
   if (self.bean && self.fields.count)
   {
      for (UIControl* control in self.fields)
      {
         if (control.key)
         {
            if ([control isKindOfClass:[UIButton class]])
               [(UIButton*)control setTitle:[self.bean valueForKey:control.key]
                                   forState:UIControlStateNormal];
            else if ([control respondsToSelector:@selector(setText:)])
               [(id)control setText:[self.bean valueForKey:control.key]];
            [control.errorStateView clearErrorState];
         }
      }
   }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
   [self assignValue:object];
}

-(void)dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
   for (UIButton* control in self.fields)
      if ([control isKindOfClass:[UIButton class]] &&
          [control designedControlEvent] == UIControlEventTouchUpInside)
          [control removeObserver:self forKeyPath:@"titleLabel.text"];
}

-(NSMutableArray*)fields
{
   if (![_fields respondsToSelector:@selector(sortUsingComparator:)])
      _fields = [_fields mutableCopy];
   return _fields;
}

-(void)assignValue:(UIControl*)sender
{
   NSError* error = nil;
   id v = [sender valueToAssign:&error];
   if (sender.key && self.bean)
   {
      BOOL assign = [self.bean setValue:v
                                   forKey:sender.key
                                    error:&error];
      
//      if (!assign && v)
      if (!assign)
         [self field:sender failedCheckWithError:error];
      else
         [self fieldClearError:sender];
   }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   if ([self.nextDelegate respondsToSelector:_cmd])
      [(id)self.nextDelegate textFieldDidBeginEditing:textField];
   if (textField.currentError && [self.delegate respondsToSelector:@selector(fieldClearError:)])
      [self.delegate fieldClearError:textField];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
   BOOL retVal = YES;
   if ([self.nextDelegate respondsToSelector:_cmd])
      retVal = [(id)self.nextDelegate textFieldShouldReturn:textField];
   if (retVal)
      [self focusOnNextField:textField];

   return retVal;
}

-(IBAction)checkAtOnce:(id)sender
{
   for (UIControl* c in self.fields)
      [self assignValue:c];
   if ([self.delegate respondsToSelector:@selector(field:failedCheckWithError:)])
      for (UIControl* c in self.fields)
         if (c.currentError)
         {
            [self.delegate field:c failedCheckWithError:c.currentError];
            break;
         }
}

-(void)field:(UIControl *)field failedCheckWithError:(NSError *)error
{
    if ([field.errorStateView respondsToSelector:@selector(setErrorState)]) {
        [field.errorStateView setErrorState];
    }
   field.currentError = error ?: [NSError errorWithDomain:@"BEAN" code:1 userInfo:nil];
   self.submit.enabled = NO;
   if ([self.delegate respondsToSelector:_cmd])
      [self.delegate field:field failedCheckWithError:error];
}

-(void)fieldClearError:(UIControl *)field
{
    if ([field.errorStateView respondsToSelector:@selector(clearErrorState)]) {
        [field.errorStateView clearErrorState];
    }
   
   field.currentError = nil;
   self.submit.enabled = [self.bean isValid];
   if ([self.delegate respondsToSelector:_cmd])
      [self.delegate fieldClearError:field];
   if ([self.delegate respondsToSelector:@selector(field:failedCheckWithError:)])
   {
      UIControl* firstError = [self firstFieldWithError];
      if (firstError)
         [self.delegate field:firstError
         failedCheckWithError:firstError.currentError];
   }
}

-(void)focusOnNextField:(id)current
{
   WEAK_REF(self);
   BLOCK_REF(current);
   dispatch_async(dispatch_get_main_queue(), ^{
      NSInteger idx = [_self.fields indexOfObject:_current];
      BOOL submit = NO;
      while (idx + 1 < _self.fields.count)
      {
         if ([(id)_self.fields[idx + 1] becomeFirstResponder])
            break;
         else
            idx ++;
         submit = YES;
      }
      if (submit)
      {
         [self checkAtOnce:nil];
         UIControl* fieldWithError = [self firstFieldWithError];
         if (!fieldWithError && [self.delegate respondsToSelector:@selector(submitForm:)])
            [self.delegate submitForm:self];
         else if (![fieldWithError becomeFirstResponder])
            [[UIControl currentFirstResponder] resignFirstResponder];
      }
   });
}

-(UIControl*)firstFieldWithError
{
   return [self.fields filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"currentError != nil"]].firstObject;
}

@end
