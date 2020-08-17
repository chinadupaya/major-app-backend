var express = require('express');
var router = express.Router();
const controller = require('../controllers/main.controller');

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.get('/users', controller.getUsers);
router.get('/users/:userId', controller.getUser);
router.post('/users',controller.postUser);
router.post('/login', controller.loginUser);
module.exports = router;
