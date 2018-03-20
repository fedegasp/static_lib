//
//  UIView+curtain.h
//  MRGraphics
//
//  Created by Federico Gasperini on 06/10/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, Courtain) {
    CourtainBottom,
    CourtainLeft,
    CourtainTop,
    CourtainRight
};


@interface MRCurtainView : UIView

@property (assign, nonatomic) IBInspectable BOOL reversable;
@property (assign, nonatomic) IBInspectable BOOL fading;
@property (assign, nonatomic) IBInspectable BOOL disableAutomaticAppearance;
@property (assign, nonatomic) IBInspectable BOOL startsVisible;

-(void)hideWithAnimation:(BOOL)animated;
-(void)showWithAnimation:(BOOL)animated;

-(void)show;
-(void)hide;


@property (assign, nonatomic) Courtain origin;

@end


@interface MRCurtainView (ibinspectable)

@property (assign, nonatomic) IBInspectable NSInteger origin;

@end
