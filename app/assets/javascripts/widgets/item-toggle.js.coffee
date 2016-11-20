class ItemToggle
  constructor: (el) ->
    @el = $(el)
    @item = $(@el.data('target'))
    @focus = $(@item).find('.input-field:first input')

#    @el.click(@toggle)

  toggle: (evt) =>
    @item.toggleClass('hidden')
    @focus.focus()


hookInstances = ->
  new ItemToggle(button) for button in $('.script-item-toggle')
  console.log('(document).turbolinks:load')

#$(document).on("turbolinks:load", hookInstances)
