//
//  Functions.m
//  MRBase
//
//  Created by Federico Gasperini on 27/10/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString* DocumentsDirectory()
{
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   NSString *documentsDirectory = [paths firstObject];
   return documentsDirectory;
}

NSString* LibraryDirectory()
{
   NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                        NSUserDomainMask,
                                                        YES);
   NSString *documentsDirectory = [paths objectAtIndex:0];
   return documentsDirectory;
}
