//
//  PhotoViewerTransition.h
//  dpr
//
//  Created by Gai, Fabio on 24/09/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRTransitionObject.h"

@protocol MRPhotoViewerDelegate <NSObject>
@optional
-(void)photoViewerIsDismissed;
@end

@interface MRPhotoViewerTransition : MRTransitionObject <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (nonatomic) CGRect mainFrame;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIImageView *modalImage;

@property (weak) IBOutlet id <MRPhotoViewerDelegate> delegate;
@end
