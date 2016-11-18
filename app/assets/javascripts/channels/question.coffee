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
      App.utils.successMessage(data.message)
      $('#answersList').append App.utils.render('comment', data.answer)

    proceedComment: (data) ->
      App.utils.successMessage(data.message)
      $('.comment-list').append App.utils.render('comment', data.comment)

    received: (data) ->
      if (data.answer)
        @proceedAnswer(data)
      else if (data.comment)
        @proceedComment(data)
      else
        return
#      return unless data.answer
#        App.utils.successMessage(data.meta)
#        answer = $.parseJSON(data.answer)
#        $('.answers-list').append JST['templates/answer'](answer)
#      return unless data.comment
#        comment = $.parseJSON(data.comment)
#        $parent = $('[data-' + comment.parent.type + '-id ="' + comment.parent.id + '"]')
#        $parent.find('.comments-list').append JST['templates/comment'](comment)

$(document).on 'turbolinks:load', ->
  question_id = $('.question-block').data('question')
  if typeof question_id != 'undefined'
    App.questionChannel.follow()
  else
    App.questionChannel.unfollow()
