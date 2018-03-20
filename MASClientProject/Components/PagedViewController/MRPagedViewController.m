//
//  DPRPagedViewController.m
//  dpr
//
//  Created by Gai, Fabio on 15/02/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

#import "MRPagedViewController.h"

@implementation MRPagedViewController
{
   NSIndexPath* _selectedIndexPath;

   MRHeaderScrollChainedDelegate* hsd;
}

-(NSMutableArray *)menuItemsArray{

    if (!_menuItemsArray) {
        _menuItemsArray = [[NSMutableArray alloc] init];
    }
    return _menuItemsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    hsd = [[MRHeaderScrollChainedDelegate alloc] init];
    
    self.menuCollection.delegate = self;
}

-(void)languageDidChange:(NSNotification *)notification
{
   if (self.menuCollection.isInitialized)
      [self.menuCollection.collectionView reloadData];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.initialized) {
       if (!_selectedIndexPath)
          _selectedIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.menuCollection.collectionView selectItemAtIndexPath:_selectedIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self setInitialized:YES];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender	{
    if([segue.identifier isEqualToString:@"initPageController"]) {
        self.pgController = segue.destinationViewController;
        self.pgController.menuView = self;
        self.menuItemsArray = [self.pgController.viewControllersObjects valueForKey:@"title"];
    }
    
}

#pragma GGpagination delegate

- (void) setCurrentItemIndex:(NSInteger)item {
   _selectedIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
    [self.menuCollection.collectionView selectItemAtIndexPath:_selectedIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

- (void)pageChanged:(NSInteger)newPageIndex {
   _selectedIndexPath = [NSIndexPath indexPathForItem:newPageIndex inSection:0];
    [self.menuCollection.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:newPageIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}


- (void) selectItem:(NSInteger) item {
    [self.pgController goToPage:item completion:^{
        //int a = 0;
    }];
}

#pragma mark FGCOLLECTIONVIEW DELEGATE

- (void)MRCollectionView:(id)collectionView isInitialized:(BOOL)initialized
{
   if (initialized)
   {
      hsd.nextDelegate = self.menuCollection;
      hsd.scrollView = self.menuCollection.collectionView;
      self.menuCollection.bounce = YES;
      self.menuCollection.collectionView.bounces = NO;
      self.menuCollection.collectionView.alwaysBounceVertical = YES;
      self.menuCollection.collectionView.alwaysBounceHorizontal = NO;
      
      self.menuCollection.collectionView.delegate = (id)hsd;

      if (!_selectedIndexPath)
         _selectedIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
      [self.menuCollection.collectionView selectItemAtIndexPath:_selectedIndexPath
                                                       animated:YES
                                                 scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
   }
}

- (NSArray *)MRCollectionViewDatasource:(id)collectionView
{
    return self.menuItemsArray;
}

- (void)MRCollectionView:(id)collectionView DidTapItem:(NSInteger)item withContent:(id)content
{
    [self selectItem:item];
}

@end
