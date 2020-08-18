const shortId = require('shortid');
const repo = require('../repository/main.repository');
const bcrypt = require('bcryptjs');
const multer = require('multer');
const shortid = require('shortid');
const path = require('path');
var storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, __dirname + '/../public/images/')
    },
    filename: function (req, file, cb) {
        cb(null, file.fieldname + '-' + Date.now() + path.extname(file.originalname))
    }
})
var uploadSingle = multer({
    storage: storage,
    limits: { fileSize: 1000000 },
    fileFilter: function (req, file, cb) {
        checkFileType(file, cb)
    }
}).single('imageupload')
var uploadMultiple = multer({
    storage: storage,
    limits: { fileSize: 1000000 },
    fileFilter: function (req, file, cb) {
        checkFileType(file, cb)
    }
}).array("listingImages", 4)

var cpUpload = multer({ storage: storage }).fields([{ name: 'nbiClearance', maxCount: 1 }, { name: 'govId', maxCount: 1 },{ name: 'signature', maxCount: 1 }])
// Check File Type
function checkFileType(file, cb) {
    console.log("check file type")
    // Allowed ext
    const filetypes = /jpeg|jpg|png|gif/;
    // Check ext
    const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
    // Check mime
    const mimetype = filetypes.test(file.mimetype);
    if (mimetype && extname) {
        return cb(null, true);
    } else {
        cb('Error: Images Only!');
    }
}

const controller = {
    getUsers: (req, res) => {
        repo.getUsers()
            .then((response) => {
                return res.status(200).json({ data: response })
            })
            .catch(() => {
                return res.status(404).json({
                    error: {
                        message: "Internal server error"
                    }
                })
            })
    },
    getUser: (req, res) => {
        console.log(req.params.userId);
        repo.getUser(req.params.userId)
            .then((response) => {
                return res.status(200).json({ data: response })
            })
            .catch(() => {
                return res.status(404).json({
                    error: {
                        message: "Internal server error"
                    }
                })
            })
    },
    loginUser: (req, res) => {
        data = req.body;
        repo.checkEmailExists(data.email)
            .then(response => {
                if (response[0][0].length == 0) {
                    return res.status(404).json({
                        error: {
                            message: "Email does not exist in database."
                        }
                    })
                } else {
                    bcrypt.compare(data.password, response[0][0][0].password, (err, res2) => {
                        if (err) {
                            console.log(err);
                            throw err;
                        } else {
                            if (res2 == true && data.email === response[0][0][0].email) {
                                res.status(200).json({
                                    success: true,
                                    id: response[0][0][0].id,
                                    email: response[0][0][0].email,
                                    first_name: response[0][0][0].first_name,
                                    last_name: response[0][0][0].last_name,
                                    rating: response[0][0][0].rating,
                                    is_worker: response[0][0][0].is_worker,
                                })
                            }
                            else {
                                res.status(404).json({
                                    success: false,
                                    message: "Your email or password is incorrect. Check again."
                                })
                            }
                        }
                    })
                }
            })
            .catch((error) => {
                console.log(error)
                res.status(404).json({
                    error: {
                        message: "Internal server error in email"
                    }
                })
            })
    },
    postUser: async (req, res) => {
        var data = req.body;
        var newId = shortId.generate();
        if (data.firstName && data.lastName && data.email) {
            const response = await repo.checkEmailExists(data.email);
            if (response[0][0].length == 0) {
                const genSaltPromise = new Promise((resolve, reject) => {
                    bcrypt.genSalt(10, function (err, salt) {
                        resolve(salt);
                    })
                })
                const salt = await genSaltPromise;
                const hashPromise = new Promise((resolve, reject) => {
                    bcrypt.hash(data.password, salt, function (err, hash) {
                        resolve(hash);
                    })
                })
                const hash = await hashPromise;
                repo.postUser(newId, data.email, data.firstName, data.lastName, hash)
                    .then((response) => {
                        console.log(response);
                        return res.status(200).json({
                            data: {
                                id: newId,
                                email: data.email,
                                first_name: data.firstName,
                                last_name: data.lastName,
                                password: hash
                            }
                        })
                    })
                    .catch((err) => {
                        return res.status(404).json({
                            error: {
                                message: "Internal server error 1"
                            }
                        })
                    });

            } else {
                return res.status(404).json({
                    error: {
                        message: "Email already exists."
                    }
                })
            }


        } else {
            //find what's missing
            res.status(404).json({
                error: {
                    message: 'One of your values is missing'
                }
            });
        }
    },
    postWorkerProfile: (req,res)=>{
        cpUpload(req,res,(err)=>{
            userId=req.body.userId
            if(req.files){
                var newId=shortid.generate();
                //console.log(req.files['nbiClearance'][0].filename,req.files['govId'][0].filename,req.files['signature'][0].filename);
                repo.postWorkerProfile(newId, userId,req.files['nbiClearance'][0].filename,req.files['govId'][0].filename,req.files['signature'][0].filename)
                .then((response=>{
                    console.log(response);
                    return res.status(200).json({
                        data:{
                            id: newId,
                            user_id: userId, 
                            nbiClearance:req.files['nbiClearance'][0].filename, 
                            govId:req.files['govId'][0].filename,
                            signature:req.files['signature'][0].filename
                        }
                    })
                }))
                
            }
        })
    },
    getJobs: (req,res)=>{
        repo.getJobs()
        .then((response)=>{
            return res.status(200).json({
                data: response
            })
        })
    },
    postJob: (req,res)=>{
        var data = req.body;
        var id = shortid.generate()
        //console.log(data);
        if(data.title && data.description && data.category && data.location && data.latitude && 
            data.longitude && data.userId && data.firstName && data.lastName && (data.userRating>=0)){
            repo.postJob(id, data.title, data.description, data.category, data.location, data.latitude, 
                data.longitude, data.userId, data.firstName, data.lastName, data.userRating)
            .then((response)=>{
                return res.status(200).json({
                    data:{
                        id:id,
                        title: data.title,
                        description: data.description,
                        category:data.category,
                        location: data.location,
                        latitude: data.latitude,
                        longitude: data.longitude,
                        user_id: data.userId,
                        first_name:data.firstName,
                        last_name: data.lastName,
                        user_rating: data.userRating
                    }
                })
            })
            .catch((err)=>{
                console.log(err);
            })
        }else{
            return res.status(404).json({
                error:{
                    message: "You're missing one or more fields"
                }
            })
        }
        
    }

}

module.exports = controller;