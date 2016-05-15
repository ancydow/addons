_ = require('lodash')
Backbone = require('backbone')
mixin = require('./mixin')
SpecialAttrs = require('./special_attrs')

class Model extends Backbone.Model
  mixin @, SpecialAttrs

  @attrAccessor: (attrs..., options)->
    attrs.push options unless options instanceof Object
    options = {} unless options instanceof Object
    _.map attrs, (attr)=>
      methodName = options.methodName or _.camelCase(attr)
      keyName = options.keyName or _.snakeCase(attr)

      @::[methodName] = (val, options = {})->
        attrs = {}
        attrs[keyName] = val
        @set(attrs, options) unless arguments.length is 0
        @get(keyName)

   @wrap: (model)->
     return model if model instanceof @
     new @(model)

module.exports = Model
