//
//  {{ object-class }}.m
//
//  Created by rest builder on 09/01/14.
//  Copyright (c) 2015. All rights reserved.
//

#import "IKCommon.h"{{^ no-import }}
#import "{{ object-class }}.h"{{/}}

{{# methods }}
NSString* {{ object-class }}_{{ action(.name) }}{{# .parameters.count }}{{# each(.parameters) }}_{{ capitalized(name) }}{{/}}{{/}} = @"{{ object-class }}_{{& action(.name) }}{{# .parameters.count }}{{# each(.parameters) }}_{{ capitalized(name) }}{{/}}{{/}}";{{/}}


@interface __{{ object-class }} ()

@property (strong, readwrite) NSString* responseClass;
@property (strong, readwrite) NSDictionary* mapping;

@end


@implementation __{{ object-class }}

@synthesize responseClass = _responseClass;
@synthesize mapping = _mapping;
{{# methods }}
{{> methodImplementation }}
{{/}}
{{# mapping }}
-(void)setDefaults
{ 
   [super setDefaults];{{# each(mapping) }}
   self.{{ @key }} = nil;{{/}}
}
{{/}}
{{> checkParameters }}

-(NSString*)endPointForAction:(NSString*)action
{
   NSString* localMangling = @"%@";
   NSString* endPoint = nil;{{# methods }}
   if (action == {{ object-class }}_{{ action(.name) }}{{# .parameters.count }}{{# each(.parameters) }}_{{ capitalized(name) }}{{/}}{{/}})
   {
      endPoint = @"{{& endpoint }}";{{# local-mangling }}
      if ([[IKEnvironment configurationName] isEqualToString:@"{{& environment-name }}"])
         localMangling = @"{{& endpoint-mangling }}";{{/}}
   }{{/}}
   if (endPoint)
      return [NSString stringWithFormat:localMangling,endPoint];

   return [super endPointForAction:action];
}

#pragma mark - Cache

-(NSTimeInterval)ttl
{ {{# methods.count }}{{# each(methods) }}{{# .cache.tags.count }}
   if (self.ikAction == {{ object-class }}_{{ action(.name) }}{{# .parameters.count }}{{# each(.parameters) }}_{{ capitalized(name) }}{{/}}{{/}})
      return {{ .cache.ttl }};{{/}}{{/}}{{/}}
   return -1;
}

-(NSArray<NSString*>*)tags
{ {{# methods.count }}{{# each(methods) }}{{# .cache.tags.count }}
   if (self.ikAction == {{ object-class }}_{{ action(.name) }}{{# .parameters.count }}{{# each(.parameters) }}_{{ capitalized(name) }}{{/}}{{/}})
      return @[{{# each(.cache.tags) }}@"{{ . }}"{{^ @last }},{{/}}{{/}}];{{/}}{{/}}{{/}}
   return @[];
}

-(NSArray<NSString*>*)invalidatesTags
{ {{# methods.count }}{{# each(methods) }}{{# .cache.invalidates-tags.count }}
   if (self.ikAction == {{ object-class }}_{{ action(.name) }}{{# .parameters.count }}{{# each(.parameters) }}_{{ capitalized(name) }}{{/}}{{/}})
      return @[{{# each(.cache.invalidates-tags) }}@"{{ . }}"{{^ @last }},{{/}}{{/}}];{{/}}{{/}}{{/}}
   return @[];
}

{{# mapping }}
#pragma mark - RestKit mapping

+(NSDictionary*)requestMapping
{ {{# base-class }}
   NSMutableDictionary* dict = (id)[super requestMapping];{{^}}
   NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];{{/}}
   [dict addEntriesFromDictionary:@{ {{# each(mapping) }}
                                    @"{{& @key }}" : @"{{& . }}"{{^ @last }},{{/}}{{/}}
                                   }];
   return dict;
}
{{/}}
@end
