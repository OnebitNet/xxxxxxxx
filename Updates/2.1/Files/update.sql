ALTER TABLE `admin_notifications` CHANGE `read_status` `is_read` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0';
ALTER TABLE `users` CHANGE `reg_step` `profile_complete` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0';
ALTER TABLE `general_settings` ADD `multi_language` TINYINT(1) NOT NULL DEFAULT '1' AFTER `force_ssl`;