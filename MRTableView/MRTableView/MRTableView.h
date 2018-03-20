//
//  BaseTableView.h
//  ContextLib
//
//  Created by Dario Trisciuoglio on 06/05/13.
//  Copyright (c) 2013 avanade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewHeaderFooterView+MRInterface.h"
#import "UITableView+backgroundImageview.h"
#import "NSArray+MRInterface.h"

@class MRTableView;

@protocol MRTableViewDelegate <NSObject>

@optional

-(void)baseTableView:(MRTableView*)btv didSelectModel:(id)model;// __attribute((deprecated));
-(void)baseTableView:(MRTableView*)btv didSelectModel:(id)model atIndexPath:(NSIndexPath*)indexPath;
-(void)baseTableView:(MRTableView*)btv willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
-(CGFloat)baseTableView:(MRTableView*)btv heightForRowAtIndexPath:(NSIndexPath*)indexPath;
-(void)baseTableView:(MRTableView*)btv scrollViewWillBeginDragging:(CGPoint)offset;
-(void)baseTableView:(MRTableView*)btv scrollViewDidScrollOffset:(CGPoint)offset;
-(void)baseTableView:(MRTableView*)btv scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
-(void)baseTableView:(MRTableView *)btv scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;

-(CGFloat)baseTableView:(MRTableView*)btv heightForFooterInSection:(NSInteger)section;
-(UIView *)baseTableView:(MRTableView*)btv viewForFooterInSection:(NSInteger)section;

-(CGFloat)baseTableView:(MRTableView*)btv heightForHeaderInSection:(NSInteger)section;
-(UIView *)baseTableView:(MRTableView*)btv viewForHeaderInSection:(NSInteger)section;

-(NSString*)baseTableView:(MRTableView*)btv cellIdentifierForModel:(id)model atIndexPath:(NSIndexPath*)indexPath;

-(BOOL)baseTableView:(MRTableView*)btv canEditRowAtIndexPath:(NSIndexPath*)indexPath;
-(BOOL)baseTableView:(MRTableView*)btv canMoveRowAtIndexPath:(NSIndexPath*)indexPath;
-(void)baseTableView:(MRTableView*)btv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)baseTableView:(MRTableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
-(UITableViewCellEditingStyle)baseTableView:(MRTableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath;
-(BOOL)baseTableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)baseTableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;

@end

@interface MRTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) IBOutletCollection(UITableViewCell) NSMutableArray* variableCells;

@property(nonatomic, weak) IBOutlet id baseTableViewDelegate;///<>
@property(nonatomic, strong) id modelData;
@property(nonatomic, strong) IBInspectable NSString* cellIdentifier;
@property(nonatomic, strong) NSArray* arrayCellIdentifier;
-(void)setDelegates;
@property(nonatomic, strong) IBInspectable UIColor* evenColor;
@property(nonatomic, strong) IBInspectable UIColor* oddColor;

-(UITableViewCell*)cellsForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
