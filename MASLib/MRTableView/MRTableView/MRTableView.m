//
//  BaseTableView.m
//  ContextLib
//
//  Created by Dario Trisciuoglio on 06/05/13.
//  Copyright (c) 2013 avanade. All rights reserved.
//

#import "MRTableView.h"
#import <MRBase/UITableViewCell+MRUtil.h>

@implementation MRTableView
{
    BOOL collectVariableCells;
}

-(void)setDelegates{
    collectVariableCells = self.variableCells == nil;
    if(!self.delegate)
    {
        self.delegate = self;
    }
    if(!self.dataSource)
    {
        self.dataSource = self;
    }
    if(self.style == UITableViewStyleGrouped)
    {
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
    }
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setDelegates];
}


-(void)changeLocale:(NSNotification*)notification
{
    [self setEditing:NO animated:YES];
}

-(void)rotateDevice:(NSNotification*)notification
{
    [self reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.modelData isMultiDimensional])
        return [self.modelData count];
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.modelData isMultiDimensional])
        return [self.modelData[section] count];
    else
        return [self.modelData count];
}

-(id)contentDataAtIndexPath:(NSIndexPath *)indexPath
{
    id cotentData = nil;
    if([self.modelData isMultiDimensional])
    {
        cotentData = self.modelData[indexPath.section];
        if (self.arrayCellIdentifier)
            self.cellIdentifier = self.arrayCellIdentifier[indexPath.section];
    }
    else
        cotentData = self.modelData;
    return cotentData;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retval = 0;
    if ([self.baseTableViewDelegate respondsToSelector:@selector(baseTableView:heightForRowAtIndexPath:)])
        retval = [self.baseTableViewDelegate baseTableView:self heightForRowAtIndexPath:indexPath];
    if (retval == 0)
        retval = [[self cellsForRowAtIndexPath:indexPath] heightWithModelData:[self contentDataAtIndexPath:indexPath][indexPath.row]];
    if (retval == 0)
        retval = self.rowHeight;
    return retval;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.baseTableViewDelegate respondsToSelector:@selector(baseTableView:canEditRowAtIndexPath:)])
        return [self.baseTableViewDelegate baseTableView:self canEditRowAtIndexPath:indexPath];
    else
        return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if ([self.baseTableViewDelegate respondsToSelector:@selector(baseTableView:commitEditingStyle:forRowAtIndexPath:)])
            [self.baseTableViewDelegate baseTableView:self commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

-(UITableViewCell*)cellsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    if ([self.baseTableViewDelegate respondsToSelector:@selector(baseTableView:cellIdentifierForModel:atIndexPath:)])
        self.cellIdentifier = [self.baseTableViewDelegate baseTableView:self
                                                 cellIdentifierForModel:[self modelAtIndexPath:indexPath]
                                                            atIndexPath:indexPath];
    
    if(self.cellIdentifier)
        cell = [self dequeueReusableCellWithIdentifier:self.cellIdentifier];
    else{
        cell = [self dequeueReusableCellWithIdentifier:self.arrayCellIdentifier[indexPath.row]];
    }
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:self.arrayCellIdentifier[indexPath.row] owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    return cell;
}

-(id)modelAtIndexPath:(NSIndexPath*)indexPath
{
    NSArray* contentData = nil;
    if([self.modelData isMultiDimensional])
        contentData = self.modelData[indexPath.section];
    else
        contentData = self.modelData;
    
    return contentData[indexPath.row];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cotentData = [self contentDataAtIndexPath:indexPath];
    UITableViewCell* cell = [self cellsForRowAtIndexPath:indexPath];
    cell.isOnlyCell = [cotentData count] == 1;
    cell.isLastCell = indexPath.row == [cotentData count] - 1;
    [cell setContent:[cotentData objectAtIndex:indexPath.row]];
    if (self.oddColor || self.evenColor)
    {
        if (!cell.backgroundView)
            cell.backgroundView = [[UIView alloc] init];
        
        if (indexPath.row%2 != 0)
            cell.backgroundView.backgroundColor = self.oddColor;
        else
            cell.backgroundView.backgroundColor = self.evenColor;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.baseTableViewDelegate respondsToSelector:@selector(baseTableView:didSelectModel:atIndexPath:)])
    {
        NSArray* contentData = nil;
        if([self.modelData isMultiDimensional])
            contentData = self.modelData[indexPath.section];
        else
            contentData = self.modelData;
        
        [self.baseTableViewDelegate baseTableView:self didSelectModel:contentData[indexPath.row] atIndexPath:indexPath];
    }
    else if ([self.baseTableViewDelegate respondsToSelector:@selector(baseTableView:didSelectModel:)])
    {
        NSArray* contentData = nil;
        if([self.modelData isMultiDimensional])
            contentData = self.modelData[indexPath.section];
        else
            contentData = self.modelData;
        
        [self.baseTableViewDelegate baseTableView:self didSelectModel:contentData[indexPath.row]];
    }
    [self deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.baseTableViewDelegate respondsToSelector:@selector(baseTableView:willDisplayCell:forRowAtIndexPath:)])
    {
        [self.baseTableViewDelegate baseTableView:self willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if([self.baseTableViewDelegate respondsToSelector:@selector(baseTableView:viewForFooterInSection:)])
        return [self.baseTableViewDelegate baseTableView:self viewForFooterInSection:section];
    else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if([self.baseTableViewDelegate respondsToSelector:@selector(baseTableView:heightForFooterInSection:)])
        return [self.baseTableViewDelegate baseTableView:self heightForFooterInSection:section];
    else
        return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([self.baseTableViewDelegate respondsToSelector:@selector(baseTableView:viewForHeaderInSection:)])
        return [self.baseTableViewDelegate baseTableView:self viewForHeaderInSection:section];
    else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([self.baseTableViewDelegate respondsToSelector:@selector(baseTableView:heightForHeaderInSection:)])
        return [self.baseTableViewDelegate baseTableView:self heightForHeaderInSection:section];
    else
        return 0;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.baseTableViewDelegate respondsToSelector:@selector(baseTableView:canMoveRowAtIndexPath:)])
        return [self.baseTableViewDelegate baseTableView:self canMoveRowAtIndexPath:indexPath];
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.baseTableViewDelegate respondsToSelector:@selector(baseTableView:shouldIndentWhileEditingRowAtIndexPath:)])
        return [self.baseTableViewDelegate baseTableView:self shouldIndentWhileEditingRowAtIndexPath:indexPath];
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.baseTableViewDelegate respondsToSelector:@selector(baseTableView:editingStyleForRowAtIndexPath:)])
        return [self.baseTableViewDelegate baseTableView:self editingStyleForRowAtIndexPath:indexPath];
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if ([self.baseTableViewDelegate respondsToSelector:@selector(baseTableView:moveRowAtIndexPath:toIndexPath:)])
        [self.baseTableViewDelegate baseTableView:self
                               moveRowAtIndexPath:sourceIndexPath
                                      toIndexPath:destinationIndexPath];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if ([self.baseTableViewDelegate respondsToSelector:@selector(baseTableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)])
        return [self.baseTableViewDelegate baseTableView:self
                targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath
                                     toProposedIndexPath:proposedDestinationIndexPath];
    return proposedDestinationIndexPath;
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if ([self.baseTableViewDelegate respondsToSelector:@selector(baseTableView:scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.baseTableViewDelegate baseTableView:self scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([self.baseTableViewDelegate respondsToSelector:@selector(baseTableView:scrollViewWillBeginDragging:)]) {
        [self.baseTableViewDelegate baseTableView:self scrollViewWillBeginDragging:scrollView.contentOffset];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.baseTableViewDelegate respondsToSelector:@selector(baseTableView:scrollViewDidScrollOffset:)]) {
        [self.baseTableViewDelegate baseTableView:self scrollViewDidScrollOffset:scrollView.contentOffset];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([self.baseTableViewDelegate respondsToSelector:@selector(baseTableView:scrollViewDidEndDragging:willDecelerate:)]) {
        [self.baseTableViewDelegate baseTableView:self scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

@end
