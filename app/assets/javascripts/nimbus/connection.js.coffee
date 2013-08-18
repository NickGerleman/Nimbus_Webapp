'use strict'

# Constructs and returns a connection object from the API representation of a connection
window.nimbus_app.connection = (connection) ->

  # Creates a root directory of the type of the connection
  create_root_directory = (promise) ->
    switch connection.type
      when 'box'
        $.ajax
          type: 'GET'
          url: 'https://api.box.com/2.0/folders/0'
          headers: Authorization: 'Bearer ' + connection.access_token
          dataType: 'JSON'
          success: (data) ->
            directory = nimbus_app.box_directory(to_return, data)
            promise.resolve(directory)
      when 'dropbox'
        $.ajax
          type: 'GET'
          url: 'https://api.dropbox.com/1/metadata/dropbox/'
          headers: Authorization: 'Bearer ' + connection.access_token
          dataType: 'JSON'
          success: (data) ->
            directory = nimbus_app.dropbox_directory(to_return, data)
            promise.resolve(directory)
      when 'google'
        $.ajax
          type: 'GET'
          url: 'https://www.googleapis.com/drive/v2/files/root'
          headers: Authorization: 'Bearer ' + connection.access_token
          dataType: 'JSON'
          success: (data) ->
            directory = nimbus_app.google_directory(to_return, data)
            promise.resolve(directory)
      when 'skydrive'
        $.ajax
          type: 'GET'
          url: 'https://apis.live.net/v5.0/me/skydrive/files'
          headers: Authorization: 'Bearer ' + connection.access_token
          dataType: 'JSON'
          success: (data) ->
            directory = nimbus_app.skydrive_directory(to_return, data)
            promise.resolve(directory)
      else console.log 'Unknown Service'

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