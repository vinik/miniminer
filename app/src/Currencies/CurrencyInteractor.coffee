'use strict'
C = null
# _ = require 'underscore'

class CurrencyInteractor

    constructor: (deps) ->
        @Entity = deps?.entities?.Currency or require './CurrencyEntity'
        C = deps?.constants or require '../../Constants'
        @async = deps?.async or require 'async'
        querystring = require 'querystring'
        @hosts = deps?.hosts || require '../../configs/hosts'
        @https = deps?.connector?.https || require 'https'
        @json = deps?.connector?.json || require 'json'

    create: (inputMessage, translatorCallback) ->
        entity = new @Entity
        # Validação dos dados recebidos
        entity.creationValidation inputMessage, (validationErrors) ->
            return translatorCallback error : validationErrors if validationErrors?
            # Cria currencies
            entity.create inputMessage, (createOutputMessage) ->
                return translatorCallback createOutputMessage if createOutputMessage?.error?
                # Cria currencies_status
                inputMessage =
                    data:
                        currency_id: createOutputMessage.success.id

    find: (inputMessage, translatorCallback) ->
        entity = new @Entity

        orderInputMessage =
            data:
                # auth_token: inputMessage.data.auth_token
                field: 'currency_id'
                value: inputMessage.data.id

        entity.getCurrency orderInputMessage, (outputMessage) ->
            translatorCallback outputMessage

    getBitCoinValue: (callback) ->

        request = require('request');
        request(@hosts.coinmarketcap.url + "ticker/bitcoin", (error, response, body)->
            console.log(body)
            callback body
        )

    getMostProfitableToMine: (callback) ->

        request = require('request');
        request(@hosts.coinmarketcap.url + "ticker", (error, response, body)->
            #console.log(body)

            json = JSON.parse body
            console.log json[0].id


            first = null
            last = null
            list = [0, 1, 2, 3, 4]
            list2 = list
            list2[item] = json[item].id for item in list

            callback list2
        )

    #getTop: (top, callback)

    _log: (msg) ->
        console.log msg

module.exports = CurrencyInteractor
