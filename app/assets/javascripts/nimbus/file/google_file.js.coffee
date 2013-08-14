window.nimbus_app.google_file = (connection, metadata) ->
  that = nimbus_app.file()
  do ->
    size = metadata.fileSize / 1024
    full_name = metadata.title
    time = Date.parse(metadata.modifiedDate)
    download_url = -> metadata.downloadUrl
    destroy = (promise) ->
      $.delete 'https://www.googleapis.com/drive/v2/files/' + metadata.id,
        access_token: connection.access_token,
        -> promise.resolve()

    that.size = -> size
    that.full_name = -> full_name
    that.time = -> time
    that.download_url = download_url
    that.destroy = destroy
    that.connection = -> connection
    that
