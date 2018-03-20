//
//  UIView+Configuration.h
//  MRComponents
//
//  Created by Enrico Cupellini on 12/03/18.
//  Copyright © 2018 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayableItem.h"
@interface UIResponder (Configuration)<DisplayableItem>

@property (readwrite) NSString *style;
@property (readwrite) NSString *status;

@end

@interface UIView (Configuration)<DisplayableItem>

@property (readwrite) IBInspectable NSString *style;
@property (readwrite) IBInspectable NSString *status;

@end

@interface UILabel (Configuration)<DisplayableItem>

@end

@interface UIImageView (Configuration)<DisplayableItem>

@end

@interface UIButton (Configuration)<DisplayableItem>

@end
