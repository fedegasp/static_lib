//
//  NSString+validation.m
//  ikframework
//
//  Created by Giovanni Castiglioni on 29/05/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "NSString+validation.h"

@implementation NSString (validation)

-(BOOL)isValidUrl
{
	NSLog(@"%@", self);
	
	NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
	
	NSRange urlStringRange = NSMakeRange(0, [self length]);
	NSMatchingOptions matchingOptions = 0;
	
	if (1 != [linkDetector numberOfMatchesInString:self options:matchingOptions range:urlStringRange])
	{
		return NO;
	}
	
	NSTextCheckingResult *checkingResult = [linkDetector firstMatchInString:self options:matchingOptions range:urlStringRange];
	
	return checkingResult.resultType == NSTextCheckingTypeLink && NSEqualRanges(checkingResult.range, urlStringRange);

}

-(BOOL)isValidEmail
{
   static NSString *emailRegex = @"[^@]+@[^.@]+(\\.[^.@]+)+";
   NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
   
   return [emailTest evaluateWithObject:self];
}

-(BOOL)isValidPhoneNumber
{
   static NSCharacterSet* cset = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      cset = [[NSCharacterSet characterSetWithCharactersInString:@"+0123456789"] invertedSet];
   });
   if (self.length)
   {
      if ([self rangeOfCharacterFromSet:cset].location == NSNotFound)
      {
         NSRange plus = [self rangeOfString:@"+"];
         return plus.location == NSNotFound || plus.location == 0;
      }
   }
   
   return YES;
}

-(BOOL)isValidPassword
{
   static NSArray* chSets = nil;
   
   if (!chSets)
   {
      chSets = @[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"],
                 [NSCharacterSet characterSetWithCharactersInString:@"ASDFGHJKLQWERTYUIOPZXCVBNM"],
                 [NSCharacterSet characterSetWithCharactersInString:@"asdfghjklqwertyuiopzxcvbnm"]];
   }
   
   BOOL length = self.length > 7 && self.length < 13;
   if (!length)
      return NO;
   
   for (NSCharacterSet *cset in chSets)
   {
      NSRange range = [self rangeOfCharacterFromSet:cset];
      if (range.location == NSNotFound)
         return NO;
   }
   
   return YES;
}


@end
