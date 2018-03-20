//
//  PhotoBrowserScrollView.h
//  TransitionManager
//
//  Created by Gai, Fabio on 13/09/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRPhotoBrowserScrollViewDelegate <NSObject>
@optional
- (NSArray *)photoBrowserDatasource;
- (void)photoBrowserDidChangePage:(int)page;
-(UIImageView *)photoBrowserMainImageForPage:(int)page;
-(void)photoBrowserIsZoomed:(BOOL)zoomed;
-(void)photoBrowserIsStartingDismissed;
-(void)photoBrowserIsDismissed;
@end

@interface MRPhotoBrowserScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic) UIImageView *currentImageView;
@property NSArray *photos;
@property NSMutableArray *photosImageview;
@property NSMutableArray *photosScrollView;

@property int currentPage;

@property (weak) IBOutlet id <MRPhotoBrowserScrollViewDelegate> pbdelegate;

@property UIImageView *modalImage;
-(instancetype) initWithFrame:(CGRect)frame
                   modalImage:(UIImageView *)modalImage
                   pbDelegate:(id<MRPhotoBrowserScrollViewDelegate>)pbdelegate
                  currentPage:(int)currentPage;
@end
