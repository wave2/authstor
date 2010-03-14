--
-- Table structure for table `auths`
--

CREATE TABLE `auths` (
  `auth_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `password` blob,
  `uri` varchar(255) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `expires` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `group_id` int(10) unsigned DEFAULT NULL,
  `description` text,
  `name` varchar(255) DEFAULT NULL,
  `notes` text,
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `last_server_update` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updating_server` int(1) unsigned NOT NULL DEFAULT '0',
  `failed_attempt` int(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`auth_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `attachments`
--

CREATE TABLE `attachments` (
  `att_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) DEFAULT NULL,
  `md5sum` char(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`att_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `event_id` int(10) unsigned NOT NULL,
  `description` text,
  PRIMARY KEY (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `keys`
--

CREATE TABLE `keys` (
  `key_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `key_type` enum('DSA') NOT NULL,
  `key_length` int(10) UNSIGNED NOT NULL,
  `subkey_type` enum('ELG-E') NOT NULL,
  `subkey_length` int(10) NOT NULL,
  `name_real` varchar(100) NOT NULL,
  `name_comment` varchar(255) NOT NULL,
  `name_email` varchar(100) NOT NULL,
  `active` boolean NOT NULL,
  `description` text,
  PRIMARY KEY (`key_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `role_id` int(11) NOT NULL,
  `rolename` text,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tags`
--

CREATE TABLE `tags` (
  `tag_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tag_text` text CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `tag_text` (`tag_text`(100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` text NOT NULL,
  `password` text NOT NULL,
  `email_address` text,
  `first_name` text,
  `last_name` text,
  `active` int(11) DEFAULT NULL,
  `mobile` varchar(100) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `auditlog`
--

CREATE TABLE `auditlog` (
  `audit_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `event_id` int(10) unsigned DEFAULT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `loglevel` char(5) NOT NULL,
  `message` varchar(255) NOT NULL,
  `ipaddress` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`audit_id`)
) ENGINE=InnodDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `auth_groups`
--

CREATE TABLE `auth_groups` (
  `group_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT '1',
  `name` varchar(100) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `user_roles`
--

CREATE TABLE `user_roles` (
  `user_id` int(11) NOT NULL DEFAULT '0',
  `role_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `notify_groups`
--

CREATE TABLE `notify_groups` (
  `group_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `group_name` char(50) DEFAULT NULL,
  `description` text,
  PRIMARY KEY  (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `auth_atts`
--

CREATE TABLE `auth_atts` (
  `auth_id` int(10) unsigned NOT NULL,
  `att_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`auth_id`,`att_id`),
  KEY `att_id` (`att_id`),
  CONSTRAINT `auth_atts_ibfk_1` FOREIGN KEY (`auth_id`) REFERENCES `auths` (`auth_id`),
  CONSTRAINT `auth_atts_ibfk_2` FOREIGN KEY (`att_id`) REFERENCES `attachments` (`att_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `auth_history`
--

CREATE TABLE `auth_history` (
  `auth_id` int(10) unsigned NOT NULL,
  `username` varchar(255) default NULL,
  `password` blob,
  `uri` varchar(255) default NULL,
  `modified` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `expires` timestamp NOT NULL default '0000-00-00 00:00:00',
  `description` text,
  `name` varchar(255) default NULL,
  `notes` text,
  `user_id` int(10) unsigned NOT NULL,
  `action` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`auth_id`,`modified`),
  CONSTRAINT `auth_history_ibfk_1` FOREIGN KEY (`auth_id`) REFERENCES `auths` (`auth_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `auth_tags`
--

CREATE TABLE `auth_tags` (
  `auth_id` int(10) unsigned NOT NULL,
  `tag_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`auth_id`,`tag_id`),
  KEY `tag_id` (`tag_id`),
  CONSTRAINT `auth_tags_ibfk_1` FOREIGN KEY (`auth_id`) REFERENCES `auths` (`auth_id`),
  CONSTRAINT `auth_tags_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `notify_users_groups`
--

CREATE TABLE `notify_users_groups` (
  `entry` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) UNSIGNED NOT NULL,
  `group_id` int(11) UNSIGNED NOT NULL,
  PRIMARY KEY  (`entry`),
  KEY `user_id` (`user_id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `user_group_noti_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_group_noti_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `notify_groups` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
