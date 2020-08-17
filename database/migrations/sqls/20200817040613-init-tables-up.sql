/* Replace with your SQL commands */
CREATE TABLE `users` (
   `id` VARCHAR(255),
   `email` VARCHAR(255),
   `first_name` VARCHAR(255) NOT NULL,
   `last_name` VARCHAR(255) NOT NULL,
   `password` VARCHAR(255) NOT NULL,
   `rating` DECIMAL(2,1),
   `is_worker` INTEGER
);

CREATE TABLE `worker_profile`(
   `id` VARCHAR(255),
   `user_id` VARCHAR(255),
   `nbi_clearance` VARCHAR(255),
   `gov_id` VARCHAR(255),
   `signature` VARCHAR(255)
)

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
   `user_rating` DECIMAL(2,1)
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
   p_signature)

END;

CREATE PROCEDURE `is_unique_email`(IN p_email VARCHAR(255))
BEGIN
	SELECT * FROM `users` WHERE `email` = p_email; 
END;