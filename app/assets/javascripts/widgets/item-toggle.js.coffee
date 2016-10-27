class ItemToggle
  constructor: (el) ->
    @el = $(el)
    @item = $(@el.data('target'))
    @focus = $(@item).find('.form-control:first')


    @el.click(@toggle)

  toggle: (evt) =>
    @item.toggleClass('hidden')
    console.log(@item)
    @focus.focus()


hookInstances = ->
  new ItemToggle(button) for button in $('.script-item-toggle')



$(document).ready(hookInstances) # "вешаем" функцию ready на событие document.ready
$(document).on('page:load', hookInstances)  # "вешаем" функцию ready на событие page:load
$(document).on('page:update', hookInstances) # "вешаем" функцию ready на событие page:update