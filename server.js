
    var MySQLEvents = require('mysql-events');
    var mysql = require('mysql');
    var format = require('date-format');

    format(); 
    format(new Date());
    var date=format('yyyy-MM-dd hh:mm:ss', new Date());

    var akauntingdb = {
        host: 'localhost',
        user: 'root',
        password: '' // no password set that's why keep blank
    };

    var opencart = mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: '',
        database: 'opencart'
    });

    

  opencart.connect();
  //---------------------------------------------------------------------------------------------

  var mysqlEventWatcher = MySQLEvents(akauntingdb);
  var watcher = mysqlEventWatcher.add(
    'akaunting',
    function (oldRow, newRow, event) {
        
      if (oldRow === null) {

      }

      if (oldRow !== null && newRow !== null) {


      }
      console.log(event);

    },
    'Active'
  );

 