//
//  AccordionTableViewController.h
//  dpr
//
//  Created by Giovanni Castiglioni on 18/12/15.
//  Copyright © 2015 Federico Gasperini. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MRAccordionTableViewController : UIViewController	<UITableViewDataSource,UITableViewDelegate>
@property (weak,nonatomic) IBOutlet UITableView *tableView;
@property NSInteger selectedRow;
@property (assign) IBInspectable CGFloat unselectedCellHeight;
@property (assign) IBInspectable NSString *cellIdentifier;
@end

@interface UITableView (PrototypeCells)

- (CGFloat)heightForRowWithReuseIdentifier:(NSString*)reuseIdentifier;
- (UITableViewCell*)prototypeCellWithReuseIdentifier:(NSString*)reuseIdentifier;

@end


#import <objc/runtime.h>

static char const * const key = "prototypeCells";

@implementation UITableView (PrototypeCells)

- (void)setPrototypeCells:(NSMutableDictionary *)prototypeCells {
	objc_setAssociatedObject(self, key, prototypeCells, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)prototypeCells {
	return objc_getAssociatedObject(self, key);
}

- (CGFloat)heightForRowWithReuseIdentifier:(NSString*)reuseIdentifier {
	return [self prototypeCellWithReuseIdentifier:reuseIdentifier].frame.size.height;
}

- (UITableViewCell*)prototypeCellWithReuseIdentifier:(NSString*)reuseIdentifier {
	if (self.prototypeCells == nil) {
		self.prototypeCells = [[NSMutableDictionary alloc] init];
	}
	
	UITableViewCell* cell = self.prototypeCells[reuseIdentifier];
	if (cell == nil) {
		cell = [self dequeueReusableCellWithIdentifier:reuseIdentifier];
		self.prototypeCells[reuseIdentifier] = cell;
	}
	return cell;
}

@end
