'use strict'

startServer = ->



    Server = require 'restwork'
    Routes = require './app/Routes'
    Handlers = require './app/Handlers'
    routes = new Routes()
    server = new Server routes.getRoutes(), Handlers
    port = 1234
    # certificatePath = process.env.S2WAY_SSL_CERTIFICATE_PATH
    # keyPath = process.env.S2WAY_SSL_KEY_PATH

    # if certificatePath? and keyPath?
    #     server.ssl_certificate fs.readFileSync "#{certificatePath}"
    #     server.ssl_key fs.readFileSync "#{keyPath}"

    server.start port, ->
        console.log "Started [ #{port} ] "


startServer()
