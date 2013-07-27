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
  popup.magnificPopup({
    mainClass: 'modal',
    type: 'ajax',
    preloader: false,
    removalDelay: 200,
    closeBtnInside: true,

  })
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

window.compatible = ->
  Modernizr.backgroundsize and
  Modernizr.borderradius and
  Modernizr.boxshadow and
  Modernizr.opacity and
  Modernizr.textshadow and
  Modernizr.csscolumns and
  Modernizr.csstransforms and
  Modernizr.csstransitions and
  Modernizr.svg and
  Modernizr.backgroundsize and
  Modernizr.borderradius and
  Modernizr.boxshadow and
  Modernizr.opacity and
  Modernizr.textshadow and
  Modernizr.csscolumns and
  Modernizr.csstransforms and
  Modernizr.csstransitions and
  Modernizr.svg and
  Date.parse('2013-07-24T07:24:04-05:00') == 1374668644000
