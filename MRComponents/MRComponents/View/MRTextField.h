//
//  FGButtonForm.h
//  BrandMe
//
//  Created by Gai, Fabio on 13/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Configuration.h"

@interface MRTextField : UITextField <UIPickerViewDelegate, UIPickerViewDataSource>{
    
}

@property(nonatomic, strong) IBInspectable UIColor* borderColor;
@property(nonatomic, assign) IBInspectable CGFloat borderWidth;
@property(nonatomic, assign) IBInspectable CGFloat borderRadius;
@property(nonatomic, assign) IBInspectable NSString *leftImage;
@property(nonatomic, assign) IBInspectable BOOL shouldShowImage;
@property(nonatomic, assign) IBInspectable UIToolbar* toolbar;
@property(nonatomic, assign) IBInspectable BOOL shouldShowToolbar;

@property IBInspectable UIColor *placeholderColor;
@property IBInspectable NSString *key;
@property IBInspectable BOOL isDatePicker;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property IBInspectable BOOL isPicker;
@property IBInspectable NSString *datasourceFromPlist;
@property IBInspectable BOOL required;
@property (strong, nonatomic) NSArray *datasource;
@property (weak, nonatomic) IBOutlet MRTextField *next;
@property (weak, nonatomic) IBOutlet id<UITextFieldDelegate> nextDelegate;
@property (strong, nonatomic) IBOutletCollection(UIView)NSArray *configurationViews;
@property (readwrite, retain) IBOutlet UIView *accessoryView;

@property (nonatomic, strong) NSNumber* insetTop;
@property (nonatomic, strong) NSNumber* insetRight;
@property (nonatomic, strong) NSNumber* insetBottom;
@property (nonatomic, strong) NSNumber* insetLeft;

@end
