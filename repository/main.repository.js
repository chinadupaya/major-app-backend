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
    postJob: function(id, title, description, category, location, latitude, longitude, userId, firstName, lastName, userRating){
        var dbTask = knex.raw('CALL create_job(?,?,?,?,?,?,?,?,?,?,?)',[
            id, title, description, category, location, latitude, longitude, userId, firstName, lastName, userRating
        ])
        var redisObject = {
            id: id,
            title: title,
            description:description, 
            category:category, 
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
    postService: function(id, title, description, category, priceRange, location,
        latitude, longitude, userId, firstName, lastName,userRating){
        var dbTask = knex.raw('CALL create_service(?,?,?,?,?,?,?,?,?,?,?,?)',[
            id, title, description, category, priceRange, location,
            latitude, longitude, userId, firstName, lastName,userRating
        ])
        var redisObject={
            id: id,
            title:title,
            description: description,
            category:category,
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
    getJobs: function(){
        return knex.raw('CALL get_jobs()')
        .then((data)=>{
            return Promise.resolve(data[0][0])
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
    getService: function(serviceId){
        const pipeline = redis.pipeline();
        pipeline.hgetall(`services:${serviceId}`);
        return pipeline.exec()
        .then((data)=>{
            return data[0][1]
        })
    },
    getServices: function(){
        return knex.raw('CALL get_services()')
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

};
module.exports = repository;