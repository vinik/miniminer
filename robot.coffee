'use strict'

startServer = ->
    Server = require 'restwork'
    Routes = require './app/Routes'
    Handlers = require './app/Handlers'
    routes = new Routes()
    server = new Server routes.getRoutes(), Handlers
    port = 1234
    # certificatePath = process.env.SSL_CERTIFICATE_PATH
    # keyPath = process.env.SSL_KEY_PATH

    # if certificatePath? and keyPath?
    #     server.ssl_certificate fs.readFileSync "#{certificatePath}"
    #     server.ssl_key fs.readFileSync "#{keyPath}"

    server.start port, ->
        console.log "Started [ #{port} ] "


startTasker= ->
    tasks = []
    tasks.push new (require './app/src/Agents/PoloniexAgentTask')
    tasks.push new (require './app/src/Agents/ForemanTask')

    Watcher = require('waferpie-utils').Watcher
    watcher = new Watcher
    for task in tasks
        watcher.register task, (err) ->
            console.log err if err?
            console.log "#{task.name} registered." unless err?


options = process.argv.slice 2

isServer = options.indexOf('server') isnt -1
isTasker = options.indexOf('tasker') isnt -1

startServer() if isServer
startTasker() if isTasker

if not isServer and not isTasker
    startTasker()
    startServer()
