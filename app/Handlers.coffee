module.exports =
    authorizationParser: true
    bodyParser: true
    queryParser: true
    easyOauth:
        enable: false
        secret: 'testSecret'
        clients: [
            {
            clientId: 'root'
            clientSecret: '112233'
            validResources: ['currencies']
            }
            {
            clientId: 'root2'
            clientSecret: '445566'
            validResources: ['currencies']
            }
        ]
        expiry: 5
