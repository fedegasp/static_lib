//
//  OptionButtonGroup.h
//  ikframework
//
//  Created by Federico Gasperini on 01/08/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSNotificationName kMROptionGroupDidChangeSelection;
extern NSNotificationName kMROptionGroupSameSelection;

@interface MROptionGroup : NSObject

@property (strong, nonatomic) IBOutletCollection(UIControl) NSArray* options;

@property (strong) IBInspectable NSString* name;

@property (assign) IBInspectable BOOL multipleSelection;

@property (assign) IBInspectable BOOL clearable;

-(IBAction)clearSelection;

@property (readonly, nonatomic) NSArray<UIControl*>* selection;

@end


@interface UIControl (OptionGroup)

@property (unsafe_unretained, nonatomic) MROptionGroup* optionGroup;

-(void)becomeOptionSelection;

@end
