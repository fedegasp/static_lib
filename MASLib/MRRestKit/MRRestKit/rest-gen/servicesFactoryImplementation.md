//
//  IKRequest+{{ groupName }}.m
//
//  Created by rest builder on 09/01/14.
//  Copyright (c) 2015. All rights reserved.
//

#import "IKCommon.h"
#import "IKRequest+{{ groupName }}.h"
{{# each(services) }}{{^ no-import }}
#import "{{ object-class }}.h"{{/}}{{/}}

@implementation IKRequest ({{ groupName }})
{{# each(services) }}
//{{ object-class }}
{{# each(methods) }}
{{> headerDoc }}
{{> methodSignature }}
{
   return [{{ object-class }} {{> methodCall}}];
}

{{> compactMethodSignature }}
{
   {{ object-class }}* instance = [{{ object-class }} {{> methodCall }}];
   if (userContext)
      [instance notifyPerformingOn:userContext];
   [instance performOnFinish:block];
   return instance;
}
{{/}}{{/}}
@end
