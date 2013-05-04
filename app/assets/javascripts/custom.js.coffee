this.ignore_warning = ->
  $.cookie("ignore_warning", true, { expires: 30 })

this.ie_warning = ->
  $('#ie_warning').modal() if $.cookie("ignore_warning") != "true"
$(document).ready -> $(document).foundation()