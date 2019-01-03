
var order = function(){
  console.log("Opencart Fatura Takip Başarılı")
  var MySQLEvents = require('mysql-events');
  var mysql = require('mysql');
  var format = require('date-format');

  format(); 
  format(new Date());
  var date=format('yyyy-MM-dd hh:mm:ss', new Date());


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
  
  var opencart = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'opencart'
  });
  akaunting.connect();
  opencart.connect();
  
  var order;
  
  var watcher = mysqlEventWatcher.add(
    'opencart.oc_order',
    function (oldRow, newRow, event) {
    var orderproduct;
    if (oldRow === null) {

    var order = newRow.fields;
    var resultdata;
        let sql = `INSERT INTO dgi_invoices(id, company_id, invoice_number, order_number, invoice_status_code, invoiced_at, due_at, amount, currency_code, currency_rate, customer_id, customer_name, customer_email, customer_phone, customer_address, notes, created_at, updated_at, category_id, parent_id)  VALUES ('${order.order_id}','1','${order.invoice_prefix}+${order.order_id}','${order.order_id}','draft','${date}','${date}','${order.total}','${order.currency_code}','${order.currency_id}','${order.customer_id}','${order.firstname} ${order.lastname}','${order.email}','${order.telephone}','${order.shipping_country} ${order.shipping_city} ${order.shipping_address_1}','${order.comment}','${date}','${date}','${order.marketing_id}','0')`;

        var query = akaunting.query(sql, function (error, results, fields) {
        if (error) throw error;
        console.log('eKLENENE Müşteri Id:' + results.insertId);
        });

        let sql2=`SELECT * FROM oc_order_product WHERE order_id="${order.order_id}"`;

        var query = opencart.query(sql2, function (error, results, fields)  {
        if (error) throw error;
        
        var product={
            order_product_id: results[0].order_product_id,
            order_id: results[0].order_id,
            product_id: results[0].product_id,
            name: results[0].name,
            model: results[0].model,
            quantity: results[0].quantity,
            price: results[0].price,
            total: results[0].total,
            tax: results[0].tax,
            reward: results[0].reward 
        }
            let sql1=`INSERT INTO dgi_invoice_items(id,company_id, invoice_id, item_id, name , quantity, price, total, tax, tax_id ,created_at,updated_at)  VALUES(${product.order_id},'1','${order.order_id}','1','${product.name}','${product.quantity}','${product.price}','${product.total}','${product.tax}','1','${date}','${date}')`;

            var query = akaunting.query(sql1, function (error, results, fields) {
            if (error) throw error;
            console.log('eKLENENE Müşteri Id:' + results.insertId);
            });   

        });
    }

    if (newRow === null) {
    var order = oldRow.fields;
        let sql=`DELETE FROM dgi_invoices WHERE id=${order.order_id}`;
        let sql1=`DELETE FROM dgi_invoice_items WHERE id=${order.order_id}`;
        var query = akaunting.query(sql, function (error, results, fields) {
            if (error) throw error;
            console.log('Silinen Siparis Id:' + order.order_id);
            });

            var query = akaunting.query(sql1, function (error, results, fields) {
            if (error) throw error;
            console.log('Silinen Siparis Id:' + order.order_id);
            });

          
    }
    
   if (oldRow !== null && newRow !== null) {

        var order = newRow.fields;

         let sql=`UPDATE dgi_invoices SET id='${order.order_id}' , invoice_number='${order.invoice_prefix}+${order.order_id}', amount='${order.total}',  currency_code='${order.currency_code}',customer_id='${order.customer_id}',customer_name='${order.firstname} ${order.lastname}',  customer_email='${order.email}', customer_phone='${order.telephone}' WHERE id = ${order.order_id}`;

       var query = akaunting.query(sql, function (error, results, fields) {
             if (error) throw error;
           console.log('Güncellenen Fatura Id:' + order.order_id);
      });
    }
  
    });
}
module.exports=order;
