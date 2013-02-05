$info      = $('#w')
wrapper    = ''
lastRecord = null
threshold  = 300
html       = true



$ ->
  $loading  = $('#loading')
  $document = $('#document')
  $content  = $('#document-content')

  lastSavedData = null

  autoSave = ->
    data = $document.serialize()
    if data != lastSavedData
      $.ajax
        data: data
        url:  $document.attr('action')
        type: 'PUT'
        dataType: 'script'

    lastSavedData = data

  setInterval autoSave, 5000

  $document.on 'submit', (e) ->
    e.preventDefault()
    autoSave()

  # TODO: delegate!
  $document.find('input').on 'blur', autoSave

  $document.find('.shared').on 'click', ->
    checked = $(@).find('input').is(':checked')
    $(@).toggleClass('selected', checked)
    autoSave()

  $(document)
    .on 'ajaxStart', ->
      # TODO: hide timeout
      $loading.addClass 'visible'
    .on 'ajaxComplete', ->
      # TODO: "global" timeout var
      c = ->
        $loading.removeClass 'visible'
      setTimeout c, 300

  content = $content.val()


  $(window).keyup (e) ->
    # ESC
    if e.which == 27

      $content.on 'mouseup.wrappr', wrap
      $content.off 'keydown.wrappr'
      $content.addClass 'wrapping'
      $(window).on 'keypress.wrappr', recordWrapper
      # mousedown in $content bind mouseup in whole document to wrap

    # i/I
    else if e.which == 73 or e.which == 105
      $content.off 'mouseup.wrappr'
      $content.on 'keydown.wrappr', tab
      $(window).off 'keypress.wrappr'

  # add undo listener

  tab = (e) ->
    if e.keyCode == 9
      selection = $content.getSelection()
      value = $content.val()
      before = value.substring(0, selection.start)
      after = value.substring(selection.start, value.length)
      console.log "'#{before}\t#{after}'"
      $content.val "#{before}\t#{after}"

      $content.setSelection selection.start + 1, selection.start + 1
      e.preventDefault()

  #$content.val $.trim($content.val())
  $content.on 'keydown.wrappr', tab

  recordWrapper = (e) ->
    charCode = if typeof e.which == 'number' then e.which else e.keyCode
    char     = String.fromCharCode(charCode) if charCode?

    if char then e.preventDefault()

    unless e.which == 13
      now = (new Date).getTime()
      if lastRecord? and now - lastRecord < threshold
        wrapper += char if char?
      else
        wrapper = if char? then char else ''
      lastRecord = now
      console.log "#{start()}...#{end()}"

    #$info.text "#{start()}...#{end()}"

  start = ->
    if html then "<#{wrapper}>" else wrapper

  end = ->
    if html then "</#{wrapper}>" else wrapper

  wrap = =>
    if $content.getSelection().length > 0
      # add to undo buffer
      $content.surroundSelectedText start(), end()

