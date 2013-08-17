'use strict'

# Construct a box file from a connection it belongs to and API metadata
window.nimbus_app.box_file = (connection, metadata) ->
  that = nimbus_app.file()
  size = metadata.size / 1024
  time = Date.parse(metadata.modified_at)

  # Get the download URL for the file
  download_url = -> 'https://api.box.com/2.0/files/' + metadata.id + '/content' +
    '?access_token=' + connection.access_token()

  # Delete the file
  destroy = (promise) ->
    $.delete 'https://api.box.com/2.0/files/',
      access_token: connection.access_token(),
      -> promise.resolve()


  # The connection the file belongs to
  that.connection = -> connection
  # The name with extension of the file
  that.full_name = -> metadata.name
  # The size in KB of the file
  that.size = -> size
  # The date modified of the file
  that.time = -> time
  that.destroy = destroy
  that.download_url = download_url
  that
