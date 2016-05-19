_ = require('lodash')
_hasProp = {}.hasOwnProperty

mixin = (klass, mixins...)->
  for mixin in mixins
    for key, value of mixin
      # Skip special cased properties and override klass's parents but not klass itself
      unless key in ['onInclude', 'prereqs'] or _hasProp.call(klass.prototype, key)
        klass.prototype[key] = value 

    # Fire include callback
    mixin.onInclude?(klass)

  klass


module.exports = mixin
