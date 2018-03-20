//
//  MRRouterChainedDelegate.h
//  MRBase
//
//  Created by Federico Gasperini on 01/06/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "MRChainedDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MRRouterChainedDelegate : MRChainedDelegate

@property (nonatomic, strong) IBInspectable NSString* selectorName;
@property (nonatomic, strong, readwrite) IBOutletCollection(NSObject) NSArray* destination;

@end

NS_ASSUME_NONNULL_END
