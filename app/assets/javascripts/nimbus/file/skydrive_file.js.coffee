'use strict'

# Construct a skydrive file from a connection it belongs to and API metadata
window.nimbus_app.skydrive_file = (connection, metadata) ->
  that = nimbus_app.file()
  size = metadata.size / 1024
  time = Date.parse(metadata.updated_time)

  # Get the download URL for the file
  download_url = -> 'https://apis.live.net/v5.0/' + metadata.id + '/content' +
    '?access_token=' + connection.access_token() + '&download=true'

  # Delete the file
  destroy = (promise) ->
    $.ajax
      type: 'DELETE'
      url: 'https://apis.live.net/v5.0/' + metadata.id
      headers: Authorization: 'Bearer ' + connection.access_token()
      dataType: 'JSON'
      success: -> promise.resolve()

  # Rename the file
  rename = (name, promise) ->
    $.ajax
      type: 'PUT'
      url: 'https://apis.live.net/v5.0/' + metadata.id
      headers: Authorization: 'Bearer ' + connection.access_token()
      data: name: name
      dataType: 'JSON'
      succes: (data) ->
        metadata = data.data[0]
        promise.resolve()


  # The connection the file belongs to
  that.connection = -> connection
  # The name with extension of the file
  that.full_name = -> metadata.name
  # The id of the file
  that.id = -> metadata.id
  # The size in KB of the file
  that.size = -> size
  # The date modified of the file
  that.time = -> time
  that.destroy = destroy
  that.download_url = download_url
  that.rename = rename
  that
