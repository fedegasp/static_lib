//
//  UIDevice+Hardware.h
//  Mobily
//
//  Created by Fabio Gai on 08/04/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/sysctl.h>

@interface UIDevice (Hardware)
+(NSString *)getDeviceHardware;
+ (NSString *) platformType:(NSString *)platform;
+(BOOL)isSmallerOrEqualTOiPhone5;
+(BOOL)isIphoneX;
@end
