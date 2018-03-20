//
//  ContentsTableViewController.m
//  MASClient
//
//  Created by Federico Gasperini on 11/11/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import "ContentsTableViewController.h"
#import "UniversalContentsTableViewController.h"

@interface ContentsTableViewController ()

@end

@implementation ContentsTableViewController

- (void)viewDidLoad
{
    if (self.tableView.tableHeaderView == nil)
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,
                                                                                  0.0f, CGFLOAT_MIN)];
    [super viewDidLoad];
    
    self.automaticDimension = self.automaticDimension;
    
    NSDictionary* nibToRegister = [self registerNibs];
    for (NSString* nib in nibToRegister)
        [self.tableView registerNib:[UINib nibWithNibName:nib
                                                   bundle:nil]
             forCellReuseIdentifier:nibToRegister[nib]];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    
}

-(void)setAutomaticDimension:(BOOL)automaticDimension
{
    _automaticDimension = automaticDimension;
    if (automaticDimension)
    {
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 60;
    }
}

-(NSDictionary*)registerNibs
{
    return nil;
}

-(void)setNumberOfSections:(NSUInteger)nofs
{
    nofs = MAX(1, nofs);
    self.sectionConfiguration = [NSMutableArray arrayWithCapacity:nofs];
    self.headerContents = [NSMutableArray arrayWithCapacity:nofs];
    self.sectionsContents = [NSMutableArray arrayWithCapacity:nofs];
    self.footerContents = [NSMutableArray arrayWithCapacity:nofs];
    for (NSInteger i = 0; i < nofs; i++)
    {
        self.sectionConfiguration[i] = [[SectionConfiguration alloc] init];
        self.headerContents[i] = [DisplayableItem nullItem];
        self.sectionsContents[i] = @[];
        self.footerContents[i] = [DisplayableItem nullItem];
    }
}

-(id<DisplayableItem>)itemForHeaderInSection:(NSInteger)section
{
    if (section < self.headerContents.count)
        if (![self.headerContents[section] isNullItem])
            return self.headerContents[section];
    return nil;
}

-(id<DisplayableItem>)itemForFooterInSection:(NSInteger)section
{
    if (section < self.footerContents.count)
        if (![self.footerContents[section] isNullItem])
            return self.footerContents[section];
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    BOOL empty = YES;
    for (NSInteger i = 0; i < self.sectionsContents.count && empty; i++)
    {
        empty = [self countForSection:i withOverflow:NULL] == 0;
    }
    if (empty) {
        
        ContentInsetLabel *messageLbl = [[ContentInsetLabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                                            self.tableView.bounds.size.width,
                                                                                            self.tableView.bounds.size.height)];
        //set the message
        messageLbl.text = self.emptyMessage;
        //center the text
        messageLbl.textAlignment = NSTextAlignmentCenter;
        messageLbl.numberOfLines = 0;
        messageLbl.minimumScaleFactor = .7;
        messageLbl.adjustsFontSizeToFitWidth = YES;
        
        //        messageLbl.font = [UIFont fontWithName:@"OpenSans" size:15.0];
        messageLbl.textInset = UIEdgeInsetsMake(0, 20, 0, 20);
        messageLbl.textColor = [UIColor darkGrayColor];
        
        
        //set back to label view
        self.tableView.backgroundView = messageLbl;
        //no separator
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
        self.tableView.backgroundView = nil;
    return self.sectionsContents.count;
}

-(void)setEmptyMessage:(NSString *)emptyMessage
{
    _emptyMessage = emptyMessage;
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self countForSection:section withOverflow:NULL];
}

-(NSInteger)countForSection:(NSInteger)section withOverflow:(BOOL*)overflow
{
    if (overflow)
        (*overflow) = NO;
    
    SectionConfiguration* sc = self.sectionConfiguration[section];
    if ([sc collapsed] && [sc collapseable])
        return 0;
    
    NSInteger maxCount = sc.singleCell ? 1 : sc.maxcount;
    if (sc.validCount)
    {
        if (sc.validCount(self.sectionsContents[section], section))
        {
            if (overflow)
                (*overflow) = self.sectionsContents[section].count > maxCount;
            return MIN(self.sectionsContents[section].count, maxCount);
        }
        else
            return 0;
    }
    else
    {
        if (overflow)
            (*overflow) = self.sectionsContents[section].count > maxCount;
        return MIN(self.sectionsContents[section].count, maxCount);
    }
}

-(NSString*)nibForHeaderInSection:(NSInteger)section
{
    return @"";
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //   NSString* nibname = [self nibForHeaderInSection:section];
    
    id<DisplayableItem> headerItem = [self itemForHeaderInSection:section];
    NSString* nibname = nil;
    
    if (headerItem){
        nibname = headerItem.nibName;
    }
    
    if (nibname.length)
    {
        SectionHeader* v = nil;
        UINib* n = [UINib nibWithNibName:nibname
                                  bundle:nil];
        v = [[n instantiateWithOwner:nil
                             options:nil] firstObject];
        
        
        BOOL stateToSet = !self.sectionConfiguration[section].collapsed;
        [v.actionButton setSelected:stateToSet];
        
        if ([self countForSection:section withOverflow:NULL] > 0
            ||
            [self alwaysShowHeaderForSection:section])
        {
            id<DisplayableItem> headerItem = [self itemForHeaderInSection:section];
            if (headerItem)
            {
                [v setContent:headerItem];
                if ([v respondsToSelector:@selector(setSection:)])
                    [v setSection:section];
            }
        }
        if (v != nil)
            return v;
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, .01)];
}

-(BOOL)alwaysShowHeaderForSection:(NSUInteger)section
{
    return self.sectionConfiguration[section].collapseable;
}

-(NSString*)nibForFooterInSection:(NSInteger)section
{
    return @"";
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    BOOL overflow = NO;
    NSInteger count = [self countForSection:section withOverflow:&overflow];
    if (count > 0 &&
        (overflow ||
         !self.sectionConfiguration[section].showFooterOnlyOnOverflow))
    {
        SectionFooter* v = nil;
        id<DisplayableItem> footerItem = [self itemForFooterInSection:section];
        if (footerItem)
        {
            
            UINib* n = [UINib nibWithNibName:footerItem.nibName
                                      bundle:nil];
            v = [[n instantiateWithOwner:nil
                                 options:nil] firstObject];
            if ([v respondsToSelector:@selector(setContent:)])
                [v setContent:footerItem];
            if ([v respondsToSelector:@selector(setSection:)])
                [v setSection:section];
        }
        if (v != nil)
            return v;
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, .01)];
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (self.hasDynamicHeader == YES)
    {
        return  UITableViewAutomaticDimension;
    }
    else
    {
        if ([self countForSection:section withOverflow:NULL] > 0
            ||
            [self alwaysShowHeaderForSection:section])
        {
            if ([self itemForHeaderInSection:section] == nil)
                return .01;
            
            if ([[self itemForHeaderInSection:section] preferredHeight] > .0)
                return [[self itemForHeaderInSection:section] preferredHeight];
            return UITableViewAutomaticDimension;
        }
        return .01;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    BOOL overflow = NO;
    NSInteger count = [self countForSection:section withOverflow:&overflow];
    if (count > 0 &&
        (overflow ||
         !self.sectionConfiguration[section].showFooterOnlyOnOverflow))
    {
        if ([self itemForFooterInSection:section] == nil)
            return .01;
        
        if ([[self itemForFooterInSection:section] preferredHeight] > .0)
            return [[self itemForFooterInSection:section] preferredHeight];
        
        return 40;
    }
    return .01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL collapsed =  self.sectionConfiguration[indexPath.section].collapseable
    && self.sectionConfiguration[indexPath.section].collapsed;
    return collapsed
    ? .0
    : [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(id)contentAtIndexPath:(NSIndexPath*)indexPath
{
    SectionConfiguration* sc = self.sectionConfiguration[indexPath.section];
    
    id obj = nil;
    if (sc.singleCell)
    {
        NSArray* arr = self.sectionsContents[indexPath.section];
        if (sc.maxcount < arr.count)
            arr = [arr subarrayWithRange:NSMakeRange(0, sc.maxcount)];
        obj = arr;
    }
    else if (self.sectionsContents.count > indexPath.section &&
             self.sectionsContents[indexPath.section].count > indexPath.row)
        obj = self.sectionsContents[indexPath.section][indexPath.row];
    
    return obj;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = [self contentAtIndexPath:indexPath];
    
    UITableViewCell* c = nil;
    if (obj)
    {
        SectionConfiguration* sc = self.sectionConfiguration[indexPath.section];
        NSString* cellIdentifier = sc.reuseCellIdentifier;
        if (cellIdentifier.length == 0 &&
            [obj respondsToSelector:@selector(isp_tableViewCellIdentifier)])
            cellIdentifier = [obj isp_tableViewCellIdentifier];
        
        c = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!sc.validCount || sc.validCount(obj, indexPath.section))
        {
            [c setContent:obj];
            [c setPostData:obj];
            
            [self configureCell:c forRowAtIndexPath:indexPath];
        }
    }
    
    return c ?: [[UITableViewCell alloc] init];
}

-(void)configureCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    
}

-(IBAction)showAll:(UIButton*)sender
{
}

-(IBAction)footerAction:(id)sender
{
}

-(IBAction)collapseOrExpandSectionAction:(id)sender
{
    NSUInteger section = [sender section];
    [self collapseOrExpandSection:section];
}

-(void) collapseOrExpandSection:(NSUInteger)section
{
    BOOL stateToSet = !self.sectionConfiguration[section].collapsed;
    NSUInteger sectionToCollapse = NSNotFound;
    if (self.accordion)
    {
        sectionToCollapse = [self.sectionConfiguration indexOfObjectPassingTest:
                             ^BOOL(SectionConfiguration * obj, NSUInteger idx, BOOL* stop)
                             {
                                 BOOL passing = !obj.collapsed;
                                 *stop = passing;
                                 return passing;
                             }];
        [self.sectionConfiguration setValue:@YES forKey:@"collapsed"];
    }
    self.sectionConfiguration[section].collapsed = stateToSet;
    
    NSMutableIndexSet* ids = [NSMutableIndexSet indexSetWithIndex:section];
    if (sectionToCollapse != NSNotFound)
        [ids addIndex:sectionToCollapse];
    
    [self.tableView reloadSections:ids withRowAnimation:UITableViewRowAnimationFade];
}

@end


@implementation SectionConfiguration

-(instancetype)init
{
    self = [super init];
    if (self)
        self.maxcount = NSIntegerMax;
    return self;
}

+(instancetype)sectionWithMaxCount:(NSUInteger)max
{
    SectionConfiguration* ret = [[self alloc] init];
    ret.maxcount = max;
    ret.singleCell = NO;
    ret.showFooterOnlyOnOverflow = YES;
    return ret;
}

+(instancetype)sectionWithSingleCell
{
    SectionConfiguration* ret = [[self alloc] init];
    ret.singleCell = YES;
    return ret;
}

@end

