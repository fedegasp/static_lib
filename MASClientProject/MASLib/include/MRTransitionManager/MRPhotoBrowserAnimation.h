//
//  CustomAnimation.h
//  material
//
//  Created by Gai, Fabio on 31/08/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRTransitionObject.h"
#import "MRPhotoBrowserScrollView.h"

@interface MRPhotoBrowserAnimation : MRTransitionObject <MRPhotoBrowserScrollViewDelegate>

@property (strong, nonatomic) NSNumber *currentPage;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIView *modalView;
@property (nonatomic) CGRect mainFrame;
@property UIImageView *modalImage;

@property MRPhotoBrowserScrollView *pbScrollView;
@property (weak) IBOutlet id <MRPhotoBrowserScrollViewDelegate> mainDelegate;
@property (weak) IBOutlet id <MRPhotoBrowserScrollViewDelegate> modalDelegate;
@end
