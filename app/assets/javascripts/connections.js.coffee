window.get_connections = (promise) ->
  connection_compare = (a, b) ->
    -1 if a.name < b.name
    0 if a.name == b.name
    1 if a.name > b.name
  $.ajax
    url: '/api/user/connections'
    dataType: 'JSON'
    success: (data) ->
      data.sort(connection_compare)
      promise.resolve(data)
    error: -> promise.reject('Unable to get connections from Nimbus API')

window.render_connection = (connection) ->
  connection_box = $('<div class="connection"></div>')
  header = $('<div class="connection-name">' + connection.name + '</div>')
  links = $('<small></small>')
  switch connection.state
    when 'in_progress'
      links.html('Connecting Your Account, Please Wait...')
    when 'error'
      links.html('Error <a data-method="post" href="/user/connections?id=' + connection.id + '&service='+ connection.type + '" rel="nofollow">Try Again?</a> -
        <a class="spinner-link" data-method="delete" href="/connections/' + connection.id + '" rel="nofollow">Delete</a>')
    when 'expired'
      links.html('Your Token Has Expired <a data-method="post" href="/user/connections?id=' + connection.id + '&service='+ connection.type + '" rel="nofollow">Reconnect</a> -
        <a class="spinner-link" data-method="delete" href="/connections/' + connection.id + '" rel="nofollow">Delete</a>')
    when 'success'
      rename = $('<a href="/connections/' + connection.id + '/edit">Rename</a>')
      rename.magnificPopup({
        mainClass: 'modal',
        type: 'ajax',
        preloader: false,
        removalDelay: 200,
        closeBtnInside: true
      })
      links.html(rename)
      links.append(' -
      <a class="spinner-link" data-method="delete" href="/connections/' + connection.id + '" rel="nofollow">Delete</a>')
  connection_box.append(header)
  connection_box.append(links)
  return connection_box