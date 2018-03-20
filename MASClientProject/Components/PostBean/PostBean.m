//
//  PostBean.m
//  BrandMe
//
//  Created by Gai, Fabio on 19/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "PostBean.h"
#import "NSObject+Post.h"

@implementation PostBean

-(void)awakeFromNib{
    [super awakeFromNib];
    [self layoutIfNeeded];
    
    [self setPostContent:[self.parentVC postData]];
}

-(void)reloadData{

}

//-(void)setImageView:(UIImageView*)imageView withPlaceholder:(NSString *)placeholder andUrl:(NSURL *)url{
//    
//    if (imageView != nil) {
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//        [request setHTTPShouldHandleCookies:NO];
//        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
//        
//        __weak typeof (imageView) weakSelf = imageView;
//        
//        [weakSelf setImageWithURLRequest:request
//                        placeholderImage:[UIImage imageNamed:placeholder]
//                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                                     if (!response)
//                                         [weakSelf setImage:image];
//                                     else
//                                         [UIView transitionWithView:weakSelf duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//                                             [weakSelf setImage:image];
//                                         } completion:nil];
//                                 } failure:nil]; 
//    }
//}

@end
