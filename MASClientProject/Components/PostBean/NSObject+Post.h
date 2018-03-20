//
//  NSObject+Post.h
//  BrandMe
//
//  Created by Gai, Fabio on 19/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostBean.h"

@interface NSObject (Post)
@property (weak, nonatomic) IBOutlet PostBean *postBean;
@property id postData;
@end
