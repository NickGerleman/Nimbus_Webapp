window.nimbus_app.box_file = (connection, metadata) ->
  that = nimbus_app.file()
  do ->
    size = metadata.size / 1024
    full_name = metadata.name
    time = Date.parse(metadata.modified_at)
    download_url = -> 'https://api.box.com/2.0/files/' + metadata.id + '/content' +
      '?access_token=' + connection.access_token()
    destroy = (promise) ->
      $.delete 'https://api.box.com/2.0/files/',
        access_token: connection.access_token(),
        -> promise.resolve()


    that.connection = -> connection
    that.full_name = -> full_name
    that.size = -> size
    that.time = -> time
    that.destroy = destroy
    that.download_url = download_url
    that
