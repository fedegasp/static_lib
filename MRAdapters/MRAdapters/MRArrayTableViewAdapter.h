//
//  MRArrayTableViewAdapter.h
//  Ax
//
//  Created by Federico Gasperini on 02/03/15.
//  Copyright (c) 2015 Federico Gasperini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MRBase/MRChainedDelegate.h>

@interface NSObject ()

-(NSString*)tableViewCellText;
-(UIImage*)tableViewCellImage;

-(NSString*)tableViewCellIdentifier;

-(void)setContent:(id)content;

@end


@protocol MRArrayTableViewAdapterDelegate <NSObject>

@optional
-(void)tableView:(UITableView*)tableView didSelect:(NSArray*)selection;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSString*)tableView:(UITableView*)tableView reuseIdentifierForIndexPath:(NSIndexPath*)indexPath;

@end


@interface MRArrayTableViewAdapter : MRChainedDelegate <UITableViewDataSource,UITableViewDelegate>

@property (readonly) BOOL arrayOfArray;
@property (readonly) NSMutableSet* selectedObjects;

@property (weak, nonatomic) IBOutlet id<MRArrayTableViewAdapterDelegate> adapterDelegate;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutletCollection(NSObject) NSMutableArray* data;

@property (assign, nonatomic) IBInspectable BOOL transientSelection;
@property (strong, nonatomic) IBInspectable NSString* plistSource;
@property (strong, nonatomic) IBInspectable NSString* cellIdentifier;

-(id)itemAtIndexPath:(NSIndexPath*)indexPath;

@end
