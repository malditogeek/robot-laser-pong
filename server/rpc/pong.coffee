
arDrone = require('ar-drone')
drone   = 
  right:  arDrone.createClient(ip: '192.168.1.50')
  left:   arDrone.createClient(ip: '192.168.1.60')

five  = require("johnny-five")
board = new five.Board()

move = null

board.on "ready", ->
  console.log 'ready'

  servoX = new five.Servo(10)
  servoY = new five.Servo(9)

  move = (x,y) ->
    servoX.move(x)
    servoY.move(Math.abs(y-90)+35)

stream = {}
['left', 'right'].forEach (paddle) ->
  stream[paddle] = drone[paddle].getPngStream()

exports.actions = (req, res, ss) ->

  req.use('session')

  ['left', 'right'].forEach (paddle) ->
    stream[paddle].on 'data', (png) ->
      ss.publish.all 'pngStream', paddle,  png.toString('base64')

  start: ->
    ['left', 'right'].forEach (paddle) ->
      console.log "Taking off #{paddle}!"
      drone[paddle].disableEmergency()
      drone[paddle].takeoff()

  moveUp: (paddle) ->
    console.log "#{paddle} moveUp"
    drone[paddle].up(0.7)

  moveDown: (paddle) ->
    console.log "#{paddle} moveDown"
    drone[paddle].down(0.7)

  stopMovingUp: (paddle) ->
    console.log "#{paddle} stopMovingUp"
    drone[paddle].stop()

  stopMovingDown: (paddle) ->
    console.log "#{paddle} stopMovingDown"
    drone[paddle].stop()

  ball: (x,y) ->
    console.log "Ball position: #{x},#{y}"
    xratio = (640/90) * 2
    yratio = (480/90) * 2
    move((x/xratio),(y/yratio))

  quit: ->
    console.log 'Landing...'
    ['left', 'right'].forEach (paddle) ->
      drone[paddle].land()
