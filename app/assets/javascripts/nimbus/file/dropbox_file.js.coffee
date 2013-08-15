window.nimbus_app.dropbox_file = (connection, metadata) ->
  that = nimbus_app.file()
  do ->
    size = parseFloat(metadata.size)
    full_name = metadata.path.slice(metadata.path.lastIndexOf('/') + 1)
    time = Date.parse(metadata.modified)
    download_url = -> encodeURI 'https://api-content.dropbox.com/1/files/dropbox' + metadata.path +
      '?access_token=' + connection.access_token
    destroy = (promise) ->
      $.post 'https://api.dropbox.com/1/fileops/delete',
        root: 'dropbox', path: path, access_token: connection.access_token,
        -> promise.resolve()

    that.connection = -> connection
    that.full_name = -> full_name
    that.size = -> size
    that.time = -> time
    that.destroy = destroy
    that.download_url = download_url
    that
