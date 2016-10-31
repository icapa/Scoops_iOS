#Práctica Cloud Computing Keepcoding 3



##Parte de cliente iOS

#####*https://github.com/icapa/Scoops_iOS*

##La parte de backend está aquí:
#####*https://github.com/icapa/Scoops_Backend*

##Actualización de publicaciones
Para la actualización de las publicaciones se utiliza una "Function" de Azure que todos los días a las 00:00 lleva a cabo la actualización.


```node

var sql = require('mssql')


module.exports = function(context, myTimer) {
    if(myTimer.isPastDue)
    {
        context.log('Node.js is running late!');
    }
    context.log("Timer last triggered at " + myTimer.last);
    context.log("Timer triggered at " + myTimer.next); 
    var config = {
        user: 'administrador',
        password: '|@#ivanolea123',
        server: 'icapabbdd.database.windows.net', // You can use 'localhost\\instance' to connect to named instance 
        database: 'practicamobile',
 
        options: {
            encrypt: true // Use this if you're on Windows Azure 
        }
    }
 

    sql.connect(config)
        .then(function() {
        
            new sql.Request().query("UPDATE AuthorPosts set published=wantPublish")
                .then(function(recordset) {
                    context.log("All news published");
                }).catch(function(err) {
                    context.log(err);
                });

        }).catch(function(err) {
            context.log(err);
        });



    context.done();
}

```