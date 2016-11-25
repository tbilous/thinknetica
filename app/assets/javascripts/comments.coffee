ready = ->

  commentForm = $('.new_comment')

#  appendComment = (data) ->
#    return if $("#comment-#{data.id}")[0]?
#    $(commentsList).append App.utils.render('comment', data)
  appendComment = (data) ->
    commentRoot = data.comment.commentable_type
    commentContainer = $("##{commentRoot}CommentsList-#{data.comment.commentable_id}")
    return if $("#comment-#{data.comment.id}.comment-block")[0]?
    $(commentContainer).prepend App.utils.render('comment', data.comment)

  commentForm.on 'ajax:success', (e, data, status, xhr) ->
    FormForClear = $(document).find(this)
    $(FormForClear)[0].reset();
    $(FormForClear).closest('.comment-wrapper').toggle()
    appendComment(data)


#  commentForm.on 'ajax:error', App.utils.ajaxErrorHandler
  commentForm.on 'ajax:error', (e, data, status, xhr) ->
    message =  data.responseJSON.errors
    for key,value of message
      message = value
      App.utils.errorMessage(message)

$(document).on("turbolinks:load", ready)
