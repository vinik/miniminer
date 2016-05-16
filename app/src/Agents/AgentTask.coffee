'use strict'

class AgentTask

    name: 'AgentTask'
    interval: 5 * 60 * 1000
    litecoins: 0.01
    keyPair: null

    constructor: (deps) ->
        @Interactor = deps?.entities?.interactor || require '../Currencies/CurrencyInteractor'
        @logger = deps?.logger || require 'winston'
        @logger.log 'info', "[AgentTask]"
        @coins = require '../../configs/coins'
        @wallets = require '../../configs/wallets'
        @bitcoin = require 'bitcoinjs-lib'


    run: (emitter) ->

        @logger.info "[AgentTask] Ok Master, let me do my work"

        keyPair = null

        keyPair = @bitcoin.ECPair.fromWIF(@wallets.bitcoin.workWallet.privateKey)
        address = keyPair.getAddress()

        @logger.info "[AgentTask] Master, I will use the wallet address " + address

        # keyPair = @bitcoin.ECPair.makeRandom()
        #
        # # Print your private key (in WIF format)
        # console.log(keyPair.toWIF())
        #
        # # Print your public key address
        # console.log(keyPair.getAddress())

        @logger.info "[AgentTask] Let me see how much we have"
        @logger.error "[AgentTask] Master, I need some bitcoins to work"

        # interactor = new @Interactor
        # interactor.getBitCoinValue (outputMessage) ->
        #     return emitter.emit 'error' if outputMessage is 'error'
        #     #console.log (outputMessage)
        #     emitter.emit 'success'

        # getBalance
        #coindust = require 'coindust'
        #console.log coindust.balance @coins.bitcoin.masterWallet

        emitter.emit 'success'

    stop: ->
        @logger.log 'info', 'parando...'

module.exports = AgentTask
