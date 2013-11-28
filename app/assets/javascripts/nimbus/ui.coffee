# runs the ui for the client
window.nimbus_app.ui = (socket_uri) ->
  show_spinner()
  extensions_map =
    txt: 'text'
    epub: 'application-epub+zip'
    zip: 'application-epub+zip'
    rar: 'application-epub+zip'
    '7z': 'application-epub+zip'
    cab: 'application-epub+zip'
    ai: 'application-illustrator'
    doc: 'application-msword'
    docx: 'application-msword'
    rtf: 'office-document'
    accdb: 'application-vnd.ms-access'
    mdb: 'application-vnd.ms-access'
    xls: 'application-vnd.ms-excel'
    xlsx: 'application-vnd.ms-excel'
    ppt: 'application-vnd.ms-powerpoint'
    pptx: 'application-vnd.ms-powerpoint'
    odt: 'office-document'
    odf: 'office-document'
    card: 'office-contact'
    torrent: 'application-x-bittorrent'
    iso: 'application-x-cd-image'
    nrg: 'application-x-cd-image'
    mdf: 'application-x-cd-image'
    flv: 'application-x-flash-video'
    fla: 'application-x-flash-video'
    swf: 'application-x-flash-video'
    exe: 'application-x-ms-dos-executable'
    msi: 'application-x-ms-dos-executable'
    mp3: 'audio-x-generic'
    aac: 'audio-x-generic'
    m4a: 'audio-x-generic'
    ogg: 'audio-x-generic'
    flac: 'audio-x-generic'
    opus: 'audio-x-generic'
    wma: 'audio-x-generic'
    ape: 'audio-x-generic'
    png: 'image-x-generic'
    bmp: 'image-x-generic'
    jpg: 'image-x-generic'
    jpeg: 'image-x-generic'
    gif: 'image-x-generic'
    webp: 'image-x-generic'
    m3u: 'playlist'
    cue: 'playlist'
    htm: 'text-html'
    html: 'text-html'
    xhtml: 'text-html'
    mhtm: 'text-html'
    dmg: 'text-x-install'
    rpm: 'text-x-install'
    deb: 'text-x-install'
    nfo: 'text-x-readme'
    odg: 'x-office-drawing'
    otg: 'x-office-drawing'
    svg: 'x-office-drawing'
    odp: 'x-office-presentation'
    ods: 'x-office-spreadsheet'
    ots: 'x-office-spreadsheet'
    csv: 'x-office-spreadsheet'
    tsv: 'x-office-spreadsheet'
    ini: 'application-x-desktop'
    xml: 'application-x-desktop'
    conf: 'application-x-desktop'
    cnf: 'application-x-desktop'
    js: 'application-x-executable'
    coffee: 'application-x-executable'
    c: 'application-x-executable'
    cpp: 'application-x-executable'
    rb: 'application-x-executable'
    java: 'application-x-executable'
    jar: 'application-x-executable'
    scala: 'application-x-executable'
    py: 'application-x-executable'
    pyc: 'application-x-executable'
    sh: 'application-x-executable'
    pl: 'application-x-executable'


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
    row = $("<tr oncontextmenu='return false;'></tr>")
    row.mousedown (event) ->
      if event.button == 2
        x = event.clientX
        y = event.clientY
        alert "X: " + x + " Y: " + y
    row.append icon_column(file)
    row.append name_column(file)
    row.append date_column(file)
    row.append size_column(file)
    row.append delete_button(file)
    return row

  # Creates a column for modified date
  date_column = (file) ->
    if file.is_file()
      date = new Date(file.time())
      hours = date.getHours()
      suffix = if hours < 12 then 'AM' else 'PM'
      hours %= 12
      hours = 12 if hours == 0
      minutes = date.getMinutes()
      minutes++ if date.getSeconds() > 30
      minute_string = if minutes < 10 then '0' + minutes else minutes + ''
      timeString = "<span class='time'>" + hours + ':' + minute_string + suffix + "</span>"
      $("<td class='date-column'>" + timeString + " " + date.toLocaleDateString() + "</td>")
    else
      $("<td class='date-column'>--</td> ")

  # Creates column for delete button
  delete_button = (file) ->
    button = $("<td class='menu-button'><a><img alt='delete' width='12' height='24' src='/icons/menu.svg'></a></td>")
#    delete_promise = $.Deferred()
#    delete_promise.done ->
#      update_promise = $.Deferred()
#      update_promise.done ->
#        refresh()
#      update_promise.fail (error) ->
#        alert(error)
#        refresh()
#      nimbus.current_directory().update(update_promise)
#    delete_promise.fail (error) ->
#      alert(error)
#    button.click ->
#      show_spinner()
#      file.destroy(delete_promise)
    return button

  # Creates column for a file link
  file_column = (file) ->
    data = $("<td class='filename'></td>")
    is_image = false
    if ["png", "gif", "jpg", "jpeg", "bmp"].indexOf(file.extension().toLowerCase()) != -1
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
      data.html(link)
    else if(file.hasOwnProperty("view_url"))
      data.html $('<a href="' + file.view_url() + '">' + file.full_name() + '</a>')
    return data

  # Creates column for a folder link
  folder_column = (file) ->
    link = $("<a>" + file.name() + "</a>")
    folder = $("<td class='filename'></td>")
    promise = $.Deferred()
    promise.done ->
      refresh()
    promise.fail (error) ->
      alert(error)
    link.click ->
      nimbus.change_directory(file, promise)
      show_spinner()
    folder.html(link)
    return folder

  # Create column for icon
  icon_column = (file) ->
    is_file = file.is_file()
    if is_file and extensions_map.hasOwnProperty(file.extension().toLowerCase())
      $("<td class='icon'><img width='32' alt='icon' src='/icons/" + extensions_map[file.extension().toLowerCase()] + ".svg' ></td>")
    else if is_file
      $("<td class='icon'><img height='32' width='32' alt='icon' src='/icons/blank.svg' ></td>")
    else
      $("<td class='icon'><img height='32' width='32' alt='icon' src='/icons/folder.svg' ></td>")

  # Create column for file/folder name/link
  name_column = (file) ->
    if file.is_file()
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
    if file.is_file() and !isNaN(file.size())
      $("<td class='size-column'>" + sizeString(file.size()) + "</td>")
    else
      $("<td class='size-column'>--</td>")