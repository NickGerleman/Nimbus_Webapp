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
  popup = $('.ajax-popup')
  popup.magnificPopup({ type: 'ajax'})
  popup.on 'mfpUpdateStatus', ->
    max_height = 0
    footer = $('.popup footer')
    height = footer.height()
    max_height = height if height > max_height
    footer.css('min-height', max_height + 'px')
    footer.css('line-height', max_height + 'px')

window.form_methods =
  toggle_load: ->
    $('.load:first, .submit:first').toggleClass('hide')
