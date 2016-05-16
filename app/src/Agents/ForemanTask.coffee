'use strict'

class ForemanTask

    name: 'ForemanTask'
    interval: 60 * 60 * 1000
    # interval: 10 * 60 * 1000
    litecoins: 0.01

    constructor: (deps) ->
        @Interactor = deps?.entities?.interactor || require '../Currencies/CurrencyInteractor'
        @logger = deps?.logger || require 'winston'
        @logger.log 'info', "[ForemanTask]"

    run: (emitter) ->
        @logger.log 'info', "[ForemanTask] Ok Master, let me see what are the most profitable coins to mine."

        interactor = new @Interactor
        interactor.getMostProfitableToMine (outputMessage) ->
            return emitter.emit 'error' if outputMessage is 'error'

            console.log 'info', "[ForemanTask] Master, I want to mine " + outputMessage
            emitter.emit 'success'


    stop: ->
        @logger.log 'info', 'parando...'

module.exports = ForemanTask
