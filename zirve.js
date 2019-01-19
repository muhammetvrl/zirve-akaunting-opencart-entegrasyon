var zirve= function (){

var fs = require("fs");
const sql = require("msnodesqlv8");
const jsonfile = require('jsonfile');
var mysql = require('mysql');
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

const query = "SELECT * FROM dbo.stokgenm";

const connectionString = "server=localhost\\BITIRME;Database=BİTİRME_2018;Trusted_Connection=Yes;Driver={SQL Server}";

let data = fs.readFileSync('data.json');  
let datajson = JSON.parse (data); 

sql.query(connectionString, query, (err, rows) => {
   
    let diffdata =jsonDiff.diff(datajson,rows);

    if(diffdata){

    jsonfile.writeFile("./data.json", rows, function (err) {
        if (err) console.error(err)
            console.log("Dosya Yazıldı!");
    });

    diffdata.forEach(element => {
        console.log(element);
       if( element[0]=="+"){
        
        var product=element[1];
        row.push(product);

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

       if( element[0]=="~"){
           console.log(element[1]);
           console.log("Güncelleme işlemi yapıldı");
        opencart.end();

       }

       if( element[0]=="-"){
        let product = element[1];
        row.push(product);

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
    });
        jsonfile.writeFile("./data.json", rows, function (err) {
            if (err) console.error(err)
             console.log("Dosya Yazıldı!");
        });
    }
    else{
        console.log("Değişiklik Yok");
        row='Değişiklik Olmadı...';
        opencart.end();

    }   
});

}

zirve();
module.exports.zirveSync=zirve;
module.exports.row = row;
console.log(row);