window.nimbus_app.directory = ->

  path = =>
    @memo_path or =>
      paths = ['/']
      current_directory = this
      while current_directory isnt null
        paths.unshift(current_directory.name)
        current_directory = current_directory.parent
      paths.map (path) -> '/' + path
      @memo_path = paths.join('')

  path: path
