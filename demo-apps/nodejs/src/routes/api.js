var express = require('express');
var router = express.Router();

/* GET home page. */

router.get('/', function(req, res) {
  res.status(200).json( { "hello" : "default"} );
});

router.get('/:name', function(req, res) {
  res.status(200).json( { "hello" : req.params.name } );
});

module.exports = router;
