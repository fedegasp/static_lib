//
//  MRArrayCollapsableTableViewAdapter.m
//  MRAdapter
//
//  Created by Federico Gasperini on 16/02/16.
//  Copyright © 2016 accenture. All rights reserved.
//

#import "MRArrayCollapsableTableViewAdapter.h"
#import <MRBase/lib.h>
#import <MRTableView/lib.h>
#import <objc/runtime.h>


@interface UIView (section_private)

-(void)setExpandedState:(BOOL)expanded;

@end


@interface MRArrayCollapsableTableViewAdapter ()

@property (strong, nonatomic) NSMutableIndexSet* collapsedSections;
@property (strong, nonatomic) NSMutableArray* originalData;
@property (strong, nonatomic) NSMutableArray* filteredData;
@property (strong, nonatomic) NSMutableSet* headersForSections;

@end


@implementation MRArrayCollapsableTableViewAdapter
{
   NSMutableIndexSet* _collapsedSections;
}

@synthesize collapsedSections = _collapsedSections;

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   NSInteger retval = [super numberOfSectionsInTableView:tableView];
   
   if (!_collapsedSections)
   {
      _headersForSections = [[NSMutableSet alloc] init];
      _collapsedSections = [[NSMutableIndexSet alloc] init];
      if (!self.startsExpanded)
         for (NSInteger idx = 0; idx < retval; idx++)
            [_collapsedSections addIndex:idx];
   }
   
   return retval;
}

-(void)setStartsExpanded:(BOOL)startsExpanded
{
   _startsExpanded = startsExpanded;
   if (self.data)
      self.data = self.originalData;
}

-(void)setHeaderXib:(NSString *)headerXib
{
   _headerXib = headerXib;
   if (self.tableView)
      [self.tableView registerNib:[UINib nibWithNibName:headerXib
                                                 bundle:nil]
forHeaderFooterViewReuseIdentifier:@"header"];
}

-(void)setTableView:(UITableView *)tableView
{
   if (self.headerXib)
      [tableView registerNib:[UINib nibWithNibName:self.headerXib
                                            bundle:nil]
forHeaderFooterViewReuseIdentifier:@"header"];
   
   [super setTableView:tableView];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   UITableViewHeaderFooterView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
   
   view.section = section;
   [self.headersForSections addObject:view];
   if (section < self.headersContent.count)
      [view setContent:self.headersContent[section]];
   [view setExpandedState:![self.collapsedSections containsIndex:section]];
   
   return view;
}

-(void)setData:(NSMutableArray *)data
{
   self.originalData = [data mutableCopy];
   self.filteredData = [[NSMutableArray alloc] init];
   if (self.startsExpanded)
   {
      if (self.originalData.isMultiDimensional)
         for (NSArray* arr in self.originalData)
            [self.filteredData addObject:[arr mutableCopy]];
      else
         [self.filteredData addObjectsFromArray:data];
   }
   else
   {
      if (self.originalData.isMultiDimensional)
         for (NSInteger i = 0; i < self.originalData.count; i++)
            [self.filteredData addObject:[[NSMutableArray alloc] init]];
   }
   
   [super setData:self.filteredData];
}

-(IBAction)expandOrCollapseSectionAction:(UIView*)sender // you can pass indexpath in private implementation
{
   NSInteger section = sender.section;
   [self expandOrCollapseSection:section];
}

-(void)expandOrCollapseSection:(NSInteger)section
{
   BOOL mustExpand = [_collapsedSections containsIndex:section];
   NSArray<NSIndexPath*>* toAnimate = nil;
   if (mustExpand)
   {
      [_collapsedSections removeIndex:section];
      toAnimate = [self expandSection:section];
      [self.tableView insertRowsAtIndexPaths:toAnimate
                            withRowAnimation:UITableViewRowAnimationAutomatic];
   }
   else
   {
      toAnimate = [self collapseSection:section];
      if (toAnimate.count)
      {
         [_collapsedSections addIndex:section];
         [self.tableView deleteRowsAtIndexPaths:toAnimate
                               withRowAnimation:UITableViewRowAnimationAutomatic];
      }
   }
   
   NSSet* headers = [self.headersForSections filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"section == %@",@(section)]];
   
   for (UIView* h in headers)
      [h setExpandedState:mustExpand];
}

-(BOOL)sectionIsCollapsed:(NSInteger)section
{
   return [self.collapsedSections containsIndex:section];
}

-(NSArray<NSIndexPath*>*)expandSection:(NSInteger)section
{
   NSMutableArray<NSIndexPath*>* retval = [[NSMutableArray alloc] init];
   
   NSMutableArray* filtered = nil;
   NSMutableArray* original = nil;
   
   if (self.arrayOfArray)
   {
      filtered = self.filteredData[section];
      original = self.originalData[section];
   }
   else
   {
      filtered = self.filteredData;
      original = self.originalData;
   }
   
   [filtered removeAllObjects];
   [filtered addObjectsFromArray:original];
   
   for (NSInteger i = 0; i < original.count; i++)
      [retval addObject:[NSIndexPath indexPathForItem:i inSection:section]];
   
   return retval;
}

-(NSArray<NSIndexPath*>*)collapseSection:(NSInteger)section
{
   NSMutableArray<NSIndexPath*>* retval = [[NSMutableArray alloc] init];
   
   NSMutableArray* filtered = nil;
   
   if (self.arrayOfArray)
      filtered = self.filteredData[section];
   else
      filtered = self.filteredData;

   for (NSInteger i = 0; i < filtered.count; i++)
      [retval addObject:[NSIndexPath indexPathForItem:i inSection:section]];
   
   [filtered removeAllObjects];
   
   return retval;
}

-(void)setPlistHeadersContent:(NSString *)plistHeadersContent
{
   _plistHeadersContent = plistHeadersContent;
   if (_plistHeadersContent)
      self.headersContent = [NSMutableArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:self.plistHeadersContent
                                                                                 withExtension:@"plist"]];
   else
      self.headersContent = nil;
}

@end


@implementation UITableViewHeaderFooterView (section)

@dynamic backgroundView;

-(void)setContent:(id)content
{
   self.textLabel.text = [content description];
}

-(void)setSection:(NSInteger)section
{
   objc_setAssociatedObject(self, @selector(section), @(section), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSInteger)section
{
   return [objc_getAssociatedObject(self, @selector(section)) integerValue];
}

@end


@implementation UIView (section_private)

-(void)setExpandedState:(BOOL)expanded
{
   if ([self respondsToSelector:@selector(setSelected:)])
      [(id)self setSelected:expanded];
   for (UIView* subView in self.subviews)
      [subView setExpandedState:expanded];
}

@end


@implementation UIView (section)

-(NSInteger)section
{
   if ([self respondsToSelector:@selector(setSection:)])
   {
      return self.section;
   }
   else
   {
      return [[self superview] section];
   }
}

@end


@implementation MRArrayCollapsableTableViewAdapterResponder

-(IBAction)pluginExpandOrCollapseSection:(id)sender
{
   [self.adapter expandOrCollapseSectionAction:sender];
}

@end
