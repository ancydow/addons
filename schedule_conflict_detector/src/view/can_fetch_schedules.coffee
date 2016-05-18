_ = require('lodash')
$ = require('jQuery')
flatMap = (ary, fn)-> _.flatten(_.map(ary, fn))

CanFetchSchedules =
  fullyFetch: (schedules, options)->
    since = options.since.toJSON()
    till = options.till.toJSON()

    fetched = schedules.fetchAll()
    hydrated = fetched.then ->
      hydrations = schedules.map (s)->
        s.fetch(data: since: since, until: till)
      $.when(hydrations...)
    hydrated.then -> schedules.trigger('hydrated')

module.exports = CanFetchSchedules
