//
//  MRCollectionViewCard.h
//  Card
//
//  Created by Gai, Fabio on 11/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRCollectionViewScrollManager.h"
#import "MRCollectionViewCardLayout.h"

@interface MRCollectionViewCard : MRCollectionViewScrollManager

@property BOOL cardMovedFirstTime;
@property IBInspectable BOOL isCard;
@property IBInspectable BOOL shouldIncline;
@property (nonatomic) IBInspectable NSInteger rangeDegree;
@property (nonatomic) IBInspectable NSInteger minDegree;
@property IBInspectable BOOL shouldScale;
@property (nonatomic) IBInspectable NSInteger marginScale;

@property (strong, nonatomic) MRCollectionViewCardLayout *cardLayout;
@property CGPoint originalCenter;
@property BOOL isAnimating;
@property (strong, nonatomic) NSMutableArray *mutableDataArray;

@property (nonatomic) NSIndexPath *firstIndexPath;
@property (nonatomic) NSIndexPath *lastIndexPath;
@property (nonatomic)  UICollectionViewCell *firstCell;
@property (nonatomic)  UICollectionViewCell *lastCell;


@property UIPanGestureRecognizer *panRecognizer;
-(void)addPanRecognizer;
-(void)removePanRecognizer;

-(void)autoPanToLeft;

@end
