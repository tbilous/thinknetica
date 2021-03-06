ready = ->
  questionsList = $(".questions-list .collection")
  questionForm = $('#new_question')
  attachInput = $(questionForm).find('.nested-fields')

  questionForm.on 'ajax:success', (e, data, status, xhr) ->
    $(questionForm)[0].reset();
    $(this).find('.nested-fields').remove()
    questionsList.append App.utils.render('question_list', data.question)
    App.utils.successMessage(data.message)
    window.location.href = "/questions/#{data.question.id} "

  questionForm.on 'ajax:error', App.utils.ajaxErrorHandler
#  questionForm.on 'ajax:error', (e, data, status, xhr) ->
#    debugger
#    message =  data.responseJSON.errors
#    for key,value of message
#      message = value
#      App.utils.errorMessage(message)

$(document).on("turbolinks:load", ready)
