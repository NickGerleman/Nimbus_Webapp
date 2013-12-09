'use strict'

# Construct a box file from a connection it belongs to and API metadata
window.NimbusApp.BoxFile = (connection, metadata) ->
  that = NimbusApp.File()
  size = metadata.size
  time = Date.parse(metadata.modified_at)

  # Get the download URL for the file
  download_url = -> 'https://api.box.com/2.0/files/' + metadata.id + '/content' +
    '?access_token=' + connection.access_token()

  # Delete the file
  destroy = (promise) ->
    $.ajax
      type: 'DELETE'
      url: 'https://api.box.com/2.0/files/' + metadata.id + '?access_token=' + connection.access_token()
      dataType: 'JSON'
      success: -> promise.resolve()
      error: (jqXHR, textStatus, errorThrown) ->
        promise.reject('Unable to delete file:' + errorThrown)

  # Rename the file
  rename = (name, promise) ->
    $.ajax
      type: 'PUT'
      url: 'https://api.box.com/2.0/files/' + metadata.id
      data:
        access_token: connection.access_token()
        name: name
      dataType: 'JSON'
      succes: (data) ->
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
