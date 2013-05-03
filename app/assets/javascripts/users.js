function loadingBar() {
    var register= $('#register');
    register.on('shown', register.modal('hide'));
    $('.modal-header').html('<h3>Please Wait...</h3>');
    $('.modal-body').html('<div class="progress progress-striped active"></div>')
    $('.progress').append('<div class="bar" style="width: 100%;"></div>');
    $('.modal-footer').remove();
    register.on('hidden', register.modal('show'));
}