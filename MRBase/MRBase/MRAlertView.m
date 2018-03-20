//
//  MRAlertView.m
//  MRBase
//
//  Created by Federico Gasperini on 23/10/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "MRAlertView.h"

@interface MRAlertView ()

@property (nonatomic, strong) UIWindow* presentingWindow;
@property (nonatomic, weak) UIWindow* currentWindow;

@end

@implementation MRAlertView

-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
                    delegate:(id<MRAlertViewDelegate>)delegate
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    MRAlertView* alert = [MRAlertView alertControllerWithTitle:title
                                                       message:message
                                                preferredStyle:UIAlertControllerStyleAlert];
    alert.delegate = delegate;
    
    [alert addAction:[UIAlertAction actionWithTitle:cancelButtonTitle
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                if ([(id)self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
                                                    [[self delegate] alertView:self
                                                          clickedButtonAtIndex:0];
                                                if ([(id)self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)])
                                                    [[self delegate] alertView:self
                                                     willDismissWithButtonIndex:0];
                                            }]];

    va_list argumentList;
    if (otherButtonTitles)
    {
        NSString* titleIter = otherButtonTitles;
        va_start(argumentList, otherButtonTitles);
        NSInteger buttonIndex = 1;
        while (titleIter)
        {
            [alert addAction:[UIAlertAction actionWithTitle:titleIter
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        if ([(id)self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
                                                            [[self delegate] alertView:self
                                                                  clickedButtonAtIndex:buttonIndex];
                                                        if ([(id)self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)])
                                                            [[self delegate] alertView:self
                                                             willDismissWithButtonIndex:buttonIndex];
                                                    }]];
            buttonIndex++;
            titleIter = va_arg(argumentList, id);
        }
        va_end(argumentList);
    }
    
    return alert;
}

-(void)dealloc
{
    [self.presentingWindow resignKeyWindow];
    [self.currentWindow makeKeyWindow];
    __block UIViewController* controller = self.currentWindow.rootViewController;
    dispatch_async(dispatch_get_main_queue(), ^{
        [controller setNeedsStatusBarAppearanceUpdate];
    });
}

-(void)show
{
    self.currentWindow = [[UIApplication sharedApplication] keyWindow];
    UIWindow* window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor clearColor];
    self.presentingWindow = window;
    self.presentingWindow.rootViewController = [UIViewController new];
    self.presentingWindow.windowLevel = UIWindowLevelStatusBar - 1;
    [self.presentingWindow makeKeyAndVisible];
    [self.delegate willPresentAlertView:self];
    [self.presentingWindow.rootViewController presentViewController:self
                                                           animated:YES
                                                         completion:^{
                                                             [self.delegate didPresentAlertView:self];
                                                         }];
}

-(void)addButtonWithTitle:(NSString*)title
{
    NSInteger buttonIndex = self.actions.count;
    UIAlertActionStyle style = buttonIndex ? UIAlertActionStyleDefault : UIAlertActionStyleCancel;
    [self addAction:[UIAlertAction actionWithTitle:title
                                             style:style
                                           handler:^(UIAlertAction * _Nonnull action) {
                                               if ([(id)self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
                                                   [[self delegate] alertView:self
                                                         clickedButtonAtIndex:buttonIndex];
                                               if ([(id)self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)])
                                                   [[self delegate] alertView:self
                                                   willDismissWithButtonIndex:buttonIndex];
                                           }]];

}

-(NSInteger)cancelButtonIndex
{
    return 0;
}

@end
