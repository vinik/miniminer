'use strict'

Order = require '../../src/Currencies/CurrencyEntity'
expect = require 'expect.js'
Error = require 'errno-codes'

describe 'The Currency entity,', ->

    describe 'when its creationValidation method is called,', ->

        inputMessage = null
        expectedMessage = null
        deps = null

        beforeEach ->
            inputMessage =
                data:
                    id: 52
                    authToken: 'my_ecommerce'
                    description: 'Teste recarga'
                    amount: 20
                    return_url: 'http://localhost.com'

            expectedMessage =
                error:
                    name: "ValidationFailed"
                    fields:
                        id: true
                        return_url: true
                        description: true
                        amount: true

            class Adapter
                find: (params, callback) ->
                    callback()

            deps = {adapters: {Order : Adapter}, tokens: ['token1']}

        it 'should callback null if there were no errors', (done) ->
            instance = new Order deps
            instance.creationValidation inputMessage, (outputMessage) ->
                expect(outputMessage).not.to.be.ok()
                done()

        it 'should return an error if the id is a big no', (done) ->
            expectedMessage.error.fields = 'id': 'message': 'Field is invalid'
            inputMessage.data.id = undefined
            instance = new Order deps
            instance.creationValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should callback the query error if it happens when querying for a created order', (done) ->
            expectedMessage.error.fields = 'id': 'message': 'annoying error'
            class Adapter
                find: (params, callback) ->
                    callback error: 'annoying error'
            deps = {adapters: {Order : Adapter}, tokens: ['token1']}
            instance = new Order deps
            instance.creationValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should fire a validation error if the order already exists', (done) ->
            expectedMessage.error.fields = 'id': 'message': 'Order already created'
            class Adapter
                find: (params, callback) ->
                    callback success: an : 'order'
            deps = {adapters: {Order : Adapter}, tokens: ['token1']}
            instance = new Order deps
            instance.creationValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should be ok if no order was found', (done) ->
            class Adapter
                find: (params, callback) ->
                    callback error: 'NOT_FOUND'
            deps = {adapters: {Order : Adapter}, tokens: ['token1']}
            instance = new Order deps
            instance.creationValidation inputMessage, (outputMessage) ->
                expect(outputMessage).not.to.be.ok()
                done()

        it 'should return an error if description is undefined', (done) ->
            expectedMessage.error.fields = 'description': 'message': 'Field is invalid'
            inputMessage.data.description = undefined
            instance = new Order deps
            instance.creationValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if description is empty', (done) ->
            expectedMessage.error.fields = 'description': 'message': 'Field is invalid'
            inputMessage.data.description = {}
            instance = new Order deps
            instance.creationValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if description is too long', (done) ->
            expectedMessage.error.fields = 'description': 'message': 'Value too long. Check the schema.'
            inputMessage.data.description = new Array(1026).join 'i'
            instance = new Order deps
            instance.creationValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if the return url was not valid', (done) ->
            expectedMessage.error.fields = 'return_url': 'message': 'Value is invalid'
            inputMessage.data.return_url = 'www.google.com'
            instance = new Order deps
            instance.creationValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if the return url was not valid', (done) ->
            expectedMessage.error.fields = 'return_url': 'message': 'Value is invalid'
            inputMessage.data.return_url = 'http:www.google.com'
            instance = new Order deps
            instance.creationValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if the return url was not valid', (done) ->
            expectedMessage.error.fields = 'return_url': 'message': 'Value is invalid'
            inputMessage.data.return_url = 'google.com'
            instance = new Order deps
            instance.creationValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should not return an error if the return url has a port', (done) ->
            inputMessage.data.return_url = 'http://desenv.localhost:8090/cliente'
            instance = new Order deps
            instance.creationValidation inputMessage, (outputMessage) ->
                expect(outputMessage).not.to.be.ok()
                done()

        it 'should return an error if the return url was not sent', (done) ->
            expectedMessage.error.fields = 'return_url': 'message': 'Field is invalid'
            inputMessage.data.return_url = {}
            instance = new Order deps
            instance.creationValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if the return url is too long', (done) ->
            expectedMessage.error.fields = 'return_url': 'message': 'Value too long. Check the schema.'
            inputMessage.data.return_url = new Array(2050).join 'i'
            instance = new Order deps
            instance.creationValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if amount is undefined', (done) ->
            expectedMessage.error.fields = 'amount': 'message': 'Field is invalid'
            inputMessage.data.amount = undefined
            instance = new Order deps
            instance.creationValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if amount is empty', (done) ->
            expectedMessage.error.fields = 'amount': 'message': 'Field is invalid'
            inputMessage.data.amount = {}
            instance = new Order deps
            instance.creationValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if amount is too long', (done) ->
            expectedMessage.error.fields = 'amount': 'message': 'Value too long. Check the schema.'
            inputMessage.data.amount = new Array(14).join '0'
            instance = new Order deps
            instance.creationValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if amount has a dot', (done) ->
            expectedMessage.error.fields = 'amount': 'message': 'Value must be represented in cents. Don\'t use dots or commas.'
            inputMessage.data.amount = 20.1
            instance = new Order deps
            instance.creationValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if amount has a comma', (done) ->
            expectedMessage.error.fields = 'amount': 'message': 'Value must be represented in cents. Don\'t use dots or commas.'
            inputMessage.data.amount = '20,01'
            instance = new Order deps
            instance.creationValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

    describe 'when its inspectValidation method is called', ->

        inputMessage = null
        expectedMessage = null
        deps = null

        beforeEach ->
            inputMessage =
                data:
                    id: 52
                    auth_token: 'token1'

            expectedMessage =
                error:
                    name: "ValidationFailed"
                    fields:
                        id: true
                        auth_token: true

        deps = { tokens: ['token1']}

        it 'should return an error if auth_token is empty', (done) ->
            expectedMessage.error.fields = 'auth_token': 'message': 'Field is invalid'
            inputMessage.data.auth_token = ''
            instance = new Order deps
            instance.inspectValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if auth_token is undefined', (done) ->
            expectedMessage.error.fields = 'auth_token': 'message': 'Field is invalid'
            delete inputMessage.data.auth_token
            instance = new Order deps
            instance.inspectValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if id is empty', (done) ->
            expectedMessage.error.fields =
                'id':
                    'message': 'Field is invalid'
                'reference':
                    'message': 'Field is invalid'

            inputMessage.data.id = ''
            instance = new Order deps
            instance.inspectValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if reference is empty', (done) ->
            expectedMessage.error.fields =
                'id':
                    'message': 'Field is invalid'
                'reference':
                    'message': 'Field is invalid'

            inputMessage.data.id = ''
            inputMessage.data.reference = ''
            instance = new Order deps
            instance.inspectValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if id is undefined', (done) ->
            expectedMessage.error.fields =
                'id':
                    'message': 'Field is invalid'
                'reference':
                    'message': 'Field is invalid'

            delete inputMessage.data.id
            instance = new Order deps
            instance.inspectValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if id is undefined', (done) ->
            expectedMessage.error.fields =
                'id':
                    'message': 'Field is invalid'
                'reference':
                    'message': 'Field is invalid'

            delete inputMessage.data.id
            delete inputMessage.data.reference
            instance = new Order deps
            instance.inspectValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if auth_token not valid', (done) ->
            expectedMessage.error.fields = 'auth_token': 'message': 'Token unknown.'
            inputMessage.data.auth_token = 'invalid toko'
            instance = new Order deps
            instance.inspectValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

    describe 'when its processValidation method is called', ->

        inputMessage = null
        expectedMessage = null
        deps = null

        beforeEach ->
            inputMessage =
                data:
                    id: 52
                    auth_token: 'token1'
                    issuer: 'visa'
                    card_number: 3213234212
                    due_date: 201512
                    sec_code_status: 1,
                    security_code: 123,
                    card_holder: 'JOSE REGO',
                    token: 'qwd7as678asd'
                    installments: 1
                    payment_type: 'credito_a_vista'

            expectedMessage =
                error:
                    name: "ValidationFailed"
                    fields:
                        id: true
                        issuer: true
                        card_number: true
                        due_date: true
                        sec_code_status: true
                        security_code: true
                        card_holder: true
                        token: true

            class Adapter
                getOrder: (params, callback) ->
                    callback success:
                        id: 'any id'
                        status: 'CREATED'
                        auth_token: inputMessage.data.auth_token


            deps = {adapters: {Order : Adapter}, tokens: ['token1']}

        it 'should return an error if the order was not found', (done) ->

            expectedMessage.error.fields = 'id': 'message': 'NOT_FOUND'

            class Adapter
                getOrder: (params, callback) ->
                    callback error: 'NOT_FOUND'

            deps = {adapters: {Order : Adapter}, tokens: ['token1']}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should fire a validation error if the order was already processed', (done) ->
            expectedMessage.error.fields = 'id': 'message': 'Order already processed'
            class Adapter
                getOrder: (params, callback) ->
                    callback success:
                        id: 'id'
                        status: 'AUTHORIZED'
                        auth_token: inputMessage.data.auth_token

            deps = {adapters: {Order : Adapter}, tokens: ['token1']}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should not fire a validation error if the order last status is error', (done) ->
            class Adapter
                getOrder: (params, callback) ->
                    callback success:
                        id: 'id'
                        status: 'ERROR'
                        auth_token: inputMessage.data.auth_token

            deps = {adapters: {Order : Adapter}, tokens: ['token1']}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).not.to.be.ok()
                done()

        it 'should return an error message if the creation token is different from the processing token', (done) ->

            expectedMessage.error.fields = 'id': 'message': 'Processing token is different from the creation token'

            class Adapter
                getOrder: (params, callback) ->
                    callback success:
                        id: 'any id'
                        auth_token: 'any_token'

            inputMessage.data.auth_token = 'other_token'

            deps = {adapters: {Order : Adapter}, tokens: ['token1', 'other_token', 'any_token']}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should be ok if the order has one status only', (done) ->
            class Adapter
                getOrder: (params, callback) ->
                    callback success:
                        id: 'any id'
                        status: 'CREATED'
                        auth_token: inputMessage.data.auth_token

            deps = {adapters: {Order : Adapter}, tokens: ['token1']}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).not.to.be.ok()
                done()

        it 'should return an error if auth_token is empty', (done) ->
            expectedMessage.error.fields = 'auth_token': 'message': 'Field is invalid'
            inputMessage.data.auth_token = ''
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if auth_token is undefined', (done) ->
            expectedMessage.error.fields = 'auth_token': 'message': 'Field is invalid'
            delete inputMessage.data.auth_token
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if issuer is empty', (done) ->
            expectedMessage.error.fields = 'issuer': 'message': 'Field is invalid'
            inputMessage.data.issuer = {}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if issuer is unknown', (done) ->
            expectedMessage.error.fields = 'issuer': 'message': 'Issuer unknown.'
            inputMessage.data.issuer = 'not a valid issuer'
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if card_number is empty', (done) ->
            expectedMessage.error.fields = 'card_number': 'message': 'Field is invalid'
            inputMessage.data.card_number = {}
            inputMessage.data.token = {}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if card_number is 0', (done) ->
            expectedMessage.error.fields = 'card_number': 'message': 'Field is invalid'
            inputMessage.data.card_number = 0
            inputMessage.data.token = {}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if card_number is too long', (done) ->
            expectedMessage.error.fields = 'card_number': 'message': 'Value too long. Check the schema.'
            inputMessage.data.card_number = new Array(22).join 'i'
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if card_number has not numbers only', (done) ->
            expectedMessage.error.fields = 'card_number': 'message': 'Value is invalid'
            inputMessage.data.card_number = '321165424687A'
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if due_date is empty', (done) ->
            expectedMessage.error.fields = 'due_date': 'message': 'Field is invalid'
            inputMessage.data.due_date = {}
            inputMessage.data.token = {}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if due_date is 0', (done) ->
            expectedMessage.error.fields = 'due_date': 'message': 'Field is invalid'
            inputMessage.data.due_date = 0
            inputMessage.data.token = {}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if due_date has not numbers only', (done) ->
            expectedMessage.error.fields = 'due_date': 'message': 'Value is invalid'
            inputMessage.data.due_date = '2012mm'
            inputMessage.data.token = {}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if due_date is too long', (done) ->
            expectedMessage.error.fields = 'due_date': 'message': 'Value does not match the schema.'
            inputMessage.data.due_date = '1234567'
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if due_date is too short', (done) ->
            expectedMessage.error.fields = 'due_date': 'message': 'Value does not match the schema.'
            inputMessage.data.due_date = '12345'
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if sec_code_status is empty', (done) ->
            expectedMessage.error.fields = 'sec_code_status': 'message': 'Field is invalid'
            inputMessage.data.sec_code_status = {}
            inputMessage.data.token = {}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if sec_code_status string invalid value', (done) ->
            expectedMessage.error.fields = 'sec_code_status': 'message': 'Value is invalid.'
            inputMessage.data.sec_code_status = '5'
            inputMessage.data.token = {}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if sec_code_status int invalid value', (done) ->
            expectedMessage.error.fields = 'sec_code_status': 'message': 'Value is invalid.'
            inputMessage.data.sec_code_status = 5
            inputMessage.data.token = {}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if security_code has not numbers only', (done) ->
            expectedMessage.error.fields = 'security_code': 'message': 'Value is invalid'
            inputMessage.data.sec_code_status = 1
            inputMessage.data.security_code = 'A22'
            inputMessage.data.token = {}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if security_code is empty', (done) ->
            expectedMessage.error.fields = 'security_code': 'message': 'Field is invalid'
            inputMessage.data.sec_code_status = 1
            inputMessage.data.security_code = {}
            inputMessage.data.token = {}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if security_code is too long', (done) ->
            expectedMessage.error.fields = 'security_code': 'message': 'Value does not match the schema.'
            inputMessage.data.security_code = '12345'
            inputMessage.data.token = {}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if security_code is too short', (done) ->
            expectedMessage.error.fields = 'security_code': 'message': 'Value does not match the schema.'
            inputMessage.data.security_code = 12
            inputMessage.data.token = {}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if card_holder value is too long', (done) ->
            expectedMessage.error.fields = 'card_holder': 'message': 'Value too long. Check the schema.'
            inputMessage.data.card_holder = new Array(52).join 'i'
            inputMessage.data.token = {}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if token value is too long', (done) ->
            expectedMessage.error.fields = 'token': 'message': 'Value too long. Check the schema.'
            inputMessage.data.token = new Array(102).join 'i'
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if token and debit', (done) ->
            expectedMessage.error.fields = 'token': 'message': 'Payment type debit not supported process with token'
            inputMessage.data.payment_type = 'debito'
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if payment type is undefined', (done) ->
            expectedMessage.error.fields = 'payment_type': 'message': 'Field is invalid'
            inputMessage.data.payment_type = undefined
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if payment type is empty', (done) ->
            expectedMessage.error.fields = 'payment_type': 'message': 'Field is invalid'
            inputMessage.data.payment_type = {}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if payment type is unknown', (done) ->
            expectedMessage.error.fields = 'payment_type': 'message': 'Payment type unknown.'
            inputMessage.data.payment_type = 'not a valid issuer'
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if installments is undefined', (done) ->
            expectedMessage.error.fields = 'installments': 'message': 'Field is invalid'
            inputMessage.data.installments = undefined
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if installments is empty', (done) ->
            expectedMessage.error.fields = 'installments': 'message': 'Field is invalid'
            inputMessage.data.installments = {}
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if the payment type is credito_a_vista and installments is bigger than the configured', (done) ->
            expectedMessage.error.fields = 'installments': 'message': 'The payment type allows only 1 installment.'
            inputMessage.data.payment_type = 'credito_a_vista'
            inputMessage.data.installments = 2
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if the payment type is debito and installments if bigger than 1', (done) ->
            expectedMessage.error.fields = 'installments': 'message': 'The payment type allows only 1 installment.'
            inputMessage.data.payment_type = 'debito'
            inputMessage.data.installments = 2
            inputMessage.data.issuer = 'visa'
            delete inputMessage.data.token

            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if the payment type is debito and card is diferent VISA and MASTERCARD', (done) ->
            expectedMessage.error.fields = 'payment_type': 'message': 'Invalid issuer for this payment type.'
            inputMessage.data.payment_type = 'debito'
            inputMessage.data.installments = 1
            inputMessage.data.issuer = 'amex'
            delete inputMessage.data.token
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error for installments bigger than 8', (done) ->
            expectedMessage.error.fields = 'installments': 'message': 'Value exceeds the field limit. Check the schema.'
            inputMessage.data.payment_type = "credito_parcelado_loja"
            inputMessage.data.installments = 9
            instance = new Order deps
            instance.processValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

    describe 'when its cancelValidation method is called', ->

        inputMessage = null
        expectedMessage = null
        deps = null

        beforeEach ->
            inputMessage =
                data:
                    id: 52
                    auth_token: 'token1'

            expectedMessage =
                error:
                    name: "ValidationFailed"
                    fields:
                        id: true
                        auth_token: true

        deps = { tokens: ['token1']}

        it 'should return an error if the order is already canceled', (done)->
            expectedMessage.error.fields = 'id':'message':'Transação já está cancelada'
            delete expectedMessage.error.fields.auth_token

            class Adapter
                getOrder: (params, callback) ->
                    callback success:
                        status: 'CANCELED'
            deps = {adapters: {Order : Adapter}, tokens: ['token1']}
            instance = new Order deps
            instance.cancelValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if the order isnt authorized', (done)->
            expectedMessage.error.fields = 'id':'message':'Pedido não pode ser cancelado, pois não está autorizado.'
            delete expectedMessage.error.fields.auth_token

            class Adapter
                getOrder: (params, callback) ->
                    callback success:
                        status: 'PROCESSING'
            deps = {adapters: {Order : Adapter}, tokens: ['token1']}
            instance = new Order deps
            instance.cancelValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()


        it 'should return an error if auth_token is empty', (done)->
            expectedMessage.error.fields = 'auth_token': 'message' : 'Field is invalid'
            inputMessage.data.auth_token = ''

            class Adapter
                getOrder: (params, callback) ->
                    callback()
            deps = {adapters: {Order : Adapter}, tokens: ['token1']}

            instance = new Order deps
            instance.cancelValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if auth_token is undefined', (done)->
            expectedMessage.error.fields = 'auth_token': 'message' : 'Field is invalid'
            inputMessage.data.auth_token = undefined

            class Adapter
                getOrder: (params, callback) ->
                    callback()
            deps = {adapters: {Order : Adapter}, tokens: ['token1']}

            instance = new Order deps
            instance.cancelValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if auth_token is invalid', (done)->
            expectedMessage.error.fields = 'auth_token':'message': 'Token unknown.'
            inputMessage.data.auth_token = 'token9999'

            class Adapter
                getOrder: (params, callback) ->
                    callback()
            deps = {adapters: {Order : Adapter}, tokens: ['token1']}

            instance = new Order deps
            instance.cancelValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

    describe 'when its histogramValidation method is called', ->
        inputMessage = null
        expectedMessage = null
        deps = null

        beforeEach ->
            inputMessage =
                data:
                    last_date: '2015-10-06'
                    auth_token: 'token1'

            expectedMessage =
                error:
                    name: "ValidationFailed"
                    fields:
                        last_date: true
                        auth_token: true

        deps = { tokens: ['token1']}

        it 'should return an error if auth_token is empty', (done) ->
            expectedMessage.error.fields = 'auth_token': 'message': 'Field is invalid'
            inputMessage.data.auth_token = ''
            instance = new Order deps
            instance.histogramValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if auth_token is undefined', (done) ->
            expectedMessage.error.fields = 'auth_token': 'message': 'Field is invalid'
            delete inputMessage.data.auth_token
            instance = new Order deps
            instance.histogramValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if auth_token not valid', (done) ->
            expectedMessage.error.fields = 'auth_token': 'message': 'Token unknown.'
            inputMessage.data.auth_token = 'invalid toko'
            instance = new Order deps
            instance.histogramValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if last_date is empty', (done) ->
            expectedMessage.error.fields = 'last_date': 'message': 'Field is invalid'
            inputMessage.data.last_date = ''
            instance = new Order deps
            instance.histogramValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if last_date is undefined', (done) ->
            expectedMessage.error.fields = 'last_date': 'message': 'Field is invalid'
            delete inputMessage.data.last_date
            instance = new Order deps
            instance.histogramValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if last_date is invalid', (done) ->
            expectedMessage.error.fields = 'last_date': 'message': 'Field is invalid'
            inputMessage.data.last_date = 'SOMETHING'
            instance = new Order deps
            instance.histogramValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should validate if its fine', (done) ->
            instance = new Order deps
            instance.histogramValidation inputMessage, (outputMessage) ->
                expect(outputMessage).not.to.be.ok()
                done()

    describe 'when its statusList method is called', ->

        inputMessage = null
        expectedMessage = null
        deps = null

        beforeEach ->
            inputMessage =
                data:
                    order_list: '309wje, 2309rjaspodk'
                    auth_token: 'token1'

            expectedMessage =
                error:
                    name: "ValidationFailed"
                    fields:
                        order_list: true
                        auth_token: true

        deps = { tokens: ['token1']}

        it 'should return an error if auth_token is empty', (done) ->
            expectedMessage.error.fields = 'auth_token': 'message': 'Field is invalid'
            inputMessage.data.auth_token = ''
            instance = new Order deps
            instance.statusListValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if auth_token is undefined', (done) ->
            expectedMessage.error.fields = 'auth_token': 'message': 'Field is invalid'
            delete inputMessage.data.auth_token
            instance = new Order deps
            instance.statusListValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if auth_token not valid', (done) ->
            expectedMessage.error.fields = 'auth_token': 'message': 'Token unknown.'
            inputMessage.data.auth_token = 'invalid toko'
            instance = new Order deps
            instance.statusListValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

        it 'should return an error if order_list is empty', (done) ->
            expectedMessage.error.fields = order_list: message: 'Field is invalid'

            inputMessage.data.order_list = undefined
            instance = new Order deps
            instance.statusListValidation inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedMessage
                done()

    describe 'when its create method is called', ->

        it 'should call the Adapters create method with the same inputMessage', (done) ->
            inputMessage =
                data:
                    id: 321
                    some: 'message'

            class Adapter
                create: (params, callback) ->
                    expect(params).to.eql inputMessage
                    done()

            deps =
                adapters:
                    Order: Adapter
                tokens: ['token1']
            instance = new Order deps
            instance._getUUID = ->
                return inputMessage.data.id
            instance.create inputMessage, () ->

        it 'should callback to the Interactor the outputMessage from the Adapter', (done) ->
            outputMessage =
                data:
                    id: 321
                    some: 'message'

            class Adapter
                create: (params, callback) ->
                    expect(params).to.eql outputMessage
                    callback outputMessage

            deps =
                adapters:
                    Order: Adapter
                tokens: ['token1']
            instance = new Order deps
            instance._getUUID = ->
            instance.create outputMessage, ->
                done()

    describe 'findOrderById()', ->

        it 'should return an error if the resource could not be found by its id', (done) ->

            expectedOutputMessage =
                error: 'NOT_FOUND'

            class Adapter
                findOrderById: (id, callback) ->
                    callback error: 'NOT_FOUND'

            deps =
                adapters:
                    Order: Adapter
                tokens: ['token1']
            instance = new Order deps
            instance.findOrderById 1, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'should return the order if it was found', (done) ->

            expectedOutputMessage =
                success:
                    id: 1
                    amount: 100
                    description: 'some cool stuff'

            class Adapter
                findOrderById: (id, callback) ->
                    callback expectedOutputMessage
            deps =
                adapters:
                    Order: Adapter
                tokens: ['token1']
            instance = new Order deps
            instance.findOrderById 1, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

    describe 'getOrder()', ->

        inputMessage = null

        beforeEach ->

            inputMessage =
                data:
                    auth_token: 'token'
                    field: 'id'
                    value: '1'

        it 'should call adapter.getOrder with auth_token, value and field is ID', (done) ->

            expectedInputMessage =
                domain: 'pay'
                resource: 'orders'
                data:
                    auth_token: inputMessage.data.auth_token
                    field: inputMessage.data.field
                    value: inputMessage.data.value

            MockAdapter = ->
                getOrder: (inputMessage, callback) ->
                    expect(inputMessage).to.eql expectedInputMessage
                    done()

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.getOrder inputMessage, ->

        it 'should call adapter.getOrder with auth_token, value and field is REFERENCE', (done) ->

            inputMessage.data.field = 'reference'

            expectedInputMessage =
                domain: 'pay'
                resource: 'orders'
                data:
                    auth_token: inputMessage.data.auth_token
                    field: inputMessage.data.field
                    value: inputMessage.data.value

            MockAdapter = ->
                getOrder: (inputMessage, callback) ->
                    expect(inputMessage).to.eql expectedInputMessage
                    done()

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.getOrder inputMessage, ->

        it 'should return an error if the resource could not be found by its id', (done) ->

            expectedOutputMessage =
                error: 'NOT_FOUND'

            class Adapter
                getOrder: (id, callback) ->
                    callback error: 'NOT_FOUND'

            deps =
                adapters:
                    Order: Adapter
                tokens: ['token1']
            instance = new Order deps
            instance.getOrder inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'should return the order if it was found', (done) ->

            expectedOutputMessage =
                success:
                    id: 1
                    amount: 100
                    description: 'some cool stuff'

            class Adapter
                getOrder: (id, callback) ->
                    callback expectedOutputMessage
            deps =
                adapters:
                    Order: Adapter
                tokens: ['token1']
            instance = new Order deps
            instance.getOrder inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

    describe 'getToken()', ->

        defaultInputMessage = null
        defaultMockGetDataToken =
            success:
                xml_send:
                    xml: ''
                xml_log:
                    xml: ''

        beforeEach ->
            defaultInputMessage =
                data:
                    id: 'id_test'
                    card_number: '4012001038443335'
                    due_date: '201508'

        it 'should return an error if the getting JSON object', (done) ->

            expectedOutputMessage =
                error: 'Internal Error'

            MockAdapter = ->
                getDataToken: (inputMessage, callback) ->
                    callback expectedOutputMessage

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.getToken defaultInputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'should return an error if there was a problem when saving send request data', (done) ->

            expectedOutputMessage =
                error: 'Internal Error'

            MockAdapter = ->
                getDataToken: (inputMessage, callback) ->
                    callback defaultMockGetDataToken
                saveTransaction: (inputMessage, callback) ->
                    callback expectedOutputMessage

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.getToken defaultInputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'should return an error if there was a problem when sending request post', (done) ->

            expectedOutputMessage =
                error: 'Internal Error'

            MockAdapter = ->
                getDataToken: (inputMessage, callback) ->
                    callback defaultMockGetDataToken
                saveTransaction: (inputMessage, callback) ->
                    callback()
                getToken: (inputMessage, callback) ->
                    callback expectedOutputMessage

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.getToken defaultInputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'should return an error if there was a problem in getting xml response obfuscated', (done) ->

            expectedOutputMessage =
                error: 'Internal Error'

            MockAdapter = ->
                getDataToken: (inputMessage, callback) ->
                    callback defaultMockGetDataToken
                saveTransaction: (inputMessage, callback) ->
                    callback()
                getToken: (inputMessage, callback) ->
                    callback()
                getDataResponseToken: (inputMessage, callback) ->
                    callback expectedOutputMessage

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.getToken defaultInputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'should return an error if there was a problem in saving return XML', (done) ->

            expectedOutputMessage =
                error: 'Internal Error'

            contTransaction = 1
            MockAdapter = ->
                getDataToken: (inputMessage, callback) ->
                    callback defaultMockGetDataToken
                getToken: (inputMessage, callback) ->
                    callback success: xml : '<xml>Transacao Token</xml>'
                getDataResponseToken: (inputMessage, callback) ->
                    callback success: xml_response_log : xml :''
                saveTransaction: (inputMessage, callback) ->
                    if contTransaction is 1
                        contTransaction++
                        callback()
                    else
                        callback expectedOutputMessage

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.getToken defaultInputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'should return an error if there was a problem of converting response XML to JSON', (done) ->

            expectedOutputMessage =
                error: 'Internal Error'

            MockAdapter = ->
                getDataToken: (inputMessage, callback) ->
                    callback defaultMockGetDataToken
                getToken: (inputMessage, callback) ->
                    callback success: xml : ''
                getDataResponseToken: (inputMessage, callback) ->
                    callback success: xml_response_log : xml : ''
                saveTransaction: (inputMessage, callback) ->
                    callback()
                convertCieloResponseToJSON: (inputMessage, callback) ->
                    callback expectedOutputMessage

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.getToken defaultInputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'should return an error if there was a problem to extract token in response JSON', (done) ->

            expectedOutputMessage =
                error: 'Internal Error'

            MockAdapter = ->
                getDataToken: (inputMessage, callback) ->
                    callback defaultMockGetDataToken
                getToken: (inputMessage, callback) ->
                    callback success: xml: ''
                getDataResponseToken: (inputMessage, callback) ->
                    callback success: xml_response_log : xml : ''
                saveTransaction: (inputMessage, callback) ->
                    callback()
                convertCieloResponseToJSON: (inputMessage, callback) ->
                    callback success: data: ''
                getTokenInfo: (inputMessage, callback) ->
                    callback expectedOutputMessage

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.getToken defaultInputMessage, (outputMessage)->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'should return success to extract codigo_cartao_truncado in response JSON', (done) ->

            MockAdapter = ->
                getDataToken: (inputMessage, callback) ->
                    callback defaultMockGetDataToken
                getToken: (inputMessage, callback) ->
                    callback success: xml: ''
                getDataResponseToken: (inputMessage, callback) ->
                    callback success: xml_response_log : xml : '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><retorno-token versao="1.2.1" id="07f0e619f06b10ce60d1" xmlns="http://ecommerce.cbmp.com.br"><token><dados-token><codigo-token>********************************************</codigo-token><status>1</status><numero-cartao-truncado>211141******2104</numero-cartao-truncado></dados-token></token></retorno-token>'
                saveTransaction: (inputMessage, callback) ->
                    callback()
                convertCieloResponseToJSON: (inputMessage, callback) ->
                    callback success: data: ''
                getTokenInfo: (inputMessage, callback) ->
                    callback success: data: ''

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.getToken defaultInputMessage, (outputMessage)->
                expect(outputMessage).to.be.ok
                done()

        it 'should return the expected token when everything is ok', (done) ->

            expectedOutputMessage =
                success:
                    token: 'CYcLHRf84wnbt4CO27ZqshMcg9v4R0vnMdZnZTwMNwo'

            MockAdapter = ->
                getDataToken: (inputMessage, callback) ->
                    callback defaultMockGetDataToken
                getToken: (inputMessage, callback) ->
                    callback success: xml: ''
                getDataResponseToken: (inputMessage, callback) ->
                    callback success: xml_response_log : xml : ''
                saveTransaction: (inputMessage, callback) ->
                    callback()
                convertCieloResponseToJSON: (inputMessage, callback) ->
                    callback success: data: ''
                getTokenInfo: (inputMessage, callback) ->
                    callback expectedOutputMessage

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.getToken defaultInputMessage, (outputMessage)->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

    describe 'synchronizeStatus()', ->

        defaultInputMessage = null

        beforeEach ->
            defaultInputMessage =
                data:
                    tid: '10069930690864281001'

        it 'should return an error if the getting JSON object', (done) ->

            expectedOutputMessage =
                error: 'Internal Error'

            MockAdapter = ->
                getSynchronizeData: (inputMessage, callback) ->
                    callback expectedOutputMessage

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.synchronizeStatus defaultInputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'should return an error if there was a problem when sending request post', (done) ->

            expectedOutputMessage =
                error: 'Internal Error'

            MockAdapter = ->
                getSynchronizeData: (inputMessage, callback) ->
                    callback success: xml: ''
                synchronizeStatus: (inputMessage, callback) ->
                    callback expectedOutputMessage

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.synchronizeStatus defaultInputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'should return an error if there was a problem of converting response XML to JSON', (done) ->

            expectedOutputMessage =
                error: 'Internal Error'

            MockAdapter = ->
                getSynchronizeData: (inputMessage, callback) ->
                    callback success: xml : ''
                synchronizeStatus: (inputMessage, callback) ->
                    callback success: xml : ''
                convertCieloResponseToJSON: (inputMessage, callback) ->
                    callback expectedOutputMessage

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.synchronizeStatus defaultInputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'should return an error if there was a problem to extract token in response JSON', (done) ->

            expectedOutputMessage =
                error: 'Internal Error'

            MockAdapter = ->
                getSynchronizeData: (inputMessage, callback) ->
                    callback success: xml: ''
                synchronizeStatus: (inputMessage, callback) ->
                    callback success: xml: ''
                convertCieloResponseToJSON: (inputMessage, callback) ->
                    callback success: data: ''
                getSynchronizeInfo: (inputMessage, callback) ->
                    callback expectedOutputMessage

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.synchronizeStatus defaultInputMessage, (outputMessage)->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'should return the expected token and xmls when everything is ok', (done) ->

            expectedOutputMessage =
                success:
                    status: 'PROCESSING'

            MockAdapter = ->
                getSynchronizeData: (inputMessage, callback) ->
                    callback success: xml: ''
                synchronizeStatus: (inputMessage, callback) ->
                    callback success: xml: ''
                convertCieloResponseToJSON: (inputMessage, callback) ->
                    callback success: data: ''
                getSynchronizeInfo: (inputMessage, callback) ->
                    callback expectedOutputMessage

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.synchronizeStatus defaultInputMessage, (outputMessage)->
                expect(outputMessage.success.status).to.eql expectedOutputMessage.success.status
                expect(outputMessage.success.synchronizeRequestData).to.be.ok()
                expect(outputMessage.success.synchronizeResponseData).to.be.ok()
                done()

    describe 'updateStatus', ->

        it 'should called updateStatus', (done) ->

            expectedInputMessage =
                data:
                    order_id: '321321321321'
                    status: 'CREATE'
                    change_date: 'hoje'
                    change_datetime: 'hoje'

            class MockMoment
                @utc: ->
                    format: (format) ->
                        'hoje'
            class MockAdapter
                createOrderStatus: (inputMessage, callback) ->
                    expect(inputMessage).to.eql expectedInputMessage
                    done()

            deps =
                moment: MockMoment
                adapters:
                    Order: MockAdapter
                tokens: ['token1']

            inputMessage =
                data:
                    order_id: expectedInputMessage.data.order_id
                    status: expectedInputMessage.data.status

            instance = new Order deps
            instance._getUUID = ->
                return '321321'
            instance.updateStatus inputMessage, ->

    describe 'process()', ->

        expectedMessage = {}

        defaultMockGetDataTransaction =
            success:
                xml_log:
                    xml: ''
                xml_send:
                    xml: ''

        beforeEach ->
            expectedMessage = {}

        describe 'errors', ->

            it 'should return an error if the get transaction data', (done) ->

                inputMessage =
                    data:
                        id: 52
                        issuer: 'mastercard'
                        card_number: 3213234212
                        due_date: 201512
                        sec_code_status: '1',
                        security_code: 1,
                        card_holder: 'JOSE REGO',
                        token: null
                        amount: 200
                        installments: 1
                        payment_type : 'credito_a_vista'
                        description: 'stuff'
                        auth_token: 'token1'
                        reference: '123456'

                expectedError =
                    error: 'Internal Error'

                class MockOrderAdapter
                    getDataTransaction: (inputMessage, callback) ->
                        callback expectedError

                deps =
                    adapters:
                        Order: MockOrderAdapter
                    tokens: ['token1']
                    ip:
                        address: (callback) ->
                            callback 'localhost'
                instance = new Order deps
                instance.process inputMessage, (outputMessage) ->
                    expect(outputMessage).to.eql expectedError
                    done()

            it 'should return an error if the save request transaction data ', (done) ->

                inputMessage =
                    data:
                        id: 52
                        issuer: 'mastercard'
                        card_number: 3213234212
                        due_date: 201512
                        sec_code_status: '1',
                        security_code: 1,
                        card_holder: 'JOSE REGO',
                        token: null
                        amount: 200
                        installments: 1
                        payment_type : 'credito_a_vista'
                        description: 'stuff'
                        auth_token: 'token1'
                        reference: '123456'

                expectedError =
                    error: 'Internal Error'

                class MockOrderAdapter
                    getDataTransaction: (inputMessage, callback) ->
                        callback defaultMockGetDataTransaction
                    saveTransaction: (inputMessage, callback) ->
                        callback expectedError

                deps =
                    adapters:
                        Order: MockOrderAdapter
                    tokens: ['token1']
                    ip:
                        address: (callback) ->
                            callback 'localhost'
                instance = new Order deps
                instance.process inputMessage, (outputMessage) ->
                    expect(outputMessage).to.eql expectedError
                    done()

            it 'should return an error if the save error response transaction data', (done) ->

                inputMessage =
                    data:
                        id: 52
                        issuer: 'mastercard'
                        card_number: 3213234212
                        due_date: 201512
                        sec_code_status: '1',
                        security_code: 1,
                        card_holder: 'JOSE REGO',
                        token: null
                        amount: 200
                        installments: 1
                        payment_type : 'credito_a_vista'
                        description: 'stuff'
                        auth_token: 'token1'
                        reference: '123456'

                expectedError =
                    error: 'Internal Error'

                cont = 1

                class MockOrderAdapter
                    getDataTransaction: (inputMessage, callback) ->
                        callback defaultMockGetDataTransaction
                    saveTransaction: (inputMessage, callback) ->
                        if cont is 1
                            cont++
                            callback()
                        else
                            callback expectedError
                    createTransaction: (inputMessage, callback) ->
                        callback error: {}

                deps =
                    adapters:
                        Order: MockOrderAdapter
                    tokens: ['token1']
                    ip:
                        address: (callback) ->
                            callback 'localhost'
                instance = new Order deps
                instance.process inputMessage, (outputMessage) ->
                    expect(outputMessage).to.eql expectedError
                    done()

            it 'should return an error if the save success response transaction data', (done) ->

                inputMessage =
                    data:
                        id: 52
                        issuer: 'mastercard'
                        card_number: 3213234212
                        due_date: 201512
                        sec_code_status: '1',
                        security_code: 1,
                        card_holder: 'JOSE REGO',
                        token: null
                        amount: 200
                        installments: 1
                        payment_type : 'credito_a_vista'
                        description: 'stuff'
                        auth_token: 'token1'
                        reference: '123456'

                expectedError =
                    error: 'Internal Error'

                cont = 1

                class MockOrderAdapter
                    getDataTransaction: (inputMessage, callback) ->
                        callback defaultMockGetDataTransaction
                    saveTransaction: (inputMessage, callback) ->
                        if cont is 1
                            cont++
                            callback()
                        else
                            callback expectedError
                    createTransaction: (inputMessage, callback) ->
                        callback success: xml : '<transacao><tid>123456789</tid></transacao>'

                deps =
                    adapters:
                        Order: MockOrderAdapter
                    tokens: ['token1']
                    ip:
                        address: (callback) ->
                            callback 'localhost'
                instance = new Order deps
                instance.process inputMessage, (outputMessage) ->
                    expect(outputMessage).to.eql expectedError
                    done()

            it 'should return an error if the converting response transaction data', (done) ->

                inputMessage =
                    data:
                        id: 52
                        issuer: 'mastercard'
                        card_number: 3213234212
                        due_date: 201512
                        sec_code_status: '1',
                        security_code: 1,
                        card_holder: 'JOSE REGO',
                        token: null
                        amount: 200
                        installments: 1
                        payment_type : 'credito_a_vista'
                        description: 'stuff'
                        auth_token: 'token1'
                        reference: '123456'

                expectedError =
                    error: 'Internal Error'

                class MockOrderAdapter
                    getDataTransaction: (inputMessage, callback) ->
                        callback defaultMockGetDataTransaction
                    saveTransaction: (inputMessage, callback) ->
                        callback()
                    createTransaction: (inputMessage, callback) ->
                        callback success: xml : '<transacao><tid>123456789</tid></transacao>'
                    convertCieloResponseToJSON: (inputMessage, callback) ->
                        callback expectedError

                deps =
                    adapters:
                        Order: MockOrderAdapter
                    tokens: ['token1']
                    ip:
                        address: (callback) ->
                            callback 'localhost'
                instance = new Order deps
                instance.process inputMessage, (outputMessage) ->
                    expect(outputMessage).to.eql expectedError
                    done()

            it 'should return an error if the converting XML response to JSON object', (done) ->

                inputMessage =
                    data:
                        id: '65ce2c2c14539370d949'
                        card_number: 3213234212
                        due_date: 201512
                        sec_code_status: '1',
                        security_code: 1,
                        card_holder: 'JOSE REGO',
                        issuer: 'amex'
                        amount: 200
                        description: 'yo mama is so fat i had to sell her'
                        payment_type: 'credito_a_vista'
                        installments: 1
                        auth_token: 'token1'
                        reference: '123456'

                expectedOutputMessage =
                    error: 'Internal Error'

                class Adapter
                    getDataTransaction: (inputMessage, callback) ->
                        callback defaultMockGetDataTransaction
                    saveTransaction: (inputMessage, callback) ->
                        callback()
                    createTransaction: (params, callback) ->
                        callback success: xml : '<transacao><tid>123456789</tid></transacao>'
                    convertCieloResponseToJSON: (inputMessage, callback) ->
                        callback expectedOutputMessage

                deps =
                    adapters:
                        Order: Adapter
                    tokens: ['token1']
                    ip:
                        address: (callback) ->
                            callback 'localhost'
                instance = new Order deps
                instance.process inputMessage, (outputMessage) ->
                    expect(outputMessage).to.eql expectedOutputMessage
                    done()

            it 'should return an error if there was a problem in return expected processing', (done) ->

                inputMessage =
                    data:
                        id: '65ce2c2c14539370d949'
                        card_number: 3213234212
                        due_date: 201512
                        sec_code_status: '1',
                        security_code: 1,
                        card_holder: 'JOSE REGO',
                        issuer: 'amex'
                        amount: 200
                        description: 'yo mama is so fat i had to sell her'
                        payment_type: 'credito_a_vista'
                        installments: 1
                        auth_token: 'token1'
                        reference: '123456'

                expectedOutputMessage =
                    error: 'Internal Error'

                class Adapter
                    getDataTransaction: (inputMessage, callback) ->
                        callback defaultMockGetDataTransaction
                    saveTransaction: (inputMessage, callback) ->
                        callback()
                    createTransaction: (params, callback) ->
                        callback success: xml : '<transacao><tid>123456789</tid></transacao>'
                    convertCieloResponseToJSON: (inputMessage, callback) ->
                        callback {}
                    returnInfoTransaction: (inputMessage, callback) ->
                        callback expectedOutputMessage

                deps =
                    adapters:
                        Order: Adapter
                    tokens: ['token1']
                    ip:
                        address: (callback) ->
                            callback 'localhost'
                instance = new Order deps
                instance.process inputMessage, (outputMessage) ->
                    expect(outputMessage).to.eql expectedOutputMessage
                    done()

            it 'should return an erro if there was a problem connecting to authorizing with return JSON Error', (done) ->
                # Cria erro similar ao erro gerado em produção
                # { error:
                # { [Error: getaddrinfo ENOTFOUND qasecommerce.cielo.com.br]
                #   code: 'ENOTFOUND',
                #   errno: 'ENOTFOUND',
                #   syscall: 'getaddrinfo',
                #   hostname: 'qasecommerce.cielo.com.br' } }
                Error.create 'ENOTFOUND', 'ENOTFOUND', 'description'

                xmlErrorConnection =
                    error: Error.ENOTFOUND

                inputMessage =
                    data:
                        id: '65ce2c2c14539370d949'
                        card_number: 3213234212
                        due_date: 201512
                        sec_code_status: '1',
                        security_code: 1,
                        card_holder: 'JOSE REGO',
                        issuer: 'amex'
                        amount: 200
                        description: 'yo mama is so fat i had to sell her by Andre'
                        payment_type: 'credito_a_vista'
                        installments: 1
                        auth_token: 'token1'
                        reference: '123456'

                expectedOutputMessage =
                    error:
                        code: 'ENOTFOUND'
                        description: 'description'
                        errno: 'ENOTFOUND'

                contSaveTransaction = 1
                class Adapter
                    getDataTransaction: (inputMessage, callback) ->
                        callback defaultMockGetDataTransaction
                    createTransaction: (params, callback) ->
                        callback xmlErrorConnection
                    saveTransaction: (inputMessage, callback) ->
                        if contSaveTransaction is 1
                            contSaveTransaction++
                            callback()
                        else
                            typeContentObject = typeof inputMessage.data.content
                            expect(typeContentObject).to.eql 'string'
                            callback()
                    convertCieloResponseToJSON: (inputMessage, callback) ->
                        throw new Error 'Não deve cair aqui'

                deps =
                    adapters:
                        Order: Adapter
                    tokens: ['token1']
                    ip:
                        address: (callback) ->
                            callback 'localhost'
                instance = new Order deps
                instance.process inputMessage, (outputMessage) ->
                    expect(outputMessage).to.eql expectedOutputMessage
                    done()

            it 'should return an erro if there was a problem connecting to authorizing with return String Error', (done) ->

                expectedOutputMessage =
                    error: 'String Error'

                inputMessage =
                    data:
                        id: '65ce2c2c14539370d949'
                        card_number: 3213234212
                        due_date: 201512
                        sec_code_status: '1',
                        security_code: 1,
                        card_holder: 'JOSE REGO',
                        issuer: 'amex'
                        amount: 200
                        description: 'yo mama is so fat i had to sell her by Andre'
                        payment_type: 'credito_a_vista'
                        installments: 1
                        auth_token: 'token1'
                        reference: '123456'

                contSaveTransaction = 1
                class Adapter
                    getDataTransaction: (inputMessage, callback) ->
                        callback defaultMockGetDataTransaction
                    createTransaction: (params, callback) ->
                        callback expectedOutputMessage
                    saveTransaction: (inputMessage, callback) ->
                        if contSaveTransaction is 1
                            contSaveTransaction++
                            callback()
                        else
                            typeContentObject = typeof inputMessage.data.content
                            expect(typeContentObject).to.eql 'string'
                            callback()
                    convertCieloResponseToJSON: (inputMessage, callback) ->
                        throw new Error 'Não deve cair aqui'

                deps =
                    adapters:
                        Order: Adapter
                    tokens: ['token1']
                    ip:
                        address: (callback) ->
                            callback 'localhost'
                instance = new Order deps
                instance.process inputMessage, (outputMessage) ->
                    expect(outputMessage).to.eql expectedOutputMessage
                    done()

            it 'should return an erro if the card token is invalid', (done) ->

                inputMessage =
                    data:
                        id: 52
                        issuer: 'amex'
                        token: 'qwd7as678asd'
                        amount: 200
                        description: 'yo mama is so fat i had to sell her'
                        payment_type: 'credito_a_vista'
                        installments: 1
                        auth_token: 'token1'
                        reference: '123456'

                outputTransactionMessage =
                    success:
                        xml:
                            '<?xml version="1.0" encoding="ISO-8859-1"?>' +
                            '<erro xmlns="http://ecommerce.cbmp.com.br">' +
                            '<codigo>052</codigo>' +
                            '<mensagem>Token não encontrado.</mensagem>' +
                            '</erro>'

                expectedOutputMessage =
                    error:
                        code: '052'
                        message: 'Token não encontrado.'

                contSaveTransaction = 1
                class Adapter
                    getDataTransaction: (inputMessage, callback) ->
                        callback defaultMockGetDataTransaction
                    createTransaction: (params, callback) ->
                        callback outputTransactionMessage
                    saveTransaction: (inputMessage, callback) ->
                        if contSaveTransaction is 1
                            contSaveTransaction++
                            callback()
                        else
                            typeContentObject = typeof inputMessage.data.content
                            expect(typeContentObject).to.eql 'string'
                            callback()
                    convertCieloResponseToJSON: (inputMessage, callback) ->
                        throw new Error 'Não deve cair aqui'

                deps =
                    adapters:
                        Order: Adapter
                    tokens: ['token1']
                instance = new Order deps
                instance.process inputMessage, (outputMessage) ->
                    expect(outputMessage).to.eql expectedOutputMessage
                    done()

        describe 'validate data', ->

            it 'should set authorize to NO_AUTHENTICATION if the token was not sent and the issuer is not mastercard or visa', (done) ->

                inputMessage =
                    data:
                        id: '65ce2c2c14539370d949'
                        card_number: 3213234212
                        due_date: 201512
                        sec_code_status: 1,
                        security_code: 1,
                        card_holder: 'JOSE REGO',
                        issuer: 'amex'
                        amount: 200
                        description: 'yo mama is so fat i had to sell her'
                        payment_type: 'credito_a_vista'
                        installments: 1
                        auth_token: 'token1'
                        reference: '123456'

                expectedMessage =
                    data:
                        configs:
                            authorize: 'NO_AUTHENTICATION'

                class Adapter
                    getDataTransaction: (inputMessage, callback) ->
                        expect(inputMessage.data.configs.authorize).to.eql expectedMessage.data.configs.authorize
                        done()

                deps =
                    adapters:
                        Order: Adapter
                    tokens: ['token1']
                    ip:
                        address: (callback) ->
                            callback 'localhost'
                instance = new Order deps
                instance.process inputMessage, () ->

            it 'should set authorize to NO_AUTHENTICATION if the token is sent and the issuer is not mastercard or visa', (done) ->

                inputMessage =
                    data:
                        id: 52
                        issuer: 'amex'
                        token: 'qwd7as678asd'
                        amount: 200
                        description: 'yo mama is so fat i had to sell her'
                        payment_type: 'credito_a_vista'
                        installments: 1
                        auth_token: 'token1'
                        reference: '123456'

                expectedMessage =
                    data:
                        configs:
                            authorize: 'NO_AUTHENTICATION'

                class Adapter
                    getDataTransaction: (inputMessage, callback) ->
                        expect(inputMessage.data.configs.authorize).to.eql expectedMessage.data.configs.authorize
                        done()

                deps =
                    adapters:
                        Order: Adapter
                    tokens: ['token1']
                    ip:
                        address: (callback) ->
                            callback 'localhost'
                instance = new Order deps
                instance.process inputMessage, () ->

            it 'should set authorize to NO_AUTHENTICATION if the token is sent and the issuer is mastercard', (done) ->

                inputMessage =
                    data:
                        id: 52
                        issuer: 'mastercard'
                        token: 'qwd7as678asd'
                        amount: 200
                        description: 'yo mama is so fat i had to sell her'
                        payment_type: 'credito_a_vista'
                        installments: 1
                        auth_token: 'token1'
                        reference: '123456'

                expectedMessage =
                    data:
                        configs:
                            authorize: 'NO_AUTHENTICATION'

                class Adapter
                    getDataTransaction: (inputMessage, callback) ->
                        expect(inputMessage.data.configs.authorize).to.eql expectedMessage.data.configs.authorize
                        done()

                deps =
                    adapters:
                        Order: Adapter
                    tokens: ['token1']
                    ip:
                        address: (callback) ->
                            callback 'localhost'
                instance = new Order deps
                instance.process inputMessage, () ->

            it 'should set authorize to NO_AUTHENTICATION if the token is sent and the issuer is visa', (done) ->

                inputMessage =
                    data:
                        id: 52
                        issuer: 'visa'
                        token: 'qwd7as678asd'
                        amount: 200
                        description: 'yo mama is so fat i had to sell her'
                        payment_type: 'credito_a_vista'
                        installments: 1
                        auth_token: 'token1'
                        reference: '123456'

                expectedMessage =
                    data:
                        configs:
                            authorize: 'NO_AUTHENTICATION'

                class Adapter
                    getDataTransaction: (inputMessage, callback) ->
                        expect(inputMessage.data.configs.authorize).to.eql expectedMessage.data.configs.authorize
                        done()

                deps =
                    adapters:
                        Order: Adapter
                    tokens: ['token1']
                    ip:
                        address: (callback) ->
                            callback 'localhost'
                instance = new Order deps
                instance.process inputMessage, () ->

            it 'should set authorize to MAYBE_AUTHENTICATE if issuer is visa and no token is sent', (done) ->

                inputMessage =
                    data:
                        id: 52
                        issuer: 'visa'
                        card_number: 3213234212
                        due_date: 201512
                        sec_code_status: '1',
                        security_code: 1,
                        card_holder: 'JOSE REGO',
                        token: null
                        amount: 200
                        installments: 1
                        payment_type : 'credito_a_vista'
                        description: 'stuff'
                        auth_token: 'token1'
                        reference: '123456'

                expectedMessage =
                    data:
                        configs:
                            authorize: 'MAYBE_AUTHENTICATE'

                class Adapter
                    getDataTransaction: (inputMessage, callback) ->
                        expect(inputMessage.data.configs.authorize).to.eql expectedMessage.data.configs.authorize
                        done()

                deps =
                    adapters:
                        Order: Adapter
                    tokens: ['token1']
                    ip:
                        address: (callback) ->
                            callback 'localhost'
                instance = new Order deps
                instance.process inputMessage, () ->

            it 'should set authorize to NO_AUTHENTICATION if noAuthentication field is set', (done) ->

                inputMessage =
                    data:
                        id: 52
                        issuer: 'visa'
                        card_number: 3213234212
                        due_date: 201512
                        sec_code_status: '1',
                        security_code: 1,
                        card_holder: 'JOSE REGO',
                        token: null
                        amount: 200
                        installments: 1
                        payment_type : 'credito_a_vista'
                        description: 'stuff'
                        auth_token: 'token1'
                        reference: '123456'
                        no_authentication: true

                expectedMessage =
                    data:
                        configs:
                            authorize: 'NO_AUTHENTICATION'

                class Adapter
                    getDataTransaction: (inputMessage, callback) ->
                        expect(inputMessage.data.configs.authorize).to.eql expectedMessage.data.configs.authorize
                        done()

                deps =
                    adapters:
                        Order: Adapter
                    tokens: ['token1']
                    ip:
                        address: (callback) ->
                            callback 'localhost'
                instance = new Order deps
                instance.process inputMessage, () ->

            it 'should set authorize to MAYBE_AUTHENTICATE if issuer is mastercard and no token is sent', (done) ->

                inputMessage =
                    data:
                        id: 52
                        issuer: 'mastercard'
                        card_number: 3213234212
                        due_date: 201512
                        sec_code_status: '1',
                        security_code: 1,
                        card_holder: 'JOSE REGO',
                        token: null
                        amount: 200
                        installments: 1
                        payment_type : 'credito_a_vista'
                        description: 'stuff'
                        auth_token: 'token1'
                        reference: '123456'

                expectedMessage =
                    data:
                        configs:
                            authorize: 'MAYBE_AUTHENTICATE'

                class Adapter
                    getDataTransaction: (inputMessage, callback) ->
                        expect(inputMessage.data.configs.authorize).to.eql expectedMessage.data.configs.authorize
                        done()

                deps =
                    adapters:
                        Order: Adapter
                    tokens: ['token1']
                    ip:
                        address: (callback) ->
                            callback 'localhost'
                instance = new Order deps
                instance.process inputMessage, () ->

        describe 'ok', ->

            it 'should return a object with tid, status and authentication url when everything is ok', (done) ->

                inputMessage =
                    data:
                        id: '65ce2c2c14539370d949'
                        card_number: 3213234212
                        due_date: 201512
                        sec_code_status: '1',
                        security_code: 1,
                        card_holder: 'JOSE REGO',
                        issuer: 'amex'
                        amount: 200
                        description: 'yo mama is so fat i had to sell her'
                        payment_type: 'credito_a_vista'
                        installments: 1
                        auth_token: 'token1'
                        reference: '123456'

                expectedOutputMessage =
                    success:
                        tid: '123456789'
                        status: 'status_test'
                        authenticationUrl: 'authenticationUrl_test'

                class Adapter
                    getDataTransaction: (inputMessage, callback) ->
                        callback defaultMockGetDataTransaction
                    saveTransaction: (inputMessage, callback) ->
                        callback()
                    createTransaction: (params, callback) ->
                        callback success: xml : '<transacao><tid>123456789</tid></transacao>'
                    convertCieloResponseToJSON: (inputMessage, callback) ->
                        callback {}
                    returnInfoTransaction: (inputMessage, callback) ->
                        callback expectedOutputMessage

                deps =
                    adapters:
                        Order: Adapter
                    tokens: ['token1']
                    ip:
                        address: (callback) ->
                            callback 'localhost'
                instance = new Order deps
                instance.process inputMessage, (outputMessage) ->
                    expect(outputMessage).to.eql expectedOutputMessage
                    done()

    describe 'updateOrderInfo', ->

        it 'should called updateOrderInfo expected error return status',(done) ->

            expectedOutputMessage =
                error: 'error status'

            inputMessage =
                data:
                    order_id: '1'
                    status: 'CREATE'
                    update_data: {}

            deps =
                tokens: ['token1']

            instance = new Order deps
            instance.updateStatus = (inputMessage, callback) ->
                callback expectedOutputMessage

            instance.updateOrderInfo inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'should called updateOrderInfo expected error',(done) ->

            expectedOutputMessage =
                error: 'error'

            inputMessage =
                data:
                    order_id: '1'
                    status: 'CREATE'
                    update_data: {}

            class MockUpdateById
                updateOrderById: (order_id, tid, callback) ->
                    callback expectedOutputMessage

            deps =
                adapters:
                    Order: MockUpdateById
                tokens: ['token1']

            instance = new Order deps
            instance.updateStatus = (inputMessage, callback) ->
                callback()

            instance.updateOrderInfo inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'should called updateOrderInfo expected success',(done) ->

            inputMessage =
                data:
                    order_id: '1'
                    status: 'CREATE'
                    update_data: {}

            class MockUpdateById
                updateOrderById: (order_id, tid, callback) ->
                    callback()

            deps =
                adapters:
                    Order: MockUpdateById
                tokens: ['token1']

            instance = new Order deps
            instance.updateStatus = (inputMessage, callback) ->
                callback()

            instance.updateOrderInfo inputMessage, (outputMessage) ->
                expect(outputMessage).not.to.be.ok
                done()

    describe 'updateOrderById', ->

        it 'should called updateOrderById expected error',(done) ->

            expectedOutputMessage =
                error: 'error'

            inputMessage =
                data:
                    order_id: '1'

            inputMessageData =
                status: 'PROCESSING'

            class MockUpdateById
                updateOrderById: (order_id, tid, callback) ->
                    callback expectedOutputMessage

            deps =
                adapters:
                    Order: MockUpdateById
                tokens: ['token1']

            instance = new Order deps
            instance.updateOrderById inputMessage, inputMessageData, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'should called updateOrderInfo expected success',(done) ->

            inputMessage =
                data:
                    order_id: '1'

            inputMessageData =
                status: 'PROCESSING'

            class MockUpdateById
                updateOrderById: (order_id, tid, callback) ->
                    callback()

            deps =
                adapters:
                    Order: MockUpdateById
                tokens: ['token1']

            instance = new Order deps
            instance.updateOrderById inputMessage, inputMessageData, (outputMessage) ->
                expect(outputMessage).to.be.ok
                done()

    describe 'when its cancel method is called', ->

        inputMessage =
            data:
                auth_token: 'token1'
                reference: '0123456789'
                order_id: 'UUID_RANDOM'
                tid: '01234567890123456789'

        it 'deverá receber um erro ao buscar os dados para envio autorizadora', (done)->

            expectedOutputMessage =
                error: 'Internal Error'

            MockAdapter = ->
                getCancelData: (inputMessage, callback) ->
                    callback expectedOutputMessage

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.cancel inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'deverá receber um erro ao salvar os dados de envio para autorizadora', (done) ->

            expectedOutputMessage =
                error: 'Internal Error'

            MockAdapter = ->
                getCancelData: (inputMessage, callback) ->
                    callback success: xml_log : xml : '<xml>XML SEND AUTORIZADORA</xml>'
                saveTransaction: (inputMessage, callback) ->
                    callback expectedOutputMessage

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.cancel inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        describe 'valida todas as possibilidades de erro da autorizadora', ->

            it 'should return an erro if there was a problem connecting to authorizing with return JSON Error', (done) ->
                # Cria erro similar ao erro gerado em produção
                # { error:
                # { [Error: getaddrinfo EIO]
                #   code: 'EIO',
                #   errno: 'EIO',
                #   syscall: 'getaddrinfo',
                #   hostname: 'qasecommerce.cielo.com.br' } }
                Error.create 'EIO', 'EIO', 'description'

                xmlErrorConnection =
                    error: Error.EIO

                expectedOutputMessage =
                    error:
                        code: 'EIO'
                        description: 'description'
                        errno: 'EIO'

                uuid = '65445665-1-1-1-321321321321'
                mockedUuid = '65445665321321321321'

                expectedInputMessage =
                    data:
                        id: mockedUuid
                        auth_token: inputMessage.data.auth_token
                        reference: inputMessage.data.reference
                        type: 'cancel'
                        type_req: 'response'
                        order_id: inputMessage.data.order_id
                        tid: inputMessage.data.tid
                        content: JSON.stringify expectedOutputMessage.error
                        created: '2015-01-01T00:00:00'

                contSaveTransaction = 1
                class Adapter
                    getCancelData: (inputMessage, callback) ->
                        callback success: xml_log : xml : '<xml>XML SEND AUTORIZADORA</xml>'
                    saveTransaction: (inputMessageSaveTransaction, callback) ->
                        if contSaveTransaction is 1
                            contSaveTransaction++
                            callback()
                        else
                            expect(inputMessageSaveTransaction).to.eql expectedInputMessage
                            done()
                    cancelOrder: (inputMessage, callback) ->
                        callback expectedOutputMessage

                class MockUUID
                    @v4: ->
                        uuid

                deps =
                    uuid: MockUUID
                    adapters:
                        Order: Adapter
                    tokens: ['token1']
                    moment:
                        utc: (object) ->
                            moment =
                                format: () ->
                                    '2015-01-01T00:00:00'

                instance = new Order deps
                instance.cancel inputMessage, (outputMessage) ->
                    expect(outputMessage).to.eql expectedOutputMessage
                    done()

            it 'deverá validar se recebeu um erro em STRING da autorizadora', (done)->

                outputMessage =
                    error: 'Internal Error'

                uuid = '65445665-1-1-1-321321321321'
                mockedUuid = '65445665321321321321'

                expectedInputMessage =
                    data:
                        id: mockedUuid
                        auth_token: inputMessage.data.auth_token
                        reference: inputMessage.data.reference
                        type: 'cancel'
                        type_req: 'response'
                        order_id: inputMessage.data.order_id
                        tid: inputMessage.data.tid
                        content: outputMessage.error
                        created: '2015-01-01T00:00:00'

                contSaveTransaction = 1
                MockAdapter = ->
                    getCancelData: (inputMessage, callback) ->
                        callback success: xml_log : xml : '<xml>XML SEND AUTORIZADORA</xml>'
                    saveTransaction: (inputMessageSaveTransaction, callback) ->
                        if contSaveTransaction is 1
                            contSaveTransaction++
                            callback()
                        else
                            expect(inputMessageSaveTransaction).to.eql expectedInputMessage
                            done()
                    cancelOrder: (inputMessage, callback) ->
                        callback outputMessage
                class MockUUID
                    @v4: ->
                        uuid

                deps =
                    uuid: MockUUID
                    tokens: ['token1']
                    moment:
                        utc: (object) ->
                            moment =
                                format: () ->
                                    '2015-01-01T00:00:00'
                    adapters:
                        Order: MockAdapter

                instance = new Order deps
                instance.cancel inputMessage, ->

            it 'deverá receber um erro caso for enviado um token inválido para autorizadora', (done) ->

                outputTransactionMessage =
                        success:
                            xml:
                                '<?xml version="1.0" encoding="ISO-8859-1"?>' +
                                '<erro xmlns="http://ecommerce.cbmp.com.br">' +
                                '<codigo>052</codigo>' +
                                '<mensagem>Token não encontrado.</mensagem>' +
                                '</erro>'

                expectedOutputMessage =
                    error:
                        code: '052'
                        message: 'Token não encontrado.'

                MockAdapter = ->
                    getCancelData: (inputMessage, callback) ->
                        callback success: xml_log : '<xml>XML SEND AUTORIZADORA</xml>'
                    saveTransaction: (inputMessage, callback) ->
                        callback()
                    cancelOrder: (inputMessage, callback) ->
                        callback outputTransactionMessage

                deps =
                    tokens: ['token1']
                    adapters:
                        Order: MockAdapter

                instance = new Order deps
                instance.cancel inputMessage, (outputMessage) ->
                    expect(outputMessage).to.eql expectedOutputMessage
                    done()

        it 'deverá receber um erro ao salvar os dados de retorno da autorizadora', (done)->

            expectedOutputMessage =
                error: 'Internal Error'

            contSaveTransaction = 1
            MockAdapter = ->
                getCancelData: (inputMessage, callback) ->
                    callback success: xml_log : '<xml>XML SEND AUTORIZADORA</xml>'
                saveTransaction: (inputMessage, callback) ->
                    if contSaveTransaction is 1
                        contSaveTransaction++
                        callback()
                    else
                        callback expectedOutputMessage
                cancelOrder: (inputMessage, callback) ->
                    callback success: xml : '<xml>XML RESPONSE AUTORIZADORA</xml>'

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.cancel inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'deverá receber um erro na atualização do status na nossa base', (done) ->

            outputTransactionMessage =
                success:
                    xml:
                        '<?xml version="1.0" encoding="ISO-8859-1"?>' +
                        '<erro xmlns="http://ecommerce.cbmp.com.br">' +
                        '<codigo>041</codigo>' +
                        '<mensagem>Tid já cancelado.</mensagem>' +
                        '</erro>'

            expectedOutputMessage =
                error: 'Internal Error'

            MockAdapter = ->
                getCancelData: (inputMessage, callback) ->
                    callback success: xml_log : '<xml>XML SEND AUTORIZADORA</xml>'
                saveTransaction: (inputMessage, callback) ->
                    callback()
                cancelOrder: (inputMessage, callback) ->
                    callback outputTransactionMessage
                createOrderStatus: (inputMessage, callback) ->
                    callback expectedOutputMessage

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.cancel inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'deverá receber um erro caso a transação já estiver cancelada na autorizadora', (done) ->

            outputTransactionMessage =
                success:
                    xml:
                        '<?xml version="1.0" encoding="ISO-8859-1"?>' +
                        '<erro xmlns="http://ecommerce.cbmp.com.br">' +
                        '<codigo>041</codigo>' +
                        '<mensagem>Tid já cancelado.</mensagem>' +
                        '</erro>'

            expectedOutputMessage =
                error:
                    code: '041'
                    message: 'Transação já está cancelada'

            MockAdapter = ->
                getCancelData: (inputMessage, callback) ->
                    callback success: xml_log : '<xml>XML SEND AUTORIZADORA</xml>'
                saveTransaction: (inputMessage, callback) ->
                    callback()
                cancelOrder: (inputMessage, callback) ->
                    callback outputTransactionMessage
                createOrderStatus: (inputMessage, callback) ->
                    callback()

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.cancel inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'deverá receber um callback sem parâmetros quando tudo ocorreu sem erros', (done)->

            changeDate = '2015-01-01 00:00:00'

            expectedOrderStatus =
                data:
                    order_id: inputMessage.data.order_id
                    status: 'REFUNDED'
                    change_date: changeDate
                    change_datetime: changeDate

            MockAdapter = ->
                getCancelData: (inputMessage, callback) ->
                    callback success: xml_log : '<xml>XML SEND AUTORIZADORA</xml>'
                saveTransaction: (inputMessage, callback) ->
                    callback()
                cancelOrder: (inputMessage, callback) ->
                    callback success: xml : '<xml>XML RESPONSE AUTORIZADORA</xml>'
                convertCieloResponseToJSON: (inputMessage, callback) ->
                    callback()
                createOrderStatus: (inputMessage, callback) ->
                    expect(inputMessage).to.eql expectedOrderStatus
                    callback()

            class MockMoment
                @utc: ->
                    format: (format) ->
                        changeDate

            deps =
                tokens: ['token1']
                moment: MockMoment
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.cancel inputMessage, (outputMessage) ->
                expect(outputMessage).not.to.be.ok()
                done()

    describe '_getUUID()', ->

    describe 'applyTax', ->

        inputMessage = null

        beforeEach ->
            inputMessage =
                data:
                    auth_token: 'AUTH_TOKEN'
                    amount: 500

        it 'should call the get contract method with the passed auth_token', (done)->

            expectedAuthToken = inputMessage.data.auth_token

            MockAdapter = ->
                getContract: (inputMessage, callback) ->
                    expect(inputMessage.data.auth_token).to.eql expectedAuthToken
                    done()

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.applyTax inputMessage, ->

        it 'should return an error if getContract failed', (done)->

            expectedOutputMessage =
                error: 'Internal Error'

            MockAdapter = ->
                getContract: (inputMessage, callback) ->
                    callback expectedOutputMessage

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.applyTax inputMessage, (outputMessage)->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'deverá aplicar apenas o calculo de taxa sem valor por transação', (done) ->

            expectedOutputMessage =
                success:
                    original_amount: 500
                    amount: 495
                    tax: 100
                    per_transaction: 0

            outputGetContract =
                success:
                    tx_adm: 100
                    amount_per_transaction: 0

            MockAdapter = ->
                getContract: (inputMessage, callback) ->
                    callback outputGetContract

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.applyTax inputMessage, (outputMessage)->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'deverá aplicar apenas o calculo do valor por transação sem a taxa', (done) ->

            expectedOutputMessage =
                success:
                    original_amount: 500
                    amount: 490
                    tax: 0
                    per_transaction: 10

            outputGetContract =
                success:
                    tx_adm: 0
                    amount_per_transaction: 10

            MockAdapter = ->
                getContract: (inputMessage, callback) ->
                    callback outputGetContract

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.applyTax inputMessage, (outputMessage)->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

        it 'should return the original amount, amount, tax and per transaction value', (done) ->

            expectedOutputMessage =
                success:
                    original_amount: 500
                    amount: 490
                    tax: 100
                    per_transaction: 5

            outputGetContract =
                success:
                    tx_adm: 100
                    amount_per_transaction: 5

            MockAdapter = ->
                getContract: (inputMessage, callback) ->
                    callback outputGetContract

            deps =
                tokens: ['token1']
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.applyTax inputMessage, (outputMessage)->
                expect(outputMessage).to.eql expectedOutputMessage
                done()

    describe 'authorizedAmountPerDay', ->

        it 'should call getAmountPerDayByStatus', (done) ->

            expectedInputMessage =
                data:
                    auth_token: 'token1'
                    status: 'AUTHORIZED'
                    change_date: '2010-01-01'

            class MockAdapter
                getAmountPerDayByStatus: (inputMessage, callback) ->
                    expect(inputMessage).to.eql expectedInputMessage
                    done()

            deps =
                adapters:
                    Order: MockAdapter
                tokens: ['token1']

            inputMessage =
                data:
                    auth_token: expectedInputMessage.data.auth_token
                    last_date: expectedInputMessage.data.change_date

            instance = new Order deps
            instance.authorizedAmountPerDay inputMessage, ->

    describe 'refundedAmountPerDay', ->

        it 'should call getAmountPerDayByStatus', (done) ->

            expectedInputMessage =
                data:
                    auth_token: 'token1'
                    status: 'REFUNDED'
                    change_date: '2010-01-01'

            class MockAdapter
                getAmountPerDayByStatus: (inputMessage, callback) ->
                    expect(inputMessage).to.eql expectedInputMessage
                    done()

            deps =
                adapters:
                    Order: MockAdapter
                tokens: ['token1']

            inputMessage =
                data:
                    auth_token: expectedInputMessage.data.auth_token
                    last_date: expectedInputMessage.data.change_date

            instance = new Order deps
            instance.refundedAmountPerDay inputMessage, ->

    describe 'saveTransaction', ->

        it 'should wrap the adapter saveTransaction method', (done) ->
            expectedInputMessage =
                data:
                    some: 'object'

            class MockAdapter
                saveTransaction: (inputMessage, callback) ->
                    expect(inputMessage).to.eql expectedInputMessage
                    done()

            deps =
                adapters:
                    Order: MockAdapter
                tokens: ['token1']

            inputMessage =
                data:
                    some: 'object'

            instance = new Order deps
            instance.saveTransaction inputMessage, ->

    describe 'statusList()', ->

        inputMessage = null

        beforeEach ->

            inputMessage =
                data:
                    auth_token: 'token'
                    order_list: 'aserwe, werasdf'

        it 'should return an error if it happens', (done) ->

            expectedInputMessage =
                domain: 'pay'
                resource: 'orders'
                data:
                    auth_token: inputMessage.data.auth_token
                    list: inputMessage.data.order_list.split ','

            expectedOutput =
                error: 'internal server wtf'

            MockAdapter = ->
                getStatuses: (inputMessage, callback) ->
                    expect(inputMessage).to.eql expectedInputMessage
                    callback expectedOutput

            deps =
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.statusList inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutput
                done()

        it 'should return NOT_FOUND if nothing was found', (done) ->

            expectedOutput =
                error: 'NOT_FOUND'

            MockAdapter = ->
                getStatuses: (inputMessage, callback) ->
                    callback expectedOutput

            deps =
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.statusList inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutput
                done()

        it 'should return the orders list if found', (done) ->

            expectedOutput =
                success: [
                    {
                        id: 'e3oijasldkf'
                        status: 'AUTHORIZED'
                    }
                    {
                        id: 'e3oijasldkf'
                        status: 'REJECTED'
                    }
                ]

            MockAdapter = ->
                getStatuses: (inputMessage, callback) ->
                    callback expectedOutput

            deps =
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.statusList inputMessage, (outputMessage) ->
                expect(outputMessage).to.eql expectedOutput
                done()

    describe 'getProcessable()', ->

        inputMessage = null

        it 'should return an error if it happens', (done) ->

            expectedInputMessage =
                domain: 'pay'
                resource: 'orders'

            expectedOutput =
                error: 'internal server wtf'

            MockAdapter = ->
                getProcessable: (params, callback) ->
                    expect(params).to.eql expectedInputMessage
                    callback expectedOutput

            deps =
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.getProcessable (outputMessage) ->
                expect(outputMessage).to.eql expectedOutput
                done()

        it 'should return NOT_FOUND if nothing was found', (done) ->

            expectedOutput =
                error: 'NOT_FOUND'

            MockAdapter = ->
                getProcessable: (params, callback) ->
                    callback expectedOutput

            deps =
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.getProcessable (outputMessage) ->
                expect(outputMessage).to.eql expectedOutput
                done()

        it 'should return the orders list if found', (done) ->

            expectedOutput =
                success: [
                    {
                        id: 'e3oijasldkf'
                        status: 'AUTHORIZED'
                    }
                    {
                        id: 'e3oijasldkf'
                        status: 'PROCESSING'
                    }
                ]

            MockAdapter = ->
                getProcessable: (params, callback) ->
                    callback expectedOutput

            deps =
                adapters:
                    Order: MockAdapter

            instance = new Order deps
            instance.getProcessable (outputMessage) ->
                expect(outputMessage).to.eql expectedOutput
                done()
