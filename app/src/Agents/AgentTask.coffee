'use strict'

class AgentTask

    name: 'AgentTask'
    interval: 10000

    constructor: (deps) ->
        @Interactor = deps?.entities?.interactor || require '../Currencies/CurrencyInteractor'
        @logger = deps?.logger || require 'winston'
        @logger.log 'info', "Test"

    run: (emitter) ->
        console.log "AgentTask"
        return true

    stop: ->
        @logger.log 'info', 'parando...'

module.exports = AgentTask
