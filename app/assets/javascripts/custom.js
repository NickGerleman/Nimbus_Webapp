function ignore_warning() {
    $.cookie("ignore_warning", true, { expires: 30 })
}

function ie_warning() {
    if ($.cookie("ignore_warning") != "true") {
        $('#ie_warning').modal()
    }
}

function ie_selector_shadow() {
    document.getElementsByClassName("active")[0].style.boxShadow = "inset 0 0 50px -12px"
}