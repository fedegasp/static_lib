//
//  UIView+Utility.h
//
//  Created by fabio on 04/08/15.
//  Copyright (c) 2015 fabio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utility)
- (id) findNextResponder;
-(void)setContent:(id)content;
-(CGFloat)fractionVisible;
@end
