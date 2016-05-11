dbHost = process.env.OPENSHIFT_MYSQL_DB_HOST || 'localhost';
dbPort = process.env.OPENSHIFT_MYSQL_DB_PORT || 3306;
dbUser = process.env.OPENSHIFT_MYSQL_DB_USERNAME || 'root';
dbPassword = process.env.OPENSHIFT_MYSQL_DB_PASSWORD || '';
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
