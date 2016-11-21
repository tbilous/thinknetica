#= require cable

App.questions = App.cable.subscriptions.create "RootChannel",
  connected: ->
    @followQuestionsList()
    @installPageChangeCallback()
    return

  received: (data) ->
    debugger
    questionList = $('.questions-list.collection')
    questionList.append data

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
        App.questions.followQuestionsList()
        return
    return
