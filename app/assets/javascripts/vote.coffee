ready = ->
  $(document).on 'ajax:success', '.vote_link', (e, data, status, xhr) ->

    wrapper = $(this).closest($('.vote-container'))
    target = $(wrapper).find($(this).data('target'))
    removeBtn = $(wrapper).find($('.remove-btn'))
    $(target).html data.rating
    removeBtn.removeClass('hidden')
    App.utils.successMessage(data.message)

  $(document).on 'ajax:success', '.vote_link', (e, data, status, xhr) ->
    App.utils.ajaxErrorHandler

  $(document).on 'ajax:success', '.remove-btn', (e, data, status, xhr) ->
    $(this).toggleClass('hidden');
    wrapper = $(this).closest($('.vote-container'))
    target = $(wrapper).find($(this).data('target'))

    $(target).html data.rating
    App.utils.successMessage(data.message)

  $(document).on 'ajax:success', '.remove-btn', (e, data, status, xhr) ->
    App.utils.ajaxErrorHandler


$(document).on("turbolinks:load", ready)
