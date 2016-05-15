_ = require('lodash')
$ = require('jQuery')
flatMap = (ary, fn)-> _.flatten(_.map(ary, fn))

CanFetchSchedules =
  fetchAllSchedules: (schedules, options)->
    fetch = schedules.fetchAll()
    fetch.then ->
      hydrated = schedules.map (s)->
        s.fetch data:
          since: options.since.toJSON()
          until: options.till.toJSON()
      $.when(hydrated...).then ->
        schedules.trigger('hydrated')

module.exports = CanFetchSchedules
