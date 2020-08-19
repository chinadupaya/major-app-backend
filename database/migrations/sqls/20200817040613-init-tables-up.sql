/* Replace with your SQL commands */
CREATE TABLE `users` (
   `id` VARCHAR(255),
   `email` VARCHAR(255),
   `first_name` VARCHAR(255) NOT NULL,
   `last_name` VARCHAR(255) NOT NULL,
   `password` VARCHAR(255) NOT NULL,
   `rating` DECIMAL(2,1),
   `is_worker` INTEGER,
   PRIMARY KEY(`id`)
);

CREATE TABLE `bookings`(
   `id` VARCHAR(255),
   `client_id` VARCHAR(255),
   `worker_id` VARCHAR(255),
   `service_id` VARCHAR(255),
   `job_id` VARCHAR(255),
   `price` DECIMAL(10,2),
   `status` INTEGER,
   PRIMARY KEY(`id`)
);

CREATE TABLE `worker_profile`(
   `id` VARCHAR(255),
   `user_id` VARCHAR(255),
   `nbi_clearance` VARCHAR(255),
   `gov_id` VARCHAR(255),
   `signature` VARCHAR(255),
   PRIMARY KEY(`id`)
);

CREATE TABLE `categories`(
   `id` VARCHAR(255),
   `name` VARCHAR(255),
   PRIMARY KEY(`id`)
);
CREATE TABLE `subcategories`(
   `id` VARCHAR(255),
   `name` VARCHAR(255),
   `category_id` VARCHAR(255),
   `category_name` VARCHAR(255),
   PRIMARY KEY(`id`, `category_id`)
);

INSERT INTO `categories`(`id`, `name`)
VALUES 
("a","Home"),
("b","Events"),
("c","Health & Fitness"),
("d","Automotive & Transport"),
("e","Office"),
("f","Others");

INSERT INTO `subcategories`(`id`, `name`,`category_id`,`category_name`)
VALUES
("a","Pest Control Services", "a", "Home"),
("b","Cleaning Services", "a", "Home"),
("c","Plumbing Services", "a", "Home"),
("d","Electrical Services", "a", "Home"),
("e","Aircon Services", "a", "Home"),
("f","Interior Design", "a", "Home"),
("g","Home Repair & Maintenance", "a", "Home"),
("h","Home Renovation & Improvement", "a", "Home"),
("i","Movers & Trucking Services", "a", "Home"),
("j","Laundry & Dry Cleaning", "a", "Home"),
("k","Food, Beverage, & Catering Services", "a", "Home"),
("l","Appliance Services & Repair", "a", "Home"),
("a","Food, Beverage, & Catering Services","b", "Events"),
("b","Entertainment Events","b", "Events"),
("c","Weddings","b", "Events"),
("a","Packed Meals","c","Health & Fitness"),
("b","Grocery","c","Health & Fitness"),
("a","Movers & Trucking Services","d","Automotive & Transport"),
("b","Office Movers & Relocators","d","Automotive & Transport"),
("a","Pest Control Services", "e","Office"),
("b","Office Maintenance & Cleaning", "e","Office");

CREATE TABLE `services`(
   `id` VARCHAR(255),
   `title` VARCHAR(255),
   `description` TEXT,
   `category_id` VARCHAR(255),
   `category_name` VARCHAR(255),
   `subcategory_id` VARCHAR(255),
   `subcategory_name` VARCHAR(255),
   `price_range` DECIMAL(10,2),
   `location` VARCHAR(255),
   `latitude` DECIMAL(10,8),
   `longitude` DECIMAL(11,8),
   `user_id` VARCHAR(255),
   `first_name` VARCHAR(255),
   `last_name` VARCHAR(255),
   `user_rating` DECIMAL(2,1),
   `create_date` DATE,
   `update_date` DATE,
   PRIMARY KEY(`id`)
);

CREATE TABLE `jobs`(
   `id` VARCHAR(255),
   `title` VARCHAR(255),
   `description` VARCHAR(255),
   `category_id` VARCHAR(255),
   `category_name` VARCHAR(255),
   `subcategory_id` VARCHAR(255),
   `subcategory_name` VARCHAR(255),
   `location` VARCHAR(255),
   `latitude` DECIMAL(10,8),
   `longitude` DECIMAL(11,8),
   `user_id` VARCHAR(255),
   `first_name` VARCHAR(255),
   `last_name` VARCHAR(255),
   `user_rating` DECIMAL(2,1),
   `create_date` DATE,
   `update_date` DATE,
   PRIMARY KEY(`id`)
);

CREATE PROCEDURE `get_users`()
BEGIN
   SELECT * FROM `users`;
END;

CREATE PROCEDURE `get_user`(p_user_id VARCHAR(255))
BEGIN
   SELECT (`id`, `email`,`first_name`, `last_name` , `rating`, `is_worker`) FROM `users`
   WHERE `id` = p_user_id;
END;

CREATE PROCEDURE `create_booking`(
   p_id VARCHAR(255),
   p_client_id VARCHAR(255),
   p_worker_id VARCHAR(255),
   p_service_id VARCHAR(255),
   p_job_id VARCHAR(255),
   p_price DECIMAL(10,2)
)
BEGIN
   INSERT INTO `bookings` (`id`,`client_id`,`worker_id`,`service_id`,`job_id`,`price`,`status`)
   VALUES (p_id, p_client_id, p_worker_id, p_service_id, p_job_id, p_price, 0);
END;

CREATE PROCEDURE `get_user_jobs`(p_user_id VARCHAR(255))
BEGIN
   SELECT * FROM `jobs` WHERE `user_id` = p_user_id;
END ;

CREATE PROCEDURE `get_user_services`(p_user_id VARCHAR(255))
BEGIN
   SELECT * FROM `services` WHERE `user_id` = p_user_id;
END ;

CREATE PROCEDURE `create_user`(
   p_id VARCHAR(255),
   p_email VARCHAR(255),
   p_first_name VARCHAR(255),
   p_last_name VARCHAR(255),
   p_password VARCHAR(255)
)
BEGIN
   INSERT INTO `users` (`id`,`email`,`first_name`, `last_name`, `password`, `rating`, `is_worker`)
   VALUES(p_id, p_email, p_first_name,p_last_name,p_password, 0.0, 0);
END;

CREATE PROCEDURE `create_service`(
   p_id VARCHAR(255),
   p_title VARCHAR(255),
   p_description TEXT,
   p_category_id VARCHAR(255),
   p_category_name VARCHAR(255),
   p_subcategory_id VARCHAR(255),
   p_subcategory_name VARCHAR(255),
   p_price_range DECIMAL(10,2),
   p_location VARCHAR(255),
   p_latitude DECIMAL(10,8),
   p_longitude DECIMAL(11,8),
   p_user_id VARCHAR(255),
   p_first_name VARCHAR(255),
   p_last_name VARCHAR(255),
   p_user_rating DECIMAL(2,1)
)
BEGIN
   INSERT INTO `services` (`id`, `title`,`description`,`category_id`,`category_name`,`subcategory_id`,`subcategory_name`,`price_range`,`location`,`latitude`,`longitude`,`user_id`,
   `first_name`,`last_name`,`user_rating`,`create_date`,`update_date`)
   VALUES (p_id,p_title,p_description,p_category_id,p_category_name, p_subcategory_id, p_subcategory_name,p_price_range,p_location,p_latitude,
   p_longitude,p_user_id,p_first_name,p_last_name,p_user_rating, now(),now());
END;

CREATE PROCEDURE `create_job`(
   p_id VARCHAR(255),
   p_title VARCHAR(255),
   p_description VARCHAR(255),
   p_category_id VARCHAR(255),
   p_category_name VARCHAR(255),
   p_subcategory_id VARCHAR(255),
   p_subcategory_name VARCHAR(255),
   p_location VARCHAR(255),
   p_latitude DECIMAL(10,8),
   p_longitude DECIMAL(11,8),
   p_user_id VARCHAR(255),
   p_first_name VARCHAR(255),
   p_last_name VARCHAR(255),
   p_user_rating DECIMAL(2,1)
)
BEGIN
   INSERT INTO `jobs` (`id`, `title`,`description`,`category_id`,`category_name`,`subcategory_id`,`subcategory_name`,
   `location`,`latitude`,`longitude`,`user_id`,`first_name`,`last_name`,`user_rating`,`create_date`,`update_date`)
   VALUES ( p_id, p_title,p_description,p_category_id,p_category_name, p_subcategory_id, p_subcategory_name,p_location ,p_latitude,p_longitude,p_user_id,
   p_first_name,p_last_name,p_user_rating, now(),now());
END;

CREATE PROCEDURE `get_services`()
BEGIN
   SELECT * FROM `services`;
END;

CREATE PROCEDURE `get_jobs`(
   IN p_distance INT,
   IN p_title VARCHAR(255),
   IN p_category_id VARCHAR(255),
   IN p_subcategory_id VARCHAR(255),
   IN p_latitude DECIMAL(10,8),
   IN p_longitude DECIMAL(11,8),
   IN sort_by VARCHAR (100),
   IN page_num INT
)
BEGIN
   SELECT * FROM `jobs`;
END;

CREATE PROCEDURE `get_job_bookings`(IN p_job_id VARCHAR(255))
BEGIN
   SELECT * FROM `bookings` WHERE `job_id` = p_job_id;
END;

CREATE PROCEDURE `get_service_bookings`(IN p_service_id VARCHAR(255))
BEGIN
   SELECT * FROM `bookings` WHERE `service_id` = p_service_id;
END;

CREATE PROCEDURE `get_categories`()
BEGIN
   SELECT * FROM `categories`;
END;

CREATE PROCEDURE `get_job_applications`(IN p_worker_id VARCHAR(255))
BEGIN
   SELECT * FROM `bookings` WHERE `worker_id` = p_worker_id;
END;

CREATE PROCEDURE `get_service_requests`(IN p_client_id VARCHAR(255))
BEGIN
   SELECT * FROM `bookings` WHERE `client_id` = p_client_id;
END;

CREATE PROCEDURE `get_subcategories`(p_category_id VARCHAR(255))
BEGIN
   SELECT * FROM `subcategories` WHERE `category_id` = p_category_id;
END;

CREATE PROCEDURE `update_booking_status`(IN p_booking_id VARCHAR(255),IN p_status INTEGER)
BEGIN
   UPDATE `bookings`
   SET `status` = p_status
   WHERE `id` = p_booking_id;
END;

CREATE PROCEDURE `create_worker_profile`(
   p_id VARCHAR(255),
   p_user_id VARCHAR(255),
   p_nbi_clearance VARCHAR(255),
   p_gov_id VARCHAR(255),
   p_signature VARCHAR(255)
)
BEGIN
   INSERT INTO `worker_profile` (`id`,`user_id`, `nbi_clearance`, `gov_id`, `signature`)
   VALUES(p_id,
   p_user_id,
   p_nbi_clearance,
   p_gov_id,
   p_signature);

   UPDATE `users`
   SET `is_worker`=1
   WHERE `id` = p_user_id;

END;

CREATE PROCEDURE `is_unique_email`(IN p_email VARCHAR(255))
BEGIN
	SELECT * FROM `users` WHERE `email` = p_email; 
END;