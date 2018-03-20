//
//  SectionConfiguration.h
//  MASClient
//
//  Created by Acciai, Ludovica on 27/10/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^ValidCount)(id sectionContent, NSUInteger section);

@interface SectionConfiguration : NSObject

@property (strong, nonatomic) NSString* reuseCellIdentifier;
@property (assign, nonatomic) NSInteger maxcount;
@property (assign, nonatomic) BOOL singleCell;
@property (assign, nonatomic) BOOL collapseable;
@property (assign, nonatomic) BOOL collapsed;
@property (copy, nonatomic) ValidCount validCount;

+(instancetype)sectionWithMaxCount:(NSUInteger)max;
+(instancetype)sectionWithSingleCell;

@property (assign) BOOL showFooterOnlyOnOverflow;

@end
