//
//  main.m
//  epcollect
//
//  Created by Federico Gasperini on 21/03/16.
//  Copyright © 2016 Federico Gasperini. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{
   @autoreleasepool
   {
      NSString* envConf = [NSString stringWithUTF8String:argv[1]];
      NSMutableArray<NSString*>* serviceConfFname = [[NSMutableArray alloc] init];
      for (int idx = 2; idx < argc; idx++)
         [serviceConfFname addObject:[NSString stringWithUTF8String:argv[idx]]];
      
      NSMutableArray<NSString*>* serviceConfs = [[NSMutableArray alloc] init];
      for (NSString* fname in serviceConfFname)
         [serviceConfs addObject:[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:fname]
                                                                 options:0
                                                                   error:NULL]];
      
      NSDictionary* envs = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:envConf]
                                                           options:0
                                                             error:NULL];
      
      NSArray* envNames = [[envs valueForKey:@"configurations"] valueForKey:@"name"];
      
      for (NSString* envName in envNames)
      {
         NSDictionary* envDict = [[envs valueForKey:@"configurations"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", envName]].firstObject;
         
         for (NSDictionary* serv in serviceConfs)
         {
            NSArray* methods = [[serv[@"services"] valueForKey:@"methods"] firstObject];
            for (NSDictionary* method in methods)
            {
               NSDictionary* env = [[envDict[@"environments"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.name == %@", method[@"environment"]]] firstObject];
               
               NSLog(@";%@;;%@;%@;%@;;%@",
                     envName,
                     env[@"web-server"],
                     env[@"port"],
                     [NSString stringWithFormat:env[@"endpoint-mangling"]?:@"%@",method[@"endpoint"]],
                     method[@"environment"]);
            }
         }
      }
      
   }
   return 0;
}
