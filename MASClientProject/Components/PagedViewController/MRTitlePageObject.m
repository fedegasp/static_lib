//
//  MRTitlePageObject.m
//  MASClient
//
//  Created by Enrico Luciano on 28/07/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "MRTitlePageObject.h"

@implementation MRTitlePageObject

-(NSString*)title
{
    if( !(self.localizingKey.length == 0) && !(self.languageFileName.length == 0))
        return MRLocalizedString(self.localizingKey,self.languageFileName);
    return _title;
}

@end
