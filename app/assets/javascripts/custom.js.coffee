this.ignore_warning = ->
  $.cookie("ignore_warning", true, { expires: 30 })

this.ie_warning = ->
  $('#ie_warning').modal() if $.cookie("ignore_warning") != "true"

this.resize = ->
  $('.modal-body').css 'max-height', Math.floor(($(window).height() - 125) * .8)
  normal_logo = $('.normal-brand')
  mini_logo = $('.mini-brand')
  nav_container = $('.container')
  nav_list = $('.nav')
  if $(window).width() < 800
    normal_logo.hide()
    mini_logo.show()
    nav_list.removeClass('pull-right')
    nav_container.css 'width', '600px'
    $('body').css 'min-width', 620
  else
    normal_logo.show()
    mini_logo.hide()
    nav_list.addClass('pull-right')
    nav_container.css 'width', 'auto'
$(document).ready resize
$(window).resize resize