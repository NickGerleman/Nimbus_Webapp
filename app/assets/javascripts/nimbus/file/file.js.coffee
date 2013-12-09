'use strict'

# The equivalent of a file superclass
window.NimbusApp.File = ->

  # The extension of the file
  extension = ->
    seperator = that.full_name().lastIndexOf('.') + 1
    if seperator == 0 then '' else that.full_name().slice(seperator)

  # The name of the file without the extension
  name = ->
    if extension()
      that.full_name().slice(0, -(that.extension().length + 1))
    else
      that.full_name()

  that =
    # Whether this is a file
    is_file: -> true
    extension: extension
    name: name
