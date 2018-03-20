//
//  {{ object-class }}.m
//
//  Created by rest builder on 09/01/14.
//  Copyright (c) 2015. All rights reserved.
//

#import "IKCommon.h"{{^ no-import }}
#import "{{ object-class }}.h"{{/}}

@implementation __{{ object-class }}
{{# mapping }}{{# each(mapping) }}{{^ inherited }}
@synthesize {{ property }} = _{{ property }};
{{/}}{{/}}{{/}}

{{# mapping }}
#pragma mark - RestKit mapping

+(NSDictionary*)mapping
{ {{# base-class }}
   NSMutableDictionary* dict = (id)[super mapping];{{# mapping }}{{# each(mapping) }}{{# inherited }}
   [[dict copy] enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString* obj, BOOL * _Nonnull stop)
    {
       if ([obj isEqualToString:@"{{ property }}"])
          [dict removeObjectForKey:key];
       *stop = NO;
    }];{{/}}{{/}}{{/}}{{^}}
   NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];{{/}}
   [dict addEntriesFromDictionary:@{ {{# each(mapping) }}{{^ managed }}{{# no-import }}
                                    @"{{& @key }}" : @"{{& property }}"{{^ @last }},{{/}}{{^}}{{^ .object-class }}
                                    @"{{& @key }}" : @"{{& property }}"{{^ @last }},{{/}}{{/}}{{/}}{{/}}{{/}}
                                   }];
   return dict;
}

+(NSDictionary*)relationships
{ {{# base-class }}
   NSMutableDictionary* dict = (id)[super relationships];{{# mapping }}{{# each(mapping) }}{{# inherited }}
   [[dict copy] enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSDictionary* obj, BOOL * _Nonnull stop)
   {
      NSString* _obj = [[[[obj allKeys] firstObject] componentsSeparatedByString:@"."] lastObject];
      if ([_obj isEqualToString:@"{{ property }}"])
         [dict removeObjectForKey:key];
      *stop = NO;
   }];{{/}}{{/}}{{/}}{{^}}
   NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];{{/}}
{{# each(mapping) }}{{# .object-class }}{{^ managed }}{{^ no-import }}
   dict[@"{{& @key }}"] = @{ @"{{& object-class }}.{{ property }}" : [{{ object-class }} mapping]};{{/}}{{/}}{{/}}{{/}}

   return dict;
}
{{/}}

#pragma mark - NSCoding

-(id)initWithCoder:(NSCoder *)decoder
{
   self = [super initWithCoder:decoder];
   if (!self)
      return nil;
{{# mapping }}{{# each(mapping) }}
   self.{{ property }} = [decoder decodeObjectForKey:@"{{ property }}"];{{/}}{{/}}
   return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
   [super encodeWithCoder:encoder];
{{# mapping }}{{# each(mapping) }}
   [encoder encodeObject:self.{{ property }} forKey:@"{{ property }}"];{{/}}{{/}}
}

@end
