//
//  MRScrollViewDelegate.h
//  MASClient
//
//  Created by Gai, Fabio on 04/11/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRScrollViewDelegate <NSObject>
//@required
@optional
- (void)fgDidScroll:(CGPoint)offset;
@end
