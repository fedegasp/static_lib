//
//  TREWLButtonInputView.m
//
//  Created by Federico Gasperini on 01/10/12.
//  Copyright (c) 2012 Federico Gasperini. All rights reserved.
//

#import "IKButtonInputView.h"

@interface IKButtonInputView ()

-(void)setup;

@end

@implementation IKButtonInputView

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self setup];
    return self;
}

-(id)init
{
    self = [super init];
    if (self)
        [self setup];
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
        [self setup];
    return self;
}

-(void)setup
{
    [self addTarget:self action:@selector(becomeFirstResponder) forControlEvents:UIControlEventTouchUpInside];
}

-(BOOL)canBecomeFirstResponder
{
    if([self.delegate respondsToSelector:@selector(shouldBecomeFirstResponder:)])
        return [self.delegate shouldBecomeFirstResponder:self];
    return YES;
}

-(BOOL)becomeFirstResponder
{
    BOOL retVal = [super becomeFirstResponder];
    if (retVal && self.targetFirstResponder)
    {
        [self.targetFirstResponder becomeFirstResponder];
        [super resignFirstResponder];
    }
    else if (retVal && [self.delegate respondsToSelector:@selector(buttonDidBecomeFirstResponder:)])
        [self.delegate buttonDidBecomeFirstResponder:self];
    return retVal;
}

-(BOOL)resignFirstResponder;
{
    if (self.targetFirstResponder)
        return [self.targetFirstResponder resignFirstResponder];
    else if ([self.delegate respondsToSelector:@selector(buttonDidResignFirstResponder:)])
        [self.delegate buttonDidResignFirstResponder:self];
    
    return [super resignFirstResponder];
}

-(IBAction)resign:(id)sender
{
    [self resignFirstResponder];
}

@end
