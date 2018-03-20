//
//  PlugInResponder.h
//  dpr
//
//  Created by Federico Gasperini on 23/12/15.
//  Copyright © 2015 Federico Gasperini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlugInResponder : UIResponder

@property (weak, nonatomic) IBOutlet UIResponder* nextResponder;

@property (weak, readonly) UIViewController* pluggedViewController;

@end


typedef void(^UndoPluggedActionBlock)(id sender);

@interface UIViewController (plug_in_responder)

@property (nonatomic, strong) IBOutlet UIResponder* nextResponder;
@property (nonatomic, copy) UndoPluggedActionBlock undoPluggedActionBlock;

-(IBAction)undoPluggedAction:(id)sender;

@end
