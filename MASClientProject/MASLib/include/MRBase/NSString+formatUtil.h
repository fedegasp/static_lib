//
//  NSString+FormatDecimalNumber.h
//  ikframework
//
//  Created by Giovanni Castiglioni on 27/03/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (formatUtil)

-(BOOL)isNumeric;

-(NSString*)arabicToWestern;
-(NSString*)westernToArabic;

+(NSString*)stringWithFormat:(NSString*)format andArguments:(NSArray*)arguments;

-(NSString*)trimmedString;

-(NSString *) stringByStrippingHTML;

-(UIFont*)fontToFitWidht:(CGFloat)w withFont:(UIFont*)font;

+ (NSString*) formatWithMIfMillionNumber:(NSNumber*)numero ;
@end
