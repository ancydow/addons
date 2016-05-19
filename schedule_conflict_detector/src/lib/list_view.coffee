_ = require('lodash')

ListView =
  initList: (options)->
    @listenTo @collection, 'reset', @renderList
    @listenTo @collection, 'addAt', @_addItem
    @listenTo @collection, 'move', @_moveItem
    @listenTo @collection, 'removeAt', @_removeItem

  renderList: ->
    selector = _.result(@, 'listSelector')
    @listViews = @collection.map (model) =>
      view = @createItemView(model)
      @$(selector).append view.el
      view

  _addItem: (model, _a, _b, idx)->
    view = @createItemView(model)
    @listViews.splice(idx, 0, view)

    @beforeAdd?(view, @listViews, idx)
    selector = _.result(@, 'listSelector')
    @$(selector).prepend view.el if idx is 0
    @$("#{selector} > :nth-child(#{idx})").after view.el unless idx is 0
    @afterAdd?(view, @listViews, idx)

  _moveItem: (model, startIdx, endIdx)->
    view = @listViews[startIdx]
    Pd.Helpers.Array.moveElement(@listViews, startIdx, endIdx)

    @beforeMove?(view, @listViews, startIdx)
    view.$el.detach()
    selector = _.result(@, 'listSelector')
    @$(selector).prepend view.el if endIdx is 0
    @$("#{selector} > :nth-child(#{endIdx})").after view.el unless endIdx is 0
    @afterMove?(view, @listViews, endIdx)

  _removeItem: (model, _a, _b, idx)->
    view = @listViews[idx]
    @listViews.splice(idx, 1)

    @beforeRemove?(view, @listViews, idx)
    view.remove()
    @afterRemove?(view, @listViews, idx)

module.exports = ListView
