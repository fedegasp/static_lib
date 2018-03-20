//
//  IKImport.h
//  orpapp
//
//  Created by Federico Gasperini on 04/11/15.
//  Copyright © 2015 Federico Gasperini. All rights reserved.
//

#ifndef IKImport_h
#define IKImport_h

#import <Foundation/Foundation.h>

#define IK_ACTIVITY_WINDOW

extern NSString* IKErrorResponseKey;

typedef NS_ENUM(NSInteger, IKLogLevel)
{
   IKLogLevelOff,
   IKLogLevelError,
   IKLogLevelDebug,
   IKLogLevelBloat
};

IKLogLevel IKLogLevelFromNSString(NSString* logLevel);

#endif /* IKImport_h */
