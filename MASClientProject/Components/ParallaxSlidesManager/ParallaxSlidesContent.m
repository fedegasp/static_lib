//
//  ParallaxSlidesContent.m
//  MASClient
//
//  Created by Gai, Fabio on 06/06/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "ParallaxSlidesContent.h"

@implementation ParallaxSlidesContent

-(void)transformAlpha:(CGFloat)alpha{
    for (UIView *v  in self.fadeViews) {
        [v setAlpha:alpha];
    }
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
   [super applyLayoutAttributes:layoutAttributes];
   if ([layoutAttributes isKindOfClass:MRParallaxLayoutAttributes.class])
   {
      if ([(id)layoutAttributes isTopItem])
      {
         self.parallaxView.transform = [(id)layoutAttributes counterParallax];
         //CGFloat alpha = 1.0 - (MIN(0, (pow([(id)layoutAttributes percentage], 2.0) - 0.5) * 2.0) + 1.0);
         CGFloat alpha = MAX (0, 1.0 - (pow([(id)layoutAttributes percentage] + .7, 2.0) - 0.5) * 2.0);
         [self.fadeViews setValue:[NSValue valueWithCGAffineTransform:CGAffineTransformIdentity]
                           forKey:@"transform"];
         [self.fadeViews setValue:@(alpha)
                           forKey:@"alpha"];
      }
      else
      {
         self.parallaxView.transform = CGAffineTransformIdentity;
         CGFloat alpha = MAX(0, (pow([(id)layoutAttributes percentage], 2.0) - 0.5) * 2.0);
         [self.fadeViews setValue:[NSValue valueWithCGAffineTransform:[(id)layoutAttributes antiParallax]]
                           forKey:@"transform"];
         [self.fadeViews setValue:@(alpha)
                           forKey:@"alpha"];
      }
   }

 
}

-(void)applyParallaxEffectForPoint:(CGPoint)offset{
    
    float factor = 0.5;
    
    float finalX = (offset.x - self.frame.origin.x) * factor;
    float finalY  = (offset.y - self.frame.origin.y) * factor;
    
    CGRect frame = self.parallaxView.bounds;
    CGRect offsetFrame = CGRectOffset(frame, (CGFloat)finalX, (CGFloat)finalY);
    
    [self.parallaxView setFrame:offsetFrame];

}

-(void)resetParallaxEffect {
    
    [self.parallaxView setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
}


@end
