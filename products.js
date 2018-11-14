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

  var product;

  var watcher = mysqlEventWatcher.add(
    'akaunting.dgi_items',
    function (oldRow, newRow, event) {
        
      if (oldRow === null) {

        product=newRow.fields;
  
         let sql = `INSERT INTO oc_product(product_id, model, sku, upc, ean, jan, isbn, mpn, location,quantity, stock_status_id, image, manufacturer_id, shipping, price, points, tax_class_id, date_available, weight, weight_class_id, length, width, height, length_class_id, subtract, minimum, sort_order, status, date_added, date_modified) 
         VALUES ('${product.id}', 'Product ${product.id}','${product.sku}','', '', '', '', '','','${product.quantity}','1','NULL', '${product.company_id}','1','${product.sale_price}','0.0000', '1', '${date}', '0.00000000', '1', '0.00000000', '0.00000000', '0', '1', '1', '1', '0', '${product.enabled}', '${date}','${date}')`;

         let sql1=`INSERT INTO oc_product_description(product_id,language_id,name,description,tag,meta_title,meta_description,meta_keyword)
         VALUES('${product.id}','1','${product.name}','${product.description}','', '', '', '')`;

          var query = opencart.query(sql, function (error, results, fields) {
            if (error) throw error;
            console.log('eKLENENE Ürün Id:' + results.insertId);
          });

          var query = opencart.query(sql1, function (error, results, fields) {
            if (error) throw error;
            console.log('eKLENENE Ürün Id:' + results.insertId);
          });
      }

      if (oldRow !== null && newRow !== null) {
        var product=oldRow.fields;
        if (event.rows[0].after.deleted_at != null) {

        let sql=`DELETE FROM oc_product WHERE product_id=${product.id}`;
        let sql1=`DELETE FROM oc_product_description WHERE product_id=${product.id}`;

        var query = opencart.query(sql, function (error, results, fields) {
          if (error) throw error;
          console.log('sİLİNEN Müşteri Id:' + product.id);
        });
        var query = opencart.query(sql1, function (error, results, fields) {
          if (error) throw error;
          console.log('sİLİNEN Müşteri Id:' + product.id);
        });
      }
      else{
        let sql =`UPDATE oc_product SET  sku='${event.rows[0].after.sku}' , price='${event.rows[0].after.sale_price}', quantity='${event.rows[0].after.quantity}' WHERE product_id = ${event.rows[0].after.id}`;

        let sql1 =`UPDATE oc_product_description SET  name='${event.rows[0].after.name}' , description='${event.rows[0].after.description}' WHERE product_id = ${product.id}`;
  
            var query = opencart.query(sql, function (error, results, fields) {
              if (error) throw error;
              console.log('gÜNCELLENEN Müşteri Id:' + product.id);
            });

            var query = opencart.query(sql1, function (error, results, fields) {
              if (error) throw error;
              console.log('gÜNCELLENEN Müşteri Id:' + product.id);
            });
            
      }

      }

    },
    'Active'
  );


  
  