ready = ->
  #$('.comment-send').click ->
#    formWrapper = $(this).data('target')
  commentForm = $('#new_answer')
#    commentsList = $(commentForm.data('target'))
  clearForm = $(commentForm).find('textarea')

#  appendComment = (data) ->
#    return if $("#comment-#{data.id}")[0]?
#    $(commentsList).append App.utils.render('comment', data)

#    $(formWrapper).toggleClass('hidden')
  console.log('answer ready')
  commentForm.on 'ajax:success', (e, data, status, xhr) ->
    debugger
#      $(clearForm).val('')
#      $(formWrapper).toggleClass('hidden')
    App.utils.successMessage(data?.message)
#    reset(this)
#      appendComment data.comment
#    reset(this)
#  commentForm.on 'ajax:complete', clearForm.val('')
#  commentForm.on 'ajax:error', App.utils.ajaxErrorHandler

$(document).on("turbolinks:load", ready)
