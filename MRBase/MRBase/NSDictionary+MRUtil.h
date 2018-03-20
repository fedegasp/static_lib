//
//  NSDictionary+SOFInterface.h
//  MRBase
//
//  Created by Dario Trisciuoglio on 29/11/13.
//  Copyright (c) 2013 Dario Trisciuoglio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (IKInterface)

-(NSDictionary *)removeNullValues;
-(BOOL)saveToPlistWithName:(NSString*)name;
-(BOOL)saveToPlistWithFilePath:(NSString*)filePath;
-(BOOL)saveToPlistWithName:(NSString*)name andFilePath:(NSString*)filePath;
-(BOOL)existsObjectAtKey:(NSString*)key;

@end

@interface NSMutableDictionary (IKInterface)

-(void)safeEntries:(NSDictionary *)value;

@end
