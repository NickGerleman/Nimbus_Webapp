# runs the ui for the client
window.nimbus_app.ui = (socket_uri) ->
  show_spinner()
  iframe = $("<iframe style='display: none' id='hidden-iframe'></iframe>")
  $('body').append(iframe)
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
    breadcrumbs = createBreadcrumbs(nimbus.current_directory())
    files = nimbus.current_directory().files();
    folders = nimbus.current_directory().subdirectories()
    for f in folders
      container.append(createRow(f))
    for f in files
      container.append(createRow(f))
    div.append(breadcrumbs)
    table.append(container)
    div.append(table)
    outer_row.append(div)
    $('#content').html(outer_row)

  #Creates the breadcrumbs
  createBreadcrumbs = (metaDirectory) ->
    breadcrumbs = $('<nav class="breadcrumbs"></nav>')
    while(metaDirectory != null)
      crumb = null
      if(metaDirectory.parent() == null )
        crumb = $('<a href="javascript:void(0)">Root</a>')
      else
        crumb = $('<a href="javascript:void(0)">' + metaDirectory.name() + '</a>')
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

  #creates a row for a file or folder
  createRow = (file) ->
    isImage = false
    row = $("<tr>");
    if(!file.hasOwnProperty("extension"))
      row.append("<td class='icon'><img height='16' width='16' alt='icon' src='/icons/folder.png' ></td>")
    else if(extensions.indexOf(file.extension().toLowerCase()) != -1)
      row.append("<td class='icon'><img height='16' width='16' alt='icon' src='/icons/" + file.extension().toLowerCase() + ".png' ></td>")
      if(["png", "gif", "jpg", "bmp"].indexOf(file.extension().toLowerCase()) != -1)
        isImage = true
    else
      row.append("<td class='icon'><img height='16' width='16' alt='icon' src='/icons/unknown.png' ></td>")
    if(file.hasOwnProperty("download_url"))
      link = $("<a href='" + file.download_url() + "'>" + file.full_name() + "</a>")
      if(isImage)
        link.magnificPopup(
          mainClass: 'modal',
          type: 'image',
          preloader: true,
          removalDelay: 200,
          closeBtnInside: false
        )
      data = $("<td class='filename'></td>")
      data.html(link)
      row.append(data)
    else if(file.hasOwnProperty("view_url"))
      row.append("<td class='filename'><a href='" + file.view_url() + "'>" + file.full_name() + "</a></td>")
    else
      folder = $("<td class='filename'><a href='javascript:void(0)'</a>" + file.name() + "</td>")
      # Change Directory
      promise = $.Deferred()
      promise.done -> refresh()
      promise.fail (error) -> alert(error)
      folder.click ->
        nimbus.change_directory(file, promise)
        show_spinner()
      row.append(folder)
    # Delete the file
    delete_button = $("<td class='delete-button'><a href='javascript:void(0)'><img alt='delete' width='16' src='/icons/delete.png'></a></td>")
    delete_promise = $.Deferred()
    delete_promise.done ->
      update_promise = $.Deferred()
      update_promise.done -> refresh()
      update_promise.fail (error) ->
        alert(error)
        refresh()
      nimbus.current_directory().update(update_promise)
    delete_promise.fail (error) -> alert(error)
    delete_button.click ->
      show_spinner()
      file.destroy(delete_promise)
    row.append(delete_button)
    return row