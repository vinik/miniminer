'use strict'
C = null

_ = require 'underscore'

class CurrencyEntity

    constructor: (deps) ->
        @Adapter = deps?.adapters?.Order || require './CurrencyAdapter'
        a=1

    creationValidation: (inputMessage, interactorCallback) ->
        @_validate inputMessage, @_creationRules(), interactorCallback

    create: (inputMessage, interactorCallback) ->
        adapter = new @Adapter
        inputMessage.data.id = @_getUUID()
        inputMessage.data.created = @moment.utc().format(C.FORMAT.MILLISECOND_TIMESTAMP)
        adapter.create inputMessage, interactorCallback

    findCurrencyById: (id, interactorCallback) ->
        adapter = new @Adapter
        adapter.findOrderById id, interactorCallback

    getCurrency: (inputMessage, interactorCallback) ->
        adapter = new @Adapter
        params =
            domain: 'miniminer'
            resource: 'currencies'
            data:
                # auth_token: inputMessage.data.auth_token
                field: inputMessage.data.field
                value: inputMessage.data.value

        adapter.getCurrency params, interactorCallback

    _validate: (inputMessage, rules, interactorCallback) ->
        validator = new (require('waferpie-utils').Validator)(rules)
        validator.validate inputMessage.data, (validationErrors) ->
            return interactorCallback error : validationErrors if validationErrors?
            interactorCallback()

    _creationRules: ->
        wpRules = require('waferpie-utils').Rules
        rules =
            validate:
                symbol: (value, data, callback) =>
                    return callback message : 'Field is invalid' if !wpRules.isUseful(value) or value is 0
                    adapter = new @Adapter
                    inputMessage =
                        data:
                            reference: value
                            auth_token: data.auth_token
                    adapter.find inputMessage, (outputMessage) ->
                        return callback() if outputMessage?.error is 'NOT_FOUND'
                        # Adaptação para manter o padrão do retorno do validator
                        return callback message : outputMessage.error if outputMessage?.error?
                        return callback message : 'Currency already created' if callback outputMessage?.success?
                name: (value, data, callback) ->
                    if _.isEmpty value
                        callback message: 'Field is invalid'
                    else if value.toString().length > 1024
                        callback message: 'Value too long. Check the schema.'
                    else
                        callback null

module.exports = CurrencyEntity
