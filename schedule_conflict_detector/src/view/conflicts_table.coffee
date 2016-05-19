mixin = require('../lib/mixin')
View = require('../lib/view')
ListView = require('../lib/list_view')
ConflictsItem = require('./conflicts_item')
template = require('./conflicts_table_template')

class ConflictsTable extends View
  mixin @, ListView
  template: template

  initialize: ->
    @initList()
    @render()

  render: ->
    @mainRender()
    @renderList()

  listSelector: '.h-conflicts-list'

  createItemView: (model) ->
    new ConflictsItem
      model: model

module.exports = ConflictsTable
