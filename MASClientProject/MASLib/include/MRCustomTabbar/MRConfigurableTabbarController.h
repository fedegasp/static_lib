//
//  MRConfigurableTabbarController.h
//  iconick-lib
//
//  Created by Federico Gasperini on 14/10/16.
//  Copyright © 2016 accenture. All rights reserved.
//

#import "MRAbstractCustomTabbarController.h"
#import "MRTabbarConfiguration.h"

@interface MRConfigurableTabbarController : MRAbstractCustomTabbarController

@property (strong, nonatomic) MRTabbarConfiguration* configuration;

@end
