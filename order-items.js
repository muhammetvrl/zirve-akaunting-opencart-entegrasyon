
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

        //   if (event.rows[0].before.name === event.rows[0].after.name && event.rows[0].before.phone === event.rows[0].after.phone && event.rows[0].before.email === event.rows[0].after.email) {
        //     let kullanici = { id, user_id, companyid, password, name, email, tax_number, phone, address, website, currency_code, enable, created_at, updated_at, deleted_at } = oldRow.fields;
        //     let sql=`DELETE FROM oc_customer WHERE customer_id=${kullanici.id}`;
    
        //     var query = opencart.query(sql, function (error, results, fields) {
        //       if (error) throw error;
        //       console.log('sİLİNENE Müşteri Id:' + kullanici.id);
        //     });
      
        //   }
        //   else
        //   {
        //     let kullanici = { id, user_id, companyid, password, name, email, tax_number, phone, address, website, currency_code, enable, created_at, updated_at, deleted_at } = newRow.fields;

        //     var name=String(kullanici.name);
        //     name=name.split(" ");
            
        //     let sql =`UPDATE oc_customer SET firstname='${name[0]}', lastname='${name[1]}' , email='${kullanici.email}', telephone='${kullanici.phone}' WHERE customer_id = ${kullanici.id}`;
  
        //     var query = opencart.query(sql, function (error, results, fields) {
        //       if (error) throw error;
        //       console.log('gÜNCELLENEN Müşteri Id:' + kullanici.id);
        //     });
        //   }
      }


    },
    'Active'
  );
  
  