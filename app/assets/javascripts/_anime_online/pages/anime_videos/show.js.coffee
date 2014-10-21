get_page =->
  $('.p-anime_video-show')

resize_player = ($page) ->
  $frame = $('iframe', $page)
  $frame.height($frame.width() * 9 / 16) if $frame

  $object = $('object', $page)
  if $object
    width = $object.parent().width()
    $object.width(width).height(width * 9 / 16)
    $('embed', $object).width(width).height(width * 9 / 16)

watch_view_count_increment = ->
  $.ajax
    url: get_page().data('watch-url')

jQuery ->
  $page = get_page()

  $('.kinds li a', $page).on 'click', ->
    $('.video iframe', $page).attr 'src', $(@).data('url')

  $('a', '.report li').on 'ajax:success', ->
    alert 'Ваше обращение принято. Спасибо!'

  resize_player $page
  $(window).resize -> resize_player($page)

  $("a.dropdown-toggle, .dropdown-menu a").on "touchstart", (e) ->
    e.stopPropagation()

  $('li.rate a', $page).on 'ajax:success', ->
    $('li.rate a', $page).addClass 'hide'
    $('li.ok', $page).removeClass 'hide'

  $('button[data-href]', $page).on 'click', ->
    window.location = $(@).data('href')

  (-> watch_view_count_increment()).delay($page.data('watch-delay')) if $page.data('watch-delay')
