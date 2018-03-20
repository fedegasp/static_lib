//
//  MRButton.h
//  MASClient
//
//  Created by Federico Gasperini on 09/12/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRButton : UIButton

@property (strong, nonatomic) IBInspectable UIColor* normalColor;
@property (strong, nonatomic) IBInspectable UIColor* selectedColor;
@property (strong, nonatomic) IBInspectable UIColor* disabledColor;

@property (strong, nonatomic) IBInspectable UIColor* selectedTintColor;
@property (strong, nonatomic) IBInspectable UIColor* disabledTintColor;

@property(nonatomic, strong) IBInspectable UIColor* borderColor;
@property(nonatomic, strong) IBInspectable UIColor* borderSelectedColor;
@property(nonatomic, assign) IBInspectable CGFloat borderWidth;
@property(nonatomic, assign) IBInspectable CGFloat borderRadius;

@property (strong, nonatomic) NSString* customFont;
@property (strong, nonatomic) NSNumber* customFontSize;
@property (assign) NSTextAlignment titleTextAlignment;
@property (assign) IBInspectable BOOL backgroundImageIsTemplate;
@property (assign) IBInspectable BOOL imageIsTemplate;
@property (assign) IBInspectable BOOL autoShrink;
@property (nonatomic, assign) IBInspectable BOOL underline;

@property(nonatomic, strong) IBInspectable NSNumber *titleEdgeTop;
@property(nonatomic, strong) IBInspectable NSNumber *titleEdgeLeft;
@property(nonatomic, strong) IBInspectable NSNumber *titleEdgeRight;
@property(nonatomic, strong) IBInspectable NSNumber *titleEdgeBottom;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray* externLabels;

@end
