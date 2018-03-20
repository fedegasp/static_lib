//
//  IKChainedDelegate.h
//  iconick-lib
//
//  Created by Federico Gasperini on 07/10/15.
//  Copyright © 2015 Federico Gasperini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRChainedDelegate : NSObject

@property (weak, nonatomic) IBOutlet id nextDelegate;

-(void)appendToObject:(NSObject*)obj;
-(void)appendToObject:(NSObject*)obj forKey:(NSString*)key;

@end
