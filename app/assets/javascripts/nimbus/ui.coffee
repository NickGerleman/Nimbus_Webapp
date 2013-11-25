# runs the ui for the client
window.nimbus_app.ui = (socket_uri) ->
  show_spinner()
  iframe = $("<iframe style='display: none' id='hidden-iframe'></iframe>")
  $('body').append(iframe)
  extensions = ["3gp", "divx", "jar", "pdf", "ss", "7z", "dll", "jpeg", "png", "swf", "ace", "dmg", "jpg", "pps", "tgz",
                "aiff", "doc", "lnk", "psd", "thm", "aif", "dss", "log", "ps", "tif", "ai", "dvf", "m4a", "pst", "tmp",
                "amr", "dwg", "m4b", "ptb", "torrent", "asf", "eml", "m4p", "pub", "ttf", "asx", "eps", "m4v", "qbb",
                "txt", "bat", "exe", "mcd", "qbw", "vcd", "bin", "fla", "mdb", "qxd", "vob", "bmp", "flv", "mid", "ram",
                "wav", "bup", "gif", "mov", "rar", "wma", "cab", "gz", "mp2", "rm", "wmv", "cbr", "hqx", "mp4", "rmvb",
                "wps", "cda", "html", "mpeg", "rtf", "xls", "cdl", "htm", "mpg", "sea", "xpi", "cdr", "ifo", "msi",
                "ses", "zip", "chm", "indd", "mswmm", "sit", "dat", "iso", "ogg", "sitx", "folder"]

  window.nimbus = nimbus_app.core(socket_uri, refresh);
  init_done = $.Deferred();
  init_done.fail (error) ->
    stop_spinner()
    alert(error || 'Something went wrong')
  init_done.done ->
    stop_spinner()
    refresh()
  nimbus.initialize(init_done)

  #refresh callback
  refresh = ->
    container = $('<tbody id="files-body">')
    table = $('<table id="files-table">')
    div = $('<div id="files-table-div">')
    outer_row = $('<div class="row">')
    breadcrumbs = '<nav class="breadcrumbs"><a href="#">Root</a></nav>'
    files = nimbus.current_directory().files();
    folders = nimbus.current_directory().subdirectories()
    for f, i in folders
      container.append(createRow(f, i))
    for f, i in files
      container.append(createRow(f, i))
    div.append(breadcrumbs)
    table.append(container)
    div.append(table)
    outer_row.append(div)
    $('#content').html(outer_row)

  #creates a row for a file or folder
  createRow = (file, i) ->
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
      row.append("<td>" + file.name() + "</td>")
    return row