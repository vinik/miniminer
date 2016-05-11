class CurrencyEntity

    constructor: (deps) ->
        @Adapter = deps?.adapters?.Order || require './CurrencyAdapter'
        a=1

    creationValidation: (inputMessage, interactorCallback) ->
        @_validate inputMessage, @_creationRules(), interactorCallback

    create: (inputMessage, interactorCallback) ->
        adapter = new @Adapter
        inputMessage.data.reference = inputMessage.data.id
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

module.exports = CurrencyEntity
