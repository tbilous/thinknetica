ready = ->
  answerForm = $('#new_answer')
  attachInput = $(answerForm).find('.nested-fields')
  clearForm = $(answerForm).find('textarea')

  answerForm.on 'ajax:success', (e, data, status, xhr) ->
#    $(answerForm)[0].reset();
#    $(this).find('.nested-fields').remove()
    App.utils.successMessage(data.message)

#  answerForm.on 'ajax:error', App.utils.ajaxErrorHandler
  answerForm.on 'ajax:error', (e, data, status, xhr) ->
    message =  data.responseJSON.errors
    for key,value of message
      message = value
      App.utils.errorMessage(message)

$(document).on("turbolinks:load", ready)
