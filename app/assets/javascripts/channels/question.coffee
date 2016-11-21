#= require cable
$ ->
  App.cable.subscriptions.create "QuestionChannel",
    connected: ->
      @follow()

    follow: ->
      return unless question_id = $('.question-block').data('question')
      @perform 'follow', question_id: question_id
      console.log 'QuestionChannel', 'follow'

    unfollow: ->
      @perform 'unfollow'
      console.log 'QuestionChannel', 'unfollow'

    proceedAnswer: (data) ->
      switch data.action
        when 'create'
          @createAnswer(data)
        when 'destroy'
          @destroyAnswer(data)

    createAnswer: (data) ->
      $('#answersList').append App.utils.render('answer', data.answer)
      App.utils.successMessage(data.message)

    destroyAnswer: (data) ->
      $("#answer-block-#{data.answer.id}").detach()
      App.utils.successMessage(data.message)

    proceedComment: (data) ->
      App.utils.successMessage(data.message)
      switch data.action
        when 'create'
          commentRoot = data.comment.commentable_type
          commentContainer = $("##{commentRoot}CommentsList-#{data.comment.commentable_id}")
          return if $("#comment-#{data.comment.id}.comment-block")[0]?
          $(commentContainer).prepend App.utils.render('comment', data.comment)
        when 'destroy'
          data = data.comment
          commentRoot = data.commentable_type
          commentContainer =
            $("##{commentRoot}CommentsList-#{data.commentable_id}")
          $(commentContainer).find("#comment-#{data.id}").detach()

    received: (data) ->
      if (data.answer)
        @proceedAnswer(data)
      else if (data.comment)
        @proceedComment(data)
      else
        return
