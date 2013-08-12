window.nimbus_app.file = ->
  extension: ->
    seperator = this.full_name.lastIndexOf('.') + 1
    this.full_name._slice(seperator)
  name : -> this.full_name.slice(0, -(this.extension().length + 1))