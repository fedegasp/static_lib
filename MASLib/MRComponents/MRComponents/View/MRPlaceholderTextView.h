//
//  MRPlaceholderTextView.h
//  dpr
//
//  Created by Gai, Fabio on 01/07/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

#import "MRTextView.h"

@interface MRPlaceholderTextView : MRTextView

@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;
@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (readwrite, retain) IBOutlet UIView *accessoryView;

-(void)textChanged:(NSNotification*)notification;

@end
