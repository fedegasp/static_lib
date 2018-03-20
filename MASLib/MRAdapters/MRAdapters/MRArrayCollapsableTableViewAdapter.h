//
//  MRArrayCollapsableTableViewAdapter.h
//  MRAdapter
//
//  Created by Federico Gasperini on 16/02/16.
//  Copyright © 2016 accenture. All rights reserved.
//

#import "MRArrayTableViewAdapter.h"
#import <MRBase/lib.h>

@interface MRArrayCollapsableTableViewAdapter : MRArrayTableViewAdapter

@property (assign, nonatomic) IBInspectable BOOL startsExpanded;
@property (strong, nonatomic) IBInspectable NSString* headerXib;

-(IBAction)expandOrCollapseSectionAction:(id)sender;
-(void)expandOrCollapseSection:(NSInteger)section;
-(BOOL)sectionIsCollapsed:(NSInteger)section;

@property (strong, nonatomic) NSArray* headersContent;
@property (strong, nonatomic) IBInspectable NSString* plistHeadersContent;
@property (readonly) NSMutableArray* filteredData;
@property (readonly) NSMutableArray* originalData;
@property (readonly) NSIndexSet* collapsedSections;

-(NSArray<NSIndexPath*>*)expandSection:(NSInteger)section;
-(NSArray<NSIndexPath*>*)collapseSection:(NSInteger)section;

@end


@interface UITableViewHeaderFooterView (section)

@property (assign) NSInteger section;

@property (nonatomic, weak) IBOutlet UIView* backgroundView;

-(void)setContent:(id)content;

@end


@interface UIView (section)

@property (readonly) NSInteger section;

@end


@interface MRArrayCollapsableTableViewAdapterResponder : PlugInResponder

@property (weak, nonatomic) IBOutlet MRArrayCollapsableTableViewAdapter* adapter;
-(IBAction)pluginExpandOrCollapseSection:(id)sender;

@end


