//
//  MRCollectionViewTab.h
//  MRTabController
//
//  Created by Gai, Fabio on 20/10/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MRCollectionView/MRCollectionView.h>

@interface MRCollectionViewTab : UIView<MRCollectionViewDelegate>

@property BOOL viewLoaded;
@property (nonatomic) MRCollectionView *tabCarousel;
@property (nonatomic) MRCollectionView *contentCarousel;

@property int position;

@property IBInspectable CGFloat tabHeight;
@property IBInspectable UIColor *tabBackground;
@property IBInspectable NSString *tabCustomCell;
@property IBInspectable NSString *tabPlist;
@property IBInspectable NSString *tabJson;
@property IBInspectable NSString *tabJsonKey;
@property IBInspectable CGFloat tabItemsInGrid;

@property IBInspectable UIColor *contentBackground;
@property IBInspectable NSString *contentCustomCell;
@property IBInspectable NSString *contentPlist;
@property IBInspectable NSString *contentJson;
@property IBInspectable NSString *contentJsonKey;
@property IBInspectable BOOL contentSlideOnTap;

-(void)scrollTabCarousel:(NSIndexPath *)indexPath;
@end
