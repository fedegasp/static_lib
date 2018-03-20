//
//  MRHeaderScrollChainedDelegate.h
//  Notif
//
//  Created by Federico Gasperini on 09/08/16.
//  Copyright © 2016 Federico Gasperini. All rights reserved.
//

@import UIKit;
#import <MRBase/MRChainedDelegate.h>

@protocol HeaderOwner <NSObject>

-(BOOL)draggingUp:(UIScrollView*)scrollView withOffset:(CGFloat)offset;
-(BOOL)draggingDown:(UIScrollView*)scrollView withOffset:(CGFloat)offset;
-(CGFloat)headerHeight;

@optional
-(void)endDragging:(UIScrollView*)scrollView;

@end

@interface UIScrollView (dragHeader)

@property (readonly, nonatomic) NSObject<HeaderOwner>* headerOwner;
@property (readonly, nonatomic) CGFloat maxVerticalOffsetNotBouncing;

@end

@interface MRHeaderScrollChainedDelegate : MRChainedDelegate <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet NSObject<HeaderOwner>* headerOwner;

@end
