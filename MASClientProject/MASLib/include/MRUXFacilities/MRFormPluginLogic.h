//
//  MRFormPluginLogic.h
//  ikframework
//
//  Created by Federico Gasperini on 13/03/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import "UIControl+valueChecking.h"
#import <MRBase/MRChainedDelegate.h>

@class MRFormPluginLogic;
@protocol MRFormPluginLogicDelegate <NSObject>

@optional
-(void)field:(UIControl*)field failedCheckWithError:(NSError*)error;
-(void)fieldClearError:(UIControl *)field;
-(void)submitForm:(MRFormPluginLogic*)form;

@end

@interface MRFormPluginLogic : MRChainedDelegate <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet id<MRFormPluginLogicDelegate> delegate;

@property (strong, nonatomic) IBOutletCollection(UIControl) NSMutableArray* fields;

@property (strong, nonatomic) IBOutlet NSObject* bean;

@property (strong, nonatomic) IBOutlet UIButton* submit;
@property (nonatomic, assign) IBInspectable BOOL checkAsYouType;

@property (nonatomic, assign, getter=isEditable) IBInspectable BOOL editable;

-(IBAction)checkAtOnce:(id)sender;

-(void)field:(UIControl*)field failedCheckWithError:(NSError*)error;
-(void)fieldClearError:(UIControl *)field;
-(void)focusOnNextField:(id)current;

-(UIControl*)firstFieldWithError;

@end
