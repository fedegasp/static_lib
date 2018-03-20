//
//  PopUpTransition.h
//  dpr
//
//  Created by Gai, Fabio on 21/01/16.
//  Copyright © 2016 Federico Gasperini. All rights reserved.
//

#import "MRTransitionObject.h"

@interface MRSplashTransition : MRTransitionObject
@property UIView *splashView;
@property (weak, nonatomic)IBOutlet UIButton *startButton;
//@property IBInspectable CGPoint *point;
@end
