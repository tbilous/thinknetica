ready = ->
  questionsList = $(".questions-list")
  questionForm = $('#new_question')
  attachInput = $(questionForm).find('.nested-fields')

  questionForm.on 'ajax:success', (e, data, status, xhr) ->
    $(questionForm)[0].reset();
    $(this).find('.nested-fields').remove()
#    App.utils.successMessage(data?.message)
    window.location.href = "/questions/#{data.question.id} "

#  questionForm.on 'ajax:error', App.utils.ajaxErrorHandler

$(document).on("turbolinks:load", ready)
