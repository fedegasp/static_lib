//
//  MKenBurns.h
//  Mobily
//
//  Created by Gai, Fabio on 14/10/15.
//  Copyright © 2015 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRBrandConfigurator : NSObject

+ (instancetype) sharedInstance;
@property(nonatomic, strong)NSDictionary* configurationDict;
@property(nonatomic, strong)NSString* configurationKey;

@end
