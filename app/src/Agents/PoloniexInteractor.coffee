'use strict'
C = null
# _ = require 'underscore'

class PoloniexInteractor

    constructor: (deps) ->
        C = deps?.constants or require '../../Constants'
        @async = deps?.async or require 'async'
        querystring = require 'querystring'
        @hosts = deps?.hosts || require '../../configs/hosts'
        @https = deps?.connector?.https || require 'https'
        @json = deps?.connector?.json || require 'json'
        @keys = require '../../configs/keys.coffee'

        @api_key = @keys.poloniex.api_key
        @api_secret = @keys.poloniex.api_secret
        @trading_url = 'https://poloniex.com/tradingApi'
        @public_url = 'https://poloniex.com/public'

    signRequest: (params)->
        sha512 = require 'sha512'
        hasher = sha512.hmac @api_secret
        hash = hasher.finalize(params)
        return hash.toString 'hex'


    query: (params, callback) ->
        request = require('request');

        nsu = new Date().getTime() * 10000

        params += '&nonce=' + nsu
        options =
            method: 'POST'
            url: @trading_url
            headers:
                Key: @api_key
                Sign: @signRequest params
            form: params

        request(options, (error, response, body)->

            # TODO error treatment

            #console.log(body)
            json = JSON.parse body
            callback json
        )

    buyCoinIWant: (coinIwant, callback) ->
        params = 'command=buy'
        currencyPair = "BTC_" + coinIwant.name
        rate = ''
        amount = coinIwant.amount
        params += '&currencyPair=' + currencyPair
        params += '&rate=' + rate
        params += '&amount=' + amount

        @query params, (order) ->
            console.log order
            callback order

    sell4Bitcoin: (coinIHave, callback) ->
        params = 'command=sell'

        currencyPair = "BTC_" + coinIHave.name
        rate = ''
        amount = coinIHave.amount

        params += '&currencyPair=' + currencyPair
        params += '&rate=' + rate
        params += '&amount=' + amount

        @query params, (order) ->
            console.log order
            callback order

    getBalances: (callback) ->
        params = 'command=returnBalances'

        @query params, (balances) ->
            console.log balances
            myBalances = []

            for own key, value of balances
                if value > 0
                    balanceItem = {"name":key,"amount":value}
                    myBalances.push balanceItem

            callback myBalances

    _log: (msg) ->
        console.log msg

module.exports = PoloniexInteractor
