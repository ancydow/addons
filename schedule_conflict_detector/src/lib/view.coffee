Bb = require('backbone')
$ = require('jQuery')

class View extends Bb.View
  mainRender: (template, data)->
    template ?= @template
    data ?= @data?()
    @$el.html template(data)

  subRender: (selector)->
    =>
      fragment = $(@template(@data()))
      subHtml = fragment.find(selector).html()
      # jQuery won't return toplevel elements with #find
      # eg, $('<p>foo</p>').find('p') => []
      # so we do the below
      subHtml ?= fragment.closest(selector).html()
      @$(selector).html subHtml

module.exports = View
