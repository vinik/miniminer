'use strict'

class PoloniexAgentTask

    name: 'PoloniexAgentTask'
    interval: 1000 * 5
    litecoins: 0.01
    keyPair: null

    constructor: (deps) ->
        @Interactor = deps?.entities?.interactor || require '../Agents/PoloniexInteractor'
        @logger = deps?.logger || require 'winston'
        @logger.log 'info', "[PoloniexAgentTask]"
        @coins = require '../../configs/coins'
        @wallets = require '../../configs/wallets'
        @bitcoin = require 'bitcoinjs-lib'

        @api_key = 'IMHPOCZL-MK2MBYL9-OD74K7C1-8VU40EK9'
        @api_secret = 'ef1567990bf71e9930a86de8ae8673ccf4d453f41bcc9b31a24a40f9f862270e14af82d3f3d829b7a66ef65130cc8a945dde217f33e4e00f76c5aff81dfdd748'
        @trading_url = 'https://poloniex.com/tradingApi'
        @public_url = 'https://poloniex.com/public'


    run: (emitter) ->

        @logger.info "[PoloniexAgentTask] Ok Master, let me do my work"

        @logger.info "[PoloniexAgentTask] Let me see how much we have"

        _ = require 'lodash'

        interactor = new @Interactor
        interactor.getBalances (balances) ->
            return emitter.emit 'error' if balances is 'error'

            console.log balances

            # _.forEach balances, (item)->
            #     console.log item


            emitter.emit 'success'

            #console.log 'info', "[ForemanTask] Master, I want to mine " + balances




        emitter.emit 'success'

    stop: ->
        @logger.log 'info', 'parando...'

module.exports = PoloniexAgentTask
