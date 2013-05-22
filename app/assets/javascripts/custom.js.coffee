"use strict"

jQuery ->
  refresh_layout()

$(window).resize ->
  refresh_layout()

refresh_layout = ->
  adjust_footer()

adjust_footer = ->
  height = $(window).height()
  $('#content').css('min-height', (height - 175) + 'px')