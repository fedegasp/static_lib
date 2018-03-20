//
//  MRPaginationController
//
//  Created by Giovanni Castiglioni on 12/03/15.
//  Copyright (c) 2015 Accenture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRPageObject.h"

@protocol MRPaginatedMenuDelegate <NSObject>

- (void) setCurrentItemIndex:(NSInteger)item;
- (void)pageChanged:(NSInteger)newPageIndex;

@end


@interface MRPaginationController : UIPageViewController		<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property NSUInteger pageIndex;
@property (nonatomic) NSInteger pageCount;
@property (readonly) UIViewController * currentViewController;
@property (assign) IBInspectable BOOL drivenPopulation;

@property (strong, nonatomic) IBOutletCollection(MRPageObject) NSArray *viewControllersObjects;
@property (strong, nonatomic) id<MRPaginatedMenuDelegate> menuView;

-(UIViewController*)addPage;

- (void) goToPage:(NSInteger)nPage completion:(void (^)(void))completion;

@end


@interface UIViewController (MRPaginationControllerIndex)

@property (readonly) NSUInteger paginationControllerIndex;

@end
