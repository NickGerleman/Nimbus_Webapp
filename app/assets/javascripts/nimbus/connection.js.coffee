# Object representing a connection
#
# @param connection the raw connection object returned by the API
window.nimbus_app.connection = (connection) ->

  create_root_directory = (promise) ->
    switch connection.type
      when 'box'
        $.ajax
          url: 'https://api.box.com/2.0/folders/0'
          data:
            access_token: connection.access_token
          dataType: 'jsonp'
          success: (data) ->
            directory = nimbus_app.box_directory(to_return, data)
            promise.resolve(directory)
      when 'dropbox'
        $.getJSON 'https://api.dropbox.com/1/metadata/dropbox/',
          access_token: connection.access_token,
          (data) ->
            directory = nimbus_app.dropbox_directory(to_return, data)
            promise.resolve(directory)
      when 'google'
        $.getJSON 'https://www.googleapis.com/drive/v2/files/root',
          access_token: connection.access_token,
          (data) ->
            directory = nimbus_app.google_directory(to_return, data)
            promise.resolve(directory)
      when 'skydrive'
        $.getJSON 'https://apis.live.net/v5.0/me/skydrive',
          access_token: connection.access_token,
          (data) ->
            directory = nimbus_app.skydrive_directory(to_return, data)
            promise.resolve(directory)
      else console.log 'Unknown Service'

  update = (new_connection) -> connection = new_connection

  to_return =
    access_token: -> connection.access_token
    name: -> connection.name
    type: -> connection.type
    create_root_directory: create_root_directory
    update: update