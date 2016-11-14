## Place all the behaviors and hooks related to the matching controller here.
## All this logic will automatically be available in application.js.
## You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  console.log('(document).turbolinks:load votes')

  $('.remove-btn').on('ajax:success', (e, data, status, xhr) ->
    $(this).toggleClass('hidden');
    wrapper = $(this).closest($('.vote-container'))
    target = $(wrapper).find($(this).data('target'))
    console.log(wrapper)
    $(target).html data.rating
    return
    )

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
  return

$(document).on("turbolinks:load", ready)
