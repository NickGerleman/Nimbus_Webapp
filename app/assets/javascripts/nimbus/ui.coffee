# runs the ui for the client
window.nimbus_app.ui = (socket_uri) ->
  show_spinner()
  extensions = ["3gp", "divx", "jar", "pdf", "ss", "7z", "dll", "jpeg", "png", "swf", "ace", "dmg", "jpg", "ppt", "tgz",
                "aiff", "doc", "lnk", "psd", "thm", "aif", "dss", "log", "ps", "tif", "ai", "dvf", "m4a", "pst", "tmp",
                "amr", "dwg", "m4b", "ptb", "torrent", "asf", "eml", "m4p", "pub", "ttf", "asx", "eps", "m4v", "qbb",
                "txt", "bat", "exe", "mcd", "qbw", "vcd", "bin", "fla", "mdb", "qxd", "vob", "bmp", "flv", "mid", "ram",
                "wav", "bup", "gif", "mov", "rar", "wma", "cab", "gz", "mp2", "rm", "wmv", "cbr", "hqx", "mp4", "rmvb",
                "wps", "cda", "html", "mpeg", "rtf", "xls", "cdl", "htm", "mpg", "sea", "xpi", "cdr", "ifo", "msi",
                "ses", "zip", "chm", "indd", "mswmm", "sit", "dat", "iso", "ogg", "sitx", "folder", "flac", "docx",
                "pptx", "xlsx", "csv"]

  nimbus = nimbus_app.core(socket_uri, refresh);
  init_done = $.Deferred();
  init_done.fail (error) ->
    stop_spinner()
    alert(error || 'Something went wrong')
  init_done.done ->
    refresh()
  nimbus.initialize(init_done)

  #refresh callback
  refresh = ->
    stop_spinner()
    container = $('<tbody id="files-body">')
    table = $('<table id="files-table">')
    div = $('<div id="files-table-div">')
    outer_row = $('<div class="row">')
    breadcrumbs = create_breadcrumbs(nimbus.current_directory())
    files = nimbus.current_directory().files();
    folders = nimbus.current_directory().subdirectories()
    for f in folders
      container.append(create_row(f))
    for f in files
      container.append(create_row(f))
    div.append(breadcrumbs)
    table.append(container)
    div.append(table)
    outer_row.append(div)
    $('#content').html(outer_row)

  #Creates the breadcrumbs
  create_breadcrumbs = (metaDirectory) ->
    breadcrumbs = $('<nav class="breadcrumbs"></nav>')
    while(metaDirectory != null)
      crumb = null
      if(metaDirectory.parent() == null )
        crumb = $('<a>Root</a>')
      else
        crumb = $('<a>' + metaDirectory.name() + '</a>')
      # each iteration shares a common scope, we must make a new one
      do ->
        promise = $.Deferred()
        promise.done -> refresh()
        promise.fail (error) -> alert(error)
        dir = metaDirectory.valueOf()
        crumb.click -> nimbus.change_directory(dir, promise)
      breadcrumbs.prepend(crumb)
      metaDirectory = metaDirectory.parent()
    return breadcrumbs

  # Creates a row for a file or folder
  create_row = (file) ->
    row = $("<tr></tr>")
    row.append icon_column(file)
    row.append name_column(file)
    row.append size_column(file)
    row.append delete_button(file)
    return row

  # Creates column for delete button
  delete_button = (file) ->
    button = $("<td class='delete-button'><a><img alt='delete' width='16' src='/icons/delete.png'></a></td>")
    delete_promise = $.Deferred()
    delete_promise.done ->
      update_promise = $.Deferred()
      update_promise.done ->
        refresh()
      update_promise.fail (error) ->
        alert(error)
        refresh()
      nimbus.current_directory().update(update_promise)
    delete_promise.fail (error) ->
      alert(error)
    button.click ->
      show_spinner()
      file.destroy(delete_promise)
    return button

  # Creates column for a file link
  file_column = (file) ->
    is_image = false
    if ["png", "gif", "jpg", "bmp"].indexOf(file.extension().toLowerCase()) != -1
      is_image = true
    if(file.hasOwnProperty("download_url"))
      link = $('<a href="' + file.download_url() + '">' + file.full_name() + '</a>')
      if is_image
        link.magnificPopup
          mainClass: 'modal',
          type: 'image',
          preloader: true,
          removalDelay: 200,
          closeBtnInside: false
      data = $("<td class='filename'></td>")
      data.html(link)
      return data
    else if(file.hasOwnProperty("view_url"))
      return $('<td class="filename"><a href="' + file.view_url() + '">' + file.full_name() + '</a></td>')

  # Creates column for a folder link
  folder_column = (file) ->
    folder = $("<td class='filename'><a>" + file.name() + "</a></td>")
    promise = $.Deferred()
    promise.done ->
      refresh()
    promise.fail (error) ->
      alert(error)
    folder.click ->
      nimbus.change_directory(file, promise)
      show_spinner()
    return folder

  # Create column for icon
  icon_column = (file) ->
    is_file = file.hasOwnProperty("extension")
    if is_file and extensions.indexOf(file.extension().toLowerCase()) != -1
      $("<td class='icon'><img height='16' width='16' alt='icon' src='/icons/" + file.extension().toLowerCase() + ".png' ></td>")
    else if is_file
      $("<td class='icon'><img height='16' width='16' alt='icon' src='/icons/unknown.png' ></td>")
    else
      $("<td class='icon'><img height='16' width='16' alt='icon' src='/icons/folder.png' ></td>")

  # Create column for file/folder name/link
  name_column = (file) ->
    if file.hasOwnProperty("extension")
      file_column(file)
    else
      folder_column(file)

  # Create column for size
  size_column = (file) ->
    sizeString = (size) ->
      iter = 0
      suffixes = ['B', 'KB', 'MB', 'GB', 'TB']
      while(size > 1024)
        size /= 1024
        iter++
      return Math.round(size) + ' ' + suffixes[iter]
    if file.hasOwnProperty("extension") and !isNaN(file.size())
      $("<td>" + sizeString(file.size()) + "</td>")
    else
      $("<td></td>")