Model = require('../lib/model')
Collection = require('../lib/collection')
User = require('./user')
Schedule = require('./schedule')


class Span extends Model
  @attrDate 'start'
  @attrDate 'end'

class Spans extends Collection
  model: Span


class Conflict extends Model
  @attrAssoc 'user', klass: User
  @attrAssoc 'schedule_one', klass: Schedule
  @attrAssoc 'schedule_two', klass: Schedule
  @attrAssoc 'spans', klass: Spans

class Conflicts extends Collection
  model: Conflict

module.exports = Conflicts
