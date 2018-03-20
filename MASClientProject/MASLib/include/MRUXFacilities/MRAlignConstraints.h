//
//  MRAlignConstraints.h
//  MASClient
//
//  Created by Federico Gasperini on 05/09/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MRAlignConstraints : NSObject

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray* constraints;

-(void)alignToValue:(CGFloat)value;
-(void)alignToMax;
-(void)alignToMin;

@end
