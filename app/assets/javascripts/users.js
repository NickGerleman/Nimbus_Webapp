function displayLoadingBar()
    {
        if (document.getElementById('loadingBar'))
            $('#loadingBar').modal('show');
        else
            {
                var loadingBarModal = $('<div class="modal hide fade" id="loadingBar" aria-hidden="true"></div>');
                var header = $('<div class="modal-header">');
                var heading = $('<h3>Please Wait...</h3>');
                var body = $('<div class="modal-body"></div>')
                var outerBar = $('<div class="progress progress-striped active"></div>');
                var innerBar = $('<div class="bar" style="width: 100%;"></div>');
                header.append(heading);
                loadingBarModal.append(header);
                outerBar.append(innerBar);
                body.append(outerBar);
                loadingBarModal.append(body);
                $('body').append(loadingBarModal);
                loadingBarModal.modal('show');
            }
    }
