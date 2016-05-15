_ = require('lodash')
PagerdutyApi =
  Model:
    onInclude: (base)->
      base::oldSync = base::sync
      base::sync = base::newSync

    newSync: (method, model, options)->
      # hacky to grab it from the collection
      # should be passed in on intialization of the model
      headers =
        "Content-Type": "application/json"
        "Accept": "application/vnd.pagerduty+json;version=2"
        "Authorization": "Token token=#{@collection.apiKey}"
      _.extend(options, {headers: headers})

      @oldSync(method, model, options)

  Collection:
    onInclude: (base)->
      base::oldSync = base::sync
      base::sync = base::newSync

    url: ->
      "https://#{@subdomain}.pagerduty.com/#{@urlPath}"

    newSync: (method, model, options)->
      headers =
        "Content-Type": "application/json"
        "Accept": "application/vnd.pagerduty+json;version=2"
        "Authorization": "Token token=#{@apiKey}"
      _.extend(options, {headers: headers})

      @oldSync(method, model, options)

module.exports = PagerdutyApi
