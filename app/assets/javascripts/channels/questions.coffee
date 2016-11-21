#= require cable

App.questions = App.cable.subscriptions.create "RootChannel",
  connected: ->
    @followQuestionsList()
    @installPageChangeCallback()
    return

  received: (data) ->
    questionList = $('.questions-list.collection')
    questionList.append data

  followQuestionsList: ->
    if $('.questions-list').length
      @perform 'follow'
      console.log 'root follow'
    else
      @perform 'unfollow'
    return

  installPageChangeCallback: ->
    if !@installedPageChangeCallback
      @installedPageChangeCallback = true
      $(document).on 'turbolinks:load', ->
        App.questions.followQuestionsList()
        return
    return
#
#
#$(document).on 'turbolinks:load', ->
#  if questions = document.getElementById('QuestionsList')
#    App.questions.follow()
#  else
#    App.questions.unfollow()


#App.questions_list = App.cable.subscriptions.create('QuestionsListChannel',
#  connected: ->
#    @followQuestionsList()
#    @installPageChangeCallback()
#    return
#  received: (data) ->
#    $('.questions-list').append data.question
#    return
#  followQuestionsList: ->
#    if $('.questions-list').length
#      @perform 'follow'
#    else
#      @perform 'unfollow'
#    return
#  installPageChangeCallback: ->
#    if !@installedPageChangeCallback
#      @installedPageChangeCallback = true
#      $(document).on 'turbolinks:load', ->
#        App.questions_list.followQuestionsList()
#        return
#    return
#)
