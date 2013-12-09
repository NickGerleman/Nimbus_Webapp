'use strict'

# Constructs and returns a connection object from the API representation of a connection
window.NimbusApp.Connection = (connection) ->

  # Creates a root directory of the type of the connection
  create_root_directory = (promise) ->
    switch connection.type
      when 'box'
        $.ajax
          url: 'https://api.box.com/2.0/folders/0'
          data: access_token: connection.access_token
          dataType: 'JSON'
          success: (data) ->
            directory = NimbusApp.BoxDirectory(to_return, data)
            promise.resolve(directory)
          error: -> promise.reject('Unable to retrieve Data from Box API for ' + connection.name)
      when 'dropbox'
        $.ajax
          url: 'https://api.dropbox.com/1/metadata/dropbox/'
          data: access_token: connection.access_token
          dataType: 'JSON'
          success: (data) ->
            directory = NimbusApp.DropboxDirectory(to_return, data)
            promise.resolve(directory)
          error: -> promise.reject('Unable to retrieve Data from Dropbox API for ' + connection.name)
      when 'google'
        $.ajax
          url: 'https://www.googleapis.com/drive/v2/files/root'
          data: access_token: connection.access_token
          dataType: 'JSON'
          success: (data) ->
            directory = NimbusApp.GoogleDirectory(to_return, data)
            promise.resolve(directory)
          error: -> promise.reject('Unable to retrieve Data from Google Drive API for ' + connection.name)
      when 'skydrive'
        $.ajax
          url: 'https://apis.live.net/v5.0/me/skydrive/files'
          data: access_token: connection.access_token
          dataType: 'JSON'
          success: (data) ->
            directory = NimbusApp.SkydriceDirectory(to_return, data)
            promise.resolve(directory)
          error: -> promise.reject('Unable to retrieve Data from SkyDrive API for ' + connection.name)
      else
        console.log 'Unknown Service'
        promise.reject()

  # Updates a connection with new information (eg title or access_token)
  update = (new_connection) -> connection = new_connection

  to_return =
    # The OAuth access_token
    access_token: -> connection.access_token
    # The name of the conenction
    name: -> connection.name
    # The service the connection uses
    type: -> connection.type
    create_root_directory: create_root_directory
    update: update