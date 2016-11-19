$(document).on 'turbolinks:load', ->
  App.questionChannel = App.cable.subscriptions.create "QuestionChannel",
    connected: ->
      @follow()

    disconnected: ->

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
      $('#answersList').append App.utils.render('comment', data.answer)
      App.utils.successMessage(data.message)

    destroyAnswer: (data) ->
      $("#answer-block-#{data.answer.id}").detach()
      App.utils.successMessage(data.message)

    proceedComment: (data) ->
      App.utils.successMessage(data.message)
      switch data.action
        when 'create'
          @createComment(data)
        when 'destroy'
          @destroyComment(data)

    createComment: (data) ->
      debugger
      commentRoot = data.comment.commentable_type
      commentContainer = $("##{commentRoot}CommentsList-#{data.comment.commentable_id}")
      $(commentContainer).prepend App.utils.render('comment', data.comment)

    destroyComment: (data) ->
      data = data.comment
      commentRoot = data.commentable_type
      commentContainer = $("##{commentRoot}CommentsList-#{data.commentable_id}")
      $(commentContainer).find("#comment-#{data.id}").detach()



    received: (data) ->
      if (data.answer)
        @proceedAnswer(data)
      else if (data.comment)
        @proceedComment(data)
      else
        return


$(document).on 'turbolinks:load', ->
  question_id = $('.question-block').data('question')
  if typeof question_id != 'undefined'
    App.questionChannel.follow()
  else
    App.questionChannel.unfollow()
