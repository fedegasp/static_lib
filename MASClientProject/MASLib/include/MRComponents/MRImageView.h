//
//
//  Created by fabio on 01/08/15.
//  Copyright (c) 2015 fabio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRImageView : UIImageView
@property IBInspectable BOOL isCircleImage;
@property(nonatomic, assign) IBInspectable CGFloat borderRadius;

@property(nonatomic, strong) IBInspectable UIColor* borderColor;
@property(nonatomic, assign) IBInspectable CGFloat borderWidth;

@property (strong, nonatomic) IBInspectable NSString* imageName;
@property (assign) IBInspectable BOOL imageIsTemplate;
@property (assign) IBInspectable UIColor *defaultTintColor;

@end
