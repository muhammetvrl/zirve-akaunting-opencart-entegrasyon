var fs = require("fs");
const jsonfile = require('jsonfile');
const sql = require("msnodesqlv8");

const connectionString = "server=localhost\\BITIRME;Database=BİTİRME_2018;Trusted_Connection=Yes;Driver={SQL Server}";

const query = "SELECT * FROM dbo.stokgenm";

sql.query(connectionString, query, (err, rows) => {

    jsonfile.writeFile("./data.json", rows, function (err) {
        if (err) console.error(err)
         console.log("Dosya Yazıldı!");
    });
});