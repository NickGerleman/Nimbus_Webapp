window.nimbus_app.ui = (socket_uri) ->
  container = $('<tbody id="files-body">')
  table = $('<table id="files-table">')
  outer_row = $('<div class="row">')
  show_spinner()

  window.nimbus = nimbus_app.core(socket_uri, refresh);
  init_done = $.Deferred();
  init_done.fail (error) ->
    stop_spinner()
    alert(error? ? error : 'Something went wrong')
  init_done.done ->
    files = nimbus.current_directory().files();
    folders = nimbus.current_directory().subdirectories()
    for f in folders
      container.append(createRow(f))
    for f in files
      container.append(createRow(f))
    stop_spinner()
    table.append(container)
    outer_row.append(table)
    $('#content').append(outer_row)
  nimbus.initialize(init_done)

  refresh = ->
    #refresh here
    console.log("should refresh")

  createRow = (file) ->
    row = $("<tr>");
    row.append("<td>")
    if(file.hasOwnProperty("download_url"))
      row.append("<td><a href='" + file.download_url() + "'>" + file.name() + "</a></td>")
    else if(file.hasOwnProperty("view_url"))
      row.append("<td><a href='" + file.view_url() + "'>" + file.name() + "</a></td>")
    else
      row.append("<td>"+ file.name() + "</td>")
    if(file.hasOwnProperty("extension"))
      row.append("<td>"+ file.extension() + "</td>")
    else
      row.append("<td> folder </td>")
    return row