//
//  AccordionTableViewController.m
//  dpr
//
//  Created by Giovanni Castiglioni on 18/12/15.
//  Copyright © 2015 Federico Gasperini. All rights reserved.
//

#import "MRAccordionTableViewController.h"


@interface MRAccordionTableViewController ()
@end

@implementation MRAccordionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.selectedRow = -1;
}


#pragma Override to customize behavior

- (IBAction)closeRow:(id)sender{
	[self selectRowAtIndexPath:[NSIndexPath indexPathForItem:self.selectedRow inSection:0]];
}

- (void) selectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(self.selectedRow == indexPath.row) {
		self.selectedRow = -1;
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		indexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
	}
	else  {
		self.selectedRow = indexPath.row;
	}
	[self.tableView beginUpdates];
	[self.tableView endUpdates];

}

#pragma mark -
#pragma mark Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat height;
	if(indexPath.row == self.selectedRow)
		height = [tableView heightForRowWithReuseIdentifier:self.cellIdentifier];
	else
		height = self.unselectedCellHeight;
	
	return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self selectRowAtIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

@end
