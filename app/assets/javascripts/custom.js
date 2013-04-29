function ignore_warning() {
$.cookie("ignore_warning", true, { expires: 30 })
}

function ie_warning() {
  if ($.cookie('ignore_warning') != true) {
  $('#ie_warning').modal()
}
}