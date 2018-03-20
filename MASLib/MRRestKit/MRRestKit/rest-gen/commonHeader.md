//
//  IKCommon.h
//
//  Created by rest builder on 09/01/14.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MRBackEnd/IKEnvironment.h>
{{# base-request.object-class }}
#import "{{ base-request.object-class }}.h"{{/}}
{{# base-response.object-class }}
#import "{{ base-response.object-class }}.h"{{/}}
{{# responses }}{{# object-class }}{{^ no-import }}
#import "{{ object-class }}.h"{{/}}{{/}}{{/}}

{{# environments }}
#ifndef kEnvironment{{ uppercase(.) }}
#define kEnvironment{{ uppercase(.) }} @"{{ . }}"
#endif
{{/}}
