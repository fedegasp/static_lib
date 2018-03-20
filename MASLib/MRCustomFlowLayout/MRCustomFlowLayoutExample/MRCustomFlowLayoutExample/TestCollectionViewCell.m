//
//  TestCollectionViewCell.m
//  CollectionTest
//
//  Created by Federico Gasperini on 22/05/17.
//  Copyright © 2017 -. All rights reserved.
//

#import "TestCollectionViewCell.h"
#import "MRGridParallaxLayout.h"

@implementation TestCollectionViewCell

-(void)setContent:(id)content
{
   [super setContent:content];
   [[[self contentView] subviews][0] setText:content];
}

- (void)applyLayoutAttributes:(MRParallaxLayoutAttributes *)layoutAttributes
{
   [super applyLayoutAttributes:layoutAttributes];
   if ([layoutAttributes isKindOfClass:MRParallaxLayoutAttributes.class])
   {
      
   }
}

@end
