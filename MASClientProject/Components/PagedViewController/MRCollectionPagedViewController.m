//
//  MRCollectionPagedViewController.m
//  MASClient
//
//  Created by Enrico Cupellini on 15/09/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "MRCollectionPagedViewController.h"

@interface MRCollectionPagedViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnDismiss;

@end

@implementation MRCollectionPagedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(id)sender {
    
    if (self.delegate)
    {
        [self.delegate collectionPagedViewControllerDidEnd:self];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UICollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionDatasource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *content = self.collectionDatasource[indexPath.row];
    
    NSString *cellIdentifier = content[@"cellIdentifier"];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell setContent:content];
    [cell layoutSubviews];
    
    return cell;
}


#pragma mark - UIScrollviewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self updatePaginationItem];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePaginationItem];
}

-(void)updatePaginationItem {
    CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
    
    NSLog(@"visible page: %ld", (long)visibleIndexPath.row);
    NSNumber *pageToDisplay = self.collectionDatasource[visibleIndexPath.row][@"page"];
    self.pageControl.currentPage = [pageToDisplay unsignedIntegerValue];
}


@end
