# runs the ui for the client
window.nimbus_app.ui = (socket_uri) ->
  show_spinner()
  sidebar = $('#app-side')
  extensions_map =
    txt: 'text', epub: 'application-book', mobi: 'application-book', azw: 'application-book',
    zip: 'package-x-generic', rar: 'package-x-generic', '7z': 'package-x-generic', cab: 'package-x-generic',
    gz: 'package-x-generic', bz2: 'package-x-generic', tar: 'package-x-generic', ai: 'application-illustrator',
    doc: 'application-msword', docx: 'application-msword', rtf: 'office-document', accdb: 'application-vnd.ms-access',
    mdb: 'application-vnd.ms-access', xls: 'application-vnd.ms-excel', xlsx: 'application-vnd.ms-excel',
    ppt: 'application-vnd.ms-powerpoint', pptx: 'application-vnd.ms-powerpoint', odt: 'office-document',
    odf: 'office-document', card: 'office-contact', torrent: 'application-x-bittorrent',
    iso: 'application-x-cd-image', nrg: 'application-x-cd-image', mdf: 'application-x-cd-image',
    flv: 'application-x-flash-video', fla: 'application-x-flash-video', swf: 'application-x-flash-video',
    exe: 'application-x-ms-dos-executable', msi: 'application-x-ms-dos-executable', mp3: 'audio-x-generic',
    aac: 'audio-x-generic', m4a: 'audio-x-generic', ogg: 'audio-x-generic', flac: 'audio-x-generic',
    wav: 'audio-x-generic', opus: 'audio-x-generic', wma: 'audio-x-generic', ape: 'audio-x-generic',
    png: 'image-x-generic', bmp: 'image-x-generic', jpg: 'image-x-generic', jpeg: 'image-x-generic',
    gif: 'image-x-generic', tif: 'image-x-generic', tiff: 'image-x-generic', webp: 'image-x-generic',
    targa: 'image-x-generic', raw: 'image-x-generic', exr: 'image-x-generic', tga: 'image-x-generic',
    hdr: 'image-x-generic', m3u: 'playlist', cue: 'playlist', htm: 'text-html', html: 'text-html', xhtml: 'text-html',
    mhtm: 'text-html', dmg: 'text-x-install', rpm: 'text-x-install', deb: 'text-x-install', nfo: 'text-x-readme',
    odg: 'x-office-drawing', otg: 'x-office-drawing', svg: 'x-office-drawing', odp: 'x-office-presentation',
    ods: 'x-office-spreadsheet', ots: 'x-office-spreadsheet', csv: 'x-office-spreadsheet', tsv: 'x-office-spreadsheet',
    ini: 'application-x-desktop', xml: 'application-x-desktop', conf: 'application-x-desktop',
    cnf: 'application-x-desktop', js: 'text-x-script', coffee: 'text-x-script', c: 'text-x-script',
    cpp: 'text-x-script', cs: 'text-x-script', rb: 'text-x-script', java: 'text-x-script', jar: 'text-x-java',
    class: 'application-x-executable', scala: 'text-x-script', py: 'text-x-script', pyc: 'application-x-executable',
    css: 'text-x-script', sh: 'text-x-script', pl: 'text-x-script', ott: 'x-office-document-template',
    pdf: 'application-pdf', mp4: 'video-x-generic', m4v: 'video-x-generic', avi: 'video-x-generic',
    wmv: 'video-x-generic', mkv: 'video-x-generic', vob: 'video-x-generic', webm: 'video-x-generic'

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
    container = $('<tbody id="files-body">')
    table = $('<table id="files-table">')
    div = $('<div id="files-table-div">')
    scroll = $('<div id="files-scroll"></div>')
    scroll.height($(window).height() - 130)
    sidebar.height($(window).height() - 133)
    breadcrumbs = create_breadcrumbs(nimbus.current_directory())
    files = nimbus.current_directory().files();
    folders = nimbus.current_directory().subdirectories()
    for f in folders
      container.append(create_row(f))
    for f in files
      container.append(create_row(f))
    div.append(breadcrumbs)
    table.append(container)
    scroll.append(table)
    div.append(scroll)
    $('#app-container').html(div)
    stop_spinner()

  # Creates a context menu around the mouse
  context_menu = (mouseDown, file) ->
    menu = menu_contents(file)
    x = mouseDown.clientX
    y = mouseDown.clientY
    # Change corner at edges
    width = menu.width()
    height = menu.height()
    hor_margin = $(window).width() - (width + x)
    vert_margin = $(window).height() - (height + y)
    x -= width if hor_margin < 20
    y -= height if vert_margin < 20
    menu.css(left: x, top: y)
    $('body').append(menu)
    # Handle exiting menu
    $('body').mousedown (event) ->
      click_x = event.clientX
      click_y = event.clientY
      outside_x = click_x < x or click_x > x + width
      outside_y = click_y < y or click_y > y + height
      if outside_x or outside_y
        menu.remove()
        $('body').off('mouseDown', this)

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
        promise.done ->
          refresh()
        promise.fail (error) ->
          alert(error)
        dir = metaDirectory.valueOf()
        crumb.click ->
          nimbus.change_directory(dir, promise)
      breadcrumbs.prepend(crumb)
      metaDirectory = metaDirectory.parent()
    return breadcrumbs

  # Creates a row for a file or folder
  create_row = (file) ->
    row = $("<tr oncontextmenu='return false;'></tr>")
    row.mousedown (event) ->
      context_menu(event, file) if event.button == 2
    row.append icon_column(file)
    row.append name_column(file)
    row.append date_column(file)
    row.append size_column(file)
    row.append menu_button(file)
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
      show_spinner() unless file.is_enumerated()
    folder.html(link)
    return folder

  # Create column for icon
  icon_column = (file) ->
    is_file = file.is_file()
    if is_file and extensions_map.hasOwnProperty(file.extension().toLowerCase())
      $("<td class='icon'><img height='32' width='32' alt='icon' src='/icons/" +
        extensions_map[file.extension().toLowerCase()] + ".svg' ></td>")
    else if is_file
      $("<td class='icon'><img height='32' width='32' alt='icon' src='/icons/blank.svg' ></td>")
    else
      $("<td class='icon'><img height='32' width='32' alt='icon' src='/icons/folder.svg' ></td>")

  # Creates column for menu button
  menu_button = (file) ->
    button = $('<td class="menu-button"><a><svg xmlns="http://www.w3.org/2000/svg" height="24" width="12">' +
      '<g class="menu-svg"><rect height="4" width="4" y="2" x="5"/><rect height="4" width="4" y="10" x="5"/>'+
      '<rect height="4" width="4" y="18" x="5"/></g></svg></a></td>')
    button.mousedown (event) ->
      context_menu(event, file)
    return button

  # Creates the contents of a context menu
  menu_contents = (file) ->
    $('<div class="context-menu">' + file.name() + '</div>')

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

#Adjust scroll area
window.nimbus_app.ui.adjust_files_scroll = ->
  $('#files-scroll').height($(window).height() - 130)
  $('#app-side').height($(window).height() - 133)
