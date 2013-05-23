"use strict"

jQuery ->
  $(document).foundation()
  refresh_layout()
  init_popups()

$(window).resize ->
  refresh_layout()

refresh_layout = ->
  adjust_footer()

adjust_footer = ->
  height = $(window).height()
  $('#content').css('min-height', (height - 175) + 'px')

init_popups = ->
  $('.ajax-popup').magnificPopup({ type: 'ajax'})

window.forms =
  toggle_load: ->
    $('.load:first, .submit:first').toggleClass('hide')
