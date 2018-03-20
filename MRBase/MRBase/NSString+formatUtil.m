//
//  NSString+FormatDecimalNumber.m
//  ikframework
//
//  Created by Giovanni Castiglioni on 27/03/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "NSString+formatUtil.h"
#import "MRMacros.h"

static __strong NSMutableCharacterSet* nonNumericCharacterSet = nil;

@implementation NSString (formatUtil)

+(void)load
{
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      nonNumericCharacterSet = [NSMutableCharacterSet decimalDigitCharacterSet];
      [nonNumericCharacterSet addCharactersInString:@".,"];
      [nonNumericCharacterSet invert];
   });
}

-(BOOL)isNumeric
{
   if (self.length > 0)
   {
      NSRange r = [self rangeOfCharacterFromSet:nonNumericCharacterSet];
      return r.location == NSNotFound;
   }
   return NO;
}

-(NSString*)arabicToWestern
{
   static NSString *arabic = @"٠١٢٣٤٥٦٧٨٩,";
   static NSString *western = @"0123456789.";
   static NSRegularExpression* regExp = nil;
   NSError* error = nil;
   if (!regExp)
      regExp = [[NSRegularExpression alloc] initWithPattern:@"[٠١٢٣٤٥٦٧٨٩]*[\\.\\,]?[٠١٢٣٤٥٦٧٨٩]+"
                                                    options:NSRegularExpressionCaseInsensitive
                                                      error:&error];
   
   NSMutableArray* toRaplace = [[NSMutableArray alloc] initWithCapacity:1];
   
   BLOCK_REF(toRaplace);
   
   [[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stopa) {
      [regExp enumerateMatchesInString:obj
                               options:NSMatchingReportProgress
                                 range:NSMakeRange(0, obj.length)
                            usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stopb) {
                               (*stopb) = [obj rangeOfString:@"://"].location != NSNotFound;
                               if (!(*stopb))
                                  (*stopb) = [obj rangeOfString:@"@"].location != NSNotFound;
                               if (!(*stopb) && result.range.length > 0)
                                  [_toRaplace addObject:[obj substringWithRange:result.range]];
                            }];
   }];
   
   NSMutableArray* replacing = [[NSMutableArray alloc] initWithCapacity:toRaplace.count];
   
   for (NSString* tr in toRaplace)
   {
      NSMutableString* s = [tr mutableCopy];
      NSRange r = NSMakeRange(0, s.length);
      for (uint i = 0; i < arabic.length - 1; i++)
      {
         NSString *a = [arabic substringWithRange:NSMakeRange(i, 1)];
         NSString *w = [western substringWithRange:NSMakeRange(i, 1)];
         [s replaceOccurrencesOfString:a
                            withString:w
                               options:NSCaseInsensitiveSearch
                                 range:r];
      }
      
      r = NSMakeRange(0, s.length - 1);
      [s replaceOccurrencesOfString:[arabic substringWithRange:NSMakeRange(arabic.length-1, 1)]
                         withString:[western substringWithRange:NSMakeRange(western.length-1, 1)]
                            options:NSCaseInsensitiveSearch
                              range:r];
      
      [replacing addObject:s];
   }
   
   NSMutableString* ret = [self mutableCopy];
   for (NSInteger i = 0; i < replacing.count; i++)
   {
      NSRange r = [ret rangeOfString:toRaplace[i] options:NSCaseInsensitiveSearch];
      [ret replaceOccurrencesOfString:toRaplace[i]
                           withString:replacing[i]
                              options:NSCaseInsensitiveSearch
                                range:r];
   }
   
   return [ret copy];
}

-(NSString*)westernToArabic
{
   static NSString *arabic = @"٠١٢٣٤٥٦٧٨٩,";
   static NSString *western = @"0123456789.";
   static NSRegularExpression* regExp = nil;
   if (!regExp)
      regExp = [[NSRegularExpression alloc] initWithPattern:@"[0123456789]*[\\.\\,]?[0123456789]+"
                                                    options:NSRegularExpressionCaseInsensitive
                                                      error:NULL];
   
   NSMutableArray* toRaplace = [[NSMutableArray alloc] initWithCapacity:1];
   
   BLOCK_REF(toRaplace);
   
   [[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stopa) {
      [regExp enumerateMatchesInString:obj
                               options:NSMatchingReportProgress
                                 range:NSMakeRange(0, obj.length)
                            usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stopb) {
                               (*stopb) = [obj rangeOfString:@"://"].location != NSNotFound;
                               if (!(*stopb))
                                  (*stopb) = [obj rangeOfString:@"@"].location != NSNotFound;
                               if (!(*stopb) && result.range.length > 0)
                                  [_toRaplace addObject:[obj substringWithRange:result.range]];
                            }];
   }];
   
   NSMutableArray* replacing = [[NSMutableArray alloc] initWithCapacity:toRaplace.count];
   
   for (NSString* tr in toRaplace)
   {
      NSMutableString* s = [tr mutableCopy];
      NSRange r = NSMakeRange(0, s.length);
      for (uint i = 0; i < arabic.length - 1; i++)
      {
         NSString *a = [arabic substringWithRange:NSMakeRange(i, 1)];
         NSString *w = [western substringWithRange:NSMakeRange(i, 1)];
         [s replaceOccurrencesOfString:w withString:a
                               options:NSCaseInsensitiveSearch
                                 range:r];
      }
      
      r = NSMakeRange(0, s.length - 1);
      [s replaceOccurrencesOfString:[western substringWithRange:NSMakeRange(western.length-1, 1)]
                         withString:[arabic substringWithRange:NSMakeRange(arabic.length-1, 1)]
                            options:NSCaseInsensitiveSearch
                              range:r];
      
      [replacing addObject:s];
   }
   
   NSMutableString* ret = [self mutableCopy];
   
   
   for (NSInteger i = 0; i < replacing.count; i++)
   {
      NSRange r = [ret rangeOfString:toRaplace[i] options:NSCaseInsensitiveSearch];
      [ret replaceOccurrencesOfString:toRaplace[i]
                           withString:replacing[i]
                              options:NSCaseInsensitiveSearch
                                range:r];
   }
   
   return [ret copy];
}

+(NSString*)stringWithFormat:(NSString*)format andArguments:(NSArray*)arguments
{
   NSString* retVal = nil;
   NSString* countString = [format stringByReplacingOccurrencesOfString:@"%%" withString:@""];
   NSInteger countParams = [countString componentsSeparatedByString:@"%"].count - 1;
   if (countParams > 0)
   {
      NSMutableArray* args = [arguments mutableCopy];
      for (NSInteger i = arguments.count; i < countParams; i ++)
         [args addObject:[NSNull null]];

      void *argList = malloc(sizeof(void *) * [args count]);
      [args getObjects:(__unsafe_unretained id*)(const id *)argList];
      retVal = [[NSString alloc] initWithFormat:format arguments:(void *) argList];
      
      free (argList);
   }
   else
   {
      retVal = format;
   }
   
   return retVal;
}

-(NSString*)trimmedString
{
   static NSCharacterSet* cset = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      cset = [NSCharacterSet whitespaceAndNewlineCharacterSet];
   });
   return [self stringByTrimmingCharactersInSet:cset];
}

-(NSString *) stringByStrippingHTML {
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
        NSString* tag = [s substringWithRange:r];
        if ([tag containsString:@"br"])
            s = [s stringByReplacingCharactersInRange:r withString:@"\n"];
        else
            s = [s stringByReplacingCharactersInRange:r withString:@""];
    }
    s= [s stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    s=[self substitute:@"&nbsp;" with:@"\n" inString:s];
    s=[self substitute:@"&egrave;" with:@"è" inString:s];
    s=[self substitute:@"&ograve;" with:@"ò" inString:s];
    s=[self substitute:@"&agrave;" with:@"à" inString:s];
    s=[self substitute:@"&igrave;" with:@"ì" inString:s];
    s=[self substitute:@"&ugrave;" with:@"ù" inString:s];
    s=[self substitute:@"&eacute;" with:@"é" inString:s];
    s=[self substitute:@"&oacute;" with:@"o" inString:s];
    s=[self substitute:@"&aacute;" with:@"a" inString:s];
    s=[self substitute:@"&iacute;" with:@"i" inString:s];
    s=[self substitute:@"&uacute;" with:@"u" inString:s];
    s=[self substitute:@"&rsquo;" with:@"'" inString:s];
    s=[self substitute:@"&lsquo;" with:@"'" inString:s];
    s=[self substitute:@"&laquo;" with:@"«" inString:s];
    s=[self substitute:@"&raquo;" with:@"»" inString:s];
    s=[self substitute:@"&rsaquo;" with:@"›" inString:s];
    s=[self substitute:@"&lsaquo;" with:@"‹" inString:s];
    s=[self substitute:@"&rdquo;" with:@"”" inString:s];
    s=[self substitute:@"&ldquo;" with:@"“" inString:s];
    s=[self substitute:@"&hellip;" with:@"..." inString:s];
    s=[self substitute:@"\r" with:@"" inString:s];
    s=[self substitute:@"\n\n" with:@"\n" inString:s];
    s=[self substitute:@"\n\n" with:@"\n" inString:s];
    s=[self substitute:@"\n\n" with:@"\n" inString:s];
    return s;
}

-(NSString *)substitute:(NSString *)stringA with:(NSString*)stringB inString:(NSString *)string{
    return [string stringByReplacingOccurrencesOfString:stringA withString:stringB];
}

-(UIFont*)fontToFitWidht:(CGFloat)w withFont:(UIFont*)font
{
    CGFloat size1 = 6.0;
    CGFloat size2 = font.pointSize;
    CGFloat width1 = [self sizeWithAttributes:@{NSFontAttributeName:[font fontWithSize:size1]}].width;
    CGFloat width2 = [self sizeWithAttributes:@{NSFontAttributeName:font}].width;
    NSInteger i = 0;
    while (i < 10)
    {
        i++;
        CGFloat guessed_size = size1 + (w - width1) * (size2 - size1) / (width2 - width1);
        
        width2 = [self sizeWithAttributes:@{NSFontAttributeName:[font fontWithSize:guessed_size]}].width;
        CGFloat d = (width2 / w);
        if ( d > .99f )
        {
            size2 = guessed_size;
            continue;
        }
        break;
    }
    if (size2 < font.pointSize)
        return [font fontWithSize:floor(size2)];
    return font;
}

+ (NSString*) formatWithMIfMillionNumber:(NSNumber*)numero {
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setLocale:[NSLocale currentLocale]];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[numberFormatter setMaximumFractionDigits:2];
//    if(numero.floatValue >= 1000000) {
//        NSNumber *abbreviato = [NSNumber numberWithFloat:numero.floatValue / 1000000];
//        return [NSString stringWithFormat:@"%@M", [numberFormatter stringFromNumber:abbreviato]];
//    }
	return [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:numero]];

}


@end
