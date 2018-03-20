-(BOOL)preOperation:(id<BackEndProviderProtocol>)requestManager
{
   BOOL ret = YES;{{# methods.count }}{{# each(methods) }}
   {{^ @first }}else {{/}}if (self.ikAction == {{ object-class }}_{{ action(name) }}{{# parameters.count }}{{# each(parameters) }}_{{ capitalized(name) }}{{/}}{{/}})
   {
      {{# parameters.count }}{{# each(parameters) }}{{# mandatory }}ret = {{^ @first }}ret && {{/}}self.{{# property }}{{ property }}{{^}}{{ name }}{{/}} != nil;{{^ @last }}
      {{/}}{{/}}{{/}}{{/}}
   }{{/}}{{/}}
   return ret;
}
