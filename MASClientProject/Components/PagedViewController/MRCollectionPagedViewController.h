//
//  MRCollectionPagedViewController.h
//  MASClient
//
//  Created by Enrico Cupellini on 15/09/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

@class MRCollectionPagedViewController;
@protocol MRCollectionPagedViewControllerDelegate <NSObject>

-(void)collectionPagedViewControllerDidEnd:(MRCollectionPagedViewController*)controller;

@end

@interface MRCollectionPagedViewController : MRViewController

@property (weak, nonatomic) id<MRCollectionPagedViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSArray <NSDictionary*> *collectionDatasource;

@end
