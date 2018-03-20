//
//  MRCollectionViewCarousel.h
//  Card
//
//  Created by Gai, Fabio on 11/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRCollectionViewBase.h"

typedef NS_ENUM(NSInteger, ScrollingDirection) {
    ScrollingLeft = 0,
    ScrollingRight,
};

@interface MRCollectionViewCarousel : MRCollectionViewBase

@property IBInspectable CGFloat itemsPerView;
@property (assign) NSInteger numberOfPages;
@property (assign) CGFloat numberOfItems;
@property  BOOL directionReverse;

@property IBInspectable BOOL slideHorizontal;
@property IBInspectable BOOL horizontalLayout;
@property IBInspectable BOOL slideOnTap;
@property IBInspectable BOOL centerCellOnTap;

@property (nonatomic) IBInspectable BOOL showPagerForSinglePage;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, assign) enum ScrollingDirection scrollingDirection;

//ScrollTo methods
- (void)scrollToPage:(NSNumber *)pageNumber animated: (BOOL)animated;
@property IBOutlet UIButton *backBtn;
@property IBOutlet UIButton *forwardBtn;
-(void)goBack;
-(void)goForward;
- (NSInteger)nextPage;
-(void)updatePageControl;
-(void)updateButtons;

-(void)notifyUpdatedPage;
@end
