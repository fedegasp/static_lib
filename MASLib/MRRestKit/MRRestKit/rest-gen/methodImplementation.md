{{> methodSignature }}
{
   {{ object-class }}* instance = [[self alloc] init];
   instance.ikAction = {{ object-class }}_{{ action(name) }}{{# parameters.count }}{{# each(parameters) }}_{{ capitalized(name) }}{{/}}{{/}};
   [instance setDefaults];
   instance.mapping = [self requestMapping];
   {{# response }}
   instance.responseClass = NSStringFromClass({{ response }}.class);{{^}}
   instance.responseClass = NSStringFromClass({{ base-response.object-class }}.class);{{/}}
   {{# environment }}instance.ikEnvironment = kEnvironment{{ environment }};{{/}}
   {{# constants }}
   instance.{{ property }} = {{# value }}{{{ constant-value(value) }}}{{^}}nil{{/}};{{/}}
   {{# parameters }}
   instance.{{# property }}{{ property }}{{^}}{{ name }}{{/}} = {{ name }};{{/}}

   [instance ikRegisterRequest];
   
   return instance;
}
