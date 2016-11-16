App.questions = App.cable.subscriptions.create "QuestionsChannel",

  connected: ->
    console.log 'QuestionsChannel', 'connected'
    @perform 'follow'

  received: (data) ->
    questionList = $('.questions-list.collection')
    questionList.append data
  follow: ->
    @perform 'follow'
