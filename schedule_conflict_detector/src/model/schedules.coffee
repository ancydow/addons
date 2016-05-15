mixin = require('../lib/mixin')
Collection = require('../lib/collection')
PDApi = require('../lib/pagerduty_api')
Schedule = require('./schedule')


class Schedules extends Collection
  mixin @, PDApi.Collection
  model: Schedule
  urlPath: 'api/v1/schedules'

  initialize: (models, options)->
    @apiKey = options.apiKey
    @subdomain= options.subdomain

  parse: (json) ->
    @offset = json.offset
    @limit = json.limit
    @total = json.total
    @query = json.query
    json.schedules

module.exports = Schedules
