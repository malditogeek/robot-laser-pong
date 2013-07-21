Game.start 'game', Pong,
  sound:       true
  stats:       false
  footprints:  false
  predictions: false

ss.event.on 'pngStream', (paddle, data) ->
  $("#stream-#{paddle}").attr('src', "data:image/png;base64,#{data}")

window.onbeforeunload = ->
  ss.rpc('pong.quit')
