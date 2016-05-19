mixin = require('../lib/mixin')
Model = require('../lib/model')
Collection = require('../lib/collection')
PDApi = require('../lib/pagerduty_api')
User = require('./user')

class Entry extends Model
  @attrDate 'start'
  @attrDate 'end'
  @attrAssoc 'user', klass: User

class Entries extends Collection
  model: Entry

class FinalLayer extends Model
  @attrAssoc 'entries', keyName: 'rendered_schedule_entries', klass: Entries

class Schedule extends Model
  mixin @, PDApi.Model
  @attrAccessor 'summary', 'html_url'
  @attrAssoc 'final_layer', keyName: 'final_schedule', klass: FinalLayer

  parse: (attrs)->
    if attrs.schedule
      attrs.schedule
    else
      attrs

module.exports = Schedule
