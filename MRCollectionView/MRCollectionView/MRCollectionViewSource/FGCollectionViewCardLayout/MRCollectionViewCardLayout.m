//
//  FlowLayout.m
//  Card
//
//  Created by Gai, Fabio on 09/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//
#import "MRCollectionView.h"
#import "MRCollectionViewCardLayout.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)
#define SYSTEM_VERSION_LESS_THAN(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@implementation MRCollectionViewCardLayout

-(CGFloat)angle{
    
    NSUInteger randomIndex = arc4random() % [self.degrees count];
    NSInteger v = [self.degrees[randomIndex] integerValue];
    return DegreesToRadians(v);
}

-(void)prepareLayout{
    self.degrees = [[NSMutableArray alloc] init];
    
    if (![self.parent rangeDegree]) {
        [self.parent setRangeDegree:8];
    }
    if (![self.parent minDegree]) {
        [self.parent setMinDegree:4];
    }
    if (![self.parent marginScale]) {
        [self.parent setMarginScale:20];
    }
    
    for (NSInteger i = -[self.parent rangeDegree]; i < [self.parent rangeDegree]; i++) {
        if ([self.parent minDegree]) {
            if ((i < -[self.parent minDegree] || i > [self.parent minDegree])) {
                [self.degrees addObject:[NSNumber numberWithInteger:i]];
            }
        }else{
            [self.degrees addObject:[NSNumber numberWithInteger:i]];
        }
    }
}

-(CGSize)collectionViewContentSize{
    return self.collectionView.frame.size;
}


-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSMutableArray* elementsInRect = [NSMutableArray array];
    
    for(NSUInteger i = 0; i < [self.collectionView numberOfSections]; i++)
    {
        for(NSUInteger j = 0; j < [self.collectionView numberOfItemsInSection:i]; j++)
        {
            
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            MRCollectionViewContent *c = (MRCollectionViewContent *)[self.collectionView cellForItemAtIndexPath:indexPath];
            
            
            
            BOOL applyEffects = [self.parent shouldIncline] != [self.parent shouldScale];
            NSInteger indexToExclude = [self.collectionView numberOfItemsInSection:i]-1;
            if (c == nil && SYSTEM_VERSION_LESS_THAN(@"9.0")) {
                //indexToExclude = 0;
            }
            BOOL canTransform = (j != indexToExclude) && applyEffects;
            
            CGFloat x = 0;
            CGFloat y = 0;
            CGFloat w = self.collectionView.frame.size.width;
            CGFloat h = self.collectionView.frame.size.height;
            
            CGRect cellFrame = CGRectMake(x,
                                          y,
                                          w,
                                          h);
            
            if(CGRectIntersectsRect(cellFrame, rect))
            {
                
                UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                
                attr.frame = cellFrame;
                attr.alpha = 1;
                
                if (canTransform) {
                    
                    CGAffineTransform variableTransform = CGAffineTransformIdentity;
                    CGFloat scaleFactor = 0.95;
                    
                    if ([self.parent shouldScale]) {
                        
                     //   CGPoint position = CGPointMake(0, -50);
                        CGPoint position = CGPointMake(0, 0);
                        if (j == [self.collectionView numberOfItemsInSection:i]-2) {
                            scaleFactor = 0.85;
                            position.y +=[self.parent marginScale];
                        }else{
                            
                            scaleFactor = 0.75;
                            position.y +=[self.parent marginScale]*2;
                            
                        }
                        
                        scaleFactor = 1-position.y/cellFrame.size.height;
                        
                       /* if (j == [self.collectionView numberOfItemsInSection:i]-2) {
                            position.x += c.frame.size.width/3;
                        }if (j == [self.collectionView numberOfItemsInSection:i]-3) {
                            position.x -= c.frame.size.width/3;
                        }*/
                        
                        // -> - position.y to put under + to put up
                        variableTransform =  CGAffineTransformMakeTranslation(position.x, position.y);
                        
                    }else if ([self.parent shouldIncline]) {
                        variableTransform =  CGAffineTransformMakeRotation(self.angle);
                    }
                    
                    CGAffineTransform transform =  CGAffineTransformConcat(CGAffineTransformMakeScale(scaleFactor, scaleFactor), variableTransform);
                    attr.transform = transform;
                    
                }else{
                    attr.transform = CGAffineTransformIdentity;
                }
                attr.zIndex = j;
                [elementsInRect addObject:attr];
            }
            
        
        }
    }
    
    [self performSelector:@selector(animating) withObject:nil afterDelay:.3];
    return elementsInRect;
}

-(void)animating{
    [self.parent setIsAnimating:NO];
}
@end
