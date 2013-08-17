'use strict'

# Construct a dropbox file from a connection it belongs to and API metadata
window.nimbus_app.dropbox_file = (connection, metadata) ->
  that = nimbus_app.file()
  size = parseFloat(metadata.size)
  full_name = metadata.path.slice(metadata.path.lastIndexOf('/') + 1)
  time = Date.parse(metadata.modified)

  # Get the download URL for the file
  download_url = ->
    encodeURI 'https://api-content.dropbox.com/1/files/dropbox' + metadata.path + '?access_token=' +
      connection.access_token()

  # Delete the file
  destroy = (promise) ->
    $.post 'https://api.dropbox.com/1/fileops/delete',
      root: 'dropbox', path: path, access_token: connection.access_token(),
      -> promise.resolve()

  # The connection the file belongs to
  that.connection = -> connection
  # The name with extension of the file
  that.full_name = -> full_name
  # The mime type of the file
  that.mime_type = -> metadata.mime_type
  # The size in KB of the file
  that.size = -> size
  # The date modified of the file
  that.time = -> time
  that.destroy = destroy
  that.download_url = download_url
  that
