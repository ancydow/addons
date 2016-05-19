_ = require('lodash')

OrderedCollection =
  onInclude: (base)->
    base::oldAdd = base::add
    base::add = base::newAdd

    base::oldRemove = base::remove
    base::remove = base::newRemove


  orderOf: (model)->
    order = @models.indexOf(model)
    order = undefined if order is -1
    order

  move: (startIndex, endIndex, options = {}) ->
    model = @models[startIndex]
    Pd.Helpers.Array.moveElement(@models, startIndex, endIndex)

    @trigger('move', model, startIndex, endIndex, options)
    [startIndex, endIndex] = [endIndex, startIndex] if endIndex < startIndex
    for model in @models[startIndex..endIndex]
      model.trigger('reorder')

  shift: (model, distance) ->
    startIndex = @orderOf(model)
    endIndex = startIndex + distance
    @move(startIndex, endIndex)

  newAdd: (models, options = {})->
    models = [models] unless _.isArray(models)
    models = _.map models, (m) => @model.wrap(m)
    @oldAdd(models, options)
    return if options.silent

    minIdx = @models.length
    for model in models
      idx = @orderOf(model)
      minIdx = idx if idx < minIdx
      @trigger('addAt', model, @, options, idx)
    model.trigger('reorder') for model in @models[minIdx...]

  newRemove: (model, options = {})->
    alwaysSilent = options.silent
    idx = @orderOf(model)
    @oldRemove(model, options)
    return if options.silent

    @trigger('removeAt', model, @, options, idx)
    model.trigger('reorder') for model in @models[idx...]

module.exports = OrderedCollection
