window.nimbus_app.file = ->
  memo_extension = null
  memo_name = null


  extension = ->
    memo_extension or do ->
      seperator = that.full_name().lastIndexOf('.') + 1
      if seperator == 0
        memo_extension = ''
      else
        memo_extension = that.full_name().slice(seperator)

  name = -> memo_name or memo_name = do ->
    if extension()
      that.full_name().slice(0, -(that.extension().length + 1))
    else
      that.full_name()

  that =
    extension: extension
    name: name
