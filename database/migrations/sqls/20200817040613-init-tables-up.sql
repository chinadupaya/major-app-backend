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
   if(p_distance is null or p_distance = -1, true, e.distance <= p_distance) AND
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
   if(p_distance is null or p_distance = -1, true, e.distance <= p_distance) AND
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

CREATE PROCEDURE `is_unique_email`(IN p_email VARCHAR(255))
BEGIN
	SELECT * FROM `users` WHERE `email` = p_email; 
END;

INSERT INTO `jobs` (`id`, `title`,`description`,`category_id`,`category_name`,`subcategory_id`,`subcategory_name`,
`location`,`position`,`user_id`,`first_name`,`last_name`,`user_rating`,`create_date`,`update_date`)
VALUES
("job-aa","titleaa","description","a","House","a","Pest Control",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("job-ab","titleab","description","a","House","b","Pest Control",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("job-ac","titleac","description","a","House","c","Pest Control",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'),"a","first","last",0,curdate(),curdate()),
("job-ba","titleba","description","b","House","a","Pest Control",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'),"a","first","last",0,curdate(),curdate()),
("job-bb","titlebb","description","b","House","b","Pest Control",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'),"a","first","last",0,curdate(),curdate()),
("job-bc","titlebc","description","b","House","c","Pest Control",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("job-ca","titleca","description","c","House","a","Pest Control",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("job-cb","titlecb","description","c","House","b","Pest Control",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("job-cc","titlecc","description","c","House","c","Pest Control",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'),"a","first","last",0,curdate(),curdate()),
("job-da","titleda","description","d","House","a","Pest Control",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("job-db","titledb","description","d","House","b","Pest Control",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'),"a","first","last",0,curdate(),curdate()),
("job-dc","titledc","description","d","House","c","Pest Control",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'),"a","first","last",0,curdate(),curdate()),
("job-ea","titleea","description","e","House","a","Pest Control",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'),"a","first","last",0,curdate(),curdate()),
("job-eb","titleeb","description","e","House","b","Pest Control",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("job-ec","titleec","description","e","House","c","Pest Control",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'),"a","first","last",0,curdate(),curdate()),
("job-fa","titlefa","description","f","House","","Pest Control",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'),"a","first","last",0,curdate(),curdate()),
("job-fb","titlefb","description","f","House","","Pest Control",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'),"a","first","last",0,curdate(),curdate()),
("job-fc","titlefc","description","f","House","","Pest Control",
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate())
;

INSERT INTO `services` (`id`, `title`,`description`,`category_id`,`category_name`,`subcategory_id`,`subcategory_name`,`price_range`,`location`,`position`,`user_id`,
   `first_name`,`last_name`,`user_rating`,`create_date`,`update_date`)
VALUES
("service-aa","titleaa","description","a","House","a","Pest Control", 10,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("service-ab","titleab","description","a","House","b","Pest Control", 20,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("service-ac","titleac","description","a","House","c","Pest Control", 30,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("service-ba","titleba","description","b","House","a","Pest Control", 40,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("service-bb","titlebb","description","b","House","b","Pest Control", 50,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("service-bc","titlebc","description","b","House","c","Pest Control", 60,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("service-ca","titleca","description","c","House","a","Pest Control", 70,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'),"a","first","last",0,curdate(),curdate()),
("service-cb","titlecb","description","c","House","b","Pest Control", 80,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("service-cc","titlecc","description","c","House","c","Pest Control", 90,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'),"a","first","last",0,curdate(),curdate()),
("service-da","titleda","description","d","House","a","Pest Control", 100,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'),"a","first","last",0,curdate(),curdate()),
("service-db","titledb","description","d","House","b","Pest Control", 10,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("service-dc","titledc","description","d","House","c","Pest Control", 20,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("service-ea","titleea","description","e","House","a","Pest Control", 30,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'),"a","first","last",0,curdate(),curdate()),
("service-eb","titleeb","description","e","House","b","Pest Control", 40,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("service-ec","titleec","description","e","House","c","Pest Control", 50,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'),"a","first","last",0,curdate(),curdate()),
("service-fa","titlefa","description","f","House","","Pest Control", 60,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("service-fb","titlefb","description","f","House","","Pest Control", 70,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate()),
("service-fc","titlefc","description","f","House","","Pest Control", 80,
"Quezon City, Philippines",ST_GeomFromText( 'POINT(121.043861 14.676208)'), "a","first","last",0,curdate(),curdate())
;