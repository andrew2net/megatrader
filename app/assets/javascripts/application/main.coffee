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

  $(document).on 'page:before-change', (data)->
    counter = new Ya.Metrika {id: 15483610}
    counter.hit data.currentTarget.activeElement.href, {
      referer: data.currentTarget.URL
#      title: data.currentTarget.activeElement.innerHTML
    }
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

#    (
#      (d, w, c)->
#        (w[c] = w[c] || []).push ()->
#          try
#            w.yaCounter15483610 = new Ya.Metrika({
#              id: 15483610
#              webvisor: true
#              clickmap: true
#              trackLinks: true
#              accurateTrackBounce: true
#              trackHash:true
#            })
#          catch e
#          return
#
#        n = d.getElementsByTagName("script")[0]
#        s = d.createElement("script")
#        f = ()->
#          n.parentNode.insertBefore(s, n)
#          return
#
#        s.type = "text/javascript"
#        s.async = true
#        s.src = (d.location.protocol == "https:" ? "https:" : "http:") + "//mc.yandex.ru/metrika/watch.js"
#
#        if (w.opera == "[object Opera]")
#          d.addEventListener("DOMContentLoaded", f, false)
#        else
#          f()
#        return
#    )(document, window, "yandex_metrika_callbacks")


    $('.articles-pager').hide()
    if $('.pagination a[rel=next]').size() > 0
      $(window).on 'scroll', ->
        more_articles_url = $('.pagination a[rel=next]').attr 'href'
        if more_articles_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60
          loading_img = $('.articles-pager').attr 'data-loading-img'
          $('.pagination').html('<img src="' + loading_img + '" alt="Loading..." title="Loading..." />')
          $('.articles-pager').show()
          $.getScript more_articles_url
        return

    $(document).on('ajax:success', '#question-form', (e, data, status, xhr) ->
      $('#question-form').append(hxr.responseText).show()
      return
    ).on('ajax:before', '#question-form', ->
      $('#question-form').hide()
      $('.loading-form').show()
      return
    ).on('ajax:complete', '#question-form', ->
      $('.loading-form').hide()
      return
    )

    $('.price-accord').accordion(
      header: 'h6'
      heightStyle: "content",
      icons: {header: 'price-accord-icon-s', activeHeader: 'price-accord-icon-e'}
    )
    $('.price-accord label').click (e)->
      e.stopPropagation()
      return

    return

  $(document).on 'ready page:load', pageLoaded

  pageLoaded

  return
