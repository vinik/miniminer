'use strict'

class Routes

    getRoutes: () ->
        currency = new (require './src/Currencies/CurrencyTranslator')
        routes =
            currencies: [
                {
                    httpMethod: 'post'
                    url: 'currencies'
                    method: currency.post
                }
                {
                    httpMethod: 'put'
                    url: 'currencies/:id'
                    method: currency.process
                }
                {
                    httpMethod: 'get'
                    url: 'currencies/:id'
                    method: currency.find
                }
                {
                    httpMethod: 'get'
                    url: 'currencies'
                    method: currency.find
                }
            ]

module.exports = Routes
