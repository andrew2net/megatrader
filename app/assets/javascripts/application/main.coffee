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
    image.animate {opacity: 1}, 300
