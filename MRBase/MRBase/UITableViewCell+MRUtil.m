//
//  UITableViewCell+MRUtil.m
//  MRBase
//
//  Created by Federico Gasperini on 05/12/13.
//  Copyright (c) 2013 Giovanni Castiglioni. All rights reserved.
//

#import "UITableViewCell+MRUtil.h"
#import <objc/runtime.h>


@implementation UIView (IndexPath)

-(NSIndexPath*)indexPath
{
   UITableViewCell* cell = (id)self;
   while (cell && ![cell isKindOfClass:UITableViewCell.class])
      cell = (id)cell.superview;
   NSIndexPath* indexPath = [cell indexPath];
   return [indexPath copy];
}

@end


@implementation UITableViewCell (MRUtil)

-(NSIndexPath*)indexPath
{
    return [self.tableView indexPathForCell:self];
}

-(UITableView*)tableView
{
    UIView* tableView = [self superview];
    while (tableView)
    {
        if ([tableView isKindOfClass:UITableView.class])
            return (id)tableView;
        else
            tableView = [tableView superview];
    }
    return nil;
}

-(BOOL)isDeletable
{
   return [objc_getAssociatedObject(self, @selector(isDeletable)) boolValue];
}

-(void)setIsDeletable:(BOOL)isDeletable
{
   objc_setAssociatedObject(self, @selector(isDeletable), @(isDeletable), OBJC_ASSOCIATION_RETAIN);
}

-(BOOL)isLastCell
{
   return [objc_getAssociatedObject(self, @selector(isLastCell)) boolValue];
}

-(void)setIsLastCell:(BOOL)isLastCell
{
   objc_setAssociatedObject(self, @selector(isLastCell), @(isLastCell), OBJC_ASSOCIATION_RETAIN);
}

-(BOOL)isOnlyCell
{
   return [objc_getAssociatedObject(self, @selector(isOnlyCell)) boolValue];
}

-(void)setIsOnlyCell:(BOOL)isOnlyCell
{
   objc_setAssociatedObject(self, @selector(isOnlyCell), @(isOnlyCell), OBJC_ASSOCIATION_RETAIN);
}

-(id)content
{
    return objc_getAssociatedObject(self, @selector(content));
}

-(void)setContent:(id)content
{
   objc_setAssociatedObject(self, @selector(content),
                            content, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//   if (!([[content description] hasPrefix:@"<"] &&
//         [[content description] hasSuffix:@">"]))
//       self.textLabel.text = [content description];
}

-(CGFloat)heightWithModelData:(id)content
{
   return 0;
}

-(void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor
{
   if (selectedBackgroundColor)
      self.selectedBackgroundView = [[UIView alloc] init];
   else
      self.selectedBackgroundView = nil;
   self.selectedBackgroundView.backgroundColor = selectedBackgroundColor;
}

-(UIColor*)selectedBackgroundColor
{
   return self.selectedBackgroundView.backgroundColor;
}

@end
