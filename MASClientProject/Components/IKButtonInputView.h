//
//  TREWLButtonInputView.h
//
//  Created by Federico Gasperini on 01/10/12.
//  Copyright (c) 2012 Federico Gasperini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IKButtonInputView;
@protocol IKButtonInputViewDelegate <NSObject>

@optional
-(BOOL)shouldBecomeFirstResponder:(IKButtonInputView *)button;
-(void)buttonDidBecomeFirstResponder:(IKButtonInputView*)button;
-(void)buttonDidResignFirstResponder:(IKButtonInputView*)button;

@end

@interface IKButtonInputView : UIButton
@property (nonatomic, weak) IBOutlet id<IKButtonInputViewDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIView* inputView;
@property (nonatomic, strong) IBOutlet UIView* inputAccessoryView;

@property (nonatomic, strong) IBOutlet UIView* targetFirstResponder;

-(IBAction)resign:(id)sender;

@end
