ready = ->
  $('.comment-send').click ->
    formWrapper = $(this).data('target')
    commentForm = $(formWrapper).find('form')
    commentsList = $(commentForm.data('target'))
    clearForm = $(commentForm).find('textarea')

    appendComment = (data) ->
      return if $("#comment-#{data.id}")[0]?
      $(commentsList).append App.utils.render('comment', data)
      App.utils.successMessage('Comment added')
      $(clearForm).val('')
      $(formWrapper).toggleClass('hidden')

    $(formWrapper).toggleClass('hidden')

    commentForm.on 'ajax:success', (e, data, status, xhr) ->
      appendComment data.comment

    commentForm.on 'ajax:error', App.utils.ajaxErrorHandler

$(document).on("turbolinks:load", ready)
