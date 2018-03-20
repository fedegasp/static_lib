//
//  UIControl+valueChecking.h
//  ikframework
//
//  Created by Federico Gasperini on 13/03/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+valueValidation.h"


@protocol ErrorStateView
-(void)setErrorState;
-(void)clearErrorState;
@end


typedef id(^ValueToAssignTransformBlock)(id, NSError* __autoreleasing*);


@interface UIControl (valueChecking)

@property (strong, nonatomic) IBInspectable NSString* key;
@property (strong, nonatomic) NSError* currentError;

@property (weak, nonatomic) IBOutlet UIView<ErrorStateView>* errorStateView;

@property (strong, nonatomic) IBInspectable UIColor* errorColor;

@property (copy, nonatomic) ValueToAssignTransformBlock transformBlock;

-(UIControlEvents)designedControlEvent;

-(id)valueToAssign:(NSError* __autoreleasing*)error;

@end
