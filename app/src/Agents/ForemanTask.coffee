'use strict'

class ForemanTask

    name: 'ForemanTask'
    interval: 60 * 60 * 1000
    # interval: 5 * 60 * 1000
    litecoins: 0.01

    constructor: (deps) ->
        @Interactor = deps?.entities?.interactor || require '../Currencies/CurrencyInteractor'
        @logger = deps?.logger || require 'winston'
        @logger.log 'info', "[ForemanTask]"

    run: (emitter) ->
        _ = require 'lodash'
        @logger.log 'info', "[ForemanTask] Ok Master, let me see what are the most profitable coins to mine."

        interactor = new @Interactor
        interactor.getMostProfitableToMine (topFive) ->
            return emitter.emit 'error' if topFive is 'error'

            strMostProfitableList = ""

            #_.forEach topFive, (item)->
            #     console.log item


            emitter.emit 'success'

            console.log 'info', "[ForemanTask] Master, I want to mine " + topFive




    stop: ->
        @logger.log 'info', 'parando...'

module.exports = ForemanTask
