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

CREATE TABLE `worker_profile`(
   `id` VARCHAR(255),
   `user_id` VARCHAR(255),
   `nbi_clearance` VARCHAR(255),
   `gov_id` VARCHAR(255),
   `signature` VARCHAR(255),
   PRIMARY KEY(`id`)
);

CREATE TABLE `services`(
   `id` VARCHAR(255),
   `title` VARCHAR(255),
   `description` TEXT,
   `category` VARCHAR(255),
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
   `category` VARCHAR(255),
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

CREATE PROCEDURE `create_job`(
   p_id VARCHAR(255),
   p_title VARCHAR(255),
   p_description VARCHAR(255),
   p_category VARCHAR(255),
   p_location VARCHAR(255),
   p_latitude DECIMAL(10,8),
   p_longitude DECIMAL(11,8),
   p_user_id VARCHAR(255),
   p_first_name VARCHAR(255),
   p_last_name VARCHAR(255),
   p_user_rating DECIMAL(2,1)
)
BEGIN
   INSERT INTO `jobs` (`id`, `title`,`description`,`category`,`location`,`latitude`,`longitude`,`user_id`,
   `first_name`,`last_name`,`user_rating`,`create_date`,`update_date`)
   VALUES ( p_id, p_title,p_description,p_category,p_location ,p_latitude,p_longitude,p_user_id,
   p_first_name,p_last_name,p_user_rating, now(),now());
END;

CREATE PROCEDURE `get_jobs`()
BEGIN
   SELECT * FROM `jobs`;
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