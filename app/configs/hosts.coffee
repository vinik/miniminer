dbHost = process.env.OPENSHIFT_MYSQL_DB_HOST || '127.0.0.1';
dbPort = process.env.OPENSHIFT_MYSQL_DB_PORT || 3306;
dbUser = process.env.OPENSHIFT_MYSQL_DB_USERNAME || 'root';
dbPassword = process.env.OPENSHIFT_MYSQL_DB_PASSWORD || 'changeme';
dbName = process.env.OPENSHIFT_GEAR_NAME || 'miniminer';


module.exports =
    mysqlParams:
        host : dbHost
        port: dbPort
        poolSize : 10
        user : dbUser
        password : dbPassword
        domain : dbName
        resource : 'currencies'
    coinmarketcap:
        url: "https://api.coinmarketcap.com/v1/"
