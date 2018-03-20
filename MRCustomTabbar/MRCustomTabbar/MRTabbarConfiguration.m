//
//  MyDprBuilder.m
//  dpr
//
//  Created by Gai, Fabio on 08/07/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

#import "MRTabbarConfiguration.h"
#import "MRConfigurableTabbarController.h"

@implementation MRTabbarConfiguration

+(instancetype)configurationWithPlistName:(NSString*)plistName
{
   id retVal = nil;
   
   NSString* confFile =
   [[NSBundle mainBundle] pathForResource:plistName
                                   ofType:@"plist"];
   if (confFile)
   {
      NSArray* array = [NSArray arrayWithContentsOfFile:confFile];
      if (array.count)
         retVal = [[self alloc] initWithArray:array];
   }
   
   return retVal;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self)
    {
       self.children = [[NSMutableArray alloc] init];
       self.icon = dict[@"icon"];
       self.selectedIcon = dict[@"selectedIcon"];
       self.name = dict[@"name"];
       self.selected = [dict[@"selected"] boolValue];
       self.storyboard = dict[@"storyboard"];
       self.identifier = dict[@"identifier"];
       self.title = dict[@"title"];
       self.transient = [dict[@"transient"] boolValue];

       for (NSDictionary *d in dict[@"children"])
          [self.children addObject:[[self.class alloc] initWithDictionary:d]];
    }
    return self;
}

-(UIViewController*)loadViewController
{
   UIStoryboard* st = nil;
   if (self.storyboard.length)
      st = [UIStoryboard storyboardWithName:self.storyboard
                                     bundle:[NSBundle mainBundle]];
   else
      st = [self.tabbarController storyboard];

   UIViewController* c = nil;
   if (self.identifier)
      c = [st instantiateViewControllerWithIdentifier:self.identifier];
   else
      c = [st instantiateInitialViewController];
   
   return c;
}

-(UIViewController*)loadViewControllerAtIndex:(NSUInteger)index
{
   if (self.children.count > index)
      return [self.children[index] loadViewController];

   return nil;
}

-(BOOL)isTransientAtIndex:(NSUInteger)index
{
    if (self.children.count > index)
        return [self.children[index] isTransient];
    return NO;
}

- (instancetype)initWithArray:(NSArray *)array
{
    self = [super init];
    if(self)
    {
        self.children = [[NSMutableArray alloc] init];
        for (NSDictionary *d in array)
            [self.children addObject:[[MRTabbarConfiguration alloc] initWithDictionary:d]];
    }
    return self;
}

-(NSInteger)selectedSectionIndex{
   NSInteger ret = 0;
   ret = [self.children indexOfObjectPassingTest:^BOOL(MRTabbarConfiguration* _Nonnull obj,
                                                       NSUInteger idx, BOOL * _Nonnull stop)
          {
             BOOL passed = obj.isSelected;
             *stop = passed;
             return passed;
          }];
   return ret != NSNotFound ? ret : 0;
}

-(void)setTabbarController:(MRConfigurableTabbarController *)tabbarController
{
   _tabbarController = tabbarController;
   for (MRTabbarConfiguration* c in self.children)
      c.tabbarController = tabbarController;
}

-(BOOL)isEqual:(id)object
{
   if ([object isKindOfClass:self.class])
      return [self.name isEqual:[object name]];
   return NO;
}

-(NSUInteger)hash
{
   return [self.name hash];
}

@end
