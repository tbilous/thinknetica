#= require cable

App.question =  App.cable.subscriptions.create "QuestionChannel",
    connected: ->
      @followQuestionPage()
      @installPageChangeCallback()
      return

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
          @createComment(data)
        when 'destroy'
          @destroyComment(data)

    createComment: (data) ->
      commentRoot = data.comment.commentable_type
      commentContainer = $("##{commentRoot}CommentsList-#{data.comment.commentable_id}")
      return if $("#comment-#{data.comment.id}.comment-block")[0]?
      $(commentContainer).prepend App.utils.render('comment', data.comment)

    destroyComment: (data) ->
      data = data.comment
      commentRoot = data.commentable_type
      commentContainer =
        $("##{commentRoot}CommentsList-#{data.commentable_id}")
      $(commentContainer).find("#comment-#{data.id}").detach()

    received: (data) ->
      if (data.answer)
        if gon.current_user_id == data.answer.user_id
          console.log 'self'
          return
        else
          @proceedAnswer(data)
      else if (data.comment)
        if gon.current_user_id == data.comment.user_id
          console.log 'self'
          return
        else
          @proceedComment(data)
      else
        return

    followQuestionPage: ->
      question_id = $('.question-block').data('question')
      if $(question_id).length
        @perform 'follow', question_id: question_id
        console.log 'question follow'
      else
        @perform 'unfollow'
        console.log 'question unfollow'
      return

    installPageChangeCallback: ->
      if !@installedPageChangeCallback
        @installedPageChangeCallback = true
        $(document).on 'turbolinks:load', ->
          App.question.followQuestionPage()
          return
      return
