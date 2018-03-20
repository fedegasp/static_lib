//
//  MRTextView.m
//  MASClient
//
//  Created by Enrico Cupellini on 14/09/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "MRTextView.h"

@implementation MRTextView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.borderColor = self.borderColor.CGColor;
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, self.insetLeft != nil ? self.insetLeft.floatValue : 0.0, self.insetTop != nil ? self.insetTop.floatValue : 0.0);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, self.insetLeft != nil ? self.insetLeft.floatValue : 0.0, self.insetTop != nil ? self.insetTop.floatValue : 0.0);
}

@end
