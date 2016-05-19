$ = require('jQuery')
Bb = require('backbone')
mixin = require('./mixin')
OrderedCollection = require('./ordered_collection')

class Collection extends Bb.Collection
  mixin @, OrderedCollection

  isFetchAlled: ->
    @fetchAlled?.state() is 'resolved'

  fetchAll: (options = {}) ->
    return @fetchAlled if @fetchAlled?
    @fetchAlled = $.Deferred()

    oldsuccess = options.success
    options.data or= {}
    options.update = true
    options.remove = false
    options.data.limit = @_fetchAllSize
    options.data.offset ||= 0
    options.success = (model, json) =>
      options.data.offset += @_fetchAllSize
      if options.data.offset < @total
        @fetch options
      else
        oldsuccess(model, json) if oldsuccess?
        @fetchAlled.resolve(model, json)
        @trigger("fetchedAll")
    @fetch options

    return @fetchAlled

module.exports = Collection
