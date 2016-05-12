'use strict'
C = null
# _ = require 'underscore'

class CurrencyInteractor

    constructor: (deps) ->
        @Entity = deps?.entities?.Currency or require './CurrencyEntity'
        C = deps?.constants or require '../../Constants'
        @async = deps?.async or require 'async'

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


    _log: (msg) ->
        console.log msg

module.exports = CurrencyInteractor
