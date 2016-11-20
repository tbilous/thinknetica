#= require cable
$(document).on 'turbolinks:load', ->
  App.questions = App.cable.subscriptions.create "RootChannel",
    connected: ->

    received: (data) ->
      questionList = $('.questions-list.collection')
      questionList.append data

    follow: ->
      @perform 'follow'
      console.log 'RootChannel', 'follow'

    unfollow: ->
      @perform 'unfollow'
      console.log 'RootChannel', 'unfollow'

$(document).on 'turbolinks:load', ->
  if questions = document.getElementById('QuestionsList')
    App.questions.follow()
  else
    App.questions.unfollow()
