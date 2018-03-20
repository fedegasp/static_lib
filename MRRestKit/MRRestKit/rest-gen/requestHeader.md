//
//  {{ object-class }}.h
//
//  Created by rest builder on 09/01/14.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>
{{# base-class }}
#import "{{ base-class }}.h"{{^}}
#import <MRRestKit/IKRKRequest.h>{{/}}

{{# methods }}
extern NSString* {{ object-class }}_{{ action(.name) }}{{# .parameters.count }}{{# each(.parameters) }}_{{ capitalized(name) }}{{/}}{{/}};{{/}}

@class {{ object-class }};

@interface __{{ object-class }} : {{# base-class }}{{ base-class }}{{^}}IKRKRequest{{/}}
{ {{# mapping }}{{# each(mapping) }}
   NSObject* _{{ @key }};{{/}}{{/}}
}
{{# mapping }}{{# each(mapping) }}
@property (strong, nonatomic) NSObject* {{ @key }};{{/}}{{/}}
{{# methods }}
{{> headerDoc }}
{{> methodSignature }};

{{/}}
@end

#import "{{ object-class }}+override_methods.h"
