//
//  PopUpTransition.h
//  dpr
//
//  Created by Gai, Fabio on 20/09/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRTransitionObject.h"

@protocol MRPopUpDelegate <NSObject>
@optional
-(IBAction)confirmButtonPressed:(id)sender;
-(IBAction)cancelButtonPressed:(id)sender;
@end

@interface MRPopUpTransition : MRTransitionObject
@property (weak, nonatomic) IBOutlet UIView *popUpView;

@property (weak) IBOutlet id <MRPopUpDelegate> mainDelegate;
@property (weak) IBOutlet id <MRPopUpDelegate> modalDelegate;
@end
