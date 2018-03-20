//
//  IKRequest+{{ groupName }}.h
//
//  Created by rest builder on 09/01/14.
//  Copyright (c) 2015. All rights reserved.
//

#import <MRBackEnd/IKRequest.h>

{{# each(services) }}{{# forward}}{{# each(forward) }}@class {{ . }};
{{/}}{{/}}{{/}}
{{# each(services) }}{{# each(methods) }}@class {{ response }};
{{/}}{{/}}
@interface IKRequest ({{ groupName }})
{{# each(services) }}{{# each(methods) }}
{{> methodSignature }};
{{> compactMethodSignature }};
{{/}}{{/}}
@end
