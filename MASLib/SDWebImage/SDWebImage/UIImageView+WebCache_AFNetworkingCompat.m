//
//  UIImageView+WebCache_AFNetworkingCompat.m
//  MASClient
//
//  Created by Federico Gasperini on 07/09/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "UIImageView+WebCache_AFNetworkingCompat.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (WebCache_AFNetworkingCompat)

- (void)setImageWithURL:(nullable NSURL *)url
       placeholderImage:(nullable UIImage *)placeholderImage
{
    [self sd_setImageWithURL:url
            placeholderImage:placeholderImage];
}

@end
