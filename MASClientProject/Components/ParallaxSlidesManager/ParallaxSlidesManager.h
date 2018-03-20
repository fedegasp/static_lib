//
//  ParallaxSlidesViewController.h
//  MASClient
//
//  Created by Gai, Fabio on 06/06/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "ParallaxSlidesContent.h"

@interface ParallaxSlidesManager : NSObject<MRCollectionViewDelegate>

@property (weak, nonatomic) IBOutlet id <MRCollectionViewDelegate> mrCollectionViewCallbacks;
@property (weak, nonatomic) IBOutlet MRCollectionView *mrCollectionView;
@property (weak, nonatomic) ParallaxSlidesContent* visibleCell;
@property (weak, nonatomic) ParallaxSlidesContent* prevCell;
@property (weak, nonatomic) ParallaxSlidesContent* forwCell;

@property (assign, nonatomic) CGFloat offsetV;
@property (assign, nonatomic) CGFloat offsetP;
@property (assign, nonatomic) CGFloat offsetF;

-(void)goForward;

@end
