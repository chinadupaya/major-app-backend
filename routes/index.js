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
router.post('/create-worker-profile', controller.postWorkerProfile)
router.post('/post-job', controller.postJob)
router.post('/post-service', controller.postService);
router.get('/jobs', controller.getJobs);
router.get('/services', controller.getServices);
router.get('/users/:userId/services', controller.getUserServices);
router.get('/users/:userId/jobs', controller.getUserJobs);
module.exports = router;
