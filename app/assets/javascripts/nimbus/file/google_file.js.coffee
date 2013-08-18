'use strict'

# Construct a google file from a connection it belongs to and API metadata
window.nimbus_app.google_file = (connection, metadata) ->
  that = nimbus_app.file()
  size = metadata.fileSize / 1024
  time = Date.parse(metadata.modifiedDate)

  # Delete the file
  destroy = (promise) ->
    $.ajax
      type: 'DELETE'
      url: 'https://www.googleapis.com/drive/v2/files/' + metadata.id
      data: access_token: connection.access_token()
      dataType: 'JSON'
      success: -> promise.resolve()

  # Rename the file
  rename = (name, promise) ->
    $.ajax
      type: 'PATCH'
      url: 'https://www.googleapis.com/drive/v2/files/' + metadata.id + '?access_token=' +
        connection.access_token()
      contentType: 'application/json'
      data: JSON.stringify
        title: name
      dataType: 'JSON'
      success: (data) ->
        metadata = data
        promise.resolve()


  # The connection the file belongs to
  that.connection = -> connection
  # The download URL for the file
  that.download_url = -> metadata.downloadUrl.replace('&gd=true', '')
  # The name with extension of the file
  that.full_name = -> metadata.title
  # The id of the file
  that.id = -> metadata.id
  # The mime type of the file
  that.mime_type = -> metadata.mimeType
  # The size in KB of the file
  that.size = -> size
  # The date modified of the file
  that.time = -> time
  # The URL to view the file on Google Drive
  that.view_url = -> metadata.alternateLink
  that.destroy = destroy
  that.rename = rename
  that
