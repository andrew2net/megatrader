# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ () ->
  images = $ '.tester-thumbs img'
  image = $ '.tester_img'
  images.click () ->
    images.removeClass 'border-orange'
    ths = $(this)
    ths.addClass 'border-orange'
    href = ths.attr 'href'
    image.attr 'href', href

    image.animate {opacity: 0}, 300, () ->
      image.attr 'src', ths.attr('src')
      return false

    image.animate {opacity: 1}, 300
    return false

  video_stub = $ '.video-stub'
  video_popup = $ '.video-popup'

  video_stub.click () ->
    video_popup.find('iframe').attr('src', $(this).attr('data-url'))
    video_popup.show()
    return false

  video_popup.click () ->
    video_popup.hide()
    video_popup.find('iframe').attr 'src', ''
    return false