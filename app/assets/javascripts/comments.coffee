ready = ->

  commentForm = $('.new_comment')

#  appendComment = (data) ->
#    return if $("#comment-#{data.id}")[0]?
#    $(commentsList).append App.utils.render('comment', data)

  commentForm.on 'ajax:success', (e, data, status, xhr) ->
    $(commentForm).closest('.comment-wrapper').toggleClass('hidden')
    $(commentForm)[0].reset();

  commentForm.on 'ajax:error', App.utils.ajaxErrorHandler

$(document).on("turbolinks:load", ready)
