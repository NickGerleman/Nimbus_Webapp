window.nimbus_app.google_file = (connection, metadata) ->
  that = nimbus_app.file()
  do ->
    size = metadata.fileSize / 1024
    full_name = metadata.title
    time = Date.parse(metadata.modifiedDate)
    download_url = do ->
      url = metadata.downloadUrl
      url.replace('&gd=true', '') if url
    view_url = metadata.alternateLink
    destroy = (promise) ->
      $.delete 'https://www.googleapis.com/drive/v2/files/' + metadata.id,
        access_token: connection.access_token,
        -> promise.resolve()


    that.connection = -> connection
    that.download_url = -> download_url
    that.full_name = -> full_name
    that.size = -> size
    that.time = -> time
    that.view_url = -> view_url
    that.destroy = destroy
    that
