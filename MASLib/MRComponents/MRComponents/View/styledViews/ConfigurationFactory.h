//
//  ConfigurationFactory.h
//  MRComponents
//
//  Created by Enrico Cupellini on 13/03/18.
//  Copyright © 2018 Accenture - MAS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DisplayableItem.h"

@interface ConfigurationFactory : NSObject

+ (instancetype _Nonnull) sharedInstance;

//@property (nonatomic, strong)NSDictionary *configurationDict;
-(void)setConfigurationDict:(NSDictionary*_Nonnull)configurationDict;
+(DisplayableItem*)itemWithStyle:(NSString *)style andStatus:(NSString *)status;

@end
