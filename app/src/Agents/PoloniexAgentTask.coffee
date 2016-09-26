'use strict'

class PoloniexAgentTask

    name: 'PoloniexAgentTask'
    interval: 1000 * 60
    litecoins: 0.01
    keyPair: null

    constructor: (deps) ->
        @Interactor = deps?.entities?.interactor || require '../Agents/PoloniexInteractor'
        @CurrencyInteractor = require '../Currencies/CurrencyInteractor'
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

        interactor = new @Interactor

        @logger.info "[PoloniexAgentTask] Ok Master, let me do my work"

        @logger.info "[PoloniexAgentTask] Let me see how much we have"

        _ = require 'lodash'

        interactor.getBalances (balances) ->
            return emitter.emit 'error' if balances is 'error'
            CurrencyInteractor = require '../Currencies/CurrencyInteractor'
            currencyInteractor = new CurrencyInteractor

            # console.log balances

            # o que eu tenho
            console.log "[PoloniexAgentTask] I have quant coinName ($ price)"

            # o que eu quero comprar
            currencyInteractor.getTop (top) ->
                # console.log "TOPS", top
                coinIWant = top[0]
                console.log  "[PoloniexAgentTask] I would like to have " + coinIWant.name + " ($ " + coinIWant.price_usd + " B" + coinIWant.price_btc + " (+ " + coinIWant.percent_change_1h + "/1h)) "

                # trocar o que eu tenho por bitcoins
                console.log  "[PoloniexAgentTask] I will now trade " + coinIWant.name + " for bitcoins"
                #interactor.purchaseBitcoins()

                console.log  "[PoloniexAgentTask] Ok, now I have x bitcoins"

                #trocar bitcoins pela moeda que eu quero
                console.log  "[PoloniexAgentTask] I will now trade bitcoins for coin2Name"
                console.log  "[PoloniexAgentTask] Ok, now I have x coin2Name ($ value)"


                emitter.emit 'success'

        emitter.emit 'success'

    stop: ->
        @logger.log 'info', 'parando...'

module.exports = PoloniexAgentTask
