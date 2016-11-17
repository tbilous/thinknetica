App.questions = App.cable.subscriptions.create "RootChannel",
  connected: ->
    @perform 'follow'
    console.log 'RootChannel', 'follow'

  received: (data) ->
    questionList = $('.questions-list.collection')
    questionList.append data
  follow: ->
    @perform 'follow'
