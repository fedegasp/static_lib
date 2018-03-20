//
//  FGButtonForm.m
//  BrandMe
//
//  Created by Gai, Fabio on 13/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRTextField.h"
#import <MRRuntimeLocalization/lib.h>
#import <objc/runtime.h>

@interface MRTextField ()<UITextFieldDelegate>

@property (nonatomic, weak)id externalDelegate;

@end

@implementation MRTextField

-(void)awakeFromNib{
   [super awakeFromNib];
   [self layoutIfNeeded];
   
   if (self.shouldShowImage) {
      UIImageView *imgforLeft=[[UIImageView alloc] initWithFrame:CGRectMake(16, 0, 45, 25)];
      [imgforLeft setImage:[UIImage imageNamed:self.leftImage]];
      [imgforLeft setContentMode:UIViewContentModeCenter];
      self.leftView=imgforLeft;
      self.leftViewMode=UITextFieldViewModeAlways;
   }
   
   super.delegate = self;
   
   if (self.placeholder == nil) {
      self.placeholder = @"";
   }
   
    if( (self.localizingKey.length>0) && (self.languageFileName.length>0)){
        self.placeholder = MRLocalizedString(self.localizingKey, self.languageFileName);
    }
   if (self.placeholderColor == nil) {
      self.placeholderColor = [UIColor lightGrayColor];
   }
   
   NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.placeholder
                                                             attributes:@{ NSForegroundColorAttributeName : self.placeholderColor }];
   self.attributedPlaceholder = str;
   
   if(self.borderColor && self.borderWidth){
      [self setBorderWithColor:self.borderColor width:self.borderWidth];
   }
   
   if(self.borderRadius > 0){
      [self setAllCornerRadius:self.borderRadius];
      [self setClipsToBounds:YES];
   }
   
   if (self.accessoryView) {
      self.inputAccessoryView =self.accessoryView;
   }
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    UIImage* image = self.background;
    if (image != nil)
    {
        self.background = [image resizableImageWithCapInsets:UIEdgeInsetsMake(self.insetTop != nil ? self.insetTop.floatValue : 0.0, self.insetLeft != nil ? self.insetLeft.floatValue : 0.0, self.insetBottom != nil ? self.insetBottom.floatValue : 0.0, self.insetRight != nil ? self.insetRight.floatValue : 0.0)];
    }
}

#pragma mark delegate management

-(BOOL)respondsToSelector:(SEL)aSelector
{
    
    struct objc_method_description hasMethod;
    hasMethod = protocol_getMethodDescription(@protocol(UITextFieldDelegate),
                                              aSelector, NO, YES);
    if ( hasMethod.name != NULL )
        return [_externalDelegate respondsToSelector:aSelector];
    
    return [super respondsToSelector:aSelector];
}

-(id)forwardingTargetForSelector:(SEL)aSelector
{
    struct objc_method_description hasMethod;
    hasMethod = protocol_getMethodDescription(@protocol(UITextFieldDelegate),
                                              aSelector, NO, YES);
    if ( hasMethod.name != NULL )
        return _externalDelegate;
    
    return [super forwardingTargetForSelector:aSelector];
}

-(void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    self.externalDelegate = delegate;
}

-(id)delegate
{
    return self;
}

#pragma mark properties

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, self.insetLeft != nil ? self.insetLeft.floatValue : 0.0, self.insetTop != nil ? self.insetTop.floatValue : 0.0);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, self.insetLeft != nil ? self.insetLeft.floatValue : 0.0, self.insetTop != nil ? self.insetTop.floatValue : 0.0);
}


-(void)setBorderWithColor:(UIColor*)color width:(CGFloat)width
{
   CALayer* layerView = [self layer];
   [layerView setBorderWidth:width];
   [layerView setBorderColor:[color CGColor]];
}

- (void)setAllCornerRadius:(CGFloat)radius
{
   CALayer* layerView = [self layer];
   layerView.cornerRadius = radius;
}

#pragma mark delegate protocol

-(void)textFieldDidBeginEditing:(MRTextField *)textField{
   
   self.layer.borderColor = self.borderColor.CGColor;
    if (self.shouldShowToolbar) {
        if (self.toolbar) {
            [self setInputAccessoryView:self.toolbar];
        }
        else{
            UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,
                                                                            0,
                                                                            [[UIScreen mainScreen] bounds].size.width,
                                                                            44)];
            [toolBar setBarStyle:UIBarStyleBlackOpaque];
            [toolBar setBackgroundColor:[UIColor whiteColor]];
            UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Chiudi"
                                                                           style:UIBarButtonItemStyleDone
                                                                          target:self
                                                                          action:@selector(chiudiPicker:)];
            
            [leftButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIFont fontWithName:@"Open Sans" size:13], NSFontAttributeName,
                                                [UIColor whiteColor], NSForegroundColorAttributeName,
                                                nil]
                                      forState:UIControlStateNormal];
            
            UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                            style:UIBarButtonItemStyleDone
                                                                           target:self
                                                                           action:@selector(textFieldShouldReturn:)];
            
            [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIFont fontWithName:@"Open Sans" size:13], NSFontAttributeName,
                                                 [UIColor whiteColor], NSForegroundColorAttributeName,
                                                 nil]
                                       forState:UIControlStateNormal];
            
            
            UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:self action:nil];
            
            NSMutableArray *items = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects: leftButton, flex, rightButton, nil]];
            if (self.next == nil) {
                [items removeLastObject];
            }
            toolBar.items = items;
            [self setInputAccessoryView:toolBar];
        }
    }
   
   if (self.isDatePicker) {
      UIDatePicker *datePicker = [[UIDatePicker alloc]init];
      datePicker.datePickerMode = UIDatePickerModeDate;
      [datePicker setDate:[NSDate date]];
      [datePicker setMaximumDate:[NSDate date]];
      [datePicker addTarget:self
                     action:@selector(updateDatePicker:)
           forControlEvents:UIControlEventValueChanged];
      
      [self setInputView:datePicker];
   }
   
   if (self.isPicker) {
      UIPickerView *picker = [[UIPickerView alloc]init];
      picker.delegate = self;
      if (self.text.length > 0) {
         NSInteger index = [self.datasource indexOfObject:self.text];
         if (index < self.datasource.count) {
            [picker selectRow:index inComponent:0 animated:YES];
         }
         
      }
      [self setInputView:picker];
   }
    
    if (self.externalDelegate && [self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.externalDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    BOOL retVal = NO;
    
    if (self.next) {
        [self.next becomeFirstResponder];
    }else {
        if ([self.nextDelegate respondsToSelector:_cmd])
            retVal = [(id)self.nextDelegate textFieldShouldReturn:textField];
        [textField resignFirstResponder];
    }
    
    if (self.externalDelegate && [self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        [self.externalDelegate textFieldShouldReturn:textField];
    }
    
    return retVal;
}



-(void)updateDatePicker:(id)sender{
   
   UIDatePicker *datePicker = (UIDatePicker *)sender;

   NSString *stringFromDate = [self.dateFormatter stringFromDate:datePicker.date];
   self.text = stringFromDate;
}

-(void)chiudiPicker:(id)sender
{
   [self resignFirstResponder];
}

-(NSArray*)datasource
{
   if (!_datasource)
   {
      if (self.datasourceFromPlist.length)
         _datasource = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.datasourceFromPlist ofType:@"plist"]];
      else
         return nil;
   }
   return _datasource;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
   return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
   return self.datasource.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
   return self.datasource[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
   
   self.text = self.datasource[row];
}

//- (CGRect)textRectForBounds:(CGRect)bounds{
//   
//   return CGRectInset( bounds , 0 , 0 );
//   
//   
//}
//- (CGRect)editingRectForBounds:(CGRect)bounds{
//   
//   return CGRectInset( bounds , 0 , 0 );
//   
//}

-(void)setStatus:(NSString *)status
{
    [super setStatus:status];
    for (UIView *view in self.configurationViews) {
        [view setStatus:status];
    }
}

@end
