//
//  {{ object-class }}.h
//
//  Created by rest builder on 09/01/14.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>
{{# base-class }}
#import "{{ base-class }}.h"{{^}}
#import <MRRestKit/IKRKResponse.h>{{/}}
{{# mapping }}{{# each(mapping) }}{{# .object-class }}{{^ no-import }}
@class {{ object-class }};{{/}}{{/}}{{/}}{{# hinerits }}
#import "{{ hinerits }}.h"{{/}}{{/}}

@class {{ object-class }};

@interface __{{ object-class }} : {{# hinerits }}{{ hinerits }}{{^}}{{# base-class }}{{ base-class }}{{^}}IKRKResponse{{/}}{{/}}
{ {{# mapping }}{{# each(mapping) }}{{^ inherited }}
   id _{{ property }};{{/}}{{/}}{{/}}
}
{{# mapping }}{{# each(mapping) }}{{^ inherited }}{{# isArray }}
@property (strong, nonatomic, nullable) NSArray<{{ object-class }}*>* {{ property }};{{^}}{{# .type }}
@property (strong, nonatomic, nullable) {{ expand-type(type) }} {{ property }};{{^}}
@property (strong, nonatomic, nullable) {{ object-class }}* {{ property }};{{/}}{{/}}{{/}}{{/}}{{/}}

@end

#import "{{ object-class }}+override_methods.h"
