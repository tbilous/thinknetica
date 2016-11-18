ready = ->
  answerForm = $('#new_answer')
  attachInput = $(answerForm).find('.nested-fields')
  clearForm = $(answerForm).find('textarea')

  answerForm.on 'ajax:success', (e, data, status, xhr) ->

    $(answerForm)[0].reset();
    $(this).find('.nested-fields').remove()
    if (data.answer) then console.log('object find')

  answerForm.on 'ajax:error', App.utils.ajaxErrorHandler

$(document).on("turbolinks:load", ready)
