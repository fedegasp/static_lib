//
//  UIImageView+WebCache_AFNetworkingCompat.h
//  MASClient
//
//  Created by Federico Gasperini on 07/09/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (WebCache_AFNetworkingCompat)

- (void)setImageWithURL:(nullable NSURL *)url
       placeholderImage:(nullable UIImage *)placeholderImage;

@end

NS_ASSUME_NONNULL_END
