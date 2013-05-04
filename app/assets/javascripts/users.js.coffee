this.displayLoadingBar = ->
  if document.getElementById 'loadingBar'
    $('#loadingBar').modal 'show'
  else
    loadingBarModal = $('<div class="modal hide fade" id="loadingBar" aria-hidden="true"></div>')
    header = $('<div class="modal-header">')
    heading = $('<h3>Please Wait...</h3>')
    body = $('<div class="modal-body"></div>')
    outerBar = $('<div class="progress progress-striped active"></div>')
    innerBar = $('<div class="bar" style="width: 100%;"></div>')
    header.append heading
    loadingBarModal.append header
    outerBar.append innerBar
    body.append outerBar
    loadingBarModal.append body
    $('body').append loadingBarModal
    loadingBarModal.modal 'show'