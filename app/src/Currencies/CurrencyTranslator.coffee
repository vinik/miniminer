'use strict'

#C = null

class CurrencyTranslator

    CurrencyInteractor: require './CurrencyInteractor'

    constructor: (deps) ->
        #C = deps?.constants || require '../../Constants'

    post: (req, res, next) =>
        orderInteractor = new @CurrencyInteractor
        inputMessage =
            data: req.body
        orderInteractor.create inputMessage, (outputMessage) =>
            if outputMessage?.error?
                errorMsg = @_handleError outputMessage.error
                @_respond res, errorMsg.status, errorMsg.message
            else
                id = {}
                if outputMessage?.success?.id?
                    id =  outputMessage.success.id
                @_respond res, 201, id
        next()

    process: (req, res, next) =>
        orderInteractor = new @CurrencyInteractor
        inputMessage = {}
        inputMessage = data : req.body
        inputMessage.data.id = req.params.id

        orderInteractor.process inputMessage, (outputMessage) =>
            if outputMessage?.error?
                errorMsg = @_handleError outputMessage.error
                @_respond res, errorMsg.status, errorMsg.message
            else
                # outputMessage terá authentication_url em caso de não envio do token
                # ou, no caso do envio (do token),
                statusCode = 202
                @_respond res, statusCode, outputMessage.success
        next()

    find: (req, res, next) =>
        orderInteractor = new @CurrencyInteractor
        orderIdentifierId = null
        orderIdentifierReference = null

        if req?.params?.id?
            orderIdentifierId = req.params.id
        else if req?.query?.order_id?
            orderIdentifierId = req.query.order_id
        else if req?.query?.reference?
            orderIdentifierReference = req.query.reference
        inputMessage =
            data:
                id: orderIdentifierId
                reference: orderIdentifierReference
                auth_token: req.query.auth_token

        orderInteractor.find inputMessage, (outputMessage) =>
            if outputMessage?.error?
                errorMsg = @_handleError outputMessage.error
                @_respond res, errorMsg.status, errorMsg.message
            else
                @_respond res, 200, outputMessage.success

        next()

    _respond: (res, status, body) ->
        res.json status, body

    _handleError: (error) ->
        returnError =
            status: 500
            message: error

        returnError.status = 404 if error is 'NOT_FOUND'
        returnError.status = 422 if error?.error?.name is 'ValidationFailed'

        returnError

module.exports = CurrencyTranslator
