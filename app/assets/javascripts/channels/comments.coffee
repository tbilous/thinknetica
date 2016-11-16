#App.comments = App.cable.subscriptions.create "CommentsChannel",
#  connected: ->
#    console.log('connected!')
#    @perform 'follow'
#
#  disconnected: ->
#    # Called when the subscription has been terminated by the server
#
#  received: (data) ->
#    console.log 'received', data
#    # Called when there's incoming data on the websocket for this channel

#App.cable.subscriptions.create "CommentsChannel", {
#  connected: ->
#    console.log('connected!')
##        @follow()
#
##      follow: ->
##        return unless gon.comment_id
##        @perform 'follow', id: gon.comment_id
#
##      received: (data) ->
##        $(commentsList)(data)
#}
#App.cable.subscriptions.create 'CommentsChannel',
#  connected: ->
#    if questionId = $('.answers').data('question-id')
#      @perform 'follow', question_id: questionId
#    else
#      @perform 'unfollow'
#  received: (data) ->
#    comments_selector = '#comments-' + data['commentable_type'] + '-' + data['commentable_id']
#    $(comments_selector + ' ul').append JST['templates/comment'](
#      comment: data['comment']
#      current_user_id: gon.current_user_id)
