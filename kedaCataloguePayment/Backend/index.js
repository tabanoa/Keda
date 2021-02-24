//Add packeges we need

const express = require('express')
const bodyParser = require('body-parser')
var stripe = require('stripe')('sk_test_0S638YiNyU6Rq37duBh4i2SC00OrI5dp6J')

const app = express()
//new code
app.set('port', (process.env.PORT || 5000));
app.use(express.static(__dirname + '/public'));

app.set('views', __dirname + '/views');
app.set('view engine', 'ejs');


app.use(bodyParser.json())
app.use(bodyParser.urlencoded({
	extended: true
}))


app.get('/', function(req, res) {
	res.send('Hello iOSDevSchool')
})


app.post('/charge', (req, res) => {

  var description = req.body.description
  var amount = req.body.amount
  var currency = req.body.currency
  var token = req.body.stripeToken


  console.log(req.body)

  stripe.charges.create({
    source: token,
    amount: amount,
    currency: currency,
    description: description

  }, function(err, charge) {
    if(err) {
      console.log(err, req.body)
      res.status(500).end()
    } else {
      console.log('success')
      res.status(200).send()
    }
  })

});

//new code
app.listen(app.get('port'), function() {
  console.log('Node app is running on port', app.get('port'));
})

// app.listen(3000, () => {

// 	console.log('Local host running on port 3000')
// })