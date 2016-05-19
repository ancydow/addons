View = require('../lib/view')
CanParseConflicts = require('./can_parse_conflicts')
CanFetchSchedules = require('./can_fetch_schedules')
ConflictsTable = require('./conflicts_table')
Moment = require('moment')
mixin = require('../lib/mixin')
template = require('./page_template')

class Page extends View
  mixin @, CanParseConflicts, CanFetchSchedules
  template: template

  initialize: (options)->
    @conflicts = options.conflicts
    @schedules = options.schedules

    @listenTo @schedules, 'hydrated', @updateConflicts
    @listenTo @schedules, 'hydrated', @subRender('.h-is-searching')
    @listenTo @conflicts, 'reset', @tableRender
    @listenTo @conflicts, 'reset', @subRender('.h-no-conflicts')
    @render()

  render: ->
    @mainRender()
    @tableRender()

  tableRender: ->
    if @conflicts.any()
      return if @tableView?
      @tableView = new ConflictsTable
        collection: @conflicts
      @$('.h-conflicts-table').html @tableView.el
    else
      @tableView?.remove()

  data: ->
    isFetching: !@schedules.isFetchAlled()
    hasNoConflicts: @schedules.isFetchAlled() && !@conflicts.any()

  updateConflicts: ->
    scheduleAttrs = @schedules.toJSON()
    conflictAttrs = @parseConflicts(scheduleAttrs)
    @conflicts.reset(conflictAttrs)

module.exports = Page
