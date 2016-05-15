$ = require('jQuery')

Moment = require('moment')
Schedules = require('./model/schedules')
Conflicts = require('./model/conflicts')
Page = require('./view/page')
UrlParams = require('./lib/url_params')
fetchAllSchedules = require('./view/can_fetch_schedules').fetchAllSchedules

$ ->
  subdomain = UrlParams.get('subdomain')
  apiKey = UrlParams.get('apiKey')

  schedules = new Schedules([], apiKey: apiKey, subdomain: subdomain)
  conflicts = new Conflicts()
  pageView = new Page
    schedules: schedules
    conflicts: conflicts
  $('.h-page').html pageView.el

  since = Moment()
  till = since.clone().add(4, 'week')
  fetchAllSchedules(schedules, {since, till})
