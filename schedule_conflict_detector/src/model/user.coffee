Model = require('../lib/model')

class User extends Model
  @attrAccessor 'summary', 'html_url'

module.exports = User
