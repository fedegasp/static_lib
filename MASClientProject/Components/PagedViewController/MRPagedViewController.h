//
//  DPRPagedViewController.h
//  dpr
//
//  Created by Gai, Fabio on 15/02/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

@interface MRPagedViewController : MRViewController <MRCollectionViewDelegate, MRPaginatedMenuDelegate>
@property IBOutlet MRCollectionView *menuCollection;
@property (strong,nonatomic) NSMutableArray *menuItemsArray;
@property (strong,nonatomic) MRPaginationController *pgController;
@property BOOL initialized;
@end
