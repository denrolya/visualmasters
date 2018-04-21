-- MySQL dump 10.13  Distrib 5.5.43, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: imperiumdesign
-- ------------------------------------------------------
-- Server version	5.5.43-0ubuntu0.14.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Document`
--

DROP TABLE IF EXISTS `Document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Document` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Document`
--

LOCK TABLES `Document` WRITE;
/*!40000 ALTER TABLE `Document` DISABLE KEYS */;
/*!40000 ALTER TABLE `Document` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OrderItem`
--

DROP TABLE IF EXISTS `OrderItem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OrderItem` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `unitPrice` decimal(10,0) NOT NULL,
  `officeCharge` int(11) NOT NULL,
  `totalPrice` double NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_33E85E198D9F6D38` (`order_id`),
  CONSTRAINT `FK_33E85E198D9F6D38` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OrderItem`
--

LOCK TABLES `OrderItem` WRITE;
/*!40000 ALTER TABLE `OrderItem` DISABLE KEYS */;
INSERT INTO `OrderItem` VALUES (2,2,1,'Olimpic',14,20,16.8),(3,2,20,'sdf',20,100,800),(7,42,8,'Hourly rate15£ / minimum of 8 hours a days',15,0,120),(8,42,8,'Weekend rate 23£ Hour / minimum of 8 hours a days',23,0,184),(9,42,1,'First hour of travel is free of charge from postcode B16.',0,0,0),(10,42,0,'Travel time includes time for return and counts after first hour as day / weekend rate',0,0,0),(11,42,1,'Fuel compensation 2 pounds for 10 miles',2,0,2),(12,43,40,'Data cabling Installation Cat6, (01 to 430) floor 8-9. Day rate charge.',16,0,625),(13,43,16,'Over times.',23,0,375),(14,45,1,'test',11,14,12.54),(15,45,233,'ads',34,1,8001.22);
/*!40000 ALTER TABLE `OrderItem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `acl_classes`
--

DROP TABLE IF EXISTS `acl_classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acl_classes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `class_type` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_69DD750638A36066` (`class_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `acl_classes`
--

LOCK TABLES `acl_classes` WRITE;
/*!40000 ALTER TABLE `acl_classes` DISABLE KEYS */;
/*!40000 ALTER TABLE `acl_classes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `acl_entries`
--

DROP TABLE IF EXISTS `acl_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acl_entries` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `class_id` int(10) unsigned NOT NULL,
  `object_identity_id` int(10) unsigned DEFAULT NULL,
  `security_identity_id` int(10) unsigned NOT NULL,
  `field_name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ace_order` smallint(5) unsigned NOT NULL,
  `mask` int(11) NOT NULL,
  `granting` tinyint(1) NOT NULL,
  `granting_strategy` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `audit_success` tinyint(1) NOT NULL,
  `audit_failure` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_46C8B806EA000B103D9AB4A64DEF17BCE4289BF4` (`class_id`,`object_identity_id`,`field_name`,`ace_order`),
  KEY `IDX_46C8B806EA000B103D9AB4A6DF9183C9` (`class_id`,`object_identity_id`,`security_identity_id`),
  KEY `IDX_46C8B806EA000B10` (`class_id`),
  KEY `IDX_46C8B8063D9AB4A6` (`object_identity_id`),
  KEY `IDX_46C8B806DF9183C9` (`security_identity_id`),
  CONSTRAINT `FK_46C8B8063D9AB4A6` FOREIGN KEY (`object_identity_id`) REFERENCES `acl_object_identities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_46C8B806DF9183C9` FOREIGN KEY (`security_identity_id`) REFERENCES `acl_security_identities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_46C8B806EA000B10` FOREIGN KEY (`class_id`) REFERENCES `acl_classes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `acl_entries`
--

LOCK TABLES `acl_entries` WRITE;
/*!40000 ALTER TABLE `acl_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `acl_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `acl_object_identities`
--

DROP TABLE IF EXISTS `acl_object_identities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acl_object_identities` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_object_identity_id` int(10) unsigned DEFAULT NULL,
  `class_id` int(10) unsigned NOT NULL,
  `object_identifier` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `entries_inheriting` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_9407E5494B12AD6EA000B10` (`object_identifier`,`class_id`),
  KEY `IDX_9407E54977FA751A` (`parent_object_identity_id`),
  CONSTRAINT `FK_9407E54977FA751A` FOREIGN KEY (`parent_object_identity_id`) REFERENCES `acl_object_identities` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `acl_object_identities`
--

LOCK TABLES `acl_object_identities` WRITE;
/*!40000 ALTER TABLE `acl_object_identities` DISABLE KEYS */;
/*!40000 ALTER TABLE `acl_object_identities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `acl_object_identity_ancestors`
--

DROP TABLE IF EXISTS `acl_object_identity_ancestors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acl_object_identity_ancestors` (
  `object_identity_id` int(10) unsigned NOT NULL,
  `ancestor_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`object_identity_id`,`ancestor_id`),
  KEY `IDX_825DE2993D9AB4A6` (`object_identity_id`),
  KEY `IDX_825DE299C671CEA1` (`ancestor_id`),
  CONSTRAINT `FK_825DE2993D9AB4A6` FOREIGN KEY (`object_identity_id`) REFERENCES `acl_object_identities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_825DE299C671CEA1` FOREIGN KEY (`ancestor_id`) REFERENCES `acl_object_identities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `acl_object_identity_ancestors`
--

LOCK TABLES `acl_object_identity_ancestors` WRITE;
/*!40000 ALTER TABLE `acl_object_identity_ancestors` DISABLE KEYS */;
/*!40000 ALTER TABLE `acl_object_identity_ancestors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `acl_security_identities`
--

DROP TABLE IF EXISTS `acl_security_identities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acl_security_identities` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `username` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_8835EE78772E836AF85E0677` (`identifier`,`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `acl_security_identities`
--

LOCK TABLES `acl_security_identities` WRITE;
/*!40000 ALTER TABLE `acl_security_identities` DISABLE KEYS */;
/*!40000 ALTER TABLE `acl_security_identities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `basic_orders`
--

DROP TABLE IF EXISTS `basic_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `basic_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) DEFAULT NULL,
  `full_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `postal` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `comments` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `discr` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `subcategory` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `designer_consultancy` tinyint(1) DEFAULT NULL,
  `media_equip_integration` tinyint(1) DEFAULT NULL,
  `light_design` tinyint(1) DEFAULT NULL,
  `floor_material` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ceiling_material` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `walls_material` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `furniture` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `color_psychology` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `classic_coloristics_canon` tinyint(1) DEFAULT NULL,
  `dominant_color` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL,
  `secondary_color` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL,
  `use_feng_shui` tinyint(1) DEFAULT NULL,
  `birth_date` datetime DEFAULT NULL,
  `use_feng_shui_for_partner` tinyint(1) DEFAULT NULL,
  `style_example` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `drawing` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `environment_photo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_1C4C162F12469DE2` (`category_id`),
  CONSTRAINT `FK_1C4C162F12469DE2` FOREIGN KEY (`category_id`) REFERENCES `galleries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `basic_orders`
--

LOCK TABLES `basic_orders` WRITE;
/*!40000 ALTER TABLE `basic_orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `basic_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classification__category`
--

DROP TABLE IF EXISTS `classification__category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `classification__category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `media_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_43629B36727ACA70` (`parent_id`),
  KEY `IDX_43629B36EA9FDD75` (`media_id`),
  CONSTRAINT `FK_43629B36727ACA70` FOREIGN KEY (`parent_id`) REFERENCES `classification__category` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_43629B36EA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media__media` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classification__category`
--

LOCK TABLES `classification__category` WRITE;
/*!40000 ALTER TABLE `classification__category` DISABLE KEYS */;
INSERT INTO `classification__category` VALUES (1,NULL,NULL,'default',1,'default','default',NULL,'2015-06-24 17:38:47','2015-06-24 17:38:47');
/*!40000 ALTER TABLE `classification__category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classification__collection`
--

DROP TABLE IF EXISTS `classification__collection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `classification__collection` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `media_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_A406B56AEA9FDD75` (`media_id`),
  CONSTRAINT `FK_A406B56AEA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media__media` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classification__collection`
--

LOCK TABLES `classification__collection` WRITE;
/*!40000 ALTER TABLE `classification__collection` DISABLE KEYS */;
/*!40000 ALTER TABLE `classification__collection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classification__context`
--

DROP TABLE IF EXISTS `classification__context`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `classification__context` (
  `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classification__context`
--

LOCK TABLES `classification__context` WRITE;
/*!40000 ALTER TABLE `classification__context` DISABLE KEYS */;
INSERT INTO `classification__context` VALUES ('default');
/*!40000 ALTER TABLE `classification__context` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classification__tag`
--

DROP TABLE IF EXISTS `classification__tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `classification__tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classification__tag`
--

LOCK TABLES `classification__tag` WRITE;
/*!40000 ALTER TABLE `classification__tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `classification__tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fos_user`
--

DROP TABLE IF EXISTS `fos_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fos_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `urn` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fos_user`
--

LOCK TABLES `fos_user` WRITE;
/*!40000 ALTER TABLE `fos_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `fos_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fos_user_group`
--

DROP TABLE IF EXISTS `fos_user_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fos_user_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `roles` longtext COLLATE utf8_unicode_ci NOT NULL COMMENT '(DC2Type:array)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_583D1F3E5E237E06` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fos_user_group`
--

LOCK TABLES `fos_user_group` WRITE;
/*!40000 ALTER TABLE `fos_user_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `fos_user_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fos_user_user`
--

DROP TABLE IF EXISTS `fos_user_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fos_user_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `username_canonical` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `email_canonical` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `salt` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `locked` tinyint(1) NOT NULL,
  `expired` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  `confirmation_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password_requested_at` datetime DEFAULT NULL,
  `roles` longtext COLLATE utf8_unicode_ci NOT NULL COMMENT '(DC2Type:array)',
  `credentials_expired` tinyint(1) NOT NULL,
  `credentials_expire_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `firstname` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastname` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `website` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `biography` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gender` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `locale` varchar(8) COLLATE utf8_unicode_ci DEFAULT NULL,
  `timezone` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `facebook_uid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `facebook_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `facebook_data` longtext COLLATE utf8_unicode_ci COMMENT '(DC2Type:json)',
  `twitter_uid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `twitter_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `twitter_data` longtext COLLATE utf8_unicode_ci COMMENT '(DC2Type:json)',
  `gplus_uid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gplus_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gplus_data` longtext COLLATE utf8_unicode_ci COMMENT '(DC2Type:json)',
  `token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `two_step_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `crn` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_C560D76192FC23A8` (`username_canonical`),
  UNIQUE KEY `UNIQ_C560D761A0D96FBF` (`email_canonical`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fos_user_user`
--

LOCK TABLES `fos_user_user` WRITE;
/*!40000 ALTER TABLE `fos_user_user` DISABLE KEYS */;
INSERT INTO `fos_user_user` VALUES (1,'aborisenko','aborisenko','aborisenko@visualmaster.co.uk','aborisenko@visualmaster.co.uk',1,'bakm03k4uw8ooccsgg44w08sw4kosc8','d/vC3B9rzZllMivYpGcsdaGeRauSAljP6tiG7xXAJzKzNBX7oPUABwF+YSwZH4hFBe+17kl1Nssiz8IdDAkakA==','2017-02-17 09:35:27',0,0,NULL,NULL,NULL,'a:1:{i:0;s:16:\"ROLE_SUPER_ADMIN\";}',0,NULL,'2015-08-31 13:10:06','2017-02-17 09:35:27',NULL,NULL,NULL,NULL,NULL,'u',NULL,NULL,NULL,NULL,NULL,'null',NULL,NULL,'null',NULL,NULL,'null',NULL,NULL,NULL),(2,'vdolya','vdolya','vdolya@visualmaster.co.uk','vdolya@visualmaster.co.uk',1,'beizpgquen4kos00sc0kc84cgc04s4g','q/79bvi5HqEKjzqyZiRDzkbQU4klwqCwp/Ms/FWVEnaZcKlM0ZhHWhEaFaTOAexhpIVJUtkQVEPcfJP33yrSGg==','2015-09-10 15:56:07',0,0,NULL,NULL,NULL,'a:1:{i:0;s:16:\"ROLE_SUPER_ADMIN\";}',0,NULL,'2015-08-31 13:11:07','2016-07-09 14:36:54',NULL,NULL,NULL,NULL,NULL,'u',NULL,NULL,NULL,NULL,NULL,'null',NULL,NULL,'null',NULL,NULL,'null',NULL,NULL,'9798316'),(3,'drolya','drolya','drolya@visualmaster.co.uk','drolya@visualmaster.co.uk',1,'khwr6422yi8ooo400wwgskcg08wkcgs','alMwTFkcUD0Bi1BXrITmtDAT+N9beStpp+LJtYBjL0HqPrQv2dVaGkLfOB8wlc3uzgvAzdWstIi4fcqko8vVPg==','2018-04-08 09:56:51',0,0,NULL,NULL,NULL,'a:1:{i:0;s:16:\"ROLE_SUPER_ADMIN\";}',0,NULL,'2015-08-31 13:12:16','2018-04-08 09:56:51',NULL,NULL,NULL,NULL,NULL,'u',NULL,NULL,NULL,NULL,NULL,'null',NULL,NULL,'null',NULL,NULL,'null',NULL,NULL,NULL),(4,'vmaksim','vmaksim','vmaksim@visualmasters.co.uk','vmaksim@visualmasters.co.uk',1,'3blkp0woi7msg88gsg80804o08skoc0','QsSJO3k0x7qW9cVwVV9VZH1hsgCS7xIQSh3yaBbLMnRyNJm1GFh4SWBWOiaCU+WqbKALlg2PDrYxcoYrooSGjA==','2015-11-04 12:43:54',0,0,NULL,NULL,NULL,'a:1:{i:0;s:16:\"ROLE_SUPER_ADMIN\";}',0,NULL,'2015-11-02 12:53:06','2015-11-04 12:43:54',NULL,NULL,NULL,NULL,NULL,'u',NULL,NULL,NULL,NULL,NULL,'null',NULL,NULL,'null',NULL,NULL,'null',NULL,NULL,NULL),(5,'admin','admin','admin@visualmasters.co.uk','admin@visualmasters.co.uk',1,'6q39ln7pavoc0wk88ggss0wg0o4k404','tD75uokK2uO0oP3tRM7fhCrP71XW8wHLbWd529lb+cz1yxUVJ6Ke2y3XftzcVCi6emOHQt6+vdga9N52NKEQdQ==','2018-04-14 06:12:57',0,0,NULL,NULL,NULL,'a:1:{i:0;s:16:\"ROLE_SUPER_ADMIN\";}',0,NULL,'2016-07-09 14:38:48','2018-04-14 06:12:57',NULL,NULL,NULL,NULL,NULL,'u',NULL,NULL,NULL,NULL,NULL,'null',NULL,NULL,'null',NULL,NULL,'null',NULL,NULL,NULL);
/*!40000 ALTER TABLE `fos_user_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fos_user_user_group`
--

DROP TABLE IF EXISTS `fos_user_user_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fos_user_user_group` (
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`group_id`),
  KEY `IDX_B3C77447A76ED395` (`user_id`),
  KEY `IDX_B3C77447FE54D947` (`group_id`),
  CONSTRAINT `FK_B3C77447A76ED395` FOREIGN KEY (`user_id`) REFERENCES `fos_user_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_B3C77447FE54D947` FOREIGN KEY (`group_id`) REFERENCES `fos_user_group` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fos_user_user_group`
--

LOCK TABLES `fos_user_user_group` WRITE;
/*!40000 ALTER TABLE `fos_user_user_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `fos_user_user_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `galleries`
--

DROP TABLE IF EXISTS `galleries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `galleries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `meta_keywords` longtext COLLATE utf8_unicode_ci,
  `meta_description` longtext COLLATE utf8_unicode_ci,
  `slides_timeout` int(11) NOT NULL DEFAULT '8000',
  `detailed_description` longtext COLLATE utf8_unicode_ci,
  `slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `galleries`
--

LOCK TABLES `galleries` WRITE;
/*!40000 ALTER TABLE `galleries` DISABLE KEYS */;
INSERT INTO `galleries` VALUES (12,NULL,NULL,18000,NULL,'bedroom-monochrome','Bedroom Monochrome'),(14,NULL,NULL,18000,NULL,'boutique','Boutique'),(15,NULL,NULL,18000,NULL,'lounge','Lounge'),(16,NULL,NULL,18000,NULL,'restaurant','Restaurant'),(17,NULL,NULL,18000,NULL,'studio-flat','Studio flat'),(18,NULL,NULL,18000,NULL,'apartment','Apartment'),(19,NULL,NULL,18000,NULL,'bathroom','Bathroom'),(20,NULL,NULL,18000,NULL,'child-s-room','Child\'s room'),(21,NULL,NULL,18000,NULL,'salon','Salon'),(22,NULL,NULL,18000,NULL,'restaurant','Restaurant'),(23,NULL,NULL,18000,NULL,'stand','Stand'),(24,NULL,NULL,18000,NULL,'office','Office'),(25,NULL,NULL,18000,NULL,'exterior','Exterior'),(26,NULL,NULL,18000,NULL,'house','House');
/*!40000 ALTER TABLE `galleries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media__gallery`
--

DROP TABLE IF EXISTS `media__gallery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media__gallery` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `context` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `default_format` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media__gallery`
--

LOCK TABLES `media__gallery` WRITE;
/*!40000 ALTER TABLE `media__gallery` DISABLE KEYS */;
/*!40000 ALTER TABLE `media__gallery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media__gallery_media`
--

DROP TABLE IF EXISTS `media__gallery_media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media__gallery_media` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gallery_id` int(11) DEFAULT NULL,
  `media_id` int(11) DEFAULT NULL,
  `position` int(11) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_80D4C5414E7AF8F` (`gallery_id`),
  KEY `IDX_80D4C541EA9FDD75` (`media_id`),
  CONSTRAINT `FK_80D4C5414E7AF8F` FOREIGN KEY (`gallery_id`) REFERENCES `media__gallery` (`id`),
  CONSTRAINT `FK_80D4C541EA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media__media` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media__gallery_media`
--

LOCK TABLES `media__gallery_media` WRITE;
/*!40000 ALTER TABLE `media__gallery_media` DISABLE KEYS */;
/*!40000 ALTER TABLE `media__gallery_media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media__media`
--

DROP TABLE IF EXISTS `media__media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media__media` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `enabled` tinyint(1) NOT NULL,
  `provider_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `provider_status` int(11) NOT NULL,
  `provider_reference` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `provider_metadata` longtext COLLATE utf8_unicode_ci COMMENT '(DC2Type:json)',
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `length` decimal(10,0) DEFAULT NULL,
  `content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_size` int(11) DEFAULT NULL,
  `copyright` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `author_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `context` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cdn_is_flushable` tinyint(1) DEFAULT NULL,
  `cdn_flush_at` datetime DEFAULT NULL,
  `cdn_status` int(11) DEFAULT NULL,
  `updated_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=247 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media__media`
--

LOCK TABLES `media__media` WRITE;
/*!40000 ALTER TABLE `media__media` DISABLE KEYS */;
INSERT INTO `media__media` VALUES (4,'may-15-may-the-force-be-with-you-cal-2560x1440.jpg',NULL,0,'sonata.media.provider.image',1,'de56535a96e08cafca5e849322ae72f039bf0920.jpeg','{\"filename\":\"may-15-may-the-force-be-with-you-cal-2560x1440.jpg\"}',2560,1440,NULL,'image/jpeg',410235,NULL,NULL,'default',NULL,NULL,NULL,'2015-06-25 16:07:54','2015-06-25 16:07:54'),(5,'wall (copy).jpg',NULL,0,'sonata.media.provider.image',1,'26b051d7189e9d0cd3343fde83d214423a5ebca1.jpeg','{\"filename\":\"wall (copy).jpg\"}',1366,768,NULL,'image/jpeg',384654,NULL,NULL,'default',NULL,NULL,NULL,'2015-06-25 16:08:23','2015-06-25 16:08:23'),(18,'l1GI3sETrew.jpg',NULL,0,'sonata.media.provider.image',1,'960f7d160db54b8bc93861b3e727573dcf8edf24.jpeg','{\"filename\":\"l1GI3sETrew.jpg\"}',800,535,NULL,'image/jpeg',104771,NULL,NULL,'default',NULL,NULL,NULL,'2015-08-10 11:09:14','2015-08-10 11:09:14'),(19,'1dolya.jpg',NULL,0,'sonata.media.provider.image',1,'a557d355a1dd1be5de33676cd04015ebaf72a904.jpeg','{\"filename\":\"1dolya.jpg\"}',1600,900,NULL,'image/jpeg',789887,NULL,NULL,'default',NULL,NULL,NULL,'2015-08-12 04:16:46','2015-08-12 04:16:46'),(20,'1dolya.jpg',NULL,0,'sonata.media.provider.image',1,'96a2ce5fb050a2156614bec038cdcc833b4e342d.jpeg','{\"filename\":\"1dolya.jpg\"}',1600,900,NULL,'image/jpeg',789887,NULL,NULL,'default',NULL,NULL,NULL,'2015-08-12 04:25:27','2015-08-12 04:25:27'),(21,'1dolya.jpg',NULL,0,'sonata.media.provider.image',1,'f39a118d33640ff74186b43385e5244b23ff5b13.jpeg','{\"filename\":\"1dolya.jpg\"}',1600,900,NULL,'image/jpeg',789887,NULL,NULL,'default',NULL,NULL,NULL,'2015-08-12 04:25:27','2015-08-12 04:25:27'),(22,'2dolya.jpg',NULL,0,'sonata.media.provider.image',1,'4143da550fd2957d77daa15ce3458f4f65214f83.jpeg','{\"filename\":\"2dolya.jpg\"}',1600,900,NULL,'image/jpeg',702951,NULL,NULL,'default',NULL,NULL,NULL,'2015-08-12 04:32:08','2015-08-12 04:32:08'),(23,'chicago_#2.jpg',NULL,0,'sonata.media.provider.image',1,'5e6e329d099ebaa7e58f6789a07aecdc127e4326.jpeg','{\"filename\":\"chicago_#2.jpg\"}',1920,1080,NULL,'image/jpeg',2300033,NULL,NULL,'default',NULL,NULL,NULL,'2015-08-12 12:35:57','2015-08-12 12:35:57'),(24,'matrix.jpg',NULL,0,'sonata.media.provider.image',1,'507cfa37bc0416f7a044ddb5e8d936ae84ecb85a.jpeg','{\"filename\":\"matrix.jpg\"}',1920,1080,NULL,'image/jpeg',3399692,NULL,NULL,'default',NULL,NULL,NULL,'2015-08-12 12:37:57','2015-08-12 12:37:57'),(25,'робота спальня1.jpg',NULL,0,'sonata.media.provider.image',1,'2265803237dbe8e1fe8ccf35f80b3f785d4cfd57.jpeg','{\"filename\":\"\\u0440\\u043e\\u0431\\u043e\\u0442\\u0430 \\u0441\\u043f\\u0430\\u043b\\u044c\\u043d\\u044f1.jpg\"}',1600,900,NULL,'image/jpeg',1293504,NULL,NULL,'default',NULL,NULL,NULL,'2015-09-10 03:10:28','2015-09-10 03:10:28'),(33,'робота спальня1.jpg',NULL,0,'sonata.media.provider.image',1,'2b9d808bb048eeb36c8b7bb3a84e0e46a09e130a.jpeg','{\"filename\":\"\\u0440\\u043e\\u0431\\u043e\\u0442\\u0430 \\u0441\\u043f\\u0430\\u043b\\u044c\\u043d\\u044f1.jpg\"}',1600,900,NULL,'image/jpeg',1293504,NULL,NULL,'default',NULL,NULL,NULL,'2015-09-10 03:46:58','2015-09-10 03:46:58'),(38,'Безымянный333.png',NULL,0,'sonata.media.provider.image',1,'fb78b29675b8853bc3150f290e1fe170ba92a60f.png','{\"filename\":\"\\u0411\\u0435\\u0437\\u044b\\u043c\\u044f\\u043d\\u043d\\u044b\\u0439333.png\"}',1366,768,NULL,'image/png',493915,NULL,NULL,'default',NULL,NULL,NULL,'2016-07-09 15:28:28','2016-07-09 15:28:28'),(39,'gotovvva.png',NULL,0,'sonata.media.provider.image',1,'2c6a4eea669b6dc606a56a2625caa65643e35a8d.png','{\"filename\":\"gotovvva.png\"}',2000,1000,NULL,'image/png',2803389,NULL,NULL,'default',NULL,NULL,NULL,'2016-10-19 08:20:15','2016-10-19 08:20:15'),(41,'ijoop0001.png',NULL,0,'sonata.media.provider.image',1,'4a95ddd41a5621271633b8a67ffc43814e4c8f2b.png','{\"filename\":\"ijoop0001.png\"}',2000,1000,NULL,'image/png',2776955,NULL,NULL,'default',NULL,NULL,NULL,'2016-10-19 08:31:48','2016-10-19 08:31:48'),(46,'Kimnata_3.png',NULL,0,'sonata.media.provider.image',1,'eb063c83b25ecbf7a9599c21759e7bac8bb72996.png','{\"filename\":\"Kimnata_3.png\"}',2000,1000,NULL,'image/png',2962869,NULL,NULL,'default',NULL,NULL,NULL,'2016-10-19 08:33:27','2016-10-19 08:33:27'),(48,'Kimnata.png',NULL,0,'sonata.media.provider.image',1,'d7c2877a498bb263208e107204abec86e178bd98.png','{\"filename\":\"Kimnata.png\"}',2000,1000,NULL,'image/png',2957871,NULL,NULL,'default',NULL,NULL,NULL,'2016-10-19 08:33:51','2016-10-19 08:33:51'),(52,'Kv 3.png',NULL,0,'sonata.media.provider.image',1,'facc137e06fbe4275fe5f45cc98d919e31e2f228.png','{\"filename\":\"Kv 3.png\"}',1920,1080,NULL,'image/png',3887884,NULL,NULL,'default',NULL,NULL,NULL,'2016-10-21 09:47:16','2016-10-21 09:47:16'),(87,'home design 3d.png',NULL,0,'sonata.media.provider.image',1,'5bc82eb150e014eb452652767d051552c357a660.png','{\"filename\":\"home design 3d.png\"}',2000,1000,NULL,'image/png',2957871,NULL,NULL,'default',NULL,NULL,NULL,'2016-10-24 05:03:00','2016-10-24 05:03:00'),(88,'home design 3d.png',NULL,0,'sonata.media.provider.image',1,'a438eaa7592a44d5f4a0ff9ff546bf4e854928b3.png','{\"filename\":\"home design 3d.png\"}',2000,1000,NULL,'image/png',2957871,NULL,NULL,'default',NULL,NULL,NULL,'2016-10-24 05:04:43','2016-10-24 05:04:43'),(91,'luxury design interior.png',NULL,0,'sonata.media.provider.image',1,'d1541959f8ffcb75e07bdcd8bd3fa45f78e3e580.png','{\"filename\":\"luxury design interior.png\"}',2000,1000,NULL,'image/png',2962869,NULL,NULL,'default',NULL,NULL,NULL,'2016-10-24 05:23:14','2016-10-24 05:23:14'),(92,'luxury design interior.png',NULL,0,'sonata.media.provider.image',1,'8a006d778fd4eb508c7f7c2b559ac763971020e0.png','{\"filename\":\"luxury design interior.png\"}',2000,1000,NULL,'image/png',2962869,NULL,NULL,'default',NULL,NULL,NULL,'2016-10-24 05:23:24','2016-10-24 05:23:24'),(102,'visualisation.png',NULL,0,'sonata.media.provider.image',1,'aa69eee93fbaefe3d92dcfcc790d4751f0cdf2d4.png','{\"filename\":\"visualisation.png\"}',1920,1080,NULL,'image/png',2579137,NULL,NULL,'default',NULL,NULL,NULL,'2016-10-24 05:42:11','2016-10-24 05:42:11'),(126,'restaurant interior design.png',NULL,0,'sonata.media.provider.image',1,'12eb5c9fc36ca24e2d5f5b194f598d358acf10a4.png','{\"filename\":\"restaurant interior design.png\"}',3000,1688,NULL,'image/png',10104829,NULL,NULL,'default',NULL,NULL,NULL,'2016-10-24 05:50:43','2016-10-24 05:50:43'),(136,'Visual Masters | Showreel','',0,'sonata.media.provider.vimeo',1,'208038023','{\"type\":\"video\",\"version\":\"1.0\",\"provider_name\":\"Vimeo\",\"provider_url\":\"https:\\/\\/vimeo.com\\/\",\"title\":\"Visual Masters | Showreel\",\"author_name\":\"Visual Masters\",\"author_url\":\"https:\\/\\/vimeo.com\\/user55849096\",\"is_plus\":\"0\",\"html\":\"<iframe src=\\\"https:\\/\\/player.vimeo.com\\/video\\/208038023\\\" width=\\\"640\\\" height=\\\"360\\\" frameborder=\\\"0\\\" title=\\\"Visual Masters | Showreel\\\" webkitallowfullscreen mozallowfullscreen allowfullscreen><\\/iframe>\",\"width\":640,\"height\":360,\"duration\":120,\"description\":\"\",\"thumbnail_url\":\"http:\\/\\/i.vimeocdn.com\\/video\\/623261224_640.jpg\",\"thumbnail_width\":640,\"thumbnail_height\":360,\"thumbnail_url_with_play_button\":\"http:\\/\\/i.vimeocdn.com\\/filter\\/overlay?src0=http%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F623261224_640.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png\",\"upload_date\":\"2017-03-12 15:50:55\",\"video_id\":208038023,\"uri\":\"\\/videos\\/208038023\"}',640,360,120,'video/x-flv',NULL,NULL,'Visual Masters','default',NULL,NULL,NULL,'2017-04-24 10:40:44','2017-04-24 10:40:12'),(138,'Showreel',NULL,0,'sonata.media.provider.vimeo',1,'208038023','{\"type\":\"video\",\"version\":\"1.0\",\"provider_name\":\"Vimeo\",\"provider_url\":\"https:\\/\\/vimeo.com\\/\",\"title\":\"Visual Masters | Showreel\",\"author_name\":\"Visual Masters\",\"author_url\":\"https:\\/\\/vimeo.com\\/user55849096\",\"is_plus\":\"0\",\"html\":\"<iframe src=\\\"https:\\/\\/player.vimeo.com\\/video\\/208038023\\\" width=\\\"640\\\" height=\\\"360\\\" frameborder=\\\"0\\\" title=\\\"Visual Masters | Showreel\\\" webkitallowfullscreen mozallowfullscreen allowfullscreen><\\/iframe>\",\"width\":640,\"height\":360,\"duration\":120,\"description\":\"\",\"thumbnail_url\":\"http:\\/\\/i.vimeocdn.com\\/video\\/623261224_640.jpg\",\"thumbnail_width\":640,\"thumbnail_height\":360,\"thumbnail_url_with_play_button\":\"http:\\/\\/i.vimeocdn.com\\/filter\\/overlay?src0=http%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F623261224_640.jpg&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png\",\"upload_date\":\"2017-03-12 15:50:55\",\"video_id\":208038023,\"uri\":\"\\/videos\\/208038023\"}',640,360,120,'video/x-flv',NULL,NULL,'Visual Masters','default',0,NULL,NULL,'2017-04-25 11:20:27','2017-04-24 11:15:34'),(139,'Screenshot 2017-04-24 12.35.21.png',NULL,0,'sonata.media.provider.image',1,'9bd734c6e53b03ff84c8688e1d386eddb1807913.png','{\"filename\":\"Screenshot 2017-04-24 12.35.21.png\"}',604,709,NULL,'image/png',206455,NULL,NULL,'default',NULL,NULL,NULL,'2017-04-25 06:44:56','2017-04-25 06:44:56'),(140,'b_room_1.jpg',NULL,0,'sonata.media.provider.image',1,'4c078b9d95edab3aae6adf68ceb3632fdb7989d0.jpeg','{\"filename\":\"b_room_1.jpg\"}',1280,720,NULL,'image/jpeg',680303,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 16:15:50','2018-03-16 16:15:50'),(141,'b_room_2.jpg',NULL,0,'sonata.media.provider.image',1,'436fdb8e15c7262c033025e61ca54d3eb457203b.jpeg','{\"filename\":\"b_room_2.jpg\"}',1280,720,NULL,'image/jpeg',616873,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 16:16:03','2018-03-16 16:16:03'),(142,'b_room_1.jpg',NULL,0,'sonata.media.provider.image',1,'4e02b62d15f00e2f9abafc5d8469c8c505a69ff1.jpeg','{\"filename\":\"b_room_1.jpg\"}',1280,720,NULL,'image/jpeg',680303,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 16:17:30','2018-03-16 16:17:30'),(143,'b_room_2.jpg',NULL,0,'sonata.media.provider.image',1,'5a841c8891446597fbe75653b0b6788582d30cc4.jpeg','{\"filename\":\"b_room_2.jpg\"}',1280,720,NULL,'image/jpeg',616873,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 16:17:50','2018-03-16 16:17:50'),(144,'b_room_3.jpg',NULL,0,'sonata.media.provider.image',1,'7e755c8c7f139a09eeefa5d233319aac196e8fd6.jpeg','{\"filename\":\"b_room_3.jpg\"}',1280,720,NULL,'image/jpeg',710427,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 16:18:34','2018-03-16 16:18:34'),(145,'b_room_4.jpg',NULL,0,'sonata.media.provider.image',1,'ca200dcbc0e4676386b5c779477469525f5dacfa.jpeg','{\"filename\":\"b_room_4.jpg\"}',1280,720,NULL,'image/jpeg',781313,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 16:18:52','2018-03-16 16:18:52'),(146,'b_room_5.jpg',NULL,0,'sonata.media.provider.image',1,'dbf7893b67dd6a2e97905fc268aeeaac524904c0.jpeg','{\"filename\":\"b_room_5.jpg\"}',1280,720,NULL,'image/jpeg',698033,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 16:19:12','2018-03-16 16:19:12'),(147,'butik_1.jpg',NULL,0,'sonata.media.provider.image',1,'0c991744a368821f0fcab62bf61fc6861f312af9.jpeg','{\"filename\":\"butik_1.jpg\"}',1280,720,NULL,'image/jpeg',403157,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 16:32:20','2018-03-16 16:32:20'),(150,'butik_1.jpg',NULL,0,'sonata.media.provider.image',1,'a15821a1ac9a9c6207c08ef889d9e126db7a038e.jpeg','{\"filename\":\"butik_1.jpg\"}',1280,720,NULL,'image/jpeg',403157,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 16:37:05','2018-03-16 16:37:05'),(151,'butik_1.jpg',NULL,0,'sonata.media.provider.image',1,'d236070a58c8f1ecae45ff298cdc43e8e667ed92.jpeg','{\"filename\":\"butik_1.jpg\"}',1280,720,NULL,'image/jpeg',403157,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 16:38:27','2018-03-16 16:38:27'),(152,'butik_2.jpg',NULL,0,'sonata.media.provider.image',1,'d6f1ce445496bed66972b9d6bdea217d32364b5a.jpeg','{\"filename\":\"butik_2.jpg\"}',1280,720,NULL,'image/jpeg',387179,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 16:38:46','2018-03-16 16:38:46'),(153,'butik_3.jpg',NULL,0,'sonata.media.provider.image',1,'681756d1c364c7d100cf022bbcacca4e543ec02f.jpeg','{\"filename\":\"butik_3.jpg\"}',1280,720,NULL,'image/jpeg',690632,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 16:39:52','2018-03-16 16:39:52'),(154,'butik_4.jpg',NULL,0,'sonata.media.provider.image',1,'efe3f1365d3953cfccb3abe915f5f9e85e2ecd68.jpeg','{\"filename\":\"butik_4.jpg\"}',1280,720,NULL,'image/jpeg',657777,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 16:40:11','2018-03-16 16:40:11'),(158,'butik_5.jpg',NULL,0,'sonata.media.provider.image',1,'03cede7a2498b1d73f95fc48531d52c18ea9f2ab.jpeg','{\"filename\":\"butik_5.jpg\"}',1280,720,NULL,'image/jpeg',737370,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 16:53:40','2018-03-16 16:53:40'),(160,'butik_7.jpg',NULL,0,'sonata.media.provider.image',1,'daa2598eccf9eb5d8b6345f9a321784eb2dd96f0.jpeg','{\"filename\":\"butik_7.jpg\"}',1280,720,NULL,'image/jpeg',637364,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 16:54:27','2018-03-16 16:54:27'),(161,'butik_6.jpg',NULL,0,'sonata.media.provider.image',1,'e434d7ad9363dbb7f078b3ee95113ae2cb9c29d2.jpeg','{\"filename\":\"butik_6.jpg\"}',1280,720,NULL,'image/jpeg',469733,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 16:55:33','2018-03-16 16:55:33'),(162,'butik_7.jpg',NULL,0,'sonata.media.provider.image',1,'4c3346da09b0bf33423e06d23e4723d834fa2cab.jpeg','{\"filename\":\"butik_7.jpg\"}',1280,720,NULL,'image/jpeg',637364,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 16:57:05','2018-03-16 16:57:05'),(163,'l_1.jpg',NULL,0,'sonata.media.provider.image',1,'fe464a037c60dcd1add9e79aa89e1b58f907755f.jpeg','{\"filename\":\"l_1.jpg\"}',1280,720,NULL,'image/jpeg',808252,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:00:30','2018-03-16 17:00:30'),(164,'l_2.jpg',NULL,0,'sonata.media.provider.image',1,'ad6f5fa2aa45ff47a50d677ba17dcf252ed123c0.jpeg','{\"filename\":\"l_2.jpg\"}',1280,720,NULL,'image/jpeg',906160,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:01:17','2018-03-16 17:01:17'),(165,'l_3.jpg',NULL,0,'sonata.media.provider.image',1,'671a2466aa7162e163d83adf08cbfff09c3a7c2e.jpeg','{\"filename\":\"l_3.jpg\"}',1280,720,NULL,'image/jpeg',789482,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:01:55','2018-03-16 17:01:55'),(166,'l_4.jpg',NULL,0,'sonata.media.provider.image',1,'e0f939ce198219f6b4cc27dc74618207ae43ac59.jpeg','{\"filename\":\"l_4.jpg\"}',1280,720,NULL,'image/jpeg',821195,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:02:16','2018-03-16 17:02:16'),(167,'l_5.jpg',NULL,0,'sonata.media.provider.image',1,'995c12579d74e93a546ec0d666d3dd0bf3e1891c.jpeg','{\"filename\":\"l_5.jpg\"}',1280,720,NULL,'image/jpeg',915827,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:02:37','2018-03-16 17:02:37'),(168,'l_6.jpg',NULL,0,'sonata.media.provider.image',1,'c1b96d63e4442a4a633416d01f98046429e0cd5d.jpeg','{\"filename\":\"l_6.jpg\"}',1280,720,NULL,'image/jpeg',664496,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:02:57','2018-03-16 17:02:57'),(169,'l_7.jpg',NULL,0,'sonata.media.provider.image',1,'79c9440ffc738a6f1adcca47617f846b5a6dd4e0.jpeg','{\"filename\":\"l_7.jpg\"}',1280,720,NULL,'image/jpeg',777982,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:03:23','2018-03-16 17:03:23'),(170,'restaurant_1.jpg',NULL,0,'sonata.media.provider.image',1,'c2d974677ab754184b756931c39ecfbd60e1c9ec.jpeg','{\"filename\":\"restaurant_1.jpg\"}',1280,720,NULL,'image/jpeg',780898,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:06:21','2018-03-16 17:06:21'),(171,'restaurant_2.jpg',NULL,0,'sonata.media.provider.image',1,'93cfebba66f5f56a00f76d2717e9d49790789d28.jpeg','{\"filename\":\"restaurant_2.jpg\"}',1280,720,NULL,'image/jpeg',728266,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:06:52','2018-03-16 17:06:52'),(172,'restaurant_3.jpg',NULL,0,'sonata.media.provider.image',1,'b2c2af393b2883ba36703e1cbc27cd87dd6c3634.jpeg','{\"filename\":\"restaurant_3.jpg\"}',1280,720,NULL,'image/jpeg',622642,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:07:14','2018-03-16 17:07:14'),(173,'restaurant_4.jpg',NULL,0,'sonata.media.provider.image',1,'ad2dd55d6d2566e64525386cb64f5aa50e24f2ad.jpeg','{\"filename\":\"restaurant_4.jpg\"}',1280,720,NULL,'image/jpeg',712168,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:07:42','2018-03-16 17:07:42'),(174,'restaurant_5.jpg',NULL,0,'sonata.media.provider.image',1,'1410f12e500ad47221d60193ae3e87fda9496c2f.jpeg','{\"filename\":\"restaurant_5.jpg\"}',1280,720,NULL,'image/jpeg',901045,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:08:50','2018-03-16 17:08:50'),(175,'restaurant_6.jpg',NULL,0,'sonata.media.provider.image',1,'3a9f724c00e71db4b5ce8628474741415b902181.jpeg','{\"filename\":\"restaurant_6.jpg\"}',1280,720,NULL,'image/jpeg',784317,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:09:25','2018-03-16 17:09:25'),(176,'restaurant_7.jpg',NULL,0,'sonata.media.provider.image',1,'0dccde5c91f3b826e2da3e69599c8c0b9e6c09e4.jpeg','{\"filename\":\"restaurant_7.jpg\"}',1280,720,NULL,'image/jpeg',798208,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:09:49','2018-03-16 17:09:49'),(177,'restaurant_8.jpg',NULL,0,'sonata.media.provider.image',1,'24ec3e553ceae646d1084f8686e498ab84d778b0.jpeg','{\"filename\":\"restaurant_8.jpg\"}',1280,720,NULL,'image/jpeg',807699,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:10:10','2018-03-16 17:10:10'),(178,'restaurant_9.jpg',NULL,0,'sonata.media.provider.image',1,'fa3cba29cbe23876e5cc886ebbebe3a981e537dd.jpeg','{\"filename\":\"restaurant_9.jpg\"}',1280,720,NULL,'image/jpeg',804505,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:10:31','2018-03-16 17:10:31'),(179,'studio_flat_1.jpg',NULL,0,'sonata.media.provider.image',1,'b8e5565b5566ccc74a0ab62818966fd89eadfeca.jpeg','{\"filename\":\"studio_flat_1.jpg\"}',1280,720,NULL,'image/jpeg',781476,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:14:43','2018-03-16 17:14:43'),(180,'studio_flat_2.jpg',NULL,0,'sonata.media.provider.image',1,'5fbc27b7edf11eab3d18385a9efa3d9e6447bbd0.jpeg','{\"filename\":\"studio_flat_2.jpg\"}',1280,720,NULL,'image/jpeg',802088,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:15:09','2018-03-16 17:15:09'),(181,'studio_flat_3.jpg',NULL,0,'sonata.media.provider.image',1,'a25c9cbebad8c6365555eb68c03ab85bd771a4f5.jpeg','{\"filename\":\"studio_flat_3.jpg\"}',1280,720,NULL,'image/jpeg',772262,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:15:29','2018-03-16 17:15:29'),(182,'studio_flat_4.jpg',NULL,0,'sonata.media.provider.image',1,'9d90610480f818e556ea5eb7b6558addcea04194.jpeg','{\"filename\":\"studio_flat_4.jpg\"}',1280,720,NULL,'image/jpeg',801673,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:15:51','2018-03-16 17:15:51'),(183,'studio_flat_5.jpg',NULL,0,'sonata.media.provider.image',1,'1a139a0beb7da21104ad291902c184d1828316da.jpeg','{\"filename\":\"studio_flat_5.jpg\"}',1280,720,NULL,'image/jpeg',831131,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:16:18','2018-03-16 17:16:18'),(184,'studio_flat_6.jpg',NULL,0,'sonata.media.provider.image',1,'18dc5ba2900b0c97274bb4b5a63879e1335b920d.jpeg','{\"filename\":\"studio_flat_6.jpg\"}',1280,720,NULL,'image/jpeg',734087,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:16:37','2018-03-16 17:16:37'),(185,'studio_flat_7.jpg',NULL,0,'sonata.media.provider.image',1,'fcd2e63a9d9c9957b6cbee2fee6225271445e233.jpeg','{\"filename\":\"studio_flat_7.jpg\"}',1280,720,NULL,'image/jpeg',711415,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:17:00','2018-03-16 17:17:00'),(186,'studio_flat_8.jpg',NULL,0,'sonata.media.provider.image',1,'454b813b6501ed19fd7934a780206b0c93b953a1.jpeg','{\"filename\":\"studio_flat_8.jpg\"}',1280,720,NULL,'image/jpeg',813221,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:17:35','2018-03-16 17:17:35'),(187,'studio_flat_8.jpg',NULL,0,'sonata.media.provider.image',1,'e02a6113855a2ae1a865923741f72a258e1bb917.jpeg','{\"filename\":\"studio_flat_8.jpg\"}',1280,720,NULL,'image/jpeg',813221,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:17:44','2018-03-16 17:17:44'),(188,'studio_flat_9.jpg',NULL,0,'sonata.media.provider.image',1,'9063b2ff85ce58d0ad31aac61b42b4f02b816048.jpeg','{\"filename\":\"studio_flat_9.jpg\"}',1280,720,NULL,'image/jpeg',813841,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:17:57','2018-03-16 17:17:57'),(189,'1.jpg',NULL,0,'sonata.media.provider.image',1,'ff799d64ee18806dee7f73ae23fd6acdea5692c5.jpeg','{\"filename\":\"1.jpg\"}',1280,720,NULL,'image/jpeg',622118,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:24:36','2018-03-16 17:24:36'),(190,'2.jpg',NULL,0,'sonata.media.provider.image',1,'17cf72211d77a396c98d410bb915fefe238e5758.jpeg','{\"filename\":\"2.jpg\"}',1280,720,NULL,'image/jpeg',626259,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:25:01','2018-03-16 17:25:01'),(191,'3.jpg',NULL,0,'sonata.media.provider.image',1,'28f4ef8cb1cf5b9c836c113252ff890d7a43da10.jpeg','{\"filename\":\"3.jpg\"}',1280,720,NULL,'image/jpeg',667844,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:25:23','2018-03-16 17:25:23'),(192,'4.jpg',NULL,0,'sonata.media.provider.image',1,'71307c22ee7cfb5d32c902ff55595b9f1813dede.jpeg','{\"filename\":\"4.jpg\"}',1280,720,NULL,'image/jpeg',763485,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:25:45','2018-03-16 17:25:45'),(193,'5.jpg',NULL,0,'sonata.media.provider.image',1,'f570db1491aefb932d907d15fe37fbe719322beb.jpeg','{\"filename\":\"5.jpg\"}',1280,720,NULL,'image/jpeg',741068,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:26:05','2018-03-16 17:26:05'),(194,'6.jpg',NULL,0,'sonata.media.provider.image',1,'eb0c2f359c7da10d935ec5c0ec27021de8f641c1.jpeg','{\"filename\":\"6.jpg\"}',1280,720,NULL,'image/jpeg',672235,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:26:24','2018-03-16 17:26:24'),(195,'7.jpg',NULL,0,'sonata.media.provider.image',1,'58e0750e65ae2dec910537c63b7126ecb2ed757b.jpeg','{\"filename\":\"7.jpg\"}',1280,720,NULL,'image/jpeg',774393,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:26:44','2018-03-16 17:26:44'),(196,'8.jpg',NULL,0,'sonata.media.provider.image',1,'5509cbc6859c7df7a5d4109c8969d7d65bff5a55.jpeg','{\"filename\":\"8.jpg\"}',1280,720,NULL,'image/jpeg',756832,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:27:04','2018-03-16 17:27:04'),(197,'9.jpg',NULL,0,'sonata.media.provider.image',1,'169c23eaf5b7e684947848ab66eea483659de510.jpeg','{\"filename\":\"9.jpg\"}',1280,720,NULL,'image/jpeg',876284,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:27:37','2018-03-16 17:27:37'),(198,'10.jpg',NULL,0,'sonata.media.provider.image',1,'aaf2fdf7c0824147bef53c91bb4d1f27224781f9.jpeg','{\"filename\":\"10.jpg\"}',1280,720,NULL,'image/jpeg',799903,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:28:03','2018-03-16 17:28:03'),(199,'1.jpg',NULL,0,'sonata.media.provider.image',1,'505d4dcd5c710db8e332c4a88773e63807213505.jpeg','{\"filename\":\"1.jpg\"}',1280,720,NULL,'image/jpeg',726271,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:47:15','2018-03-16 17:47:15'),(200,'2.jpg',NULL,0,'sonata.media.provider.image',1,'ee33d5fdfab2a983bf01643f9e141de4768c7e46.jpeg','{\"filename\":\"2.jpg\"}',1280,720,NULL,'image/jpeg',918219,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:47:43','2018-03-16 17:47:43'),(201,'1.jpg',NULL,0,'sonata.media.provider.image',1,'c870b46a31e2273c1c75057a27d126f5fce87708.jpeg','{\"filename\":\"1.jpg\"}',1280,720,NULL,'image/jpeg',819051,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:49:51','2018-03-16 17:49:51'),(202,'2.jpg',NULL,0,'sonata.media.provider.image',1,'0c529e5a3e128a50a6f33483695b859b36be67bd.jpeg','{\"filename\":\"2.jpg\"}',1280,720,NULL,'image/jpeg',782116,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:50:17','2018-03-16 17:50:17'),(203,'1.jpg',NULL,0,'sonata.media.provider.image',1,'df3f561930edfe163adcca0728f1c482050bf2eb.jpeg','{\"filename\":\"1.jpg\"}',1280,720,NULL,'image/jpeg',743513,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:53:29','2018-03-16 17:53:29'),(204,'2.jpg',NULL,0,'sonata.media.provider.image',1,'0d87185dd8f761c4895eb18b091580c3b87fa685.jpeg','{\"filename\":\"2.jpg\"}',1280,720,NULL,'image/jpeg',843267,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:53:58','2018-03-16 17:53:58'),(205,'1.jpg',NULL,0,'sonata.media.provider.image',1,'39e5a0c1ed458c86cc1f2a2aa136d122d7323c52.jpeg','{\"filename\":\"1.jpg\"}',1280,720,NULL,'image/jpeg',1010892,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:56:34','2018-03-16 17:56:34'),(206,'1.jpg',NULL,0,'sonata.media.provider.image',1,'99f5225316e65faeec7695ce5662e3dff77516d7.jpeg','{\"filename\":\"1.jpg\"}',1280,720,NULL,'image/jpeg',1010892,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:56:40','2018-03-16 17:56:40'),(207,'2.jpg',NULL,0,'sonata.media.provider.image',1,'6ff10748e23fa6aee078744b6ad93ed229eb3c30.jpeg','{\"filename\":\"2.jpg\"}',1280,720,NULL,'image/jpeg',915273,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 17:56:59','2018-03-16 17:56:59'),(208,'1.jpg',NULL,0,'sonata.media.provider.image',1,'79def22ca2e591d7a3f40c11d0a9a9b25aa1b5cf.jpeg','{\"filename\":\"1.jpg\"}',1280,720,NULL,'image/jpeg',673400,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:02:27','2018-03-16 18:02:27'),(209,'2.jpg',NULL,0,'sonata.media.provider.image',1,'9c734754c804016e83aa42c64fa965efc597f9be.jpeg','{\"filename\":\"2.jpg\"}',1280,720,NULL,'image/jpeg',647688,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:02:51','2018-03-16 18:02:51'),(210,'3.jpg',NULL,0,'sonata.media.provider.image',1,'5bead27a7fd2ae05023e1727561733de9feb4b6a.jpeg','{\"filename\":\"3.jpg\"}',1280,720,NULL,'image/jpeg',824726,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:03:15','2018-03-16 18:03:15'),(211,'4.jpg',NULL,0,'sonata.media.provider.image',1,'b50f52e92f13193802bec280ab937e83a16710bf.jpeg','{\"filename\":\"4.jpg\"}',1280,720,NULL,'image/jpeg',731287,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:03:36','2018-03-16 18:03:36'),(212,'1.jpg',NULL,0,'sonata.media.provider.image',1,'dd2a74aaad5c6dc43b477e7eb7a8d8593c444594.jpeg','{\"filename\":\"1.jpg\"}',1280,720,NULL,'image/jpeg',966118,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:05:03','2018-03-16 18:05:03'),(213,'2.jpg',NULL,0,'sonata.media.provider.image',1,'8a2e8c6375fbeabf78d07eb96a8266abe7be5f7f.jpeg','{\"filename\":\"2.jpg\"}',1280,720,NULL,'image/jpeg',754616,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:05:31','2018-03-16 18:05:31'),(214,'3.jpg',NULL,0,'sonata.media.provider.image',1,'86e7ad5ed2f32937903aecb26aa4e93bd6f3c4f9.jpeg','{\"filename\":\"3.jpg\"}',1280,720,NULL,'image/jpeg',671968,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:05:54','2018-03-16 18:05:54'),(215,'4.jpg',NULL,0,'sonata.media.provider.image',1,'b0b01644a9310e3182fd01ef64be4b3f42c0a1e6.jpeg','{\"filename\":\"4.jpg\"}',1280,720,NULL,'image/jpeg',754034,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:06:48','2018-03-16 18:06:48'),(216,'5.jpg',NULL,0,'sonata.media.provider.image',1,'a90c633d6438308be9857435d444aa87492fae45.jpeg','{\"filename\":\"5.jpg\"}',1280,720,NULL,'image/jpeg',767106,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:07:27','2018-03-16 18:07:27'),(217,'6.jpg',NULL,0,'sonata.media.provider.image',1,'977d0e9d1726f0d0963ac841a9eb1aec5ab0c485.jpeg','{\"filename\":\"6.jpg\"}',1280,720,NULL,'image/jpeg',631907,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:07:50','2018-03-16 18:07:50'),(218,'1.jpg',NULL,0,'sonata.media.provider.image',1,'0fa4bd95cdc9cd4aac5ea6b0524ce61507268b21.jpeg','{\"filename\":\"1.jpg\"}',1280,720,NULL,'image/jpeg',956768,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:10:56','2018-03-16 18:10:56'),(219,'2.jpg',NULL,0,'sonata.media.provider.image',1,'fbc1fb0ebf91c5aa35af466d37b39c409ce7980b.jpeg','{\"filename\":\"2.jpg\"}',1280,720,NULL,'image/jpeg',784342,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:11:27','2018-03-16 18:11:27'),(220,'3.jpg',NULL,0,'sonata.media.provider.image',1,'4ce598aa263812209267d540edf3fc40122136e4.jpeg','{\"filename\":\"3.jpg\"}',1280,720,NULL,'image/jpeg',822048,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:11:57','2018-03-16 18:11:57'),(221,'4.jpg',NULL,0,'sonata.media.provider.image',1,'a58b5a4dcb86a6768e5b79d261f9ad0314d1a010.jpeg','{\"filename\":\"4.jpg\"}',1280,720,NULL,'image/jpeg',795774,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:12:18','2018-03-16 18:12:18'),(222,'5.jpg',NULL,0,'sonata.media.provider.image',1,'0b22999965256b6b838cbe111048b63d7d1a32cb.jpeg','{\"filename\":\"5.jpg\"}',1280,720,NULL,'image/jpeg',1146915,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:12:42','2018-03-16 18:12:42'),(223,'6.jpg',NULL,0,'sonata.media.provider.image',1,'d3c0afd0f529d44fff6ffae36f368751fffd95f8.jpeg','{\"filename\":\"6.jpg\"}',1280,720,NULL,'image/jpeg',1056891,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:13:07','2018-03-16 18:13:07'),(224,'7.jpg',NULL,0,'sonata.media.provider.image',1,'518a036dc6f9b6fb80327daa6c602798c5742ccf.jpeg','{\"filename\":\"7.jpg\"}',1280,720,NULL,'image/jpeg',1177407,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:13:45','2018-03-16 18:13:45'),(225,'11.jpg',NULL,0,'sonata.media.provider.image',1,'6bf7114af66da91d541e54df97e17c57494126df.jpeg','{\"filename\":\"11.jpg\"}',1280,720,NULL,'image/jpeg',775864,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:15:40','2018-03-16 18:15:40'),(226,'12.jpg',NULL,0,'sonata.media.provider.image',1,'fabd2eac7a6679b4e3c697ab001dfb80cf62ca39.jpeg','{\"filename\":\"12.jpg\"}',1280,720,NULL,'image/jpeg',629903,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:16:08','2018-03-16 18:16:08'),(227,'13.jpg',NULL,0,'sonata.media.provider.image',1,'aee40cef4faa7e73b2a8e7cde687a0b93e9b061b.jpeg','{\"filename\":\"13.jpg\"}',1280,720,NULL,'image/jpeg',785089,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:16:31','2018-03-16 18:16:31'),(228,'14.jpg',NULL,0,'sonata.media.provider.image',1,'da76d6420f4948ea5e3b4565abdcd92498c60d9f.jpeg','{\"filename\":\"14.jpg\"}',1280,720,NULL,'image/jpeg',620393,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:16:52','2018-03-16 18:16:52'),(229,'15.jpg',NULL,0,'sonata.media.provider.image',1,'323e4d35229a04faa4d508458687fd3a487c9d33.jpeg','{\"filename\":\"15.jpg\"}',1280,720,NULL,'image/jpeg',1087225,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:17:16','2018-03-16 18:17:16'),(230,'16.jpg',NULL,0,'sonata.media.provider.image',1,'66b670201dd4a9874a1fd98915645e8d1c67e646.jpeg','{\"filename\":\"16.jpg\"}',1280,720,NULL,'image/jpeg',998064,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:17:39','2018-03-16 18:17:39'),(231,'17.jpg',NULL,0,'sonata.media.provider.image',1,'da61bb229bbe2b4b317d1eee6ff4c992d54ece3e.jpeg','{\"filename\":\"17.jpg\"}',1280,720,NULL,'image/jpeg',828996,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:18:04','2018-03-16 18:18:04'),(232,'18.jpg',NULL,0,'sonata.media.provider.image',1,'2144be58bdfc9e3b516178c64f7440828ba63572.jpeg','{\"filename\":\"18.jpg\"}',1280,720,NULL,'image/jpeg',872810,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:18:29','2018-03-16 18:18:29'),(233,'19.jpg',NULL,0,'sonata.media.provider.image',1,'cbba41941fba4041e12421fb44cd8e6c79096f2b.jpeg','{\"filename\":\"19.jpg\"}',1280,720,NULL,'image/jpeg',964526,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:18:56','2018-03-16 18:18:56'),(234,'20.jpg',NULL,0,'sonata.media.provider.image',1,'9ccb4162c3c137e1ef81ffe430858a8bfafcd8d6.jpeg','{\"filename\":\"20.jpg\"}',1280,720,NULL,'image/jpeg',750624,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:19:27','2018-03-16 18:19:27'),(235,'21.jpg',NULL,0,'sonata.media.provider.image',1,'9d4a83581011f800ed282f67202422a8c79bc79d.jpeg','{\"filename\":\"21.jpg\"}',1280,720,NULL,'image/jpeg',762490,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:19:54','2018-03-16 18:19:54'),(236,'22.jpg',NULL,0,'sonata.media.provider.image',1,'d6216c5ed235080bb962056a742b9793a64d1988.jpeg','{\"filename\":\"22.jpg\"}',1280,720,NULL,'image/jpeg',641992,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:20:26','2018-03-16 18:20:26'),(237,'23.jpg',NULL,0,'sonata.media.provider.image',1,'b0b5e9aa387a263d8fab066a255fc6731678fca1.jpeg','{\"filename\":\"23.jpg\"}',1280,720,NULL,'image/jpeg',671171,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:23:13','2018-03-16 18:23:13'),(238,'24.jpg',NULL,0,'sonata.media.provider.image',1,'854afb5634c105399444c88cb00362b3111c18f0.jpeg','{\"filename\":\"24.jpg\"}',1280,720,NULL,'image/jpeg',676667,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:24:22','2018-03-16 18:24:22'),(239,'25.jpg',NULL,0,'sonata.media.provider.image',1,'f2ecce29bb4c3030f7fd0bb7f7e61130dd9b1c4c.jpeg','{\"filename\":\"25.jpg\"}',1280,720,NULL,'image/jpeg',667520,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:24:49','2018-03-16 18:24:49'),(240,'26.jpg',NULL,0,'sonata.media.provider.image',1,'cc2c4555758a3b8ad91cf2d4593ac56645eb39d4.jpeg','{\"filename\":\"26.jpg\"}',1280,720,NULL,'image/jpeg',728530,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:25:20','2018-03-16 18:25:20'),(241,'27.jpg',NULL,0,'sonata.media.provider.image',1,'4daec405b09c463b274fec57c860881b3bf9d1f4.jpeg','{\"filename\":\"27.jpg\"}',1280,720,NULL,'image/jpeg',845006,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:25:42','2018-03-16 18:25:42'),(242,'28.jpg',NULL,0,'sonata.media.provider.image',1,'b1cf2125cb7de70dbc1f93dd5b1d504237580383.jpeg','{\"filename\":\"28.jpg\"}',1280,720,NULL,'image/jpeg',706990,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:26:05','2018-03-16 18:26:05'),(243,'29.jpg',NULL,0,'sonata.media.provider.image',1,'70c80200662f71c4c63a7bc678e55b273b7fc970.jpeg','{\"filename\":\"29.jpg\"}',1280,720,NULL,'image/jpeg',666777,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:26:25','2018-03-16 18:26:25'),(244,'30.jpg',NULL,0,'sonata.media.provider.image',1,'9f9ad91b8af63e24b570c494f0941474464ddeda.jpeg','{\"filename\":\"30.jpg\"}',1280,720,NULL,'image/jpeg',796821,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:26:56','2018-03-16 18:26:56'),(245,'31.jpg',NULL,0,'sonata.media.provider.image',1,'098b022b748899adcce393873e1608b6e8e8da3e.jpeg','{\"filename\":\"31.jpg\"}',1280,720,NULL,'image/jpeg',724107,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:27:16','2018-03-16 18:27:16'),(246,'32.jpg',NULL,0,'sonata.media.provider.image',1,'978b02170238e2027e2777fb29bb902976dc7cf3.jpeg','{\"filename\":\"32.jpg\"}',1280,720,NULL,'image/jpeg',613329,NULL,NULL,'default',NULL,NULL,NULL,'2018-03-16 18:27:37','2018-03-16 18:27:37');
/*!40000 ALTER TABLE `media__media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `postal` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `comments` longtext COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `phonenumber` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `file_id` int(11) DEFAULT NULL,
  `sales_person` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `project_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `terms` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `delivery_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `invoice_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_E52FFDEE93CB796C` (`file_id`),
  CONSTRAINT `FK_E52FFDEE93CB796C` FOREIGN KEY (`file_id`) REFERENCES `orders_files` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (2,'Dolyavolodimir@gmail.com','Flat 103, 51 Pinfold Street,','B2 4AY','sdf','Volodimir Volodimirovics Dolya','07449552179',NULL,'','','',NULL,NULL,NULL),(24,'chiotkij@gmail.com','4 Windsor terrace','B16 8UH','vfsy','Tomas Binkevic','07429324528',NULL,'','','',NULL,NULL,NULL),(42,'kathryn.bowyer@stoneleigh.co.uk','The Ditches Hall, Ellesmere Road, Wem, Shropshire.','SY4 5TX','Data','Stoneleigh Consultancy Limited','01939 238800',NULL,'Ivetta Dolya','Alstom Transport Technology Centre','transfer','2017-10-14 00:00:00',NULL,NULL),(43,'Jon@mka-ltd.com','Suite 8, 5th Floor, Lambourne House, Romford, Essex.','RM1 3LD','Networks','mka-ltd.com','01708 206540',NULL,'Ivetta Dolya','CAMA NETWORKS - Cornerblock, 2 Cornwall street, Birmingham B3 2DL','transfer','2017-11-25 00:00:00',NULL,NULL),(44,'Test@test.com','test','test','test','Test','test',12,NULL,NULL,NULL,NULL,'2018-02-18 10:58:25',NULL),(45,'test2@amil.com','es','te','testtes','test2','12412',13,NULL,NULL,'cash','2013-01-01 00:00:00','2018-02-18 10:59:07','2018-02-20 17:02:51');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders_files`
--

DROP TABLE IF EXISTS `orders_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `relative_path` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `absolute_path` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `size` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_479FEFF824FFA15C` (`relative_path`),
  UNIQUE KEY `UNIQ_479FEFF8D1FE575D` (`absolute_path`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders_files`
--

LOCK TABLES `orders_files` WRITE;
/*!40000 ALTER TABLE `orders_files` DISABLE KEYS */;
INSERT INTO `orders_files` VALUES (1,'/uploads/orders/7-f0e5bf50e0c05ec9683659c2f9032d4c.zip','/var/www/imperiumdesign.co.uk/releases/20160804164026/app/../web/uploads/orders/7-f0e5bf50e0c05ec9683659c2f9032d4c.zip','7-f0e5bf50e0c05ec9683659c2f9032d4c.zip','80303'),(2,'/uploads/orders/8-dc252b5a3bfd1849bc5197eafcb84890.zip','/var/www/imperiumdesign.co.uk/releases/20160808184547/app/../web/uploads/orders/8-dc252b5a3bfd1849bc5197eafcb84890.zip','8-dc252b5a3bfd1849bc5197eafcb84890.zip','32208770'),(3,'/uploads/orders/9-6a3e5c94ec73bb5fc87795564d6d3fb7.jpeg','/var/www/imperiumdesign.co.uk/releases/20160812085514/app/../web/uploads/orders/9-6a3e5c94ec73bb5fc87795564d6d3fb7.jpeg','9-6a3e5c94ec73bb5fc87795564d6d3fb7.jpeg','1315288'),(4,'/uploads/orders/10-43d6d9bb8671c393171992ec1508d0bc.jpeg','/var/www/imperiumdesign.co.uk/releases/20170424123645/app/../web/uploads/orders/10-43d6d9bb8671c393171992ec1508d0bc.jpeg','10-43d6d9bb8671c393171992ec1508d0bc.jpeg','177426'),(5,'/uploads/orders/16-7fa8c0ae59b9ae3aa1e8377b0edd17f4.zip','/var/www/imperiumdesign.co.uk/releases/20170516082225/app/../web/uploads/orders/16-7fa8c0ae59b9ae3aa1e8377b0edd17f4.zip','16-7fa8c0ae59b9ae3aa1e8377b0edd17f4.zip','24520119'),(6,'/uploads/orders/17-70384d62a2d2d15fb7ecad60528cd0ce.zip','/var/www/imperiumdesign.co.uk/releases/20170516090441/app/../web/uploads/orders/17-70384d62a2d2d15fb7ecad60528cd0ce.zip','17-70384d62a2d2d15fb7ecad60528cd0ce.zip','24520119'),(7,'/uploads/orders/18-f33b575c1e86aec7a6af1d820bd65e02.zip','/var/www/imperiumdesign.co.uk/releases/20170516090441/app/../web/uploads/orders/18-f33b575c1e86aec7a6af1d820bd65e02.zip','18-f33b575c1e86aec7a6af1d820bd65e02.zip','24520119'),(8,'/uploads/orders/19-0e3684400f1847dfb7a9b8577f9f1901.zip','/var/www/imperiumdesign.co.uk/releases/20170516090441/app/../web/uploads/orders/19-0e3684400f1847dfb7a9b8577f9f1901.zip','19-0e3684400f1847dfb7a9b8577f9f1901.zip','24520119'),(9,'/uploads/orders/20-0f6280b7e0d83ac6da1d42b5612eccf2.zip','/var/www/imperiumdesign.co.uk/releases/20170516090441/app/../web/uploads/orders/20-0f6280b7e0d83ac6da1d42b5612eccf2.zip','20-0f6280b7e0d83ac6da1d42b5612eccf2.zip','24520119'),(10,'/uploads/orders/21-3c0ae566584188cecd8723c5a2e0c713.zip','/var/www/imperiumdesign.co.uk/releases/20170516090441/app/../web/uploads/orders/21-3c0ae566584188cecd8723c5a2e0c713.zip','21-3c0ae566584188cecd8723c5a2e0c713.zip','24520119'),(11,'/uploads/orders/22-df0a2e3014ae5bddd805c1cf6f72dbaa.docx','/var/www/imperiumdesign.co.uk/releases/20170516090441/app/../web/uploads/orders/22-df0a2e3014ae5bddd805c1cf6f72dbaa.docx','22-df0a2e3014ae5bddd805c1cf6f72dbaa.docx','229021'),(12,'/uploads/orders/44-716d99c80be4df384173acc96a460734.zip','/var/www/imperiumdesign.co.uk/releases/20180217205016/app/../web/uploads/orders/44-716d99c80be4df384173acc96a460734.zip','44-716d99c80be4df384173acc96a460734.zip','98727'),(13,'/uploads/orders/45/45-eea707e6309ab0288df8d9dc35b2f9ee.zip','/var/www/imperiumdesign.co.uk/releases/20180217205016/app/../web/uploads/orders/45/45-eea707e6309ab0288df8d9dc35b2f9ee.zip','45-eea707e6309ab0288df8d9dc35b2f9ee.zip','98727');
/*!40000 ALTER TABLE `orders_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `slides`
--

DROP TABLE IF EXISTS `slides`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `slides` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `image_content` int(11) NOT NULL,
  `gallery_page` int(11) DEFAULT NULL,
  `text_content` longtext COLLATE utf8_unicode_ci,
  `display_order` varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  `transparent_zone_params` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_B8C020916BD56775` (`image_content`),
  KEY `IDX_B8C0209187159EAC` (`gallery_page`),
  CONSTRAINT `FK_B8C020916BD56775` FOREIGN KEY (`image_content`) REFERENCES `media__media` (`id`),
  CONSTRAINT `FK_B8C0209187159EAC` FOREIGN KEY (`gallery_page`) REFERENCES `galleries` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `slides`
--

LOCK TABLES `slides` WRITE;
/*!40000 ALTER TABLE `slides` DISABLE KEYS */;
INSERT INTO `slides` VALUES (1,142,12,NULL,'1','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(2,143,12,NULL,'2','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(3,144,12,NULL,'3','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(4,145,12,NULL,'4','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(5,146,12,NULL,'5','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(6,147,14,NULL,'1','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(9,152,14,NULL,'2','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(10,153,14,NULL,'3','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(11,154,14,NULL,'4','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(15,158,14,NULL,'5','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(17,161,14,NULL,'6','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(18,162,14,NULL,'7','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(19,163,15,NULL,'1','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(20,164,15,NULL,'2','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(21,165,15,NULL,'3','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(22,166,15,NULL,'4','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(23,167,15,NULL,'5','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(24,168,15,NULL,'6','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(25,169,15,NULL,'7','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(26,170,16,NULL,'1','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(27,171,16,NULL,'2','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(28,172,16,NULL,'3','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(29,173,16,NULL,'4','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(31,174,16,NULL,'5','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(32,175,16,NULL,'6','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(33,176,16,NULL,'7','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(34,177,16,NULL,'8','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(35,178,16,NULL,'9','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(36,179,17,NULL,'1','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(37,180,17,NULL,'2','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(38,181,17,NULL,'3','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(39,182,17,NULL,'4','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(40,183,17,NULL,'5','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(41,184,17,NULL,'6','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(42,185,17,NULL,'7','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(43,186,17,NULL,'8','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(44,188,17,NULL,'9','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(45,189,18,NULL,'1','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(46,190,18,NULL,'2','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(47,191,18,NULL,'3','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(48,192,18,NULL,'4','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(49,193,18,NULL,'5','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(50,194,18,NULL,'6','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(51,195,18,NULL,'7','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(52,196,18,NULL,'8','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(53,197,18,NULL,'9','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(54,198,18,NULL,'10','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(55,199,19,NULL,'1','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(56,200,19,NULL,'2','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(57,201,20,NULL,'1','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(58,202,20,NULL,'2','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(59,203,21,NULL,'1','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(60,204,21,NULL,'2','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(61,205,22,NULL,'1','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(62,207,22,NULL,'2','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(63,208,23,NULL,'1','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(64,209,23,NULL,'2','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(65,210,23,NULL,'3','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(66,211,23,NULL,'4','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(67,212,24,NULL,'1','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(68,213,24,NULL,'2','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(69,214,24,NULL,'3','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(70,215,24,NULL,'4','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(71,216,24,NULL,'5','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(72,217,24,NULL,'6','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(73,218,25,NULL,'1','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(74,219,25,NULL,'2','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(75,220,25,NULL,'3','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(76,221,25,NULL,'4','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(77,222,25,NULL,'5','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(78,223,25,NULL,'6','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(79,224,25,NULL,'7','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(80,225,26,NULL,'1','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(81,226,26,NULL,'2','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(82,227,26,NULL,'3','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(83,228,26,NULL,'4','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(84,229,26,NULL,'5','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(85,230,26,NULL,'6','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(86,231,26,NULL,'7','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(87,232,26,NULL,'8','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(88,233,26,NULL,'9','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(89,234,26,NULL,'10','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(90,235,26,NULL,'11','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(91,236,26,NULL,'12','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(92,237,26,NULL,'13','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(93,238,26,NULL,'14','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(94,239,26,NULL,'15','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(95,240,26,NULL,'16','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(96,241,26,NULL,'17','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(97,242,26,NULL,'18','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(98,243,26,NULL,'19','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(99,244,26,NULL,'20','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(100,245,26,NULL,'21','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(101,246,26,NULL,'22','a:6:{s:7:\"opacity\";d:0.7;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}');
/*!40000 ALTER TABLE `slides` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `videos`
--

DROP TABLE IF EXISTS `videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `videos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `video_content` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_29AA64321B28D904` (`video_content`),
  CONSTRAINT `FK_29AA64321B28D904` FOREIGN KEY (`video_content`) REFERENCES `media__media` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `videos`
--

LOCK TABLES `videos` WRITE;
/*!40000 ALTER TABLE `videos` DISABLE KEYS */;
INSERT INTO `videos` VALUES (12,138);
/*!40000 ALTER TABLE `videos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-04-21  3:48:59
