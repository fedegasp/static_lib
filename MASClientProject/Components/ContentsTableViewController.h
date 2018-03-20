//
//  ContentsTableViewController.h
//  MASClient
//
//  Created by Federico Gasperini on 11/11/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DisplayableItem.h"
//#import "SectionHeader.h"
//#import "SectionFooter.h"

#import "SectionConfiguration.h"


@interface ContentsTableViewController : MRTableViewController

@property (assign, nonatomic) BOOL automaticDimension;

-(NSDictionary*)registerNibs;

-(void)setNumberOfSections:(NSUInteger)nofs;

@property (strong, nonatomic) NSMutableArray<SectionConfiguration*>* sectionConfiguration;

@property (strong, nonatomic) NSMutableArray<id<DisplayableItem>>* headerContents;
@property (strong, nonatomic) NSMutableArray<id<DisplayableItem>>* footerContents;

@property (strong, nonatomic) id currentItem;

@property (strong, nonatomic) IBInspectable NSString* emptyMessage;

@property (strong, nonatomic) NSMutableArray<NSArray*>* sectionsContents;
@property (assign, nonatomic) BOOL hasDynamicHeader;
@property (assign, nonatomic) IBInspectable BOOL accordion;

-(BOOL)alwaysShowHeaderForSection:(NSUInteger)section;

-(id<DisplayableItem>)itemForHeaderInSection:(NSInteger)section;
-(id<DisplayableItem>)itemForFooterInSection:(NSInteger)section;

-(NSString*)nibForHeaderInSection:(NSInteger)section;
-(NSString*)nibForFooterInSection:(NSInteger)section;

-(IBAction)showAll:(UIButton*)sender;
-(IBAction)footerAction:(id)sender;

-(NSInteger)countForSection:(NSInteger)section withOverflow:(BOOL*)overflow;
-(void)configureCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath;

-(id)contentAtIndexPath:(NSIndexPath*)indexPath;

-(IBAction)collapseOrExpandSectionAction:(id)sender;
-(void)collapseOrExpandSection:(NSUInteger)section;

@end

