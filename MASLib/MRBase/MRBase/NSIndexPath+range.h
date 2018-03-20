//
//  NSIndexPath+range.h
//  MRBase
//
//  Created by Federico Gasperini on 11/07/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (range)

+(NSArray<NSIndexPath*>*)indexPathsWithRange:(NSRange)range inSection:(NSUInteger)section;

@end
