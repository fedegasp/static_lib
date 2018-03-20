//
// MRBadgeView.h
//  ikframework
//
//  Created by Federico Gasperini on 03/11/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRBadgeView : UIView

@property (assign, nonatomic) IBInspectable BOOL active;
@property (strong, nonatomic) IBInspectable NSString* badgeTag;
@property (weak, nonatomic) IBOutlet UIView* backgroudView;
@property (weak, nonatomic) IBOutlet UILabel* label;

-(void)setBadgeValue:(NSString*)value;

@end
