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
        _ = require('lodash')
        request(@hosts.coinmarketcap.url + "ticker", (error, response, body)->
            #console.log(body)

            json = JSON.parse body
            #console.log json[0].id

            filteredList = _.filter json, (filtered)->
                return filtered.percent_change_24h? and filtered.rank < 100

            #console.log orderedList
            orderedList = _.orderBy filteredList, ['percent_change_1h'], ['desc']

            list2 = []
            list2[index] = orderedList[index] for index in [0..4]

            callback list2
        )


    getTop: (callback) ->

        request = require('request');
        _ = require('lodash')
        request(@hosts.coinmarketcap.url + "ticker", (error, response, body)->
            #console.log(body)

            json = JSON.parse body
            #console.log json[0].id

            filteredList = _.filter json, (filtered)->
                return filtered.percent_change_1h? and filtered.rank < 10

            #console.log orderedList
            orderedList = _.orderBy filteredList, ['percent_change_1h'], ['desc']

            list2 = []
            list2[index] = orderedList[index] for index in [0..5]

            callback list2
        )

    _log: (msg) ->
        console.log msg

module.exports = CurrencyInteractor
