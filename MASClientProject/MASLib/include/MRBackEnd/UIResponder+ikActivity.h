//
//  UIResponder+ikActivity.h
//  MRBackEnd
//
//  Created by Federico Gasperini on 02/08/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IKRequest.h"

@interface UIResponder (ikActivity) <IKActivityContext>

+(void)setActivityIndicatorNibName:(NSString*)nibName;

@property (weak, nonatomic) IBOutlet UIView* ikActivityIndicatorView;

-(void)startIkActivity;
-(void)stopIkActivity;

@end
