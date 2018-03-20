//
//  NSObject+scrollDelegate.h
//  MASClient
//
//  Created by Gai, Fabio on 04/11/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRScrollViewDelegate.h"

@interface NSObject (scrollDelegate)
@property (weak) IBOutlet id <MRScrollViewDelegate> scrollDelegate;
@end
