class ItemToggle
  constructor: (el) ->
    @el = $(el)
    @item = $(@el.data('target'))
    @focus = $(@item).find('.input-field:first input')

    @el.click(@toggle)

  toggle: (evt) =>
    @item.toggleClass('hidden')
    @focus.focus()


hookInstances = ->
  new ItemToggle(button) for button in $('.script-item-toggle')
  console.log('(document).turbolinks:load')



#$(document).ready(hookInstances) # "вешаем" функцию ready на событие document.ready
#$(document).on('page:load', hookInstances)  # "вешаем" функцию ready на событие page:load
#$(document).on('page:update', hookInstances) # "вешаем" функцию ready на событие page:update
$(document).on("turbolinks:load", hookInstances)
