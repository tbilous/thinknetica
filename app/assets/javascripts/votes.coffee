# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  console.log('(document).turbolinks:load votes')
  $('.remove-btn').click ->
    $(this).toggleClass('hidden')

  # Voting for a question
  $('.vote_link').on('ajax:success', (e, data, status, xhr) ->
    wrapper = $(this).closest($('.vote-container'))
    target = $(wrapper).find($(this).data('target'))
    removeBtn = $(wrapper).find($('.remove-btn'))
    data = $.parseJSON(xhr.responseText)

    $('.vote-error').remove()
    $(target).html data.rating
    removeBtn.removeClass('hidden')

    return
  ).on 'ajax:error', (e, xhr, status, error) ->
    wrapper = $(this).closest($('.vote-container'))
    message = $.parseJSON(xhr.responseText)

    $('.vote-error').remove()

    alert = '<div class="alert alert-danger vote-error">' +
      '<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>' + message.error + '</div>'
    $(wrapper).prepend alert

    return


  # Voting for an answer
  $('.a_vote_link').on('ajax:success', (e, data, status, xhr) ->
    answer_id = $(this).data('targetId')
    data = $.parseJSON(xhr.responseText)

    $('.vote-error').remove()
    $('#a-rating-' + answer_id).html data.rate
    return
  ).on 'ajax:error', (e, xhr, status, error) ->
    answer_id = $(this).data('targetId')
    message = $.parseJSON(xhr.responseText)

    $('.vote-error').remove()
    alert = '<div class="alert alert-danger vote-error">' +
      '<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>' + message.error + '</div>'
    $('#a-content-' + answer_id).prepend alert

    return
  return

$(document).on("turbolinks:load", ready)
