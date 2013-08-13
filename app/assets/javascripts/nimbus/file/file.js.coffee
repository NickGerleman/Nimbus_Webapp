window.nimbus_app.file = ->

  extension = do ->
    seperator = that.full_name.lastIndexOf('.') + 1
    that.full_name.slice(seperator)

  name = that.full_name.slice(0, -(that.extension().length + 1))

  that =
    extension: extension
    name: -> name
