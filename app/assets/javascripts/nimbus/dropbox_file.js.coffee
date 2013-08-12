window.nimbus_app.dropbox_file = (connection, metadata) ->
  that = nimbus_app.file()
  do ->
    size = parseFloat(metadata.size)
    full_name = metadata.path.slice(path.lastIndexOf('/') + 1)
    time = Date.parse(metadata.modified)
    download_link = 'https://api-content.dropbox.com/1/files/dropbox' + path +
      '?access_token=' + connection.access_token
    destroy = (promise) ->
      $.post 'https://api.dropbox.com/1/fileops/delete',
        {root: 'dropbox', path: path, access_token: connection.access_token},
        -> promise.resolve()

    that.size = size
    that.full_name = full_name
    that.time = time
    that.download_link = download_link
    that.destroy = destroy
    that
