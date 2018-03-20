//
//  FlowLayout.h
//  Card
//
//  Created by Gai, Fabio on 09/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRCollectionViewCardLayout : UICollectionViewFlowLayout
@property NSMutableArray *degrees;
@property BOOL isLoad;
@property BOOL incline;
@property (nonatomic) CGFloat angle;
@property BOOL scale;

@property (nonatomic) NSInteger rangeDegree;
@property (nonatomic) NSInteger minDegree;

@property BOOL firstTime;
@end