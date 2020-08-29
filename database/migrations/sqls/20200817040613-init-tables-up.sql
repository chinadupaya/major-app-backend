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

CREATE TABLE `reviews`(
   `id` VARCHAR(255),
   `reviewer_id` VARCHAR(255),
   `first_name` VARCHAR(255),
   `last_name` VARCHAR(255),
   `rating` DECIMAL(2,1),
   `content` TEXT,
   `reviewed_id` VARCHAR(255)
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
   `position` GEOMETRY,
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
   `position` GEOMETRY,
   `user_id` VARCHAR(255),
   `first_name` VARCHAR(255),
   `last_name` VARCHAR(255),
   `user_rating` DECIMAL(2,1),
   `create_date` DATE,
   `update_date` DATE,
   PRIMARY KEY(`id`)
);

CREATE TABLE `rooms` (
    `id` VARCHAR(255),
    `user_id` VARCHAR(255),
    `chat_with` VARCHAR(255),
    `room_name` VARCHAR(255),
    `created_at` DATETIME,
    PRIMARY KEY(`id`, `user_id`)
);

CREATE TABLE `messages` (
    `id` VARCHAR(255),
    `room_id` VARCHAR(255),
    `type` VARCHAR(255),
    `content` TEXT,
    `sent_by` VARCHAR(255),
    `created_at` DATETIME,
    PRIMARY KEY(`id`)
);

CREATE PROCEDURE `check_room_exists`(
   IN p_user_id VARCHAR(255),
   IN p_chat_with VARCHAR(255)
)
BEGIN
   SELECT * FROM `rooms` WHERE `user_id` = p_user_id AND `chat_with` = p_chat_with;
END;

CREATE PROCEDURE `get_user_rooms`(IN p_user_id VARCHAR(255))
BEGIN
    SELECT * FROM `rooms` WHERE `user_id` = p_user_id;
END ;

CREATE PROCEDURE `get_room_messages` (IN p_room_id VARCHAR(255))
BEGIN
    SELECT * FROM `messages` WHERE `room_id` = p_room_id
    ORDER BY `created_at`;

END;

CREATE PROCEDURE `create_room`(IN p_id VARCHAR(255), IN p_user_id VARCHAR(255),p_chat_with VARCHAR(255),IN p_room_name VARCHAR(255))
BEGIN
    INSERT INTO `rooms`(`id`,`user_id`, `chat_with`, `room_name`, `created_at`) VALUES (p_id,p_user_id, p_chat_with, p_room_name, now());
END;

CREATE PROCEDURE `create_message`(IN p_id VARCHAR(255), 
    IN p_room_id VARCHAR(255),
    IN p_sent_by VARCHAR(255), 
    IN p_content TEXT,
    IN p_type VARCHAR(255))
BEGIN
    INSERT INTO `messages`(`id`, `room_id`,`type`, `content`, `sent_by`, `created_at`)
    VALUES (p_id, p_room_id, p_type, p_content, p_sent_by, now());
END;

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
   VALUES(p_id, p_email, p_first_name,p_last_name,p_password, 5.0, 0);
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
   DECLARE user_location geometry default ST_GeomFromText( 'POINT(0 0)') ;
   DECLARE pointString varchar(255);
   SET pointString = concat('POINT(', p_longitude, ' ', p_latitude, ')');
   SET user_Location = ST_GeomFromText(  pointString);
   INSERT INTO `services` (`id`, `title`,`description`,`category_id`,`category_name`,`subcategory_id`,`subcategory_name`,`price_range`,`location`,`position`,`user_id`,
   `first_name`,`last_name`,`user_rating`,`create_date`,`update_date`)
   VALUES (p_id,p_title,p_description,p_category_id,p_category_name, p_subcategory_id, p_subcategory_name,p_price_range,p_location,
   user_Location,
   p_user_id,p_first_name,p_last_name,p_user_rating, now(),now());
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
   DECLARE user_location geometry default ST_GeomFromText( 'POINT(0 0)') ;
   DECLARE pointString varchar(255);
   SET pointString = concat('POINT(', p_longitude, ' ', p_latitude, ')');
   SET user_Location = ST_GeomFromText(  pointString);
   INSERT INTO `jobs` (`id`, `title`,`description`,`category_id`,`category_name`,`subcategory_id`,`subcategory_name`,
   `location`,`position`,`user_id`,`first_name`,`last_name`,`user_rating`,`create_date`,`update_date`)
   VALUES ( p_id, p_title,p_description,p_category_id,p_category_name, p_subcategory_id, p_subcategory_name,p_location,
   user_Location,p_user_id,
   p_first_name,p_last_name,p_user_rating, now(),now());
END;

CREATE PROCEDURE `get_services`(
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
   DECLARE ls_page_num INT;
   SET ls_page_num = 10*(page_num-1);
   SELECT * FROM(
      SELECT *, ST_DISTANCE_Sphere( ST_GeomFromText(concat('POINT(',p_longitude,' ',p_latitude,')')), `position` ) AS `distance`FROM `services`
   )e
   WHERE
   if(p_category_id is null or length(trim(p_category_id)) = 0, true, e.category_id = p_category_id ) AND
   if(p_subcategory_id is null or length(trim(p_subcategory_id)) = 0, true, e.subcategory_id = p_subcategory_id ) AND
   if(p_distance is null or p_distance = -1  or p_latitude is null or p_longitude is null, true, e.distance <= p_distance) AND
   e.title LIKE CONCAT("%",p_title,"%")
   ORDER BY
   CASE WHEN sort_by='date_ascending' THEN e.create_date END,
   CASE WHEN sort_by='date_descending' THEN e.create_date END DESC,
   CASE WHEN sort_by='price_ascending' THEN e.price_range END,
   CASE WHEN sort_by='price_descending' THEN e.price_range END DESC
   LIMIT ls_page_num,10;
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
   DECLARE ls_page_num INT;
   SET ls_page_num = 10*(page_num-1);
   SELECT * FROM (
      SELECT *, ST_DISTANCE_Sphere( ST_GeomFromText(concat('POINT(',p_longitude,' ',p_latitude,')')), `position` ) AS `distance` FROM `jobs`
   )e
   WHERE
   if(p_category_id is null or length(trim(p_category_id)) = 0, true, e.category_id = p_category_id ) AND
   if(p_subcategory_id is null or length(trim(p_subcategory_id)) = 0, true, e.subcategory_id = p_subcategory_id ) AND
   if(p_distance is null or p_distance = -1 or p_latitude is null or p_longitude is null, true, e.distance <= p_distance) AND
   e.title LIKE CONCAT("%",p_title,"%")
   ORDER BY
   CASE WHEN sort_by='date_ascending' THEN e.create_date END,
   CASE WHEN sort_by='date_descending' THEN e.create_date END DESC
   LIMIT ls_page_num,10;
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

CREATE PROCEDURE `create_review`(
   IN p_id VARCHAR(255),
   IN p_reviewer_id VARCHAR(255),
   IN p_first_name VARCHAR(255),
   IN p_last_name VARCHAR(255),
   IN p_rating DECIMAL(2,1),
   IN p_content TEXT,
   IN p_reviewed_id VARCHAR(255)
)
BEGIN
   INSERT INTO `reviews` (`id`,`reviewer_id`,`first_name`,`last_name`,`rating`,`content`,`reviewed_id`)
   VALUES (p_id,p_reviewer_id,p_first_name,p_last_name,p_rating,p_content,p_reviewed_id);
END;

CREATE PROCEDURE `get_user_reviews`(
   IN p_reviewed_id VARCHAR(255)
)
BEGIN
   SELECT *, AVG(`rating`) AS `average` FROM `reviews` WHERE `reviewed_id` = p_reviewed_id
   GROUP BY `rating`,`id`,`reviewer_id`,`first_name`,`last_name`,`content`,`reviewed_id`;
END;


CREATE PROCEDURE `is_unique_email`(IN p_email VARCHAR(255))
BEGIN
	SELECT * FROM `users` WHERE `email` = p_email; 
END;

INSERT INTO `categories`(`id`, `name`)
VALUES 
("a","Home"),
("b","Events"),
("c","Health & Fitness"),
("d","Automotive & Transport"),
("e","Office"),
("f","Construction"),
("g","Others");

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
("b","Office Maintenance & Cleaning", "e","Office"),
("a","Carpentry", "f","Carpentry"),
("b","Plumbing", "f","Carpentry");


INSERT INTO `jobs` (`id`, `title`,`description`,`category_id`,`category_name`,`subcategory_id`,`subcategory_name`,
`location`,`position`,`user_id`,`first_name`,`last_name`,`user_rating`,`create_date`,`update_date`)
VALUES
("job-aa","Pest Control Request","description","a","House","a","Pest Control",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("job-ab","Cleaning Request","description","a","House","b","Cleaning",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.045861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("job-ac","Plumbing Request","description","a","House","c","Plumbing",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.046861 14.676208)'),"a","first","last",0,curdate(),curdate()),
("job-ba","Food Event Request","description","b","Events","a","Food",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.041861 14.676208)'),"a","first","last",0,curdate(),curdate()),
("job-bb","Entertainment Event Request","description","b","Events","b","Entertainment",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.046861 14.676208)'),"a","first","last",0,curdate(),curdate()),
("job-bc","Weddings Events Request","description","b","Events","c","Weddings",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("job-ca","Packed meals Request","description","c","Health & Fitness","a","Packed meals",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.671208)'), "a","first","last",0,curdate(),curdate()),
("job-cb","Grocery Request","description","c","Health & Fitness","b","Grocery",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.675208)'), "a","first","last",0,curdate(),curdate()),
("job-da","Movers Request","description","d","Automotive & Transport","a","Movers",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.678208)'), "a","first","last",0,curdate(),curdate()),
("job-db","Office moving Request","description","d","Automotive & Transport","b","Offive Movers",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.671208)'),"a","first","last",0,curdate(),curdate()),
("job-ea","Office pest control Request","description","e","Office","a","Pest Control",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.679208)'),"a","first","last",0,curdate(),curdate()),
("job-eb","Office maintenance Request","description","e","Office","b","Office Maintenance",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043361 14.676208)'), "a","first","last",0,curdate(),curdate()),
("job-fa","Carpentry Request","description","f","Construction","a","Carpentry",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'),"a","first","last",0,curdate(),curdate()),
("job-fb","Plumbing Request","description","f","Construction","b","Plumbing",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043761 14.676208)'),"a","first","last",0,curdate(),curdate())
;

INSERT INTO `services` (`id`, `title`,`description`,`category_id`,`category_name`,`subcategory_id`,`subcategory_name`,`price_range`,`location`,`position`,`user_id`,
   `first_name`,`last_name`,`user_rating`,`create_date`,`update_date`)
VALUES
("service-aa","Pest Control Service","description","a","House","a","Pest Control", 900.00,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("service-ab","Cleaning Service","description","a","House","b","Cleaning",900.00,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.044873 14.676208)'), "a","first","last",0,curdate(),curdate()),
("service-ac","Plumbing Service","description","a","House","c","Plumbing",900.00,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.045885 14.676208)'),"a","first","last",0,curdate(),curdate()),
("service-ba","Food Event Service","description","b","Events","a","Food",900.00,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.046897 14.676208)'),"a","first","last",0,curdate(),curdate()),
("service-bb","Entertainment Event Service","description","b","Events","b","Entertainment",900.00,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.048869 14.676208)'),"a","first","last",0,curdate(),curdate()),
("service-bc","Weddings Events Service","description","b","Events","c","Weddings",900.00,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676216)'), "a","first","last",0,curdate(),curdate()),
("service-ca","Packed meals Service","description","c","Health & Fitness","a","Packed meals",900.00,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.636225)'), "a","first","last",0,curdate(),curdate()),
("service-cb","Grocery Service","description","c","Health & Fitness","b","Grocery",900.00,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.656234)'), "a","first","last",0,curdate(),curdate()),
("service-da","Movers Service","description","d","Automotive & Transport","a","Movers",900.00,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.696243)'), "a","first","last",0,curdate(),curdate()),
("service-db","Office moving Service","description","d","Automotive & Transport","b","Offive Movers",900.00,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676252)'),"a","first","last",0,curdate(),curdate()),
("service-ea","Office pest control Service","description","e","Office","a","Pest Control",900.00,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.042861 14.676261)'),"a","first","last",0,curdate(),curdate()),
("service-eb","Office maintenance Service","description","e","Office","b","Office Maintenance",900.00,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("service-fa","Carpentry Service","description","f","Construction","a","Carpentry",900.00,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043761 14.674208)'),"a","first","last",0,curdate(),curdate()),
("service-fb","Plumbing Service","description","f","Construction","b","Plumbing",900.00,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043361 14.672208)'),"a","first","last",0,curdate(),curdate())
;