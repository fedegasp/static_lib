//
//  InMemoryCache.h
//  iconick-lib
//
//  Created by Federico Gasperini on 07/04/16.
//  Copyright © 2016 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CacheInterface.h"
#import "MRObjectCache.h"

@interface MRObjectCache (in_memory_impl)

// InMemoryCache is the default implemetation, other
// implementations  MUST NOT  call SetDefaultCache()
// in +(void)load method of ObjectCache category.

+(void)useInMemoryImplementation;

@end


@interface InMemoryCache : NSObject <CacheInterface>

@end
