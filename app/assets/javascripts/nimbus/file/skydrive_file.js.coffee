window.nimbus_app.skydrive_file = (connection, metadata) ->
  that = nimbus_app.file()
  do ->
    size = metadata.size / 1024
    full_name = metadata.name
    time = Date.parse(metadata.updated_time)
    download_url = -> 'https://apis.live.net/v5.0/' + metadata.id + '/content' +
      '?access_token=' + connection.access_token()
    destroy = (promise) ->
      $.delete  'https://apis.live.net/v5.0/' + metadata.id
        access_token: connection.access_token(),
        -> promise.resolve()

    that.connection = -> connection
    that.full_name = -> full_name
    that.size = -> size
    that.time = -> time
    that.destroy = destroy
    that.download_url = download_url
    that
