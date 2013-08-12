window.nimbus_app.dropbox_directory = (opts) ->
  that = nimbus_app.directory(opts.id)
  isEnumerated = false

  enumerate = (promise) ->
    #do stuff
    isEnumerated = true

  upload_url = ->

  name =

  that.parent = opts.parent
  that.enumerate = enumerate
  that.upload_url = upload_url
  that.name = name
  that.isEnumerated = -> isEnumerated
  that