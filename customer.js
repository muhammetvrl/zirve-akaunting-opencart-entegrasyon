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
  var mysqlEventWatcher = MySQLEvents(akauntingdb);
  
  var opencart = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'opencart'
  });
  
  opencart.connect();

  let kullanici;
  
  var watcher = mysqlEventWatcher.add(
    'akaunting.dgi_customers',
    function (oldRow, newRow, event) {
        
      if (oldRow === null) {

        let kullanici = { id, user_id, companyid, password, name, email, tax_number, phone, address, website, currency_code, enable, created_at, updated_at, deleted_at } = newRow.fields;

        var name=String(kullanici.name);
        name=name.split(" ");
  
         let sql = `INSERT INTO oc_customer(customer_id, customer_group_id, language_id, firstname, lastname,email, telephone, fax, password, salt, cart, wishlist, newsletter, address_id, custom_field, ip, status, safe, token, code, date_added)  VALUES ('${kullanici.id}', '1', '0', '${name[0]}', '${name[1]}', '${kullanici.email}', '${kullanici.phone}', 'null', 'null', 'null', NULL, NULL, '0', '0', '', '', '1', '1', '', '', '${date}')`;
  
         var query = opencart.query(sql, function (error, results, fields) {
           if (error) throw error;
           console.log('eKLENENE Müşteri Id:' + results.insertId);
         });
      }
  


      if (oldRow !== null && newRow !== null) {

          if (event.rows[0].before.name === event.rows[0].after.name && event.rows[0].before.phone === event.rows[0].after.phone && event.rows[0].before.email === event.rows[0].after.email) {
            let kullanici = { id, user_id, companyid, password, name, email, tax_number, phone, address, website, currency_code, enable, created_at, updated_at, deleted_at } = oldRow.fields;
            let sql=`DELETE FROM oc_customer WHERE customer_id=${kullanici.id}`;
    
            var query = opencart.query(sql, function (error, results, fields) {
              if (error) throw error;
              console.log('sİLİNENE Müşteri Id:' + kullanici.id);
            });
      
          }
          else
          {
            let kullanici = { id, user_id, companyid, password, name, email, tax_number, phone, address, website, currency_code, enable, created_at, updated_at, deleted_at } = newRow.fields;

            var name=String(kullanici.name);
            name=name.split(" ");
            
            let sql =`UPDATE oc_customer SET firstname='${name[0]}', lastname='${name[1]}' , email='${kullanici.email}', telephone='${kullanici.phone}' WHERE customer_id = ${kullanici.id}`;
  
            var query = opencart.query(sql, function (error, results, fields) {
              if (error) throw error;
              console.log('gÜNCELLENEN Müşteri Id:' + kullanici.id);
            });
          }
      }
      console.log(event.rows[0].before);

    },
    'Active'
  );
  
  