var knex = require('knex')({
    client: 'mysql',
    version: '5.7',
    connection: {
        host : 'db_server',
        user : 'root',
        password : 'password',
        database : 'mydb'
    }
});
const Redis = require("ioredis");
const redis = new Redis(6379, "app_redis")

const repository={
    getUsers: function(){
        return knex.raw('CALL get_users()')
        .then((data)=>{
            return Promise.resolve(data[0][0])
        })
    },
    getUser: function(userId){
        const pipeline = redis.pipeline();
        pipeline.hgetall(`users:${userId}`)
        return pipeline.exec()
        .then((data)=>{
            return data[0][1]
        })
    },
    checkEmailExists: function(email){
        return knex.raw('CALL is_unique_email(?)', [email])
        .then((data)=>{
            return Promise.resolve(data);
        })
    },
    postUser: function(id, email, firstName, lastName, hash){
        const dbTask= knex.raw('CALL create_user(?,?,?,?,?)',[id, email, firstName, lastName, hash])
        .then((data)=>{
            return Promise.resolve(data);
        })
        const redisObject = {
            id: id, email:email, first_name: firstName, last_name: lastName, rating:0, is_worker:0
        }
        const pipeline = redis.pipeline();
        pipeline.hmset(`users:${id}`, redisObject)
        const kvsTask = pipeline.exec();
        //return Promise.resolve(dbTask);
        return Promise.all([dbTask, kvsTask])
    },
    postWorkerProfile: function(id, userId, nbiClearance, govId, signature){
        return knex.raw('CALL create_worker_profile(?,?,?,?,?)',[id, userId, nbiClearance, govId, signature])
        .then((data)=>{
            return Promise.resolve(data);
        })
    },
    postBooking: function(id, clientId, workerId, serviceId, jobId, price){
        return knex.raw('CALL create_booking(?,?,?,?,?,?)',[id, clientId, workerId, serviceId, jobId, price])
        .then((data)=>{
            return Promise.resolve(data);
        })
    },
    postJob: function(id, title, description, categoryId, categoryName,subcategoryId, subcategoryName, location, latitude, 
        longitude, userId, firstName, lastName, userRating){
        var dbTask = knex.raw('CALL create_job(?,?,?,?,?,?,?,?,?,?,?,?,?,?)',[
            id, title, description, categoryId, categoryName,subcategoryId, subcategoryName, location, latitude, 
            longitude, userId, firstName, lastName, userRating
        ])
        var redisObject = {
            id: id,
            title: title,
            description:description, 
            category_id:categoryId,
            category_name:categoryName,
            subcategory_id:subcategoryId,
            subcategory_name:subcategoryName, 
            location:location, 
            latitude:latitude, 
            longitude:longitude, 
            user_id:userId, 
            first_name:firstName, 
            last_name:lastName, 
            user_rating:userRating
        }
        const pipeline = redis.pipeline();
        pipeline.hmset(`jobs:${id}`, redisObject)
        const kvsTask = pipeline.exec();
        return Promise.all([dbTask, kvsTask]);
    },
    postService: function(id, title, description, categoryId, categoryName,subcategoryId, subcategoryName,
        priceRange, location,latitude, longitude, userId, firstName, lastName,userRating){
        var dbTask = knex.raw('CALL create_service(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',[
            id, title, description, categoryId, categoryName,subcategoryId, subcategoryName, priceRange, location,
            latitude, longitude, userId, firstName, lastName,userRating
        ])
        var redisObject={
            id: id,
            title:title,
            description: description,
            category_id:categoryId,
            category_name:categoryName,
            subcategory_id:subcategoryId,
            subcategory_name:subcategoryName,
            price_range: priceRange,
            location: location,
            latitude:latitude,
            longitude:longitude,
            user_id: userId,
            first_name: firstName,
            last_name: lastName,
            user_rating: userRating
        }
        const pipeline = redis.pipeline();
        pipeline.hmset(`services:${id}`, redisObject)
        const kvsTask = pipeline.exec();
        return Promise.all([dbTask, kvsTask]);
    },
    getJobs: function(distance,title,categoryId, subcategoryId,latitude,longitude,sortBy,pageNum){
        var input = [distance,title,categoryId, subcategoryId,latitude,longitude,sortBy,pageNum];
        return knex.raw('CALL get_jobs(?,?,?,?,?,?,?,?)',input)
        .then((data)=>{
            return Promise.resolve(data[0][0])
        })
        .catch((err)=>{
            console.log(err);
            console.log(input);
            throw err;
        })
    },
    getJob: function(jobId){
        const pipeline = redis.pipeline();
        pipeline.hgetall(`jobs:${jobId}`);
        return pipeline.exec()
        .then((data)=>{
            //console.log(data);
            return data[0][1]
        })
    },
    getJobBookings: function(jobId){
        return knex.raw('CALL get_job_bookings(?)',[jobId])
        .then((data)=>{
            return Promise.resolve(data[0][0])
        })
    },
    getServiceBookings: function(serviceId){
        console.log(serviceId);
        return knex.raw('CALL get_service_bookings(?)',[serviceId])
        .then((data)=>{
            return Promise.resolve(data[0][0])
        })
    },
    getService: function(serviceId){
        const pipeline = redis.pipeline();
        pipeline.hgetall(`services:${serviceId}`);
        return pipeline.exec()
        .then((data)=>{
            return data[0][1]
        })
    },
    getServices: function(distance,title,categoryId, subcategoryId,latitude,longitude,sortBy,pageNum){
        return knex.raw('CALL get_services(?,?,?,?,?,?,?,?)',[distance,title,categoryId, subcategoryId,latitude,longitude,sortBy,pageNum])
        .then((data)=>{
            return Promise.resolve(data[0][0])
        })
    },
    getUserJobs: function(userId){
        return knex.raw('CALL get_user_jobs(?)',[userId])
        .then((data)=>{
            return Promise.resolve(data[0][0])
        })
    },
    getUserServices: function(userId){
        return knex.raw('CALL get_user_services(?)',[userId])
        .then((data)=>{
            return Promise.resolve(data[0][0])
        })
    },
    getCategories: function(){
        return knex.raw('CALL get_categories()')
        .then((data)=>{
            return Promise.resolve(data[0][0])
        })
    },
    getSubcategories: function(categoryId){
        return knex.raw('CALL get_subcategories(?)',[categoryId])
        .then((data)=>{
            return Promise.resolve(data[0][0])
        })
    },
    getJobApplications: function(workerId){
        return knex.raw('CALL get_job_applications(?)',[workerId])
        .then((data)=>{
            return Promise.resolve(data[0][0])
        })
    },
    getServiceRequests: function(clientId){
        return knex.raw('CALL get_service_requests(?)',[clientId])
        .then((data)=>{
            return Promise.resolve(data[0][0])
        })
    },
    putBookingStatus: function(bookingId, status){
        return knex.raw('CALL update_booking_status(?,?)',[bookingId, status])
        .then((data)=>{
            return Promise.resolve(data[0][0])
        })
    },
    postReview: function(id, reviewerId, firstName, lastName,rating,content,reviewedId){
        return knex.raw('CALL create_review(?,?,?,?,?,?,?)',[id, reviewerId, firstName, lastName,rating,content,reviewedId])
        .then((data)=>{
            return Promise.resolve(data);
        })
    },
    getUserReviews: function(userId){
        return knex.raw('CALL get_user_reviews(?)',[userId])
        .then((data)=>{
            return Promise.resolve(data[0][0])
        })
    },
    getUserRooms: function(userId){
        return knex.raw('CALL get_user_rooms(?)',[userId])
        .then((data)=>{
            return Promise.resolve(data[0][0]);
        })
    },
    postRoom: function(roomId, userIdOne, userIdTwo, nameOne, nameTwo){
        console.log(roomId, userIdOne, userIdTwo, nameOne, nameTwo);
        const dbTaskOne =  knex.raw('CALL create_room(?,?,?,?)',[
            roomId, userIdOne, userIdTwo, nameTwo
        ]);
        const dbTaskTwo =  knex.raw('CALL create_room(?,?,?,?)',[
            roomId, userIdTwo, userIdOne, nameOne
        ])

        return Promise.all([dbTaskOne, dbTaskTwo]);
    },
    getMessages: function(roomId){
        return knex.raw('CALL get_room_messages(?)',[roomId])
        .then((data)=>{
            return Promise.resolve(data[0][0])
        })
    },
    postMessage: function(id, roomId, type, sentBy,content){
        return knex.raw('CALL create_message(?,?,?,?,?)',[id,roomId, sentBy,content, type])
        .then((data)=>{
            return Promise.resolve(data);
        })
    },
    checkRoomExists: function(userId, chatWith){
        return knex.raw('CALL check_room_exists(?,?)',[userId, chatWith])
        .then((data)=>{
            return Promise.resolve(data[0][0])
        })
    }

};
module.exports = repository;