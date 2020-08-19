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
router.put('/update-booking-status', controller.putBookingStatus);
router.post('/create-worker-profile', controller.postWorkerProfile)
router.post('/post-job', controller.postJob)
router.post('/post-service', controller.postService);
router.post('/post-booking', controller.postBooking);
router.get('/jobs', controller.getJobs);
router.get('/services', controller.getServices);
router.get('/users/:userId/services', controller.getUserServices);
router.get('/users/:userId/jobs', controller.getUserJobs);
router.get('/users/:userId/job-applications', controller.getJobApplications);
router.get('/users/:userId/service-requests', controller.getServiceRequests);
router.get('/jobs/:jobId', controller.getJob);
router.get('/jobs/:jobId/bookings', controller.getJobBookings);
router.get('/services/:serviceId', controller.getService);
router.get('/services/:serviceId/bookings', controller.getServiceBookings);
router.get('/categories', controller.getCategories);
router.get('/categories/:categoryId/subcategories', controller.getSubcategories);
module.exports = router;
