//
//  MRTabbarConfiguration.h
//  dpr
//
//  Created by Gai, Fabio on 08/07/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MRConfigurableTabbarController;

@interface MRTabbarConfiguration : NSObject

+(instancetype)configurationWithPlistName:(NSString*)plistName;

-(instancetype)initWithDictionary:(NSDictionary *)dict;
-(instancetype)initWithArray:(NSArray *)array;

@property NSString *icon;
@property NSString *selectedIcon;
@property NSString *name;
@property NSString *title;

@property NSString *storyboard;
@property NSString *identifier;

@property NSMutableArray <MRTabbarConfiguration*> *children;
@property (readonly, nonatomic) NSInteger selectedSectionIndex;
@property (assign, nonatomic, getter=isSelected) BOOL selected;
@property (assign, nonatomic, getter=isTransient) BOOL transient;

-(BOOL)isTransientAtIndex:(NSUInteger)index;

@property (weak, nonatomic) MRConfigurableTabbarController* tabbarController;

-(UIViewController*)loadViewControllerAtIndex:(NSUInteger)index;

@end
