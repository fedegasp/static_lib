//
//  UITextField+property_proxying.h
//  iconick-lib
//
//  Created by Federico Gasperini on 21/12/15.
//  Copyright © 2015 accenture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (property_proxying)

@property (nonatomic, assign) IBInspectable CGFloat verticalAdjustment;

@property (nonatomic, assign) IBInspectable CGFloat leftInset;
@property (nonatomic, assign) IBInspectable CGFloat rightInset;

@property (nonatomic, assign) IBInspectable NSInteger rightViewMode;

@property (strong, nonatomic) IBOutlet UIView* rightView;

-(IBAction)toggleSecureField:(id)sender;

@property (readwrite) IBOutlet UIView* inputView;
@property (readwrite) IBOutlet UIView* inputAccessoryView;

@end

