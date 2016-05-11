'use strict'
# C = null
wpRules = null
querystring = null

class CurrencyAdapter

    constructor: (deps) ->
        @QueryBuilder = deps?.util?.queryBuilder || require('waferpie-utils').QueryBuilder
        @PersistenceConnector = deps?.connector?.mysql || require('waferpie-utils').Connectors.MySQL
        @HttpConnector = deps?.connector?.http || require('waferpie-utils').Connectors.Http
        @https = deps?.connector?.https || require 'https'
        @Builder = deps?.xmlBuilder || require('xml2js').Builder
        @Parser = deps?.xmlParser || require('xml2js').Parser
        @moment = deps?.moment || require 'moment'
        querystring = require 'querystring'
        # C = deps?.constants || require '../../Constants'
        @wpRules = require('waferpie-utils').Rules
        @hosts = deps?.hosts || require '../../configs/hosts'

        @mysqlParams = @hosts.mysqlParams

    find: (inputMessage, entityCallback) ->
        $ = new @QueryBuilder
        query = $.select('id')
            .from('currencies')
            .where(
                $.equal('reference', $.escape(inputMessage.data.reference)),
                $.equal('auth_token', $.escape(inputMessage.data.auth_token))
            )
            .limit(1)
            .build()
        connector = new @PersistenceConnector @mysqlParams
        connector.read query, (error, success) ->
            return entityCallback error : error if error?
            return entityCallback success: success if success?
            entityCallback error: C.ERROR.NOT_FOUND

    findOrderById: (id, entityCallback) ->
        @_findById id, 'currencies', entityCallback

    getStatus: (inputMessage, entityCallback) ->
        $ = new @QueryBuilder
        @mysqlParams.resource = 'currencies_status'
        query = $.select('status')
            .from(@mysqlParams.resource)
            .where(
                $.equal('order_id', $.escape(inputMessage.data.id))
            )
            .build()
        connector = new @PersistenceConnector @mysqlParams
        connector.read query, (error, success) ->
            return entityCallback error : error if error?
            return entityCallback success: success if success?
            entityCallback error: C.ERROR.NOT_FOUND

    getCurrency: (inputMessage, entityCallback) ->

        fields = [
            'currencies.id'
            'currencies.name'
        ]

        selectFields = ''
        for key in fields
            selectFields += "#{key},"

        selectFields = selectFields.substring(0, selectFields.length-1)

        $ = new @QueryBuilder

        # InputMessage com opção para passar auth_token ou não.
        whereConditions = []
        whereConditions[0] = $.equal("currencies.#{inputMessage.data.field}", $.escape(inputMessage.data.value))
        #whereConditions[1] = $.equal('auth_token', $.escape(inputMessage.data.auth_token)) if inputMessage?.data?.auth_token?

        @mysqlParams.resource = inputMessage.resource
        query = $.select(selectFields)
            .from(@mysqlParams.resource)
            .where(
                whereConditions
            )
            #.orderBy('currencies_status.change_datetime', 'DESC')
            .limit(1)
            .build()

        connector = new @PersistenceConnector @mysqlParams
        connector.read query, (error, success) ->
            return entityCallback error : error if error?
            return entityCallback success : success[0] if success?
            entityCallback error: C.ERROR.NOT_FOUND

    create: (inputMessage, entityCallback)->
        connector = new @PersistenceConnector @mysqlParams
        connector.changeTable 'currencies'
        connector.create inputMessage.data, (err) ->
            return entityCallback error: err if err?
            outputMessage =
                success:
                    id: inputMessage.data.id
            return entityCallback outputMessage

    updateCurrencyById: (id, data,entityCallback) ->
        @_updateById id, data, 'currencies', entityCallback


#############################################
########                            #########
########      MÉTODOS PRIVADOS      #########
########                            #########
#############################################

    _findById: (id, table, entityCallback) ->
        connector = new @PersistenceConnector @mysqlParams
        connector.changeTable table
        connector.readById id, (error, success) ->
            return entityCallback error : error if error?
            entityCallback success : (success[0] or success)

    _updateById: (id, data, tableName, entityCallback)->
        connector = new @PersistenceConnector @mysqlParams
        connector.changeTable tableName
        connector.update id, data, (error, success) ->
            return entityCallback error : error if error?
            entityCallback success : success



    _convertJSONtoXML: (rootName, data, callback) ->
        builder = new @Builder(rootName: rootName, renderOpts: pretty: false)
        converted = null
        try
            converted = builder.buildObject data
        catch e
            return @_callbackError C.ERROR.XML, callback

        callback xml : converted

    _obfuscator: (field) ->

        if @wpRules.isUseful field
            if @wpRules.isNumber field
                field = field.toString()
            return field.replace /./g, "*"
        return field

    _callbackError: (errorMessage, callback) ->
        callback error: errorMessage


module.exports = CurrencyAdapter
