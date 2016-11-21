ready = ->

  commentForm = $('.new_comment')

#  appendComment = (data) ->
#    return if $("#comment-#{data.id}")[0]?
#    $(commentsList).append App.utils.render('comment', data)

  commentForm.on 'ajax:success', (e, data, status, xhr) ->
    FormForClear = $(document).find(this)
    $(FormForClear)[0].reset();
    debugger
    $(FormForClear).closest('.comment-wrapper').toggle()

  commentForm.on 'ajax:error', App.utils.ajaxErrorHandler

$(document).on("turbolinks:load", ready)
