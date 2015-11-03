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
  CONSTRAINT `FK_46C8B806DF9183C9` FOREIGN KEY (`security_identity_id`) REFERENCES `acl_security_identities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_46C8B8063D9AB4A6` FOREIGN KEY (`object_identity_id`) REFERENCES `acl_object_identities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
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
  CONSTRAINT `FK_825DE299C671CEA1` FOREIGN KEY (`ancestor_id`) REFERENCES `acl_object_identities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_825DE2993D9AB4A6` FOREIGN KEY (`object_identity_id`) REFERENCES `acl_object_identities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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
-- Table structure for table `classification__category`
--

DROP TABLE IF EXISTS `classification__category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `classification__category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `context` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
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
  KEY `IDX_43629B36E25D857E` (`context`),
  KEY `IDX_43629B36EA9FDD75` (`media_id`),
  CONSTRAINT `FK_43629B36EA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media__media` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_43629B36727ACA70` FOREIGN KEY (`parent_id`) REFERENCES `classification__category` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_43629B36E25D857E` FOREIGN KEY (`context`) REFERENCES `classification__context` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classification__category`
--

LOCK TABLES `classification__category` WRITE;
/*!40000 ALTER TABLE `classification__category` DISABLE KEYS */;
INSERT INTO `classification__category` VALUES (1,NULL,'default',NULL,'default',1,'default','default',NULL,'2015-06-24 17:38:47','2015-06-24 17:38:47');
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
  `context` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `media_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tag_collection` (`slug`,`context`),
  KEY `IDX_A406B56AE25D857E` (`context`),
  KEY `IDX_A406B56AEA9FDD75` (`media_id`),
  CONSTRAINT `FK_A406B56AEA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media__media` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_A406B56AE25D857E` FOREIGN KEY (`context`) REFERENCES `classification__context` (`id`)
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
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classification__context`
--

LOCK TABLES `classification__context` WRITE;
/*!40000 ALTER TABLE `classification__context` DISABLE KEYS */;
INSERT INTO `classification__context` VALUES ('default','default',1,'2015-06-24 17:38:47','2015-06-24 17:38:47');
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
  `context` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tag_context` (`slug`,`context`),
  KEY `IDX_CA57A1C7E25D857E` (`context`),
  CONSTRAINT `FK_CA57A1C7E25D857E` FOREIGN KEY (`context`) REFERENCES `classification__context` (`id`)
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_C560D76192FC23A8` (`username_canonical`),
  UNIQUE KEY `UNIQ_C560D761A0D96FBF` (`email_canonical`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fos_user_user`
--

LOCK TABLES `fos_user_user` WRITE;
/*!40000 ALTER TABLE `fos_user_user` DISABLE KEYS */;
INSERT INTO `fos_user_user` VALUES (1,'aborisenko','aborisenko','aborisenko@visualmaster.co.uk','aborisenko@visualmaster.co.uk',1,'bakm03k4uw8ooccsgg44w08sw4kosc8','d/vC3B9rzZllMivYpGcsdaGeRauSAljP6tiG7xXAJzKzNBX7oPUABwF+YSwZH4hFBe+17kl1Nssiz8IdDAkakA==','2015-09-27 05:04:36',0,0,NULL,NULL,NULL,'a:1:{i:0;s:16:\"ROLE_SUPER_ADMIN\";}',0,NULL,'2015-08-31 13:10:06','2015-09-27 05:04:36',NULL,NULL,NULL,NULL,NULL,'u',NULL,NULL,NULL,NULL,NULL,'null',NULL,NULL,'null',NULL,NULL,'null',NULL,NULL),(2,'vdolya','vdolya','vdolya@visualmaster.co.uk','vdolya@visualmaster.co.uk',1,'beizpgquen4kos00sc0kc84cgc04s4g','qA8AejxKkY6tlOc7ylrPya1LkQspZViQjQKBM5J1mbYIKRgltCkr3Xuqg35m18eMsJUNljkR7zJaUBV9ZGIsYw==','2015-09-10 15:56:07',0,0,NULL,NULL,NULL,'a:1:{i:0;s:16:\"ROLE_SUPER_ADMIN\";}',0,NULL,'2015-08-31 13:11:07','2015-09-10 15:56:07',NULL,NULL,NULL,NULL,NULL,'u',NULL,NULL,NULL,NULL,NULL,'null',NULL,NULL,'null',NULL,NULL,'null',NULL,NULL),(3,'drolya','drolya','drolya@visualmaster.co.uk','drolya@visualmaster.co.uk',1,'khwr6422yi8ooo400wwgskcg08wkcgs','alMwTFkcUD0Bi1BXrITmtDAT+N9beStpp+LJtYBjL0HqPrQv2dVaGkLfOB8wlc3uzgvAzdWstIi4fcqko8vVPg==','2015-10-06 06:48:33',0,0,NULL,NULL,NULL,'a:1:{i:0;s:16:\"ROLE_SUPER_ADMIN\";}',0,NULL,'2015-08-31 13:12:16','2015-10-06 06:48:33',NULL,NULL,NULL,NULL,NULL,'u',NULL,NULL,NULL,NULL,NULL,'null',NULL,NULL,'null',NULL,NULL,'null',NULL,NULL);
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
  CONSTRAINT `FK_B3C77447FE54D947` FOREIGN KEY (`group_id`) REFERENCES `fos_user_group` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_B3C77447A76ED395` FOREIGN KEY (`user_id`) REFERENCES `fos_user_user` (`id`) ON DELETE CASCADE
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
  `page_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `meta_title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `meta_keywords` longtext COLLATE utf8_unicode_ci,
  `meta_description` longtext COLLATE utf8_unicode_ci,
  `slides_timeout` int(11) NOT NULL DEFAULT '8000',
  `detailed_description` longtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `galleries`
--

LOCK TABLES `galleries` WRITE;
/*!40000 ALTER TABLE `galleries` DISABLE KEYS */;
INSERT INTO `galleries` VALUES (1,'home','Homepage',NULL,'\'Pay attention to the beauty surrounding you\'',18000,''),(2,'interior','Interior Design',NULL,'\'Pay attention to the beauty surrounding you\'',18000,'<p><span style=\"font-size: 8pt;\"><strong>Interior design</strong> is the first and one of the most important part in creating your living space. Doing it more comfortable and aesthetic, you can&rsquo;t avoid designing. Ordering a design project minimises your risks of getting bad results and saves your nerves. After spending lots of money on reconstruction works you may be disappointed by the results. Finished interior wihout previous projecting&nbsp;might not match your expectations. That\'s why creating 3D model is the best decision you can make before starting reconstruction works. You can save your money, minimize risks and it helps you to bring your idea to executors.</span></p>\r\n<p><span style=\"font-size: 8pt;\">Following common rules is the best way to get what you want. We <strong>consider every aspect</strong>, every small details while doing our job. The main technological idea is to construct perspective images using <strong>gathering line dots</strong>. The right angle plays a great role in this process because perspective images mainly have artistic and compositional aspects. They depend on the angles which are chosen by designers. We always take into consideration<strong> compatibility of materials</strong> in interior. It&rsquo;s obvious that not every material fit to each other. It is caused by different factors - from transparency to Feng Shui.</span></p>\r\n<p><span style=\"font-size: 8pt;\">Other equally important aspect in creating an interior is to take into consideration a<strong> light influence on materials</strong>. Every material has it\'s unique attribute how it reacts on lightening. For example, oak painting frame under neon lights will look differently from the pine painting frame. We consider all this factors, even if there are more than 1 lightening affect.</span></p>\r\n<p><span style=\"font-size: 8pt;\"><strong>In the past</strong> all designers had been using way more simple and understandable technologies to do their usual work. A simple sheet, a pencil, a ruler, they created 3d pictures using projection method. The output was a sort of <strong>3D bad quality picture on a 2D sheet of paper</strong>, and this was the only what client had been given. They mainly had been using an <strong>architectural design method</strong>. It takes a lot of time and different skills to do our job in this <strong>outdated method</strong>.</span></p>\r\n<p><span style=\"font-size: 8pt;\">Technology does not stand still and instead of paper sheets and pencils comes computer with <strong>software for projecting and designing</strong>. Modern technology allows to create <strong>3D images</strong> and the angle&nbsp;may be <strong>any angle and distance</strong> you need. Paper image does not allow this scope. Using newest technologies allows us to chose any point of view you like while projecting an image, which is qualitatively affect on the final result. <strong>Velocity</strong> is our main benefit. Just on 1 engine we use more than 3000 cores, which helps us not to wait for a long time while all necessary processes are finished.</span></p>\r\n<p><span style=\"font-size: 8pt;\">&nbsp;</span></p>'),(3,'special','Special Projects',NULL,NULL,18000,'<p><span style=\"font-size: 8pt;\">Different decoration items are widely used for creating <strong>special and unique interior</strong>. We offer to clients the best decision - <strong>unique items made of wood, steel or glass</strong>. Each of them are <strong>not just hadmade</strong>, they are made almost by <strong>professional artists</strong>, fanatics of their craft. Unique items&nbsp;bring your interior uniqueness, that\'s for sure.</span></p>\r\n<p><span style=\"font-size: 8pt;\">We adapt to your present <strong>interior, coloristics, stylistics</strong>. While making a choice, remember that it is <strong>easier, cheaper and faster</strong> <strong>to order a custom item</strong> rather than buy a factory one to change it\'s configuration and try to build it in your interior.</span></p>\r\n<p><span style=\"font-size: 8pt;\"><strong>Wooden decoration</strong> elements are highly valued since the beginning of time, and they are still highly valued, especially in the epoch of plastic and mass production. People surrounded themselves by natural wooden items to create a forest aura to feel forest energy and nature\'s power and this continues nowadays. Strong wooden breeds bring naturalness, healing attributes and luxury into people\'s homes.&nbsp;You can order a unique design of wooden interior items of any difficulty. We produce stairs, picture frames, doors, furniture and other items made of wood.</span></p>\r\n<p><span style=\"font-size: 8pt;\"><strong>Steel</strong> <strong>constructions</strong> are used ubiquitously throughout the world, they are also an essential part of every house or apartment. Forge is considered to be one of the hardest crafts. Handmade steel elements are used to be high valued and practiciality in usual life. For instance, steel wares are often take place being a fence, gates, grilles, even a family coat of arms hanging in the hall. We have enough capabilities to ensure client\'s will: from projecting an item\'s design to creating direct item.</span></p>\r\n<p><span style=\"font-size: 8pt;\"><strong>Stained glass</strong> is an element of the decorative arts, it\'s beginnings lies in the early Christianity. It was often used in Roman temples and was highly estimated. Stained glass itself is a whole coloured glass, fastened by plumbum wire. In the Reneissance era stained glass had been considered as a glass pictorial art, artists skretched colour glass to create a pictures. Nowadays it is used mainly as an interior item, bringing splendor and richness to people\'s properties.</span></p>\r\n<p><span style=\"font-size: 8pt;\">You can also <strong>order a design project</strong> of stained glass and it\'s producing. We need to know <strong>size</strong>, a <strong>type of design</strong> which is required. After a while, we propose several <strong>sketches</strong> (every sketch is created <strong>manually</strong>, just like any other item) and then it goes to <strong>production</strong>.</span></p>\r\n<p><span style=\"font-size: 8pt;\">&nbsp;</span></p>'),(5,'web','Web Development',NULL,NULL,18000,'<p><span style=\"font-size: 8pt;\">ImD team creates different categories of <strong>websites and software</strong>, from <strong>presentation pages</strong> to complicated systems like <strong>webstores</strong> or <strong>bulletin boards</strong>. Our custom software may be installed on every PC or Mac. To launch our software, you need only<strong> web</strong> to be installed. </span></p>\r\n<p><span style=\"font-size: 8pt;\">Development of database programs for companies is what we offer. Client <strong>pay only for ready-to-use product </strong>and<strong> technical support</strong>, it doesn\'t matter how many working machines you need to install it on. It\'s way more <strong>cheaper and easier</strong> to order unique program rather than to buy licensed software individually on each&nbsp;working laptop.</span></p>\r\n<p><span style=\"font-size: 8pt;\">Mainly we use Symfony2, CMS Joomla and WordPress systems, based on PHP:&nbsp;</span></p>\r\n<p><span style=\"font-size: 8pt;\"><strong>Symfony2</strong> is the safest programming language for web-development. Front end mostly created with Bootstrap library. We use Javascript to add more dynamics to your website.</span></p>\r\n<p><span style=\"font-size: 8pt;\"><strong>Joomla</strong> is a content management system &nbsp;for publishing web content. It is built on a model-view-controller web application framework that can be used independently jf the CMS.&nbsp;</span></p>\r\n<p><span style=\"font-size: 8pt;\"><strong>WordPress</strong> is the most popular blogging system in use of the Web, it is based on PHP and MySQL. It provides for creating, editing and managing content on the website.</span></p>\r\n<p><span style=\"font-size: 8pt;\">Our developing team stands for the proper approach to work. Every created website passes beta-testing. After succeeding on beta-testing, it goes to production.&nbsp;Development is based on Behaviour Driven principles. Client provides us specifications in the form of instructions (&laquo;I press this button and then I see this and I get correct result\"). Other words, scenario. Based on the scenario, developers start coding. After coding goes beta-testing.&nbsp;We use Continuous Integration services for testing, which are carrying beta. If testing is successful, a code goes on production.</span></p>\r\n<p><span style=\"font-size: 8pt;\">&nbsp;</span></p>\r\n<p><span style=\"font-size: 8pt;\">&nbsp;</span></p>');
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
  CONSTRAINT `FK_80D4C541EA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media__media` (`id`),
  CONSTRAINT `FK_80D4C5414E7AF8F` FOREIGN KEY (`gallery_id`) REFERENCES `media__gallery` (`id`)
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
  `category_id` int(11) DEFAULT NULL,
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
  `cdn_flush_identifier` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_5C6DD74E12469DE2` (`category_id`),
  CONSTRAINT `FK_5C6DD74E12469DE2` FOREIGN KEY (`category_id`) REFERENCES `classification__category` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media__media`
--

LOCK TABLES `media__media` WRITE;
/*!40000 ALTER TABLE `media__media` DISABLE KEYS */;
INSERT INTO `media__media` VALUES (4,1,'may-15-may-the-force-be-with-you-cal-2560x1440.jpg',NULL,0,'sonata.media.provider.image',1,'de56535a96e08cafca5e849322ae72f039bf0920.jpeg','{\"filename\":\"may-15-may-the-force-be-with-you-cal-2560x1440.jpg\"}',2560,1440,NULL,'image/jpeg',410235,NULL,NULL,'default',NULL,NULL,NULL,'2015-06-25 16:07:54','2015-06-25 16:07:54',NULL),(5,1,'wall (copy).jpg',NULL,0,'sonata.media.provider.image',1,'26b051d7189e9d0cd3343fde83d214423a5ebca1.jpeg','{\"filename\":\"wall (copy).jpg\"}',1366,768,NULL,'image/jpeg',384654,NULL,NULL,'default',NULL,NULL,NULL,'2015-06-25 16:08:23','2015-06-25 16:08:23',NULL),(9,1,'Louis Vuitton - City Guide 2014','Directed by  Romain Chassaing\nDOP : Mahdi Lepart\nAgency : DesQuatre\nProducer : Edouard Chassaing\nProduced by Solab\nMusic : AU REVOIR SIMONE - \"TELL ME - CLOCK OPERA REMIX\"\nMoshi Moshi Records\nMany Thanks to :\nShangri La Hotel in Paris, Ito Restaurant & Yoom Restaurant in Paris\nTom Berendsen from Legs (LA-NY), \nIris & Edmond from Eagle Media (Shanghai),\nElisa & Elia from Studio Liz (Venezia)',0,'sonata.media.provider.vimeo',1,'130524176','{\"type\":\"video\",\"version\":\"1.0\",\"provider_name\":\"Vimeo\",\"provider_url\":\"https:\\/\\/vimeo.com\\/\",\"title\":\"Louis Vuitton - City Guide 2014\",\"author_name\":\"Romain Chassaing\",\"author_url\":\"http:\\/\\/vimeo.com\\/user40994803\",\"is_plus\":\"1\",\"html\":\"<iframe src=\\\"https:\\/\\/player.vimeo.com\\/video\\/130524176\\\" width=\\\"1280\\\" height=\\\"720\\\" frameborder=\\\"0\\\" title=\\\"Louis Vuitton - City Guide 2014\\\" webkitallowfullscreen mozallowfullscreen allowfullscreen><\\/iframe>\",\"width\":1280,\"height\":720,\"duration\":109,\"description\":\"Directed by  Romain Chassaing\\nDOP : Mahdi Lepart\\nAgency : DesQuatre\\nProducer : Edouard Chassaing\\nProduced by Solab\\nMusic : AU REVOIR SIMONE - \\\"TELL ME - CLOCK OPERA REMIX\\\"\\nMoshi Moshi Records\\nMany Thanks to :\\nShangri La Hotel in Paris, Ito Restaurant & Yoom Restaurant in Paris\\nTom Berendsen from Legs (LA-NY), \\nIris & Edmond from Eagle Media (Shanghai),\\nElisa & Elia from Studio Liz (Venezia)\",\"thumbnail_url\":\"http:\\/\\/i.vimeocdn.com\\/video\\/522418355_1280.jpg\",\"thumbnail_width\":1280,\"thumbnail_height\":720,\"video_id\":130524176,\"uri\":\"\\/videos\\/130524176\"}',1280,720,109,'video/x-flv',NULL,NULL,'Romain Chassaing','default',NULL,NULL,NULL,'2015-06-25 16:48:24','2015-06-25 16:48:24',NULL),(10,1,'Louis Vuitton - City Guide 2014','Directed by  Romain Chassaing\nDOP : Mahdi Lepart\nAgency : DesQuatre\nProducer : Edouard Chassaing\nProduced by Solab\nMusic : AU REVOIR SIMONE - \"TELL ME - CLOCK OPERA REMIX\"\nMoshi Moshi Records\nMany Thanks to :\nShangri La Hotel in Paris, Ito Restaurant & Yoom Restaurant in Paris\nTom Berendsen from Legs (LA-NY), \nIris & Edmond from Eagle Media (Shanghai),\nElisa & Elia from Studio Liz (Venezia)',0,'sonata.media.provider.vimeo',1,'130524176','{\"type\":\"video\",\"version\":\"1.0\",\"provider_name\":\"Vimeo\",\"provider_url\":\"https:\\/\\/vimeo.com\\/\",\"title\":\"Louis Vuitton - City Guide 2014\",\"author_name\":\"Romain Chassaing\",\"author_url\":\"http:\\/\\/vimeo.com\\/user40994803\",\"is_plus\":\"1\",\"html\":\"<iframe src=\\\"https:\\/\\/player.vimeo.com\\/video\\/130524176\\\" width=\\\"1280\\\" height=\\\"720\\\" frameborder=\\\"0\\\" title=\\\"Louis Vuitton - City Guide 2014\\\" webkitallowfullscreen mozallowfullscreen allowfullscreen><\\/iframe>\",\"width\":1280,\"height\":720,\"duration\":109,\"description\":\"Directed by  Romain Chassaing\\nDOP : Mahdi Lepart\\nAgency : DesQuatre\\nProducer : Edouard Chassaing\\nProduced by Solab\\nMusic : AU REVOIR SIMONE - \\\"TELL ME - CLOCK OPERA REMIX\\\"\\nMoshi Moshi Records\\nMany Thanks to :\\nShangri La Hotel in Paris, Ito Restaurant & Yoom Restaurant in Paris\\nTom Berendsen from Legs (LA-NY), \\nIris & Edmond from Eagle Media (Shanghai),\\nElisa & Elia from Studio Liz (Venezia)\",\"thumbnail_url\":\"http:\\/\\/i.vimeocdn.com\\/video\\/522418355_1280.jpg\",\"thumbnail_width\":1280,\"thumbnail_height\":720,\"video_id\":130524176,\"uri\":\"\\/videos\\/130524176\"}',1280,720,109,'video/x-flv',NULL,NULL,'Romain Chassaing','default',NULL,NULL,NULL,'2015-07-18 15:24:51','2015-07-18 15:24:51',NULL),(11,1,'Louis Vuitton - City Guide 2014','Directed by  Romain Chassaing\nDOP : Mahdi Lepart\nAgency : DesQuatre\nProducer : Edouard Chassaing\nProduced by Solab\nMusic : AU REVOIR SIMONE - \"TELL ME - CLOCK OPERA REMIX\"\nMoshi Moshi Records\nMany Thanks to :\nShangri La Hotel in Paris, Ito Restaurant & Yoom Restaurant in Paris\nTom Berendsen from Legs (LA-NY), \nIris & Edmond from Eagle Media (Shanghai),\nElisa & Elia from Studio Liz (Venezia)',0,'sonata.media.provider.vimeo',1,'130524176','{\"type\":\"video\",\"version\":\"1.0\",\"provider_name\":\"Vimeo\",\"provider_url\":\"https:\\/\\/vimeo.com\\/\",\"title\":\"Louis Vuitton - City Guide 2014\",\"author_name\":\"Romain Chassaing\",\"author_url\":\"http:\\/\\/vimeo.com\\/user40994803\",\"is_plus\":\"1\",\"html\":\"<iframe src=\\\"https:\\/\\/player.vimeo.com\\/video\\/130524176\\\" width=\\\"1280\\\" height=\\\"720\\\" frameborder=\\\"0\\\" title=\\\"Louis Vuitton - City Guide 2014\\\" webkitallowfullscreen mozallowfullscreen allowfullscreen><\\/iframe>\",\"width\":1280,\"height\":720,\"duration\":109,\"description\":\"Directed by  Romain Chassaing\\nDOP : Mahdi Lepart\\nAgency : DesQuatre\\nProducer : Edouard Chassaing\\nProduced by Solab\\nMusic : AU REVOIR SIMONE - \\\"TELL ME - CLOCK OPERA REMIX\\\"\\nMoshi Moshi Records\\nMany Thanks to :\\nShangri La Hotel in Paris, Ito Restaurant & Yoom Restaurant in Paris\\nTom Berendsen from Legs (LA-NY), \\nIris & Edmond from Eagle Media (Shanghai),\\nElisa & Elia from Studio Liz (Venezia)\",\"thumbnail_url\":\"http:\\/\\/i.vimeocdn.com\\/video\\/522418355_1280.jpg\",\"thumbnail_width\":1280,\"thumbnail_height\":720,\"video_id\":130524176,\"uri\":\"\\/videos\\/130524176\"}',1280,720,109,'video/x-flv',NULL,NULL,'Romain Chassaing','default',NULL,NULL,NULL,'2015-07-18 15:25:00','2015-07-18 15:25:00',NULL),(12,1,'Louis Vuitton - City Guide 2014','Directed by  Romain Chassaing\nDOP : Mahdi Lepart\nAgency : DesQuatre\nProducer : Edouard Chassaing\nProduced by Solab\nMusic : AU REVOIR SIMONE - \"TELL ME - CLOCK OPERA REMIX\"\nMoshi Moshi Records\nMany Thanks to :\nShangri La Hotel in Paris, Ito Restaurant & Yoom Restaurant in Paris\nTom Berendsen from Legs (LA-NY), \nIris & Edmond from Eagle Media (Shanghai),\nElisa & Elia from Studio Liz (Venezia)',0,'sonata.media.provider.vimeo',1,'130524176','{\"type\":\"video\",\"version\":\"1.0\",\"provider_name\":\"Vimeo\",\"provider_url\":\"https:\\/\\/vimeo.com\\/\",\"title\":\"Louis Vuitton - City Guide 2014\",\"author_name\":\"Romain Chassaing\",\"author_url\":\"http:\\/\\/vimeo.com\\/user40994803\",\"is_plus\":\"1\",\"html\":\"<iframe src=\\\"https:\\/\\/player.vimeo.com\\/video\\/130524176\\\" width=\\\"1280\\\" height=\\\"720\\\" frameborder=\\\"0\\\" title=\\\"Louis Vuitton - City Guide 2014\\\" webkitallowfullscreen mozallowfullscreen allowfullscreen><\\/iframe>\",\"width\":1280,\"height\":720,\"duration\":109,\"description\":\"Directed by  Romain Chassaing\\nDOP : Mahdi Lepart\\nAgency : DesQuatre\\nProducer : Edouard Chassaing\\nProduced by Solab\\nMusic : AU REVOIR SIMONE - \\\"TELL ME - CLOCK OPERA REMIX\\\"\\nMoshi Moshi Records\\nMany Thanks to :\\nShangri La Hotel in Paris, Ito Restaurant & Yoom Restaurant in Paris\\nTom Berendsen from Legs (LA-NY), \\nIris & Edmond from Eagle Media (Shanghai),\\nElisa & Elia from Studio Liz (Venezia)\",\"thumbnail_url\":\"http:\\/\\/i.vimeocdn.com\\/video\\/522418355_1280.jpg\",\"thumbnail_width\":1280,\"thumbnail_height\":720,\"video_id\":130524176,\"uri\":\"\\/videos\\/130524176\"}',1280,720,109,'video/x-flv',NULL,NULL,'Romain Chassaing','default',NULL,NULL,NULL,'2015-07-18 15:25:03','2015-07-18 15:25:03',NULL),(13,1,'Louis Vuitton - City Guide 2014','Directed by  Romain Chassaing\nDOP : Mahdi Lepart\nAgency : DesQuatre\nProducer : Edouard Chassaing\nProduced by Solab\nMusic : AU REVOIR SIMONE - \"TELL ME - CLOCK OPERA REMIX\"\nMoshi Moshi Records\nMany Thanks to :\nShangri La Hotel in Paris, Ito Restaurant & Yoom Restaurant in Paris\nTom Berendsen from Legs (LA-NY), \nIris & Edmond from Eagle Media (Shanghai),\nElisa & Elia from Studio Liz (Venezia)',0,'sonata.media.provider.vimeo',1,'130524176','{\"type\":\"video\",\"version\":\"1.0\",\"provider_name\":\"Vimeo\",\"provider_url\":\"https:\\/\\/vimeo.com\\/\",\"title\":\"Louis Vuitton - City Guide 2014\",\"author_name\":\"Romain Chassaing\",\"author_url\":\"http:\\/\\/vimeo.com\\/user40994803\",\"is_plus\":\"1\",\"html\":\"<iframe src=\\\"https:\\/\\/player.vimeo.com\\/video\\/130524176\\\" width=\\\"1280\\\" height=\\\"720\\\" frameborder=\\\"0\\\" title=\\\"Louis Vuitton - City Guide 2014\\\" webkitallowfullscreen mozallowfullscreen allowfullscreen><\\/iframe>\",\"width\":1280,\"height\":720,\"duration\":109,\"description\":\"Directed by  Romain Chassaing\\nDOP : Mahdi Lepart\\nAgency : DesQuatre\\nProducer : Edouard Chassaing\\nProduced by Solab\\nMusic : AU REVOIR SIMONE - \\\"TELL ME - CLOCK OPERA REMIX\\\"\\nMoshi Moshi Records\\nMany Thanks to :\\nShangri La Hotel in Paris, Ito Restaurant & Yoom Restaurant in Paris\\nTom Berendsen from Legs (LA-NY), \\nIris & Edmond from Eagle Media (Shanghai),\\nElisa & Elia from Studio Liz (Venezia)\",\"thumbnail_url\":\"http:\\/\\/i.vimeocdn.com\\/video\\/522418355_1280.jpg\",\"thumbnail_width\":1280,\"thumbnail_height\":720,\"video_id\":130524176,\"uri\":\"\\/videos\\/130524176\"}',1280,720,109,'video/x-flv',NULL,NULL,'Romain Chassaing','default',NULL,NULL,NULL,'2015-07-18 15:25:06','2015-07-18 15:25:06',NULL),(14,1,'Louis Vuitton - City Guide 2014','Directed by  Romain Chassaing\nDOP : Mahdi Lepart\nAgency : DesQuatre\nProducer : Edouard Chassaing\nProduced by Solab\nMusic : AU REVOIR SIMONE - \"TELL ME - CLOCK OPERA REMIX\"\nMoshi Moshi Records\nMany Thanks to :\nShangri La Hotel in Paris, Ito Restaurant & Yoom Restaurant in Paris\nTom Berendsen from Legs (LA-NY), \nIris & Edmond from Eagle Media (Shanghai),\nElisa & Elia from Studio Liz (Venezia)',0,'sonata.media.provider.vimeo',1,'130524176','{\"type\":\"video\",\"version\":\"1.0\",\"provider_name\":\"Vimeo\",\"provider_url\":\"https:\\/\\/vimeo.com\\/\",\"title\":\"Louis Vuitton - City Guide 2014\",\"author_name\":\"Romain Chassaing\",\"author_url\":\"http:\\/\\/vimeo.com\\/user40994803\",\"is_plus\":\"1\",\"html\":\"<iframe src=\\\"https:\\/\\/player.vimeo.com\\/video\\/130524176\\\" width=\\\"1280\\\" height=\\\"720\\\" frameborder=\\\"0\\\" title=\\\"Louis Vuitton - City Guide 2014\\\" webkitallowfullscreen mozallowfullscreen allowfullscreen><\\/iframe>\",\"width\":1280,\"height\":720,\"duration\":109,\"description\":\"Directed by  Romain Chassaing\\nDOP : Mahdi Lepart\\nAgency : DesQuatre\\nProducer : Edouard Chassaing\\nProduced by Solab\\nMusic : AU REVOIR SIMONE - \\\"TELL ME - CLOCK OPERA REMIX\\\"\\nMoshi Moshi Records\\nMany Thanks to :\\nShangri La Hotel in Paris, Ito Restaurant & Yoom Restaurant in Paris\\nTom Berendsen from Legs (LA-NY), \\nIris & Edmond from Eagle Media (Shanghai),\\nElisa & Elia from Studio Liz (Venezia)\",\"thumbnail_url\":\"http:\\/\\/i.vimeocdn.com\\/video\\/522418355_1280.jpg\",\"thumbnail_width\":1280,\"thumbnail_height\":720,\"video_id\":130524176,\"uri\":\"\\/videos\\/130524176\"}',1280,720,109,'video/x-flv',NULL,NULL,'Romain Chassaing','default',NULL,NULL,NULL,'2015-07-18 15:25:08','2015-07-18 15:25:08',NULL),(15,1,'Louis Vuitton - City Guide 2014','Directed by  Romain Chassaing\nDOP : Mahdi Lepart\nAgency : DesQuatre\nProducer : Edouard Chassaing\nProduced by Solab\nMusic : AU REVOIR SIMONE - \"TELL ME - CLOCK OPERA REMIX\"\nMoshi Moshi Records\nMany Thanks to :\nShangri La Hotel in Paris, Ito Restaurant & Yoom Restaurant in Paris\nTom Berendsen from Legs (LA-NY), \nIris & Edmond from Eagle Media (Shanghai),\nElisa & Elia from Studio Liz (Venezia)',0,'sonata.media.provider.vimeo',1,'130524176','{\"type\":\"video\",\"version\":\"1.0\",\"provider_name\":\"Vimeo\",\"provider_url\":\"https:\\/\\/vimeo.com\\/\",\"title\":\"Louis Vuitton - City Guide 2014\",\"author_name\":\"Romain Chassaing\",\"author_url\":\"http:\\/\\/vimeo.com\\/user40994803\",\"is_plus\":\"1\",\"html\":\"<iframe src=\\\"https:\\/\\/player.vimeo.com\\/video\\/130524176\\\" width=\\\"1280\\\" height=\\\"720\\\" frameborder=\\\"0\\\" title=\\\"Louis Vuitton - City Guide 2014\\\" webkitallowfullscreen mozallowfullscreen allowfullscreen><\\/iframe>\",\"width\":1280,\"height\":720,\"duration\":109,\"description\":\"Directed by  Romain Chassaing\\nDOP : Mahdi Lepart\\nAgency : DesQuatre\\nProducer : Edouard Chassaing\\nProduced by Solab\\nMusic : AU REVOIR SIMONE - \\\"TELL ME - CLOCK OPERA REMIX\\\"\\nMoshi Moshi Records\\nMany Thanks to :\\nShangri La Hotel in Paris, Ito Restaurant & Yoom Restaurant in Paris\\nTom Berendsen from Legs (LA-NY), \\nIris & Edmond from Eagle Media (Shanghai),\\nElisa & Elia from Studio Liz (Venezia)\",\"thumbnail_url\":\"http:\\/\\/i.vimeocdn.com\\/video\\/522418355_1280.jpg\",\"thumbnail_width\":1280,\"thumbnail_height\":720,\"video_id\":130524176,\"uri\":\"\\/videos\\/130524176\"}',1280,720,109,'video/x-flv',NULL,NULL,'Romain Chassaing','default',NULL,NULL,NULL,'2015-07-18 15:25:11','2015-07-18 15:25:11',NULL),(16,1,'Louis Vuitton - City Guide 2014','Directed by  Romain Chassaing\nDOP : Mahdi Lepart\nAgency : DesQuatre\nProducer : Edouard Chassaing\nProduced by Solab\nMusic : AU REVOIR SIMONE - \"TELL ME - CLOCK OPERA REMIX\"\nMoshi Moshi Records\nMany Thanks to :\nShangri La Hotel in Paris, Ito Restaurant & Yoom Restaurant in Paris\nTom Berendsen from Legs (LA-NY), \nIris & Edmond from Eagle Media (Shanghai),\nElisa & Elia from Studio Liz (Venezia)',0,'sonata.media.provider.vimeo',1,'130524176','{\"type\":\"video\",\"version\":\"1.0\",\"provider_name\":\"Vimeo\",\"provider_url\":\"https:\\/\\/vimeo.com\\/\",\"title\":\"Louis Vuitton - City Guide 2014\",\"author_name\":\"Romain Chassaing\",\"author_url\":\"http:\\/\\/vimeo.com\\/user40994803\",\"is_plus\":\"1\",\"html\":\"<iframe src=\\\"https:\\/\\/player.vimeo.com\\/video\\/130524176\\\" width=\\\"1280\\\" height=\\\"720\\\" frameborder=\\\"0\\\" title=\\\"Louis Vuitton - City Guide 2014\\\" webkitallowfullscreen mozallowfullscreen allowfullscreen><\\/iframe>\",\"width\":1280,\"height\":720,\"duration\":109,\"description\":\"Directed by  Romain Chassaing\\nDOP : Mahdi Lepart\\nAgency : DesQuatre\\nProducer : Edouard Chassaing\\nProduced by Solab\\nMusic : AU REVOIR SIMONE - \\\"TELL ME - CLOCK OPERA REMIX\\\"\\nMoshi Moshi Records\\nMany Thanks to :\\nShangri La Hotel in Paris, Ito Restaurant & Yoom Restaurant in Paris\\nTom Berendsen from Legs (LA-NY), \\nIris & Edmond from Eagle Media (Shanghai),\\nElisa & Elia from Studio Liz (Venezia)\",\"thumbnail_url\":\"http:\\/\\/i.vimeocdn.com\\/video\\/522418355_1280.jpg\",\"thumbnail_width\":1280,\"thumbnail_height\":720,\"video_id\":130524176,\"uri\":\"\\/videos\\/130524176\"}',1280,720,109,'video/x-flv',NULL,NULL,'Romain Chassaing','default',NULL,NULL,NULL,'2015-07-18 15:25:18','2015-07-18 15:25:18',NULL),(17,1,'Louis Vuitton - City Guide 2014','Directed by  Romain Chassaing\nDOP : Mahdi Lepart\nAgency : DesQuatre\nProducer : Edouard Chassaing\nProduced by Solab\nMusic : AU REVOIR SIMONE - \"TELL ME - CLOCK OPERA REMIX\"\nMoshi Moshi Records\nMany Thanks to :\nShangri La Hotel in Paris, Ito Restaurant & Yoom Restaurant in Paris\nTom Berendsen from Legs (LA-NY), \nIris & Edmond from Eagle Media (Shanghai),\nElisa & Elia from Studio Liz (Venezia)',0,'sonata.media.provider.vimeo',1,'130524176','{\"type\":\"video\",\"version\":\"1.0\",\"provider_name\":\"Vimeo\",\"provider_url\":\"https:\\/\\/vimeo.com\\/\",\"title\":\"Louis Vuitton - City Guide 2014\",\"author_name\":\"Romain Chassaing\",\"author_url\":\"http:\\/\\/vimeo.com\\/user40994803\",\"is_plus\":\"1\",\"html\":\"<iframe src=\\\"https:\\/\\/player.vimeo.com\\/video\\/130524176\\\" width=\\\"1280\\\" height=\\\"720\\\" frameborder=\\\"0\\\" title=\\\"Louis Vuitton - City Guide 2014\\\" webkitallowfullscreen mozallowfullscreen allowfullscreen><\\/iframe>\",\"width\":1280,\"height\":720,\"duration\":109,\"description\":\"Directed by  Romain Chassaing\\nDOP : Mahdi Lepart\\nAgency : DesQuatre\\nProducer : Edouard Chassaing\\nProduced by Solab\\nMusic : AU REVOIR SIMONE - \\\"TELL ME - CLOCK OPERA REMIX\\\"\\nMoshi Moshi Records\\nMany Thanks to :\\nShangri La Hotel in Paris, Ito Restaurant & Yoom Restaurant in Paris\\nTom Berendsen from Legs (LA-NY), \\nIris & Edmond from Eagle Media (Shanghai),\\nElisa & Elia from Studio Liz (Venezia)\",\"thumbnail_url\":\"http:\\/\\/i.vimeocdn.com\\/video\\/522418355_1280.jpg\",\"thumbnail_width\":1280,\"thumbnail_height\":720,\"video_id\":130524176,\"uri\":\"\\/videos\\/130524176\"}',1280,720,109,'video/x-flv',NULL,NULL,'Romain Chassaing','default',NULL,NULL,NULL,'2015-07-18 15:25:21','2015-07-18 15:25:21',NULL),(18,1,'l1GI3sETrew.jpg',NULL,0,'sonata.media.provider.image',1,'960f7d160db54b8bc93861b3e727573dcf8edf24.jpeg','{\"filename\":\"l1GI3sETrew.jpg\"}',800,535,NULL,'image/jpeg',104771,NULL,NULL,'default',NULL,NULL,NULL,'2015-08-10 11:09:14','2015-08-10 11:09:14',NULL),(19,1,'1dolya.jpg',NULL,0,'sonata.media.provider.image',1,'a557d355a1dd1be5de33676cd04015ebaf72a904.jpeg','{\"filename\":\"1dolya.jpg\"}',1600,900,NULL,'image/jpeg',789887,NULL,NULL,'default',NULL,NULL,NULL,'2015-08-12 04:16:46','2015-08-12 04:16:46',NULL),(20,1,'1dolya.jpg',NULL,0,'sonata.media.provider.image',1,'96a2ce5fb050a2156614bec038cdcc833b4e342d.jpeg','{\"filename\":\"1dolya.jpg\"}',1600,900,NULL,'image/jpeg',789887,NULL,NULL,'default',NULL,NULL,NULL,'2015-08-12 04:25:27','2015-08-12 04:25:27',NULL),(21,1,'1dolya.jpg',NULL,0,'sonata.media.provider.image',1,'f39a118d33640ff74186b43385e5244b23ff5b13.jpeg','{\"filename\":\"1dolya.jpg\"}',1600,900,NULL,'image/jpeg',789887,NULL,NULL,'default',NULL,NULL,NULL,'2015-08-12 04:25:27','2015-08-12 04:25:27',NULL),(22,1,'2dolya.jpg',NULL,0,'sonata.media.provider.image',1,'4143da550fd2957d77daa15ce3458f4f65214f83.jpeg','{\"filename\":\"2dolya.jpg\"}',1600,900,NULL,'image/jpeg',702951,NULL,NULL,'default',NULL,NULL,NULL,'2015-08-12 04:32:08','2015-08-12 04:32:08',NULL),(23,1,'chicago_#2.jpg',NULL,0,'sonata.media.provider.image',1,'5e6e329d099ebaa7e58f6789a07aecdc127e4326.jpeg','{\"filename\":\"chicago_#2.jpg\"}',1920,1080,NULL,'image/jpeg',2300033,NULL,NULL,'default',NULL,NULL,NULL,'2015-08-12 12:35:57','2015-08-12 12:35:57',NULL),(24,1,'matrix.jpg',NULL,0,'sonata.media.provider.image',1,'507cfa37bc0416f7a044ddb5e8d936ae84ecb85a.jpeg','{\"filename\":\"matrix.jpg\"}',1920,1080,NULL,'image/jpeg',3399692,NULL,NULL,'default',NULL,NULL,NULL,'2015-08-12 12:37:57','2015-08-12 12:37:57',NULL),(25,1,'робота спальня1.jpg',NULL,0,'sonata.media.provider.image',1,'2265803237dbe8e1fe8ccf35f80b3f785d4cfd57.jpeg','{\"filename\":\"\\u0440\\u043e\\u0431\\u043e\\u0442\\u0430 \\u0441\\u043f\\u0430\\u043b\\u044c\\u043d\\u044f1.jpg\"}',1600,900,NULL,'image/jpeg',1293504,NULL,NULL,'default',NULL,NULL,NULL,'2015-09-10 03:10:28','2015-09-10 03:10:28',NULL),(26,1,'GC_team (2).jpg',NULL,0,'sonata.media.provider.image',1,'aee97a284992eeeb2ccbb908eb9654027706580e.jpeg','{\"filename\":\"GC_team (2).jpg\"}',1200,895,NULL,'image/jpeg',106693,NULL,NULL,'default',NULL,NULL,NULL,'2015-09-10 03:13:17','2015-09-10 03:13:17',NULL),(27,1,'slide 2(1).jpg',NULL,0,'sonata.media.provider.image',1,'04373ac6d8d12951b0dcca745ca4a8020d0bd67e.jpeg','{\"filename\":\"slide 2(1).jpg\"}',1300,866,NULL,'image/jpeg',106274,NULL,NULL,'default',NULL,NULL,NULL,'2015-09-10 03:17:07','2015-09-10 03:17:07',NULL),(28,1,'slide3.jpg',NULL,0,'sonata.media.provider.image',1,'e972a4b96810608784945dc304f488b34a5aca18.jpeg','{\"filename\":\"slide3.jpg\"}',1200,662,NULL,'image/jpeg',109614,NULL,NULL,'default',NULL,NULL,NULL,'2015-09-10 03:20:50','2015-09-10 03:20:50',NULL),(29,1,'slide4.jpg',NULL,0,'sonata.media.provider.image',1,'de53e3256f98720818aa71e9acf2e68d3f2516e0.jpeg','{\"filename\":\"slide4.jpg\"}',2862,2000,NULL,'image/jpeg',607565,NULL,NULL,'default',NULL,NULL,NULL,'2015-09-10 03:32:27','2015-09-10 03:32:27',NULL),(30,1,'slide4.jpg',NULL,0,'sonata.media.provider.image',1,'d0451fec6c5f5bcbcfd285dfa48613744f6b83f3.jpeg','{\"filename\":\"slide4.jpg\"}',2862,2000,NULL,'image/jpeg',607565,NULL,NULL,'default',NULL,NULL,NULL,'2015-09-10 03:36:07','2015-09-10 03:36:07',NULL),(31,1,'робота спальня.jpg',NULL,0,'sonata.media.provider.image',1,'bf9eb7d3c77a01bc20ba87f5ff03b9441e528dfc.jpeg','{\"filename\":\"\\u0440\\u043e\\u0431\\u043e\\u0442\\u0430 \\u0441\\u043f\\u0430\\u043b\\u044c\\u043d\\u044f.jpg\"}',1600,900,NULL,'image/jpeg',1067229,NULL,NULL,'default',NULL,NULL,NULL,'2015-09-10 03:46:15','2015-09-10 03:46:15',NULL),(32,1,'робота спальня2.jpg',NULL,0,'sonata.media.provider.image',1,'a168c6156a5bb428ae021d9a3c4703194047bf6e.jpeg','{\"filename\":\"\\u0440\\u043e\\u0431\\u043e\\u0442\\u0430 \\u0441\\u043f\\u0430\\u043b\\u044c\\u043d\\u044f2.jpg\"}',1600,900,NULL,'image/jpeg',1284798,NULL,NULL,'default',NULL,NULL,NULL,'2015-09-10 03:46:33','2015-09-10 03:46:33',NULL),(33,1,'робота спальня1.jpg',NULL,0,'sonata.media.provider.image',1,'2b9d808bb048eeb36c8b7bb3a84e0e46a09e130a.jpeg','{\"filename\":\"\\u0440\\u043e\\u0431\\u043e\\u0442\\u0430 \\u0441\\u043f\\u0430\\u043b\\u044c\\u043d\\u044f1.jpg\"}',1600,900,NULL,'image/jpeg',1293504,NULL,NULL,'default',NULL,NULL,NULL,'2015-09-10 03:46:58','2015-09-10 03:46:58',NULL),(34,1,'робота спальня1.jpg',NULL,0,'sonata.media.provider.image',1,'c5a215bb71f2c3231bd37e7756ffc82dfc044048.jpeg','{\"filename\":\"\\u0440\\u043e\\u0431\\u043e\\u0442\\u0430 \\u0441\\u043f\\u0430\\u043b\\u044c\\u043d\\u044f1.jpg\"}',1600,900,NULL,'image/jpeg',1293504,NULL,NULL,'default',NULL,NULL,NULL,'2015-09-10 03:47:00','2015-09-10 03:47:00',NULL),(35,1,'vikings-medieval-midgard-swords-blacksmith-forge.jpg',NULL,0,'sonata.media.provider.image',1,'932aa5ee3f0ffc70b71936fb6e1cda9ef75fec0e.jpeg','{\"filename\":\"vikings-medieval-midgard-swords-blacksmith-forge.jpg\"}',1920,1440,NULL,'image/jpeg',236917,NULL,NULL,'default',NULL,NULL,NULL,'2015-09-14 10:44:13','2015-09-14 10:44:13',NULL),(36,1,'slide3.jpg',NULL,0,'sonata.media.provider.image',1,'da4573824fa70c9e21101304d062a52c33312ef9.jpeg','{\"filename\":\"slide3.jpg\"}',1200,662,NULL,'image/jpeg',109614,NULL,NULL,'default',NULL,NULL,NULL,'2015-09-20 06:03:16','2015-09-20 06:03:16',NULL);
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
  `category_id` int(11) DEFAULT NULL,
  `full_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `postal` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `comments` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `discr` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `use_3d_graphics` tinyint(1) DEFAULT NULL,
  `color_psychology` tinyint(1) DEFAULT NULL,
  `color_preferences` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `max_video_length` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `format` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `music` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `additional_effect` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `materials_total_gbs` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `designer_consultancy` tinyint(1) DEFAULT NULL,
  `media_equip_integration` tinyint(1) DEFAULT NULL,
  `floor_material` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ceiling_material` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `walls_material` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `furniture` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `classic_coloristics_canon` tinyint(1) DEFAULT NULL,
  `dominant_color` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL,
  `secondary_color` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL,
  `use_feng_shui` tinyint(1) DEFAULT NULL,
  `birth_date` datetime DEFAULT NULL,
  `use_feng_shui_for_partner` tinyint(1) DEFAULT NULL,
  `subcategory` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `light_design` tinyint(1) DEFAULT NULL,
  `style_example` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `drawing` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `environment_photo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_E52FFDEE12469DE2` (`category_id`),
  CONSTRAINT `FK_E52FFDEE12469DE2` FOREIGN KEY (`category_id`) REFERENCES `galleries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `slides`
--

LOCK TABLES `slides` WRITE;
/*!40000 ALTER TABLE `slides` DISABLE KEYS */;
INSERT INTO `slides` VALUES (2,26,1,'<p style=\"text-align: justify;\"><span style=\"font-size: 16pt; color: #008080; font-family: helvetica;\">Imperium Design team is a group of people who are seeking of a chance to make this world better and more beautiful. We provide great design descisions for all types of premises. Our main goal is to visualize your inner space.&nbsp;&nbsp;</span></p>','1','a:6:{s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:7:\"opacity\";d:0.59999999999999998;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(3,27,1,'<p style=\"text-align: left;\"><span style=\"font-family: helvetica; font-size: 16pt; color: #3366ff;\">Doing our best, we improve your everyday life by making it more comfortable and more beneficial. Remember - your surrounding influences on your inner world, your mood and your character.</span></p>','2','a:6:{s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:7:\"opacity\";d:0.59999999999999998;s:5:\"color\";s:6:\"18252e\";s:8:\"position\";i:80;s:8:\"closable\";b:1;}'),(4,28,1,'<p><span style=\"font-family: helvetica; font-size: 16pt;\">ImD team consists of exclusive professionals you can rely on. For years we\'ve been doing our best in moviemaking, creating an interior and exterior design projects, web programming and web design.</span></p>','3','a:6:{s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:7:\"opacity\";d:0.59999999999999998;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(5,29,1,'<p><span style=\"font-size: 16pt;\"><strong><span style=\"font-family: helvetica;\">ImD Advantages:&nbsp;</span></strong></span></p>\r\n<p><span style=\"font-family: helvetica; font-size: 14pt;\">- <strong>Using high-tech to create the project.</strong> We use 3D Max, full Adobe package. As a result, we create high quality product, which helps you to visualize your thoughts and pictures in your mind.<br /></span></p>\r\n<p><span style=\"font-family: helvetica; font-size: 14pt;\">- <strong>Time economy.</strong> Leave your order online. Consult to our specialists via Skype, this helps us to understand you in a better way. We provide you full support while creating your project to nip misunderstandings. As a result, you\'ll be given a project in siutable extension and ready-to-use.</span></p>\r\n<p><span style=\"font-size: 14pt;\">&nbsp;</span></p>','4','a:6:{s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:7:\"opacity\";d:0.59999999999999998;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(6,30,1,'<p><span style=\"font-size: 16pt;\"><strong><span style=\"font-family: helvetica;\">ImD Advantages: </span></strong></span></p>\r\n<p><span style=\"font-size: 14pt; font-family: helvetica;\">- <strong>Money saving.</strong> We offer competitive prices to our clients. The average price for the project is lower than you may suspect.</span></p>\r\n<p><span style=\"font-size: 14pt; font-family: helvetica;\">- <strong>Wide range of services.</strong> From interior design to filmmaking - it depends on your needs.</span></p>','5','a:6:{s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:7:\"opacity\";d:0.59999999999999998;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:40;s:8:\"closable\";b:0;}'),(7,31,2,'<p><span style=\"font-size: 18pt; font-family: helvetica;\"><strong>The first step</strong> to bringing a&nbsp;project to life is creating <strong>a sketch</strong>.</span></p>\r\n<p><span style=\"font-size: 18pt; font-family: helvetica;\">We send it to the client <strong>to confirm</strong> and make corrections if necessary.</span></p>','6','a:6:{s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:7:\"opacity\";d:0.69999999999999996;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(8,32,2,'<p><span style=\"font-size: 18pt; font-family: helvetica;\">On the <strong>next step</strong> you\'ll be given <strong>black&amp;white rendering</strong>, a net without textures and a list of items, which will go in the project. In other words, it\'s a virtual edition of the whole project, a <strong>sceleton.</strong> This step considers ergonomic issue of space, apartment\'s practiciality.</span></p>','7','a:6:{s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:7:\"opacity\";d:0.59999999999999998;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:40;s:8:\"closable\";b:0;}'),(9,34,2,'<p><span style=\"font-size: 18pt; font-family: helvetica;\"><strong>The last step</strong> considers all components, accurate <strong>detalization</strong>, shadows, lights, materials. You are getting a finished project in any resolution you need. This will be more than enough to any of your furnishing masters.</span></p>','8','a:6:{s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:7:\"opacity\";d:0.59999999999999998;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:60;s:8:\"closable\";b:0;}'),(11,35,3,'<p><span style=\"font-size: 14pt; font-family: helvetica;\">ImD\'s designers in cooperation with blacksmiths produce forged items of different size and complexity. We allow customers to follow the process stage by stage.</span></p>','1','a:6:{s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:7:\"opacity\";d:0.59999999999999998;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}'),(12,36,5,NULL,'1','a:6:{s:7:\"opacity\";d:0.69999999999999996;s:11:\"orientation\";i:1;s:4:\"size\";i:280;s:5:\"color\";s:6:\"000000\";s:8:\"position\";i:20;s:8:\"closable\";b:0;}');
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
  CONSTRAINT `FK_29AA64321B28D904` FOREIGN KEY (`video_content`) REFERENCES `media__media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `videos`
--

LOCK TABLES `videos` WRITE;
/*!40000 ALTER TABLE `videos` DISABLE KEYS */;
INSERT INTO `videos` VALUES (1,9),(2,10),(3,11),(4,12),(5,13),(6,14),(7,15),(8,16),(9,17);
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

-- Dump completed on 2015-10-10 17:27:32
