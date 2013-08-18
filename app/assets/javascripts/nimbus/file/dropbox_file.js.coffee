'use strict'

# Construct a dropbox file from a connection it belongs to and API metadata
window.nimbus_app.dropbox_file = (connection, metadata) ->
  that = nimbus_app.file()
  size = parseFloat(metadata.size)
  time = Date.parse(metadata.modified)

  # Get the download URL for the file
  download_url = ->
    encodeURI 'https://api-content.dropbox.com/1/files/dropbox' + metadata.path + '?access_token=' +
      connection.access_token()

  # Delete the file
  destroy = (promise) ->
    $.ajax
      type: 'POST'
      url: 'https://api.dropbox.com/1/fileops/delete'
      data:
        root: 'dropbox'
        path: metadata.path
        access_token: connection.access_token()
      dataType: 'JSON'
      success: ->
        promise.resolve()

  # The name with extension of the file
  full_name = -> metadata.path.slice(metadata.path.lastIndexOf('/') + 1)

  # Rename the file
  rename = (name, promise) ->
    $.ajax
      type: 'POST'
      url: 'https://api.dropbox.com/1/fileops/move'
      data:
        root: 'dropbox'
        from_path: metadata.path
        to_path: metadata.path.replace(full_name(), name)
        access_token: connection.access_token()
      dataType: 'JSON'
      success: (data) ->
        metadata = data
        promise.resolve()


  # The connection the file belongs to
  that.connection = -> connection
  # The mime type of the file
  that.mime_type = -> metadata.mime_type
  # The size in KB of the file
  that.size = -> size
  # The date modified of the file
  that.time = -> time
  that.destroy = destroy
  that.download_url = download_url
  that.full_name = full_name
  that.rename = rename
  that
