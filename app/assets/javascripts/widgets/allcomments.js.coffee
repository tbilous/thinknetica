#class CommentForm
#  constructor: (el) ->
#    @el = $(el)
#    @item = $(@el.data('target'))
#    @form = $(@item.find('form'))
#    @list = $(@form.data('target'))
#
#    @el.click(@toggle)
#
#    @el.on 'click', (e) ->
#      e.preventDefault()
#      false
#
#  toggle: (evt) =>
#    @item.toggleClass('hidden')
#
#  appendComment = (data) ->
#    return if $("#comment-#{data.id}")[0]?
#    @list.append App.utils.render('comment', data)
#    console.log('return')
#
#  $(@form).on 'ajax:success', (e, data, status, xhr) ->
#    App.utils.successMessage(data?.message)
#    @appendComment data.comment
#    @item.toggleClass('hidden')
#
#  $(@form).on 'ajax:error', App.utils.ajaxErrorHandler

#hookInstances = ->
#  new CommentForm(button) for button in $('.comment-send')
#  console.log('CommentAnswerForm load')
#
#$(document).on('turbolinks:load', hookInstances)
