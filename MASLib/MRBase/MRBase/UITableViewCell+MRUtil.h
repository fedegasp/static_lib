//
//  UITableViewCell+IKInterface.h
//  GSEIndisp
//
//  Created by Federico Gasperini on 05/12/13.
//  Copyright (c) 2013 Giovanni Castiglioni. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MRTableView;

@interface UIView (IndexPath)

-(NSIndexPath* __nullable)indexPath;

@end

@interface UITableViewCell (MRUtil)

@property (nonatomic, strong, nullable) id content;

-(CGFloat)heightWithModelData:(id __nullable)content;

@property (readonly, nonatomic, nullable) UITableView *tableView;
@property (readonly, nonatomic, nullable) NSIndexPath* indexPath;
@property (nonatomic, assign) BOOL isLastCell;
@property (nonatomic, assign) BOOL isOnlyCell;
@property (nonatomic, assign) BOOL isDeletable;

@property (nonatomic, strong, nullable) IBInspectable UIColor* selectedBackgroundColor;

@end
