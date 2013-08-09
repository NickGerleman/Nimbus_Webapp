"use strict"

# jQuery function is shortcut for once DOM is ready
jQuery ->
  $(document).foundation()
  refresh_layout()
  init_popups()
  create_callbacks()

$(window).resize ->
  refresh_layout()

refresh_layout = ->
  adjust_footer()

# Should eventually move to CSS
adjust_footer = ->
  height = $(window).height()
  $('#content').css('min-height', (height - 200) + 'px')

init_popups = ->
  popup = $('.ajax-popup')
  popup.magnificPopup({
    mainClass: 'modal',
    type: 'ajax',
    preloader: false,
    removalDelay: 200,
    closeBtnInside: true
  })

create_callbacks = ->
  $('.spinner-link').click ->
    show_spinner()

window.show_spinner = ->
  spin_box = $('<div id="spinner-box">')
  spin_overlay = $('<div id="spinner-overlay">')
  spin_overlay.append(spin_box)
  $(document.body).append(spin_overlay)
  opts = {
    lines: 13,
    length: 0,
    width: 20,
    radius: 50,
    corners: 1,
    color: '#fff',
    shadow: false,
    # Causes issues with my laptop and Chrome when quickly closing the spinner
    hwaccel: false,
    className: 'spinner',
    zIndex: 2e9,
  }
  spin_box.spin(opts)

window.stop_spinner = ->
  $('#spinner-overlay').remove()

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
  # Check if it correctly parses ISO 8601 time
  Date.parse('2013-07-24T07:24:04-05:00') == 1374668644000
