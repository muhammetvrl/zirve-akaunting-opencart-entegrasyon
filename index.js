var express = require('express');
var bodyParser = require('body-parser')
var akauntingSync=require('./akaunting')
var dbwrite=require('./veritabani')
var order=require('./order')
var fs = require("fs");
const sql = require("msnodesqlv8");
const jsonfile = require('jsonfile');
var mysql = require('mysql');
var format = require('date-format');
var jsonDiff = require('json-diff')


var app = express();
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json());
app.set('view engine', 'pug');

app.use(bodyParser.json())


app.get('/excellupload', function (req, res) {
  res.render('excellupload');
})


app.get('/akauntingch', function (req, res) {
  var mysql = require('mysql');

  var connection = mysql.createConnection({
    host     : 'localhost',
    user     : 'root',
    password : '',
    database : 'opencart'
  });
  
  var data = [];
  var dataproduct = [];
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
  })

  connection.query('SELECT * FROM degisim_urun', function(err, rows, fields) {

    if (err) {
      res.status(500).json({"status_code": 500,"status_message": "internal server error"});
    } else {
      
     rows.forEach(element => {
       var product= {
        islem: element.islem,
        product_id: element.product_id,      
        name: element.name,
        description: element.description,
        sku: element.sku,
        quantity: element.quantity,
        price: element.price,
         }
         dataproduct.push(product);
     });

    }
    res.render('akauntingch',{dataproduct:dataproduct, data:data});
  connection.end();
  })
})

app.get('/orderakaunting', function (req, res) {
  order();
  res.render('orderakaunting');
})
app.get('/orderakauntingch', function (req, res) {
  res.render('orderakauntingch');
})

app.get('/', function (req, res) {
    res.render('index')
  })

app.get('/zirve', function (req, res) {
  if (!req.body) return res.sendStatus(400)

    var fs = require("fs");
    const sql = require("msnodesqlv8");
    const jsonfile = require('jsonfile');
    var mysql      = require('mysql');
    var format = require('date-format');
    var jsonDiff = require('json-diff')
    
    var opencart = mysql.createConnection({
    host     : 'localhost',
    user     : 'root',
    password : '',
    database : 'opencart'
    });
    
    opencart.connect();
    
    
    format(); 
      format(new Date());
      var date=format('yyyy-MM-dd hh:mm:ss', new Date());
    
    const connectionString = "server=localhost\\BITIRME;Database=BİTİRME_2018;Trusted_Connection=Yes;Driver={SQL Server}";
    
    const query = "SELECT * FROM dbo.stokgenm";
    
    let data = fs.readFileSync('data.json');  
    let datajson = JSON.parse (data); 

    sql.query(connectionString, query, (err, rows) => {
    

        let diffdata =jsonDiff.diff(datajson,rows);
    
        if(diffdata){
        
          var datach=[];
          var product;
          diffdata.forEach(element => { 
            if( element[0]=="+"){
              product = element[1];
              datach.push(product);
              let sql = `INSERT INTO oc_product(product_id, model, sku,
                  upc, ean, jan, isbn, mpn, location,quantity,
                  stock_status_id, image,manufacturer_id, shipping,
                  price, points, tax_class_id, date_available, weight,
                  weight_class_id, length, width, height,
                  length_class_id, subtract, minimum, sort_order,
                  status, date_added, date_modified) 
                
                  VALUES ('${product.Stk}',
                  'Product ${product.Ref}',
                  '${product.Ref}','', '', '', '', '','',
                  '${product.Stb}','1','NULL', '1',
                  '1',
                  '500','0.0000', '1',
                  '${date}', '0.00000000', '1', 
                  '0.00000000', '0.00000000',
                  '0', '1', '1', '1', '0',
                  '1', 
                  '${date}','${date}')`;
          
                let sql1=`INSERT INTO oc_product_description(product_id,
                  language_id,name,description,tag,
                  meta_title,meta_description,meta_keyword)
                VALUES('${product.Stk}','1',
                '${product.Sta}','${product.Sta}'
                ,'', '', '', '')`;
          
                var query = opencart.query(sql, function (error, results, fields) {
                if (error) throw error;
                console.log('eKLENEN Ürün Id:' + results.insertId);
                opencart.end();
            
            
                });
                var query1 = opencart.query(sql1, function (error, results, fields) {
                    if (error) throw error;
                    console.log('eKLENEN Ürün Id:' + results.insertId);
                    });
            }      
            if( element[0]=="-"){
              product = element[1];
              datach.push(product);
              let sql=`DELETE FROM oc_product WHERE product_id=${product.Stk}`;
              let sql1=`DELETE FROM oc_product_description WHERE product_id=${product.Stk}`;
      
              var query = opencart.query(sql, function (error, results, fields) {
                  if (error) throw error;
                  console.log('sİLİNEN Ürün Id:' + product.Stk);
                });
                var query1 = opencart.query(sql1, function (error, results, fields) {
                  if (error) throw error;
                  console.log('sİLİNEN Ürün Id:' + product.Stk);
                });
      
              opencart.end();
          } 
          dbwrite();
          });
          datach.forEach(element =>{
          res.statusCode = 404;
          res.setHeader('Content-Type', 'text/html');
          res.render("zirve",element); 

          })
        }
        else{
            res.statusCode = 404;
            res.setHeader('Content-Type', 'text/html');
            res.render("zirve",{"res":"Değişiklik Algılanmadı..."});  
            opencart.end();
        }   
    });
})

app.post('/zirve', function (req, res) {
  if (!req.body) return res.sendStatus(400)
  var data=req.body;
  res.redirect('/zirve')
})

app.post('/excellread', function (req, res) {
  if (!req.body) return res.sendStatus(400)
  var data=req.body.upload;
  
  var XLSX = require('xlsx')
  var mysql = require('mysql');
  var format = require('date-format');

  format(); 
  format(new Date());
  var date=format('yyyy-MM-dd hh:mm:ss', new Date())

  var opencart = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'opencart'
  });
  
  opencart.connect();

  var workbook = XLSX.readFile(`../${data}`);
  var sheet_name_list = workbook.SheetNames;
  var xlData = XLSX.utils.sheet_to_json(workbook.Sheets[sheet_name_list[0]]);
  console.log(xlData);

  xlData.forEach(item => {

    let sql = `INSERT INTO oc_product(model, sku,
      upc, ean, jan, isbn, mpn, location,quantity,
      stock_status_id, image, manufacturer_id, shipping,
      price, points, tax_class_id, date_available, weight,
      weight_class_id, length, width, height,
      length_class_id, subtract, minimum, sort_order,
      status, date_added, date_modified) 
    
      VALUES (
      'Product ${item.model}',
      '${item.sku}','', '', '', '', '','',
      '${item.quantity}','1','NULL', 
      '1','1',
      '${item.price}','0.0000', '1',
      '${date}', '0.00000000', '1', 
      '0.00000000', '0.00000000',
       '0', '1', '1', '1', '0',
      '1', 
      '${date}','${date}')`;

      

      var query = opencart.query(sql, function (error, results, fields) {
      if (error) throw error;
      console.log('eKLENEN Ürün Id:' + results.insertId);

      let sql1=`INSERT INTO oc_product_description(product_id,
        language_id,name,description,tag,
        meta_title,meta_description,meta_keyword)
       VALUES(${results.insertId},'1',
       '${item.name}','${item.description}'
       ,'', '', '', '')`;

       let sql2=`INSERT INTO oc_product_to_category (product_id,category_id) VALUES('${results.insertId}','20')`;

       var query = opencart.query(sql1, function (error, results, fields) {
        if (error) throw error;
        console.log('eKLENEN Ürün Id:' + results.insertId);
        });

        var query = opencart.query(sql2, function (error, results, fields) {
          if (error) throw error;
          console.log('eKLENEN Ürün Id:' + results.insertId);
          });

      });

     
  })

  res.render('excelldata',{xlData:xlData})
})





app.get('/akaunting', function (req, res) {

res.redirect("akauntingch")

})

app.post('/akaunting', function (req, res) {
  if (!req.body) return res.sendStatus(400)
  
res.render("akaunting",req.body)
akauntingSync();


})

app.listen(3000, () => {
    console.log("Server running on port 3000");
   });