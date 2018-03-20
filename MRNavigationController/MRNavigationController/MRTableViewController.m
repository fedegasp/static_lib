//
//
//  Created by fabio on 01/08/15.
//  Copyright (c) 2015 fabio. All rights reserved.
//

#import "MRTableViewController.h"
#import <objc/runtime.h>
#import "MRNavigationViewController.h"
#import "NSObject+scrollDelegate.h"

@interface MRTableViewController ()

@end


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-property-synthesis"
#pragma clang diagnostic ignored "-Wprotocol"

@implementation MRTableViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
     }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (!self.disableHideKeyboardOnTap)
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

#pragma mark parallax

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([self.scrollDelegate respondsToSelector:@selector(fgDidScroll:)]) {
        [self.scrollDelegate fgDidScroll:scrollView.contentOffset];
    }
    [self headerIsScrollingWithOffset:scrollView.contentOffset];
}

-(void)headerIsScrollingWithOffset:(CGPoint)offset{
    
    if(self.isParallax){
        if (offset.y < 0) {
            
            self.tableView.tableHeaderView.clipsToBounds = NO;
            UIView* v = self.tableView.tableHeaderView.subviews.firstObject;
            v.frame = CGRectMake(v.bounds.origin.x,
                                 offset.y,
                                 v.bounds.size.width,
                                 self.originalHeaderviewHeight-offset.y);
            
        }else{
            self.tableView.tableHeaderView.clipsToBounds = YES;
            UIView* v = self.tableView.tableHeaderView.subviews.firstObject;
            v.frame = CGRectMake(v.bounds.origin.x,
                                 offset.y/3,
                                 v.bounds.size.width,
                                 v.frame.size.height);
        }
    }
}

@end

#pragma clang diagnostic pop

