var express = require('express');
var bodyParser = require('body-parser')

var app = express();
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json());
app.set('view engine', 'pug');

app.use(bodyParser.json())

app.get('/', function (req, res) {
    res.render('index')
  })

  
app.get('/zirve', function (req, res) {
  if (!req.body) return res.sendStatus(400)
  res.render('zirve')
})

app.post('/zirve', function (req, res) {
  if (!req.body) return res.sendStatus(400)
  res.render(JSON.stringify(req.body));
})


app.listen(3000, () => {
    console.log("Server running on port 3000");
   });