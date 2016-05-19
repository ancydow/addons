UrlParams =

  COMMA_SEPARATED_PARAMS: []

  decomposeParams: ->
    search = window.location.search
    return {} unless '?' in search
    searchParams = search.slice search.indexOf("?") + 1
    @decomposeParamsString(searchParams)

  decomposeParamsString: (searchParams)->
    slices = searchParams.split('&')

    params = {}
    for item in slices
      [key, value] = item.split('=')
      continue unless key? and value?
      key = decodeURIComponent(key)
      value = decodeURIComponent(value)
      @decomposeItem(params, key, value)

    params

  decomposeItem: (params, key, value) ->
    value = undefined if value is ''

    if @paramIsArray(key)
      key = @prepareArrayKey(key)
      value = @prepareArrayValues(key, value)
      params[key] ||= []
      params[key] = params[key].concat(value) if value?
      # Since the key of a comma-separated param provides no context to its type, return to avoid an infinite loop
      return params[key] if @paramIsCommaSeparatedArray(key)
    else if @paramIsHash(key)
      value = @prepareHashValues(key, value)
      key = @prepareHashKey(key)
      params[key] ||= {}
      _(params[key]).extend(value) if value?
    else
      params[key] = value
      return

    @decomposeItem(params, key, params[key]) if params[key]?

    return

  paramIsArray: (key) ->
    key[-2..-1] is '[]' or @paramIsCommaSeparatedArray(key)

  paramIsHash: (key) ->
    key[-1..-1] is ']' and key[0] isnt '[' and !@paramIsArray(key) and '[' in key

  paramIsCommaSeparatedArray: (key) ->
    key in @COMMA_SEPARATED_PARAMS

  prepareArrayKey: (key) ->
    return key[0...-2] unless @paramIsCommaSeparatedArray(key)
    key

  prepareHashKey: (key) ->
    key[0...(key.lastIndexOf('['))]

  prepareArrayValues: (key, value) ->
    if @paramIsCommaSeparatedArray(key) and value? and ',' in value
      value.split(',')
    else
      [value] if value?

  prepareHashValues: (key, value) ->
    key = key[(key.indexOf('[') + 1)...-1]
    result = {}
    result[key] = value
    result

  recomposeParams: (params) ->
    searchPath = (window.location.search.split('?'))[0]
    paramsString = @recomposeParamsString(params)
    window.location.search = "#{searchPath}?#{paramsString}"

  recomposeParamsString: (params) ->
    paramStrings = []
    for key, value of params
      @recomposeItem(paramStrings, key, value)
    paramStrings.join "&"

  recomposeItem: (memo, key, value) ->
    _value = _(value)
    key = decodeURIComponent(key)
    if _value.isArray()
      @recomposeArrayItem(memo, key, _value)
    else if _value.isObject()
      @recomposeHashItem(memo, key, _value)
    else
      @recomposeScalarItem(memo, key, value)
    return

  recomposeArrayItem: (memo, key, value) ->
    if @paramIsCommaSeparatedArray(key)
      @recomposeScalarItem(memo, key, value.join(','))
    else
      key += '[]'
      _(value).each (v) => @recomposeItem(memo, key, v)

  recomposeHashItem: (memo, key, value) ->
    _(value).each (v, k) => @recomposeItem(memo, "#{key}[#{k}]", v)

  recomposeScalarItem: (memo, key, value) ->
    memo.push "#{key}=#{encodeURIComponent(value)}" if value?

  get: (param, defaultVal) ->
    params = @decomposeParams()
    params[param] || defaultVal

  set: (param, value)->
    params = @decomposeParams()
    params[param] = value
    @recomposeParams(params)

module.exports = UrlParams
