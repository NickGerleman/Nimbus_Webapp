'use strict'

# Construct a skydrive file from a connection it belongs to and API metadata
window.nimbus_app.skydrive_file = (connection, metadata) ->
  that = nimbus_app.file()
  size = metadata.size
  time = Date.parse(metadata.updated_time)

  # Get the download URL for the file
  download_url = -> 'https://apis.live.net/v5.0/' + metadata.id + '/content' +
    '?access_token=' + connection.access_token()

  # Delete the file
  destroy = (promise) ->
    $.ajax
      type: 'DELETE'
      url: 'https://apis.live.net/v5.0/' + metadata.id + '?access_token=' + connection.access_token()
      dataType: 'JSON'
      success: -> promise.resolve()
      error: (jqXHR, textStatus, errorThrown) ->
        promise.reject('Unable to delete file:' + errorThrown)

  # Rename the file
  rename = (name, promise) ->
    $.ajax
      type: 'PUT'
      url: 'https://apis.live.net/v5.0/' + metadata.id + '?access_token=' + connection.access_token()
      contentType: 'application/json'
      data: JSON.stringify
        name: name
      dataType: 'JSON'
      success: (data) ->
        metadata = data
        promise.resolve()
      error: (jqXHR, textStatus, errorThrown) ->
        promise.reject('Unable to rename file:' + errorThrown)

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
