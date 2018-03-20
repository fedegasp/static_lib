//
//  OverlaySlideTransition.h
//  Giruland
//
//  Created by Gai, Fabio on 04/10/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRTransitionObject.h"

@interface MROverlaySlideTransition : MRTransitionObject


@property (weak, nonatomic)  IBOutlet UIView *container;
@property (weak, nonatomic)  IBOutlet UIView *overlayView;
@property(nonatomic) IBInspectable BOOL tapToDismiss;
@property(nonatomic) IBInspectable UIColor *overlayColor;
@property(nonatomic, assign) IBInspectable CGFloat overlayAlpha;
@property(nonatomic, assign) IBInspectable int direction;
typedef NS_ENUM(NSInteger, direction) {
    slideUp,
    slideDown,
    slideLeft,
    slideRight
};

@end
