//
//  MRPageObject.h
//  dpr
//
//  Created by Giovanni Castiglioni on 16/01/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRPageObject : NSObject

@property (strong,nonatomic) IBInspectable  NSString *StoriboardRef;
@property (strong,nonatomic) IBInspectable  NSString *controllerID;

+(instancetype)pageObjectWithStoryboard:(NSString*)st andController:(NSString*)cid;

@end

