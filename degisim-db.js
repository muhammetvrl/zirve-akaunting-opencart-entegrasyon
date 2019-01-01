var degisim = function(){
  var mysql = require('mysql');

  var connection = mysql.createConnection({
    host     : 'localhost',
    user     : 'root',
    password : '',
    database : 'opencart'
  });
  
  var data = [];
  connection.connect();
  
  connection.query('SELECT * FROM degisim_musteri', function(err, rows, fields) {

    if (err) {
      res.status(500).json({"status_code": 500,"status_message": "internal server error"});
    } else {
      
     rows.forEach(element => {
       var customer= {
        islem: element.islem,
        id: element.customer_id,      
        firstname: element.firstname,
        lastname: element.lastname,
        email: element.email,
        telephone: element.telephone,
         }
         data.push(customer);
     });
    }

  connection.end();
  }
  )
}
module.exports=degisim;
