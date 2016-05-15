_ = require('lodash')
Moment = require('moment')
Collection = require('./collection')

CLASS_METHODS =
  attrAssoc: (assoc, options = {})->
    @attrAccessor(assoc, options)
    @registerAssocAttr(assoc, options)

  attrDate: (attr, options = {})->
    @attrAccessor(attr, options)
    @registerDateAttr(attr, options)

  # options: 
  # className: a string representing the class to use for this association
  # polymorphic: if the value of this can have multiple Backbone Model/Collection types
  registerAssocAttr: (assoc, options)->
    type = 'assoc'
    methodName = _.camelCase(assoc, false)
    polymorphic = options.polymorphic
    klass = options.klass
    keyName = options.keyName
    keyName ?= _.snakeCase(assoc, false)

    @::specialAttrs ||= []
    @::specialAttrs.push {type, methodName, klass, keyName, polymorphic}

  registerDateAttr: (attr, options)->
    type = 'date'
    keyName = options.keyName
    keyName ?= _.snakeCase(attr, false)
    @::specialAttrs ||= []
    @::specialAttrs.push {type, keyName}


SpecialAttrs =
  onInclude: (base)->
    _.extend(base, CLASS_METHODS)
    base::oldSet = base::set
    base::set = base::newSet

  toJSON: ->
    toJSONHelper = (json, value, key, object)->
      json[key] = value?.toJSON?() or value
      json

    _.reduce(@attributes, toJSONHelper, {})

  validate: ->
    errors = @oldValidate?()
    errors ?= {}
    _(@attributes).each (attrVal, attrKey)=>
      attrErrors = attrVal?.validate?()
      errors[attrKey] = attrErrors if attrErrors
    errors if _.any(errors)

  newSet: (key, val = null, options = {})->
    # arg munging required by ::set
    return @ if key is null
    if (typeof key is 'object')
      attrs = key
      options = val
    else
      (attrs = {})[key] = val

    @attributes ?= {}
    cache = {}
    _(@specialAttrs).each (attrSpec)=>
      return unless attrVal = attrs[attrSpec.keyName]
      @setAssoc(attrSpec, attrVal) if attrSpec.type is 'assoc'
      @setDate(attrSpec, attrVal) if attrSpec.type is 'date'
      delete attrs[attrSpec.keyName]
      cache[attrSpec.keyName] = attrVal

    ret = @oldSet(attrs)

    # we readd the attrs, in case the model initialize uses it
    _.extend(attrs, cache)
    ret


  setAssoc: (assoc, assocAttrs)->
    if not @get(assoc.keyName)?
      @attributes[assoc.keyName] = new assoc.klass()

    # haaaacky, fix
    assocAttrs = assocAttrs.attributes if assocAttrs.attributes?
    assocAttrs = assocAttrs.models if assocAttrs.models?
    if @[assoc.methodName]() instanceof Collection
      @[assoc.methodName]().reset(assocAttrs)
    else
      @[assoc.methodName]().set(assocAttrs)

    @trigger "change:#{assoc.keyName}"

  setDate: (attrSpec, attrVal)->
    # from http://stackoverflow.com/a/12756279/1115281
    fullIsoRegex = /(\d{4})-(\d{2})-(\d{2})T(\d{2})\:(\d{2})\:(\d{2}(\.\d+)?)(Z|[+-](\d{2})\:(\d{2}))/
    if attrVal.constructor isnt Moment().constructor and not attrVal.match?(fullIsoRegex)
      throw 'Invalid date value'
    attrVal = Moment(attrVal) if attrVal.constructor isnt Moment().constructor
    # #failfast
    if not attrVal.isValid()
      throw 'Invalid date value'

    @attributes[attrSpec.keyName] = attrVal
    @trigger "change:#{attrSpec.keyName}"

module.exports = SpecialAttrs
