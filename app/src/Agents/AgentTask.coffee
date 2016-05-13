'use strict'

class AgentTask

    name: 'AgentTask'
    interval: 3000

    constructor: (deps) ->
        @Interactor = deps?.entities?.interactor || require '../Currencies/CurrencyInteractor'
        @logger = deps?.logger || require 'winston'
        @logger.log 'info', "Test"

    run: (emitter) ->
        console.log "AgentTask"
        emitter.emit 'success'

    stop: ->
        @logger.log 'info', 'parando...'

module.exports = AgentTask
