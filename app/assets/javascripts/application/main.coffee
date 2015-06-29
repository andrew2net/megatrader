# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on 'click', '.tester-thumbs img', ->
    images = $ '.tester-thumbs img'
    image = $ '.tester_img'
    images.removeClass 'border-orange'
    ths = $(this)
    ths.addClass 'border-orange'
    href = ths.attr 'href'
    image.attr 'href', href

    image.animate {opacity: 0}, 300, ->
      image.attr 'src', ths.attr('src')
      return

    image.animate {opacity: 1}, 300
    return


  $(document).on 'click', '.video-stub', ->
    video_popup = $ '.video-popup'
    video_popup.find('iframe').attr('src', $(this).attr('data-url'))
    video_popup.show()
    return

  $(document).on 'click', '.video-popup', ->
    video_popup = $ this
    video_popup.hide()
    video_popup.find('iframe').attr 'src', ''
    return

  $(document).on 'click', '.locale-btn', ->
    locale_sw = $ '.locale-sw'
    top = locale_sw.css('top')
    if locale_sw.css('top') != '0px'
      locale_sw.animate {top: '0'}
    else
      locale_sw.animate {top: '28px'}
    return

  pageLoaded = ->
    $('.articles-pager').hide()
    if $('.pagination a[rel=next]').size() > 0
      $(window).on 'scroll', ->
        more_articles_url = $('.pagination a[rel=next]').attr 'href'
        if more_articles_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60
          $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />')
          $('.articles-pager').show()
          $.getScript more_articles_url
        return
      return
    return

  $(document).on 'ready page:load', pageLoaded

  pageLoaded

  return