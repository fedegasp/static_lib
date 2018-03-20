//
//  NSObject+Post.m
//  BrandMe
//
//  Created by Gai, Fabio on 19/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "NSObject+Post.h"
#import <objc/runtime.h>

NSString const *postBeankey =  @"unique.key_postbean";
NSString const *postDatakey =  @"unique.key_postdata";

@implementation NSObject (Post)

- (void)setPostBean:(PostBean *)postBean
{
    objc_setAssociatedObject(self, &postBeankey, postBean, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(PostBean *)postBean
{
    return objc_getAssociatedObject(self, &postBeankey);
}

-(void)setPostData:(id)postData
{
    objc_setAssociatedObject(self, &postDatakey, postData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    id content = objc_getAssociatedObject(self, &postDatakey);
    [self.postBean setParentVC:self];
    [self.postBean setPostContent:content];
}

-(id)postData
{
    return objc_getAssociatedObject(self, &postDatakey);
}

-(id)valueForUndefinedKey:(NSString *)key
{
   NSLog(@"trying to access %@ on object of type %@ with value %@", key, NSStringFromClass(self.class), [self description]);
   return nil;
}

@end
