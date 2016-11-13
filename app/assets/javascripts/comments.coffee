$ ->
  commentForm = $("#NewQuestionComment")
  addAnswerBtn = $("#add_answer_btn")
  commentsList = $("#QuestionCommentsList")
  cancelBtn = $(".cancel-btn")
  wrapper = $(commentForm).closest('.comment-wrapper')

  appendComment = (data) ->
    return if $("#comment_#{data.id}")[0]?
    commentsList.append App.utils.render('comment', data)

  cancelBtn.on 'click', (e) ->
    commentForm.toggleClass('hidden')

  addAnswerBtn.on 'click', (e) ->
    e.preventDefault()
    false

  commentForm.on 'ajax:success', (e, data, status, xhr) ->
    App.utils.successMessage(data?.message)
    appendComment data.comment
    wrapper.toggleClass('hidden')

  commentForm.on 'ajax:error', App.utils.ajaxErrorHandler
#
#  commentsList.on 'ajax:success', '.delete-comment-link', (e, data) ->
#    App.utils.successMessage(data?.message)
#    console.log('delete')
#    $(e.target).closest('.comment-block')?.remove()

#  $('.delete-comment-link').click 'ajax:success', (e, data) ->
#    console.log('delete')
#    App.utils.successMessage(data?.message)
#    $(e.target).closest('.comment-block')?.remove()

#  commentsList.on 'ajax:error', '.delete-comment-link', App.utils.ajaxErrorHandler

#  answersList.on 'click', '.edit-answer-link', (e) ->
#    e.preventDefault()
#    cont = $(e.target).closest('.answer')
#    form = cont.find('.answer-edit-form')
#    info = cont.find('.answer-info')
#
#    info.hide()
#    form.show()
#    form.find('.cancel-btn').one 'click', ->
#      form.hide()
#      info.show()
#      form.off('ajax:success ajax:error')
#
#    form.one 'ajax:success', (e, data) ->
#      App.utils.successMessage(data?.message)
#      cont.replaceWith App.utils.render('answer', data.answer)
#
#    form.on 'ajax:error', App.utils.ajaxErrorHandler
#
#  answersList.on 'ajax:success', '.best-answer-link', (e, data) ->
#    App.utils.successMessage(data?.message)
#    answersList.find('.answer-best-badge').remove()
#    $(e.target).closest('.answer')?.remove()
#    answersList.prepend App.utils.render('answer', data.answer)
#
#  PrivatePub.subscribe "/questions/#{gon.question_id}", (data, channel) ->
#    appendAnswer data.answer

