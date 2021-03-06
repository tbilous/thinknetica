#= require cable

App.rootQuestions = App.cable.subscriptions.create "RootChannel",
  connected: ->
    @followQuestionsList()
    @installPageChangeCallback()
    return

  createQuestion: (data) ->
    questionList = $('#QuestionsList .collection')
    questionList.append App.utils.render('question_list', data.questions)
    App.utils.successMessage(data.message)

  destroyQuestion: (data) ->
    questionList = $("#question_#{data.questions.id}")
    $(questionList).detach()
    App.utils.successMessage(data.message)

  proceedQuestion: (data) ->
    switch data.action
      when 'create'
        @createQuestion(data)
      when 'destroy'
        @destroyQuestion(data)

  received: (data) ->
    if gon.current_user_id == data.questions.user_id
      console.log 'self'
      return
    else
      @proceedQuestion(data)

  followQuestionsList: ->
    if $('.questions-list').length
      @perform 'follow'
      console.log 'root follow'
    else
      @perform 'unfollow'
      console.log 'root unfollow'
    return

  installPageChangeCallback: ->
    if !@installedPageChangeCallback
      @installedPageChangeCallback = true
      $(document).on 'turbolinks:load', ->
        App.rootQuestions.followQuestionsList()
        return
    return
