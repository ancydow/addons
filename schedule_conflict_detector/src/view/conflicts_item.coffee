View = require('../lib/view')
template = require('./conflicts_item_template')

class ConflictsItem extends View
  template: template
  tagName: 'tr'

  initialize: (options)->
    @render()

  render: ->
    @mainRender()

  data: ->
    userName: @model.user().summary()
    userUrl: @model.user().htmlUrl()
    scheduleOneName: @model.scheduleOne().summary()
    scheduleOneUrl: @model.scheduleOne().htmlUrl()
    scheduleTwoName: @model.scheduleTwo().summary()
    scheduleTwoUrl: @model.scheduleTwo().htmlUrl()
    dateString: @formatSpan(@model.spans().first())

  formatSpan: (span)->
    start = span.start().format('MMM Do [at] H:mm')
    end = span.end().format('MMM Do [at] H:mm')
    "#{start} - #{end}"

module.exports = ConflictsItem
