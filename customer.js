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

  var mysqlEventWatcher = MySQLEvents(akauntingdb);
  var watcher = mysqlEventWatcher.add(
    'akaunting',
    function (oldRow, newRow, event) {
      
      if(event.tableId==118){
       
        var kullanici=newRow.fields;
        if (oldRow === null) {
  
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
        console.log(event.tableId);

      }

      if(event.tableId==126){
        var product=newRow.fields;  
            if (oldRow === null) {
      
               let sql = `INSERT INTO oc_product(product_id, model, sku,
                upc, ean, jan, isbn, mpn, location,quantity,
                stock_status_id, image, manufacturer_id, shipping,
                price, points, tax_class_id, date_available, weight,
                weight_class_id, length, width, height,
                length_class_id, subtract, minimum, sort_order,
                status, date_added, date_modified) 
              
                VALUES ('${product.id}',
                'Product ${product.id}',
                '${product.sku}','', '', '', '', '','',
                '${product.quantity}','1','NULL', 
                '${product.company_id}','1',
                '${product.sale_price}','0.0000', '1',
                '${date}', '0.00000000', '1', 
                '0.00000000', '0.00000000',
                 '0', '1', '1', '1', '0',
                '${product.enabled}', 
                '${date}','${date}')`;
      
               let sql1=`INSERT INTO oc_product_description(product_id,
                language_id,name,description,tag,
                meta_title,meta_description,meta_keyword)
               VALUES('${product.id}','1',
               '${product.name}','${product.description}'
               ,'', '', '', '')`;
      
      var query = opencart.query(sql, function (error, results, fields) {
        if (error) throw error;
        console.log('eKLENEN Ürün Id:' + results.insertId);
      });
      
         var query = opencart.query(sql1, function (error, results, fields) {
              if (error) throw error;
              console.log('eKLENEN Ürün Id:' + results.insertId);
            });
            }
      
        if (oldRow !== null && newRow !== null) {
          var product=oldRow.fields;
          if (event.rows[0].after.deleted_at != null) {
        
          let sql=`DELETE FROM oc_product WHERE product_id=${product.id}`;
          let sql1=`DELETE FROM oc_product_description WHERE product_id=${product.id}`;
        
          var query = opencart.query(sql, function (error, results, fields) {
            if (error) throw error;
            console.log('sİLİNEN Ürün Id:' + product.id);
          });
          var query = opencart.query(sql1, function (error, results, fields) {
            if (error) throw error;
            console.log('sİLİNEN Ürün Id:' + product.id);
          });
      }
        }
      }

      

});
  
  
var opencartdb = {
  host: 'localhost',
  user: 'root',
  password: '' 
};
var mysqlEventWatcher = MySQLEvents(opencartdb);

var akaunting = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'akaunting'
});

akaunting.connect();

var order;

var watcher = mysqlEventWatcher.add(
  'opencart.oc_order',
  function (oldRow, newRow, event) {
      
    if (oldRow === null) {

      order = newRow.fields;
      console.log(order);
       let sql = `INSERT INTO dgi_invoices(id, company_id, invoice_number, order_number, invoice_status_code, invoiced_at, due_at, amount, currency_code, currency_rate, customer_id, customer_name, customer_email, customer_phone, customer_address, notes, created_at, updated_at, category_id, parent_id)  VALUES ('${order.order_id}','1','${order.invoice_prefix}','${order.order_id}','draft','${date}','${date}','${order.total}','${order.currency_code}','${order.currency_id}','${order.customer_id}','${order.firstname} ${order.lastname}','${order.email}','${order.telephone}','${order.shipping_country} ${order.shipping_city} ${order.shipping_address_1}','${order.comment}','${date}','${date}','${order.marketing_id}','0')`;

       let sql1=`INSERT INTO dgi_invoice_items( company_id, invoice_id, item_id, name , sku , quantity, price, total, tax, tax_id ,created_at,updated_at)  VALUES('1','${order.order_id}','${order.order_id}','draft','${date}','${date}','${order.total}','${order.currency_code}')`;
       

        var query = akaunting.query(sql, function (error, results, fields) {
          if (error) throw error;
          console.log('eKLENENE Müşteri Id:' + results.insertId);
         });
     }

    if (oldRow !== null && newRow !== null) {

    }


  },
  'Active'
);
  
  