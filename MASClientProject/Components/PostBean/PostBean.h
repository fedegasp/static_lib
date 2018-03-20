//
//  PostBean.h
//  BrandMe
//
//  Created by Gai, Fabio on 19/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PostBeanDelegate <NSObject>
- (void)postBeanLoadImage:(UIImage *)image;
@end

@interface PostBean : UIView {
    id _postContent;
}

@property (weak) IBOutlet id <PostBeanDelegate> delegate;
@property (strong, nonatomic) id postContent;

@property (weak, nonatomic) IBOutlet id parentVC;
-(void)reloadData;
//-(void)setImageView:(UIImageView*)imageView withPlaceholder:(NSString *)placeholder andUrl:(NSURL *)url;
@property (strong, nonatomic) IBInspectable NSString* avatarPlaceholder;
@property (strong, nonatomic) IBInspectable NSString* placeholder;

@property (nonatomic) IBInspectable BOOL shouldReloadParent;

@end
