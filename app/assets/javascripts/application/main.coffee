# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ () ->
  $(document).on 'click', '.tester-thumbs img', () ->
    images = $ '.tester-thumbs img'
    image = $ '.tester_img'
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


  $(document).on 'click', '.video-stub', () ->
    video_popup = $ '.video-popup'
    video_popup.find('iframe').attr('src', $(this).attr('data-url'))
    video_popup.show()
    return false

  $(document).on 'click', '.video-popup', () ->
    video_popup = $ this
    video_popup.hide()
    video_popup.find('iframe').attr 'src', ''
    return false

  $(document).on 'click', '.locale-btn', () ->
    locale_sw = $ '.locale-sw'
    top = locale_sw.css('top')
    if locale_sw.css('top') != '0px'
      locale_sw.animate {top: '0'}
    else
      locale_sw.animate {top: '28px'}
    return false

  return false