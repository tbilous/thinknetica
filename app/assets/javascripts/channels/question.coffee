App.cable.subscriptions.create 'QuestionChannel',
  connected: ->
    @follow()
    console.log 'QuestionChannel', 'follow'

  follow: ->
    question_id = $('.question-block').data('question')
    return unless question_id
    @perform 'follow', question_id: question_id

  received: (data) ->
    return unless data.answer
      answer = $.parseJSON(data.answer)
      $('.answers-list').append JST['templates/answer'](answer)
    return unless data.comment
      comment = $.parseJSON(data.comment)
      $parent = $('[data-' + comment.parent.type + '-id ="' + comment.parent.id + '"]')
      $parent.find('.comments-list').append JST['templates/comment'](comment)

