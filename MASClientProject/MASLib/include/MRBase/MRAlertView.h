//
//  MRAlertView.h
//  MRBase
//
//  Created by Federico Gasperini on 23/10/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRAlertView;
@protocol MRAlertViewDelegate

@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(MRAlertView * _Nonnull)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)willPresentAlertView:(MRAlertView * _Nonnull)alertView;  // before animation and showing view
- (void)didPresentAlertView:(MRAlertView * _Nonnull)alertView;  // after animation

- (void)alertView:(MRAlertView * _Nonnull)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

@end

@interface MRAlertView : UIAlertController

- (instancetype _Nonnull)initWithTitle:(NSString * _Nullable)title
                               message:(NSString * _Nullable)message
                              delegate:(id _Nullable)delegate /*MRAlertViewDelegate*/
                     cancelButtonTitle:(NSString * _Nullable)cancelButtonTitle
                     otherButtonTitles:(NSString * _Nullable)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

-(void)show;

-(void)addButtonWithTitle:(NSString * _Nonnull)title;

@property (assign, nonatomic) NSInteger tag;
@property (weak, nonatomic, nullable) id<MRAlertViewDelegate> delegate;

@property (strong, nonatomic, nullable) NSError* error;
@property (strong, nonatomic, nullable) NSArray* actionTitles;

@property (readonly) NSInteger cancelButtonIndex;

@end
