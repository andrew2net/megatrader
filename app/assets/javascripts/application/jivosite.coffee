$(document).on "ready page:change", ->
  jivosite_id = $('#jivosite_id').text()
  if window.jivo_init
    window.jivo_init()
  widget_id = jivosite_id
  s = document.createElement 'script'
  s.type = 'text/javascript'
  s.async = true
  s.src = '//code.jivosite.com/script/widget/'+widget_id
  ss = document.getElementsByTagName('script')[0]
  ss.parentNode.insertBefore(s, ss)
  return
