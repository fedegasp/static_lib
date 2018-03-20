//
//  ParallaxSlidesContent.h
//  MASClient
//
//  Created by Gai, Fabio on 06/06/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

@interface ParallaxSlidesContent : MRCollectionViewContent

@property (weak, nonatomic) IBOutlet UIView *parallaxView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSMutableArray* fadeViews;
-(void)transformAlpha:(CGFloat)alpha;
-(void)applyParallaxEffectForPoint:(CGPoint)offset;
-(void)resetParallaxEffect;
@end
