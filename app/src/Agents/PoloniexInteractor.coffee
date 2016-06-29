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

        nsu = new Date().getTime()

        params += '&nonce=' + nsu
        options =
            method: 'POST'
            url: @trading_url
            headers:
                Key: @api_key
                Sign: @signRequest params
            form: params

        request(options, (error, response, body)->
            #console.log(body)
            json = JSON.parse body
            callback json
        )


    getBalances: (callback) ->
        params = 'command=returnBalances'

        @query params, (balances) ->
            console.log balances
            
            callback balances.BTC



    _log: (msg) ->
        console.log msg

module.exports = PoloniexInteractor
