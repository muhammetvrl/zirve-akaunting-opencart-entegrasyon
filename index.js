var express = require('express');

var app = express();


app.set('view engine', 'pug');

app.get('/', function (req, res) {
    res.render('index')
  })


app.listen(3000, () => {
    console.log("Server running on port 3000");
   });