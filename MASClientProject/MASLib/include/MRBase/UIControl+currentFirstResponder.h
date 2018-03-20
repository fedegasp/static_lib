//
//  UIControl+currentFirstResponder.h
//  iconick-lib
//
//  Created by Federico Gasperini on 19/01/16.
//  Copyright © 2016 accenture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (currentFirstResponder)

+(UIControl*)currentFirstResponder;

-(IBAction)becomeFirstResponder:(id)sender;

@end
