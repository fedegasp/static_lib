{{ first-lowercase(object-class) }}For{{ name }}{{# parameters.count }}{{# each(parameters) }}{{# @first }}With{{ capitalized(name) }}{{^}} {{# @last }}and{{ capitalized(name) }}{{^}}{{ name }}{{/}}{{/}}:{{ name }}{{/}}{{/}}