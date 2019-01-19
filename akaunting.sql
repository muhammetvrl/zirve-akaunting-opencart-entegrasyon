-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1:3306
-- Üretim Zamanı: 10 Oca 2019, 09:47:57
-- Sunucu sürümü: 5.7.19-log
-- PHP Sürümü: 5.6.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `akaunting`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_accounts`
--

DROP TABLE IF EXISTS `dgi_accounts`;
CREATE TABLE IF NOT EXISTS `dgi_accounts` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `currency_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `opening_balance` double(15,4) NOT NULL DEFAULT '0.0000',
  `bank_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bank_phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bank_address` text COLLATE utf8mb4_unicode_ci,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `accounts_company_id_index` (`company_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_accounts`
--

INSERT INTO `dgi_accounts` (`id`, `company_id`, `name`, `number`, `currency_code`, `opening_balance`, `bank_name`, `bank_phone`, `bank_address`, `enabled`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'Kasa', '1', 'USD', 0.0000, 'Kasa', NULL, NULL, 1, '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_bills`
--

DROP TABLE IF EXISTS `dgi_bills`;
CREATE TABLE IF NOT EXISTS `dgi_bills` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `bill_number` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_number` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bill_status_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `billed_at` datetime NOT NULL,
  `due_at` datetime NOT NULL,
  `amount` double(15,4) NOT NULL,
  `currency_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `currency_rate` double(15,8) NOT NULL,
  `vendor_id` int(11) NOT NULL,
  `vendor_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vendor_email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vendor_tax_number` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vendor_phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vendor_address` text COLLATE utf8mb4_unicode_ci,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `category_id` int(11) NOT NULL DEFAULT '1',
  `parent_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `bills_company_id_bill_number_deleted_at_unique` (`company_id`,`bill_number`,`deleted_at`),
  KEY `bills_company_id_index` (`company_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_bill_histories`
--

DROP TABLE IF EXISTS `dgi_bill_histories`;
CREATE TABLE IF NOT EXISTS `dgi_bill_histories` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `bill_id` int(11) NOT NULL,
  `status_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notify` tinyint(1) NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bill_histories_company_id_index` (`company_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_bill_items`
--

DROP TABLE IF EXISTS `dgi_bill_items`;
CREATE TABLE IF NOT EXISTS `dgi_bill_items` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `bill_id` int(11) NOT NULL,
  `item_id` int(11) DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sku` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` double(7,2) NOT NULL,
  `price` double(15,4) NOT NULL,
  `total` double(15,4) NOT NULL,
  `tax` double(15,4) NOT NULL DEFAULT '0.0000',
  `tax_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bill_items_company_id_index` (`company_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_bill_payments`
--

DROP TABLE IF EXISTS `dgi_bill_payments`;
CREATE TABLE IF NOT EXISTS `dgi_bill_payments` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `bill_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `paid_at` datetime NOT NULL,
  `amount` double(15,4) NOT NULL,
  `currency_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `currency_rate` double(15,8) NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `payment_method` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bill_payments_company_id_index` (`company_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_bill_statuses`
--

DROP TABLE IF EXISTS `dgi_bill_statuses`;
CREATE TABLE IF NOT EXISTS `dgi_bill_statuses` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bill_statuses_company_id_index` (`company_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_bill_statuses`
--

INSERT INTO `dgi_bill_statuses` (`id`, `company_id`, `name`, `code`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'Taslak', 'draft', '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL),
(2, 1, 'Teslim Alındı', 'received', '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL),
(3, 1, 'Kısmi', 'partial', '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL),
(4, 1, 'Ödenmiş', 'paid', '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_bill_totals`
--

DROP TABLE IF EXISTS `dgi_bill_totals`;
CREATE TABLE IF NOT EXISTS `dgi_bill_totals` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `bill_id` int(11) NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` double(15,4) NOT NULL,
  `sort_order` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bill_totals_company_id_index` (`company_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_categories`
--

DROP TABLE IF EXISTS `dgi_categories`;
CREATE TABLE IF NOT EXISTS `dgi_categories` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `color` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `categories_company_id_index` (`company_id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_categories`
--

INSERT INTO `dgi_categories` (`id`, `company_id`, `name`, `type`, `color`, `enabled`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'Transfer', 'other', '#605ca8', 1, '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL),
(2, 1, 'Depozito', 'income', '#f39c12', 1, '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL),
(3, 1, 'Satış', 'income', '#6da252', 1, '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL),
(4, 1, 'Diğer', 'expense', '#d2d6de', 1, '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL),
(5, 1, 'Genel', 'item', '#00c0ef', 1, '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL),
(6, 1, 'teknoloji', 'item', '#0a19a1', 1, '2018-11-09 16:40:31', '2018-11-09 16:40:31', NULL),
(7, 1, 'Giyim Aksesuar', 'item', '#00a65a', 1, '2018-11-12 17:01:44', '2018-11-12 17:01:44', NULL);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_companies`
--

DROP TABLE IF EXISTS `dgi_companies`;
CREATE TABLE IF NOT EXISTS `dgi_companies` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `domain` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_companies`
--

INSERT INTO `dgi_companies` (`id`, `domain`, `enabled`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, '', 1, '2018-10-21 11:53:05', '2018-10-21 11:53:05', NULL);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_currencies`
--

DROP TABLE IF EXISTS `dgi_currencies`;
CREATE TABLE IF NOT EXISTS `dgi_currencies` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rate` double(15,8) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `precision` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `symbol` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `symbol_first` int(11) NOT NULL DEFAULT '1',
  `decimal_mark` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `thousands_separator` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `currencies_company_id_code_deleted_at_unique` (`company_id`,`code`,`deleted_at`),
  KEY `currencies_company_id_index` (`company_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_currencies`
--

INSERT INTO `dgi_currencies` (`id`, `company_id`, `name`, `code`, `rate`, `enabled`, `created_at`, `updated_at`, `deleted_at`, `precision`, `symbol`, `symbol_first`, `decimal_mark`, `thousands_separator`) VALUES
(1, 1, 'Amerikan Doları', 'USD', 1.00000000, 1, '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL, '2', '$', 1, '.', ','),
(2, 1, 'Avro', 'EUR', 1.25000000, 1, '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL, '2', '€', 1, ',', '.'),
(3, 1, 'İngiliz Sterlini', 'GBP', 1.60000000, 1, '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL, '2', '£', 1, '.', ','),
(4, 1, 'Türk Lirası', 'TRY', 0.80000000, 1, '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL, '2', '₺', 1, ',', '.');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_customers`
--

DROP TABLE IF EXISTS `dgi_customers`;
CREATE TABLE IF NOT EXISTS `dgi_customers` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tax_number` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `website` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `customers_company_id_email_deleted_at_unique` (`company_id`,`email`,`deleted_at`),
  KEY `customers_company_id_index` (`company_id`)
) ENGINE=MyISAM AUTO_INCREMENT=165 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_customers`
--

INSERT INTO `dgi_customers` (`id`, `company_id`, `user_id`, `name`, `email`, `tax_number`, `phone`, `address`, `website`, `currency_code`, `enabled`, `created_at`, `updated_at`, `deleted_at`) VALUES
(142, 1, NULL, 'Nihat Yılmaz', 'vrl.muhammet123@gmail.com123', '30000', '+90 (544) 514 78 91', 'asdasdasdaas', 'www.nabaer.com', 'GBP', 1, '2018-12-29 04:45:51', '2018-12-29 04:46:03', '2018-12-29 04:46:03'),
(141, 1, NULL, 'Ömer Faruk Aydın', 'deneme123@deneme.com1', '99999999', '+90 (544) 514 78 91', 'asdadsada', 'www.varol.me', 'TRY', 1, '2018-12-29 04:41:40', '2018-12-29 04:42:48', '2018-12-29 04:42:48'),
(140, 1, NULL, 'Drasdadasd asddsadsa', 'deneme123@deneme.comadasd', '99999999', '+90 (544) 514 78 91', 'asdasd', 'www.varol.me', 'USD', 1, '2018-12-29 04:32:46', '2018-12-29 04:36:29', '2018-12-29 04:36:29'),
(139, 1, NULL, 'Muhammet Varol', 'deneme@deneme.com123', '99999999', '+90 (544) 514 78 91', 'sadasdasd', 'www.varol.me', 'USD', 1, '2018-12-29 04:29:49', '2018-12-29 05:11:49', '2018-12-29 05:11:49'),
(138, 1, NULL, 'Durkan Kaya', 'vrl.muhammet123@gmail.com', '99999999', '+90 (544) 514 78 91', 'asdasdaasd', 'www.varol.me', 'EUR', 1, '2018-12-28 13:31:37', '2018-12-29 05:12:45', '2018-12-29 05:12:45'),
(137, 1, NULL, 'Recep Ali', 'vrl.muhammet55600@gmail.com1', '99999999', '+90 (544) 514 78 91', NULL, 'www.varol.me', 'USD', 1, '2018-12-28 13:30:33', '2018-12-29 04:38:39', '2018-12-29 04:38:39'),
(133, 1, NULL, 'Muhammet Varol', 'deneme@deneme.com412', '99999999', '41212', 'asdasd', 'www.durkan.com', 'USD', 1, '2018-12-28 12:01:56', '2018-12-28 12:06:02', '2018-12-28 12:06:02'),
(134, 1, NULL, 'Aydın Akbulut', 'vrl.muhammet@gmail.com111', '99999999', '+90 (544) 514 78 91', 'asdassdasd', 'www.durkan.com', 'EUR', 1, '2018-12-28 12:09:48', '2018-12-28 12:10:24', '2018-12-28 12:10:24'),
(135, 1, NULL, 'Muhammet Varol', 'deneme@deneme.com', '99999999', '+90 (544) 514 78 91', 'asdasdasd', 'www.durkan.com', 'GBP', 1, '2018-12-28 12:12:00', '2018-12-28 12:12:19', '2018-12-28 12:12:19'),
(136, 1, NULL, 'Aydın Yılmaz', 'vrl.muhammet55600@gmail.com', '99999999', '+90 (544) 514 78 91', 'sadasdsa', 'www.durkan.com', 'USD', 1, '2018-12-28 12:14:22', '2018-12-29 04:38:29', '2018-12-29 04:38:29'),
(132, 1, NULL, 'Aydın Akbulut', 'deneme@deneme.com1', '99999999', '+90 (544) 514 78 91', 'asdasda', 'www.varol.me', 'USD', 1, '2018-12-28 11:55:38', '2018-12-28 12:01:17', '2018-12-28 12:01:17'),
(131, 1, NULL, 'Muhammet Varol1', 'vrl.muhammet55600@gmail.com1', '99999999', '+90 (544) 514 78 91', NULL, 'www.durkan.com', 'USD', 1, '2018-12-28 11:45:55', '2018-12-28 12:01:28', '2018-12-28 12:01:28'),
(130, 1, NULL, 'Muhammet Varol', 'vrl.muhammet@gmail.com', '000009999', '+90 (544) 514 78 91', 'Çay mahallesi', 'www.varol.me', 'TRY', 1, '2018-12-28 11:34:21', '2018-12-28 11:34:32', '2018-12-28 11:34:32'),
(129, 1, NULL, 'Yaaaaaaa', 'deneme1423@deneme.com', '99999999', '514789112312', 'sassdasdas', 'www.durkan.com', 'USD', 1, '2018-12-28 09:30:32', '2018-12-28 10:03:33', '2018-12-28 10:03:33'),
(128, 1, NULL, 'vcxxc vcxx', 'deneme123@deneme.com123', '99999999', '+90 (544) 514 78 91', 'adasasdads', 'www.varol.me', 'EUR', 1, '2018-12-28 09:24:26', '2018-12-28 09:24:53', '2018-12-28 09:24:53'),
(127, 1, NULL, 'vasasvsa asdas', 'deneme@deneme.com1235532', '99999999', '+90 (544) 514 78 91', 'asdasdasda', 'www.varol.me', 'GBP', 1, '2018-12-28 09:21:49', '2018-12-28 09:29:40', '2018-12-28 09:29:40'),
(126, 1, NULL, 'aasddsa asdas', 'deneme@deneme.com123asd', '99999999', '+90 (544) 514 78 91', 'asdasdasdsa', 'www.var', 'USD', 1, '2018-12-28 06:11:13', '2018-12-28 06:11:43', '2018-12-28 06:11:43'),
(125, 1, NULL, 'Muhammet Varol', 'deneme@deneme.com123123', '1231231', '+90 (544) 514 78 91', 'asdasdas', 'www.varol.me', 'USD', 1, '2018-12-28 06:08:14', '2018-12-28 06:08:51', '2018-12-28 06:08:51'),
(124, 1, NULL, 'ascasca', 'vrl.muhammet55600@gmail.comas', '99999999', '+90 (544) 514 78 91', 'asasd', 'www.durkan.com', 'USD', 1, '2018-12-27 04:42:32', '2018-12-27 04:42:44', '2018-12-27 04:42:44'),
(123, 1, NULL, 'aaaaaaaaaaaaa', 'deneme@deneme.comaa', '1231231', '+90 (544) 514 78 91', 'asdasda', 'www.durkan.com', 'EUR', 1, '2018-12-27 04:35:34', '2018-12-27 04:40:59', '2018-12-27 04:40:59'),
(122, 1, NULL, 'asdnassd', 'vrl.muhammet1235@gmail.com', '99999999', '+90 (544) 514 78 91', 'sadasdasda', 'www.varol.me', 'USD', 1, '2018-12-27 04:32:36', '2018-12-27 04:33:26', '2018-12-27 04:33:26'),
(121, 1, NULL, 'Muhammet  Varol', 'vrl@muhammet.com', '99999999', '+90 (544) 514 78 91', 'asdasdasd', 'www.varol.me', 'USD', 1, '2018-12-18 11:32:04', '2018-12-28 10:03:54', '2018-12-28 10:03:54'),
(120, 1, NULL, 'Recep Ali', 'vrl.muhammet55600@gmail.com', '99999999', '+90 (544) 514 78 91', 'asdsassadsad', 'www.durkan.com', 'USD', 1, '2018-12-18 11:16:58', '2018-12-28 06:10:05', '2018-12-28 06:10:05'),
(119, 1, NULL, 'cccccccaa aas', 'deneme123@deneme.comasdas', '1231231', '+90 (544) 514 78 91', NULL, 'www.durkan.com', 'EUR', 1, '2018-12-18 10:36:37', '2018-12-18 10:50:54', '2018-12-18 10:50:54'),
(118, 1, NULL, 'bbb bb', 'vrl.muhammet55600@gmail.comasdd', '99999999', '+90 (544) 514 78 91', 'sadasdsda', 'www.durkan.com', 'USD', 1, '2018-12-18 10:31:04', '2018-12-28 09:29:24', '2018-12-28 09:29:24'),
(117, 1, NULL, 'asasadads asfasf', 'dene12adme@deneme.com', '1231231', '+90 (544) 514 78 91', 'asdasdasd', 'www.durkan.com', 'GBP', 1, '2018-12-18 10:28:15', '2018-12-27 04:33:12', '2018-12-27 04:33:12'),
(116, 1, NULL, 'Muhammet', 'vrl.muham12samet55600@gmail.com', '99999999', '+90 (544) 514 78 91', 'asdasdasdas', 'www.durkan.com', 'EUR', 1, '2018-12-18 10:27:18', '2018-12-28 10:02:56', '2018-12-28 10:02:56'),
(115, 1, NULL, 'deneme deneme', 'deneme123@deneme.com44', '99999999', '+90 (544) 514 78 91', 'kkkk', 'www.varol.me', 'TRY', 1, '2018-11-26 06:25:15', '2018-11-26 06:27:20', '2018-11-26 06:27:20'),
(113, 1, NULL, 'Fatih Kalender', 'vrl.muhammet55600@gmail.com123', '99999999', '+90 (544) 514 78 91', 'asdaadsas', 'www.varol.me', 'GBP', 1, '2018-11-25 14:52:02', '2018-12-28 10:02:48', '2018-12-28 10:02:48'),
(114, 1, NULL, 'Çağrı  Melih', 'vrl.muhammet55600@gmail.com1', '1231231', '+90 (544) 514 78 91', 'asdasdas', 'www.varol.me', 'USD', 1, '2018-11-25 16:35:24', '2018-11-25 16:36:07', '2018-11-25 16:36:07'),
(111, 1, NULL, 'Fatih Yılmaz', 'deneme@deneme.com1231123', '99999999', '+90 (544) 514 78 91', 'asdasdasda', 'www.sofiaydın.com', 'TRY', 1, '2018-11-25 13:45:05', '2018-11-25 14:08:11', '2018-11-25 14:08:11'),
(112, 1, NULL, 'Mustafa Varol', 'deneme@deneme.comasdd', '99999999', '+90 (544) 514 78 91', 'asdasda', 'www.durkan.com', 'EUR', 1, '2018-11-25 13:52:47', '2018-11-25 14:02:16', '2018-11-25 14:02:16'),
(110, 1, NULL, 'İbrahim Sari', 'deneme@deneme.com12312', '99999999', '514789112312', 'adadaad', 'www.varol.me', 'GBP', 1, '2018-11-25 13:43:07', '2018-11-25 14:02:02', '2018-11-25 14:02:02'),
(108, 1, NULL, 'Durkan Kaya', 'deneme123@deneme.com1', '99999999', '+90 (544) 514 78 91', 'aaaaaaaaaaaaaa', 'www.durkan.com', 'GBP', 1, '2018-11-14 05:13:52', '2018-12-28 10:02:39', '2018-12-28 10:02:39'),
(109, 1, NULL, 'Aydın Akbul', 'deneme@deneme.com1231', '99999999', '+90 (544) 514 78 91', 'aaaaaaaaaaaaaaa', 'www.sofiaydın.com', 'TRY', 1, '2018-11-14 05:14:32', '2018-12-28 10:02:29', '2018-12-28 10:02:29'),
(107, 1, NULL, 'Aydın Akbulut', 'deneme123@deneme.com11', '99999999', '+90 (544) 514 78 91', 'aaaaaaaaaaaaaa', 'www.sofiaydın.com', 'EUR', 1, '2018-11-14 05:12:08', '2018-11-14 05:13:21', '2018-11-14 05:13:21'),
(105, 1, NULL, 'Muhammet Varol', 'deneme@deneme.com1', '99999999', '12312312', 'asdasdsad', 'www.durkan.com', 'EUR', 1, '2018-11-10 13:10:04', '2018-12-28 10:04:03', '2018-12-28 10:04:03'),
(106, 1, NULL, 'Durkan Kaya', 'deneme123@deneme.com', '99999999', '+90 (544) 514 78 91', 'assssssssssss', 'www.durkan.com', 'TRY', 1, '2018-11-14 05:11:07', '2018-11-14 05:13:30', '2018-11-14 05:13:30'),
(104, 1, NULL, 'Aydın Akbulut', 'vrl.muhammet123@gmail.com', '1231231', '+90 (544) 514 78 91', 'asdasasdads', 'www.varol.me', 'GBP', 1, '2018-11-10 13:08:09', '2018-11-10 13:09:16', '2018-11-10 13:09:16'),
(103, 1, NULL, 'Muhammet Yıl', 'vrl.muhammet@gmail.com', '9999999989821', '+90 (544) 514 78 91', 'iiiiiiiiiiiiiiiiiiiiii', 'www.varol.me', 'TRY', 1, '2018-11-10 12:58:00', '2018-12-28 10:03:41', '2018-12-28 10:03:41'),
(143, 1, NULL, 'Ömer Faruk', 'deneme123@deneme.com132', '99999999', '+90 (544) 514 78 91', 'sdasdasasd', 'www.varol.me', 'USD', 1, '2018-12-29 04:47:16', '2018-12-29 04:47:29', '2018-12-29 04:47:29'),
(144, 1, NULL, 'Muhammet Yıl', 'deneme123@deneme.comas', '1231231', '+90 (544) 514 78 91', 'asdasdaads', 'www.durkan.com', 'EUR', 1, '2018-12-29 05:11:20', '2018-12-29 05:11:33', '2018-12-29 05:11:33'),
(145, 1, NULL, 'Muhammet Varolı', 'vrl.muhammet55600@gmail.com', '99999999898', '+90 (544) 514 78 91', 'asdasdasdada', 'www.varol.me', 'TRY', 1, '2018-12-29 05:13:13', '2018-12-29 15:37:46', NULL),
(146, 1, NULL, 'Aydın Akbulut', 'vrl.muhammet@gmail.com3', '99999999', '514789112312', 'jghjkgh', NULL, 'USD', 1, '2018-12-29 08:06:00', '2018-12-29 08:06:22', '2018-12-29 08:06:22'),
(147, 1, NULL, 'Durkan Aydın', 'vrl.muhammet55600@gmail.com1', '1231231', '+90 (544) 514 78 91', NULL, NULL, 'TRY', 1, '2018-12-29 08:18:14', '2018-12-29 12:54:42', '2018-12-29 12:54:42'),
(148, 1, NULL, 'Aydın Akbulut', 'deneme@deneme.com123', '99999999', '+90 (544) 514 78 91', 'aaaaaaaaaaaaaa', 'www.durkan.com', 'GBP', 1, '2018-12-29 08:28:15', '2018-12-29 08:32:40', '2018-12-29 08:32:40'),
(149, 1, NULL, 'Ömer Faruk Aydın', 'vrl.muhammet55600@gmail.com12', '99999999', '+90 (544) 514 78 91', 'aaaaaaaaaaaaaaaaaa', 'www.varol.me', 'EUR', 1, '2018-12-29 08:32:09', '2018-12-29 08:32:09', NULL),
(150, 1, NULL, 'Ali Veli', 'deneme@deneme.com1231', '99999999', '+90 (544) 514 78 91', 'aaaaaaa', 'www.varol.me', 'USD', 1, '2018-12-29 08:39:18', '2018-12-29 08:49:08', '2018-12-29 08:49:08'),
(151, 1, NULL, 'Veli  Yılmaz', 'deneme@deneme.com0', '99999999', '+90 (544) 514 78 91', 'aaaaaaaaaaa', 'www.durkan.com', 'EUR', 1, '2018-12-29 08:40:09', '2018-12-29 15:38:02', '2018-12-29 15:38:02'),
(157, 1, NULL, 'Nihat Yılmaz', 'deneme@deneme.com1231', '6111111111', '+90 (544) 514 78 91', 'aaaaaaa', 'www.nabaer.com', 'EUR', 1, '2018-12-29 11:21:24', '2018-12-29 11:21:24', NULL),
(152, 1, NULL, 'Aydın Akbulutaaa', 'deneme@deneme.com', '99999999', '+90 (544) 514 78 91', NULL, 'www.durkan.com', 'GBP', 1, '2018-12-29 09:08:57', '2018-12-29 11:17:04', '2018-12-29 11:17:04'),
(153, 1, NULL, 'Aydına Akbulut123', 'deneme@deneme.coma', '1231231', '+90 (544) 514 78 91', 'aaaaaaa', 'www.varol.me', 'GBP', 1, '2018-12-29 09:09:34', '2018-12-29 11:30:33', '2018-12-29 11:30:33'),
(154, 1, NULL, 'bbbbbbbbbbbb bbbb', 'vrl.muhammet55600@gmail.comvv', '1231231', '+90 (544) 514 78 91', 'aaaaaaa', 'www.varol.me', 'EUR', 1, '2018-12-29 09:10:09', '2018-12-29 09:13:42', '2018-12-29 09:13:42'),
(155, 1, NULL, 'bbbbbbbbbbbb bbbb', 'vrl.muhammet55600@gmail.comvvasd', '1231231', '+90 (544) 514 78 91', 'aaaaaaa', 'www.varol.me', 'EUR', 1, '2018-12-29 09:13:25', '2018-12-29 09:14:00', '2018-12-29 09:14:00'),
(156, 1, NULL, 'Durkan varr', 'deneme@deneme.com4', '99999999', '+90 (544) 514 78 91', 'aaaaaaa', 'www.varol.me', 'GBP', 1, '2018-12-29 11:16:50', '2018-12-29 13:08:13', '2018-12-29 13:08:13'),
(158, 1, NULL, 'Çağrı Dönmez', 'vrl.muhammet@gmail.com000', '99999999', '+90 (544) 514 78 91', 'aaaaaaaaaaaaaaa', 'www.varol.me', 'GBP', 1, '2018-12-29 13:11:47', '2018-12-29 13:12:13', '2018-12-29 13:12:13'),
(159, 1, NULL, 'Çağrı Dönmez', 'deneme123@deneme.com1', '99999999', '+90 (544) 514 78 91', 'aaaaaaaaaa', 'www.nabaer.com', 'USD', 1, '2018-12-29 15:39:07', '2018-12-30 09:29:03', '2018-12-30 09:29:03'),
(160, 1, NULL, 'aaaaaaa aaa', 'deneme@deneme.com123241', '99999999', '+90 (544) 514 78 91', 'aaaaaaaaaa', 'www.nabaer.com', 'USD', 1, '2018-12-29 15:39:39', '2018-12-29 16:16:31', '2018-12-29 16:16:31'),
(162, 1, NULL, 'Ömer Faruk', 'vrl.muhammet55600@gmail.com123', '99999999', '+90 (544) 514 78 91', 'aaaaaaaaaa', 'www.durkan.com', 'USD', 1, '2018-12-30 09:01:16', '2018-12-30 09:30:05', '2018-12-30 09:30:05'),
(161, 1, NULL, 'Aydın Yılmaz0', 'vrl.muhammet55600@gmail.com15', '99999999', '+90 (544) 514 78 91', 'aaaaaaa', 'www.durkan.com', 'USD', 1, '2018-12-30 08:53:03', '2018-12-30 08:58:21', '2018-12-30 08:58:21'),
(163, 1, NULL, 'Recep Kalender oğlu', 'deneme@deneme.com1231234', '99999999', '+90 (544) 514 78 91', NULL, 'www.durkan.com', 'USD', 1, '2018-12-30 09:02:54', '2018-12-30 09:04:47', '2018-12-30 09:04:47'),
(164, 1, NULL, 'Durkan Ali', 'deneme@deneme.com1234', '99999999', '+90 (544) 514 78 91', 'aaa', 'www.durkan.com', 'USD', 1, '2018-12-30 09:31:59', '2018-12-30 09:33:13', NULL);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_failed_jobs`
--

DROP TABLE IF EXISTS `dgi_failed_jobs`;
CREATE TABLE IF NOT EXISTS `dgi_failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_invoices`
--

DROP TABLE IF EXISTS `dgi_invoices`;
CREATE TABLE IF NOT EXISTS `dgi_invoices` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `invoice_number` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_number` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `invoice_status_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `invoiced_at` datetime NOT NULL,
  `due_at` datetime NOT NULL,
  `amount` double(15,4) NOT NULL,
  `currency_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `currency_rate` double(15,8) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `customer_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_tax_number` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_address` text COLLATE utf8mb4_unicode_ci,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `category_id` int(11) NOT NULL DEFAULT '1',
  `parent_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoices_company_id_invoice_number_deleted_at_unique` (`company_id`,`invoice_number`,`deleted_at`),
  KEY `invoices_company_id_index` (`company_id`)
) ENGINE=MyISAM AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_invoices`
--

INSERT INTO `dgi_invoices` (`id`, `company_id`, `invoice_number`, `order_number`, `invoice_status_code`, `invoiced_at`, `due_at`, `amount`, `currency_code`, `currency_rate`, `customer_id`, `customer_name`, `customer_email`, `customer_tax_number`, `customer_phone`, `customer_address`, `notes`, `created_at`, `updated_at`, `deleted_at`, `category_id`, `parent_id`) VALUES
(46, 1, 'INV-2018-00+46', '46', 'draft', '2019-01-01 22:02:58', '2019-01-01 22:02:58', 106.0000, 'USD', 2.00000000, 165, 'Muhammet Varol', 'vrl.muhammet55600@gmail.com', NULL, '00000000000', 'Turkey Konya Selçuk Üni', '', '2019-01-01 19:02:58', '2019-01-01 19:02:58', NULL, 0, 0),
(44, 1, 'INV-2018-00+44', '44', 'draft', '2019-01-01 21:45:35', '2019-01-01 21:45:35', 85.0000, 'USD', 2.00000000, 165, 'muhammmet varol', 'deneme@deneme.com', NULL, '5445147891', 'Turkey Konya Selçuk Üni', '', '2019-01-01 18:45:35', '2019-01-01 18:45:35', NULL, 0, 0),
(45, 1, 'INV-2018-00+45', '45', 'draft', '2019-01-01 21:51:06', '2019-01-01 21:51:06', 85.0000, 'USD', 2.00000000, 165, 'muhammmet varol', 'deneme@deneme.com', NULL, '5445147891', 'Turkey Konya Selçuk Üni', '', '2019-01-01 18:51:06', '2019-01-01 18:51:06', NULL, 0, 0),
(41, 1, 'INV-2018-00+41', '41', 'draft', '2019-01-01 21:38:14', '2019-01-01 21:38:14', 85.0000, 'USD', 2.00000000, 165, 'muhammmet varol', 'deneme@deneme.com', NULL, '5445147891', 'Turkey Konya Selçuk Üni', '', '2019-01-01 18:38:14', '2019-01-01 18:38:14', NULL, 0, 0),
(39, 1, 'INV-2018-00+39', '39', 'draft', '2019-01-01 17:19:43', '2019-01-01 17:19:43', 106.0000, 'USD', 2.00000000, 165, 'muhammmet varol', 'deneme@deneme.com', NULL, '5445147891', 'Turkey Konya Selçuk Üni', '', '2019-01-01 14:19:43', '2019-01-01 14:19:43', NULL, 0, 0),
(42, 1, 'INV-2018-00+42', '42', 'draft', '2019-01-01 21:43:18', '2019-01-01 21:43:18', 106.0000, 'USD', 2.00000000, 165, 'muhammmet varol', 'deneme@deneme.com', NULL, '5445147891', 'Turkey Konya Selçuk Üni', '', '2019-01-01 18:43:18', '2019-01-01 18:43:18', NULL, 0, 0),
(35, 1, 'INV-2018-00+35', '35', 'draft', '2019-01-01 16:48:19', '2019-01-01 16:48:19', 85.0000, 'USD', 2.00000000, 165, 'muhammmet varol', 'deneme@deneme.com', NULL, '5445147891', 'Turkey Konya Selçuk Üni', '', '2019-01-01 13:48:19', '2019-01-01 10:51:04', '2019-01-01 10:51:04', 0, 0),
(26, 1, 'INV-2018-00', '26', 'draft', '2018-12-31 20:46:33', '2018-12-31 20:46:33', 106.0000, 'USD', 2.00000000, 165, 'muhammmet varol', 'deneme@deneme.com', NULL, '5445147891', 'Turkey Konya Selçuk Üni', '', '2018-12-31 17:46:33', '2019-01-01 10:51:36', '2019-01-01 10:51:36', 0, 0),
(36, 1, 'INV-2018-00+36', '36', 'draft', '2019-01-01 16:56:37', '2019-01-01 16:56:37', 85.0000, 'USD', 2.00000000, 165, 'muhammmet varol', 'deneme@deneme.com', NULL, '5445147891', 'Turkey Konya Selçuk Üni', '', '2019-01-01 13:56:37', '2019-01-01 13:56:37', NULL, 0, 0),
(33, 1, 'INV-2018-00+33', '33', 'draft', '2019-01-01 16:40:55', '2019-01-01 16:40:55', 85.0000, 'USD', 2.00000000, 165, 'muhammmet varol', 'deneme@deneme.com', NULL, '5445147891', 'Turkey Konya Selçuk Üni', '', '2019-01-01 13:40:55', '2019-01-01 10:50:54', '2019-01-01 10:50:54', 0, 0),
(32, 1, 'INV-2018-00+32', '32', 'draft', '2019-01-01 16:38:46', '2019-01-01 16:38:46', 165.0000, 'USD', 2.00000000, 165, 'muhammmet varol', 'deneme@deneme.com', NULL, '5445147891', 'Turkey Konya Selçuk Üni', '', '2019-01-01 13:38:46', '2019-01-01 10:51:16', '2019-01-01 10:51:16', 0, 0),
(29, 1, 'INV-2018-00', '29', 'draft', '2019-01-01 16:13:48', '2019-01-01 16:13:48', 105.0000, 'USD', 2.00000000, 165, 'muhammmet varol', 'deneme@deneme.com', NULL, '5445147891', 'Turkey Konya Selçuk Üni', '', '2019-01-01 13:13:48', '2019-01-01 10:51:28', '2019-01-01 10:51:28', 0, 0);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_invoice_histories`
--

DROP TABLE IF EXISTS `dgi_invoice_histories`;
CREATE TABLE IF NOT EXISTS `dgi_invoice_histories` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `status_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notify` tinyint(1) NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_histories_company_id_index` (`company_id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_invoice_histories`
--

INSERT INTO `dgi_invoice_histories` (`id`, `company_id`, `invoice_id`, `status_code`, `notify`, `description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 1, 'draft', 0, 'INV-00001 eklendi!', '2018-11-14 08:32:40', '2018-12-28 10:01:42', '2018-12-28 10:01:42'),
(2, 1, 16, 'draft', 0, 'INV-00001 eklendi!', '2018-11-14 08:32:40', '2018-11-14 08:32:40', NULL),
(3, 1, 17, 'draft', 0, 'INV-00002 eklendi!', '2018-11-15 16:49:42', '2018-12-28 10:01:51', '2018-12-28 10:01:51'),
(4, 1, 18, 'draft', 0, 'INV-00003 eklendi!', '2018-11-15 16:51:13', '2018-11-15 16:51:13', NULL),
(5, 1, 29, 'draft', 0, 'INV-00004 eklendi!', '2018-12-31 07:32:14', '2019-01-01 10:51:28', '2019-01-01 10:51:28'),
(6, 1, 30, 'draft', 0, 'INV-00005 eklendi!', '2018-12-31 14:18:30', '2018-12-31 14:43:23', '2018-12-31 14:43:23');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_invoice_items`
--

DROP TABLE IF EXISTS `dgi_invoice_items`;
CREATE TABLE IF NOT EXISTS `dgi_invoice_items` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `item_id` int(11) DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sku` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` double(7,2) NOT NULL,
  `price` double(15,4) NOT NULL,
  `total` double(15,4) NOT NULL,
  `tax` double(15,4) NOT NULL DEFAULT '0.0000',
  `tax_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_items_company_id_index` (`company_id`)
) ENGINE=MyISAM AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_invoice_items`
--

INSERT INTO `dgi_invoice_items` (`id`, `company_id`, `invoice_id`, `item_id`, `name`, `sku`, `quantity`, `price`, `total`, `tax`, `tax_id`, `created_at`, `updated_at`, `deleted_at`) VALUES
(26, 1, 26, 1, 'iPhone', NULL, 1.00, 101.0000, 101.0000, 0.0000, 1, '2018-12-31 17:46:33', '2019-01-01 10:51:36', '2019-01-01 10:51:36'),
(7, 1, 30, NULL, 'Xiamio Mi 8', '', 2.00, 1110.0000, 2220.0000, 0.0000, 1, '2018-12-31 14:18:30', '2018-12-31 14:43:23', '2018-12-31 14:43:23'),
(2, 1, 2, 1, 'Canon EOS 5D', NULL, 1.00, 80.0000, 80.0000, 0.0000, 1, '2018-12-31 17:11:04', '2018-12-31 14:43:37', '2018-12-31 14:43:37'),
(29, 1, 29, 1, 'iMac', NULL, 1.00, 100.0000, 100.0000, 0.0000, 1, '2019-01-01 13:13:48', '2019-01-01 10:51:28', '2019-01-01 10:51:28'),
(32, 1, 32, 1, 'Canon EOS 5D', NULL, 2.00, 80.0000, 160.0000, 0.0000, 1, '2019-01-01 13:38:46', '2019-01-01 10:51:15', '2019-01-01 10:51:15'),
(33, 1, 33, 1, 'Canon EOS 5D', NULL, 1.00, 80.0000, 80.0000, 0.0000, 1, '2019-01-01 13:40:55', '2019-01-01 10:50:53', '2019-01-01 10:50:53'),
(35, 1, 35, 1, 'Canon EOS 5D', NULL, 1.00, 80.0000, 80.0000, 0.0000, 1, '2019-01-01 13:48:19', '2019-01-01 10:51:04', '2019-01-01 10:51:04'),
(36, 1, 36, 1, 'Canon EOS 5D', NULL, 1.00, 80.0000, 80.0000, 0.0000, 1, '2019-01-01 13:56:37', '2019-01-01 13:56:37', NULL),
(39, 1, 39, 1, 'iPhone', NULL, 1.00, 101.0000, 101.0000, 0.0000, 1, '2019-01-01 14:19:43', '2019-01-01 14:19:43', NULL),
(41, 1, 41, 1, 'Canon EOS 5D', NULL, 1.00, 80.0000, 80.0000, 0.0000, 1, '2019-01-01 18:38:14', '2019-01-01 18:38:14', NULL),
(44, 1, 44, 1, 'Canon EOS 5D', NULL, 1.00, 80.0000, 80.0000, 0.0000, 1, '2019-01-01 18:45:35', '2019-01-01 18:45:35', NULL),
(46, 1, 46, 1, 'iPhone', NULL, 1.00, 101.0000, 101.0000, 0.0000, 1, '2019-01-01 19:02:58', '2019-01-01 19:02:58', NULL);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_invoice_payments`
--

DROP TABLE IF EXISTS `dgi_invoice_payments`;
CREATE TABLE IF NOT EXISTS `dgi_invoice_payments` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `paid_at` datetime NOT NULL,
  `amount` double(15,4) NOT NULL,
  `currency_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `currency_rate` double(15,8) NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `payment_method` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_payments_company_id_index` (`company_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_invoice_statuses`
--

DROP TABLE IF EXISTS `dgi_invoice_statuses`;
CREATE TABLE IF NOT EXISTS `dgi_invoice_statuses` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_statuses_company_id_index` (`company_id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_invoice_statuses`
--

INSERT INTO `dgi_invoice_statuses` (`id`, `company_id`, `name`, `code`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'Taslak', 'draft', '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL),
(2, 1, 'Gönderilen', 'sent', '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL),
(3, 1, 'Görüldü', 'viewed', '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL),
(4, 1, 'Onaylandı', 'approved', '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL),
(5, 1, 'Kısmi', 'partial', '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL),
(6, 1, 'Ödenmiş', 'paid', '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_invoice_totals`
--

DROP TABLE IF EXISTS `dgi_invoice_totals`;
CREATE TABLE IF NOT EXISTS `dgi_invoice_totals` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` double(15,4) NOT NULL,
  `sort_order` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_totals_company_id_index` (`company_id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_invoice_totals`
--

INSERT INTO `dgi_invoice_totals` (`id`, `company_id`, `invoice_id`, `code`, `name`, `amount`, `sort_order`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 1, 'sub_total', 'invoices.sub_total', 102.0000, 1, '2018-11-14 08:32:40', '2018-12-28 10:01:42', '2018-12-28 10:01:42'),
(2, 1, 1, 'tax', 'Normal Vergi', 5.1000, 3, '2018-11-14 08:32:40', '2018-12-28 10:01:42', '2018-12-28 10:01:42'),
(3, 1, 1, 'total', 'invoices.total', 107.1000, 4, '2018-11-14 08:32:40', '2018-12-28 10:01:42', '2018-12-28 10:01:42'),
(4, 1, 17, 'sub_total', 'invoices.sub_total', 1500.0000, 1, '2018-11-15 16:49:42', '2018-12-28 10:01:51', '2018-12-28 10:01:51'),
(5, 1, 17, 'total', 'invoices.total', 1500.0000, 3, '2018-11-15 16:49:42', '2018-12-28 10:01:51', '2018-12-28 10:01:51'),
(6, 1, 18, 'sub_total', 'invoices.sub_total', 1500.0000, 1, '2018-11-15 16:51:13', '2018-11-15 16:51:13', NULL),
(7, 1, 18, 'total', 'invoices.total', 1500.0000, 3, '2018-11-15 16:51:13', '2018-11-15 16:51:13', NULL),
(8, 1, 29, 'sub_total', 'invoices.sub_total', 44.0000, 1, '2018-12-31 07:32:14', '2019-01-01 10:51:28', '2019-01-01 10:51:28'),
(9, 1, 29, 'tax', 'Vergi Muaf', 0.0000, 3, '2018-12-31 07:32:14', '2019-01-01 10:51:28', '2019-01-01 10:51:28'),
(10, 1, 29, 'total', 'invoices.total', 44.0000, 4, '2018-12-31 07:32:14', '2019-01-01 10:51:28', '2019-01-01 10:51:28'),
(11, 1, 30, 'sub_total', 'invoices.sub_total', 2220.0000, 1, '2018-12-31 14:18:30', '2018-12-31 14:43:23', '2018-12-31 14:43:23'),
(12, 1, 30, 'tax', 'Vergi Muaf', 0.0000, 3, '2018-12-31 14:18:30', '2018-12-31 14:43:23', '2018-12-31 14:43:23'),
(13, 1, 30, 'total', 'invoices.total', 2220.0000, 4, '2018-12-31 14:18:30', '2018-12-31 14:43:23', '2018-12-31 14:43:23');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_items`
--

DROP TABLE IF EXISTS `dgi_items`;
CREATE TABLE IF NOT EXISTS `dgi_items` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sku` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `sale_price` double(15,4) NOT NULL,
  `purchase_price` double(15,4) NOT NULL,
  `quantity` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `tax_id` int(11) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `items_company_id_sku_deleted_at_unique` (`company_id`,`sku`,`deleted_at`),
  KEY `items_company_id_index` (`company_id`)
) ENGINE=MyISAM AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_items`
--

INSERT INTO `dgi_items` (`id`, `company_id`, `name`, `sku`, `description`, `sale_price`, `purchase_price`, `quantity`, `category_id`, `tax_id`, `enabled`, `created_at`, `updated_at`, `deleted_at`) VALUES
(68, 1, 'Mi 9', '874521212', 'akıllı telefon', 1000.0000, 900.0000, 100, 6, NULL, 1, '2018-12-31 06:14:11', '2018-12-31 06:17:44', '2018-12-31 06:17:44'),
(67, 1, 'asdasdsa', '11111121', NULL, 50.0000, 40.0000, 110, 5, 1, 1, '2018-12-30 12:53:38', '2018-12-30 12:59:42', '2018-12-30 12:59:42'),
(66, 1, 'Coffee', '9876543211543', 'kahve', 1000.0000, 900.0000, 100, 5, 1, 1, '2018-12-30 12:52:01', '2018-12-31 07:09:46', '2018-12-31 07:09:46'),
(65, 1, 'Coffee2', '9876543211543897', 'kahve', 1000.0000, 900.0000, 100, 5, 1, 1, '2018-12-30 12:44:31', '2018-12-30 13:02:40', '2018-12-30 13:02:40'),
(64, 1, 'Xiamio Redmi Note 4', '15521512', 'asdas', 1000.0000, 900.0000, 100, 6, 2, 1, '2018-12-18 11:14:51', '2018-12-18 11:14:51', NULL),
(62, 1, 'NFK', '124125758', 'aaaaaaaaaaaaa', 40.0000, 40.0000, 100, 6, NULL, 1, '2018-12-18 10:46:18', '2018-12-18 11:13:17', '2018-12-18 11:13:17'),
(63, 1, 'gnbfbgddffbd', '111111asd123', 'asddasdas', 50.0000, 50.0000, 12, 6, 1, 1, '2018-12-18 10:49:26', '2018-12-18 10:50:32', '2018-12-18 10:50:32'),
(55, 1, 'Xiamio Mi 8', '9876543211', 'aaaaaa', 3600.0000, 2800.0000, 20, 6, 2, 1, '2018-11-14 05:29:33', '2018-11-14 06:23:07', NULL),
(56, 1, 'Note 8', '1212412512', 'aaaaaaaaaaaaa', 4000.0000, 3500.0000, 30, 6, 2, 1, '2018-11-14 05:39:22', '2018-11-14 05:39:40', '2018-11-14 05:39:40'),
(54, 1, 'Xiamio Mi 8', '999977534', 'aaaaaa', 3000.0000, 2800.0000, 50, 6, 2, 1, '2018-11-14 05:27:06', '2018-11-14 05:36:52', '2018-11-14 05:36:52'),
(53, 1, 'Xiamio Redmi Note 5', '111111', 'aaaaa', 1500.0000, 1300.0000, 14, 6, NULL, 1, '2018-11-14 05:18:48', '2018-11-15 16:49:42', NULL),
(52, 1, 'Xiamio Redmi Note 4', '11111111231', 'aaaaaaaa', 1050.0000, 950.0000, 20, 6, 3, 1, '2018-11-14 05:18:10', '2018-11-14 05:26:21', '2018-11-14 05:26:21'),
(61, 1, 'Stp Kablp', '987654321113', 'asas', 1000.0000, 900.0000, 100, 6, 1, 1, '2018-11-25 14:59:55', '2018-11-25 14:59:55', NULL),
(60, 1, 'UTP kablo', '987654321123', 'asdasd', 1000.0000, 900.0000, 110, 6, NULL, 1, '2018-11-25 14:51:29', '2018-11-25 14:51:29', NULL),
(58, 1, 'Klavye', '987654321152', 'assssssssssss', 69.0000, 50.0000, 120, 6, 2, 1, '2018-11-14 07:34:18', '2018-11-25 16:45:27', '2018-11-25 16:45:27'),
(59, 1, 'Fiber Kablo', '11111112361435', 'Fiber kablosu', 1000.0000, 800.0000, 100, 6, 1, 1, '2018-11-25 14:49:27', '2018-12-31 07:09:33', '2018-12-31 07:09:33'),
(57, 1, 'Mouse', '111111324', 'fare', 40.0000, 30.0000, 100, 6, 2, 1, '2018-11-14 06:46:53', '2018-11-14 06:46:53', NULL),
(44, 1, 'Xiamio Redmi Note 4', '11111111231', 'sadadsdas', 1000.0000, 900.0000, 110, 6, 2, 1, '2018-11-12 17:04:53', '2018-11-12 17:48:43', '2018-11-12 17:48:43'),
(45, 1, 'Ceysu', '987654321', 'asdasd', 50.0000, 40.0000, 12, 5, NULL, 1, '2018-11-12 17:05:21', '2018-11-12 17:40:20', '2018-11-12 17:40:20'),
(46, 1, 'Kulaklık', '111111', NULL, 50.0000, 40.0000, 100, 6, 3, 1, '2018-11-12 17:34:42', '2018-11-12 17:45:46', '2018-11-12 17:45:46'),
(69, 1, 'Fiber', '11111112361', 'asdasd', 1000.0000, 900.0000, 100, 6, 1, 1, '2018-12-31 06:35:16', '2018-12-31 06:35:16', NULL);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_jobs`
--

DROP TABLE IF EXISTS `dgi_jobs`;
CREATE TABLE IF NOT EXISTS `dgi_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `queue` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_reserved_at_index` (`queue`,`reserved_at`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_media`
--

DROP TABLE IF EXISTS `dgi_media`;
CREATE TABLE IF NOT EXISTS `dgi_media` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `disk` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `directory` varchar(68) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filename` varchar(121) COLLATE utf8mb4_unicode_ci NOT NULL,
  `extension` varchar(28) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mime_type` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `aggregate_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `size` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `media_disk_directory_filename_extension_unique` (`disk`,`directory`,`filename`,`extension`),
  KEY `media_disk_directory_index` (`disk`,`directory`),
  KEY `media_aggregate_type_index` (`aggregate_type`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_media`
--

INSERT INTO `dgi_media` (`id`, `disk`, `directory`, `filename`, `extension`, `mime_type`, `aggregate_type`, `size`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'uploads', '1/items', '41977768_300502957446885_2374641260843086317_n', 'jpg', 'image/jpeg', 'image', 193369, '2018-10-21 11:59:36', '2018-10-21 11:59:36', NULL),
(2, 'uploads', '1/items', 'susan-yin-647448-unsplash', 'jpg', 'image/jpeg', 'image', 751947, '2018-11-04 08:57:19', '2018-11-04 08:57:19', NULL),
(3, 'uploads', '1/items', 'efbe355d-0ca5-4973-91cb-92159d8cabb4', 'png', 'image/png', 'image', 7548, '2018-11-04 09:02:31', '2018-11-04 09:02:31', NULL),
(4, 'uploads', '1/items', '240_F_89310694_CEibgXJZE4ghOcToHPzoBiU3CGmRE6aH', 'jpg', 'image/jpeg', 'image', 20906, '2018-11-12 16:58:14', '2018-11-12 16:58:14', NULL),
(5, 'uploads', '1/items', 'istanbul-gece-kulupleri', 'jpg', 'image/jpeg', 'image', 1040048, '2018-11-12 17:00:02', '2018-11-12 17:00:02', NULL),
(6, 'uploads', '1/items', '20170215AW985240', 'jpg', 'image/jpeg', 'image', 130738, '2018-11-12 17:01:55', '2018-11-12 17:01:55', NULL),
(7, 'uploads', '1/items', 'com-y2xxexorf62s5sj0h3r0', 'jpg', 'image/jpeg', 'image', 43065, '2018-11-12 17:02:31', '2018-11-12 17:02:31', NULL),
(8, 'uploads', '1/items', '5a68990261361f1d94d8f4c6', 'jpg', 'image/jpeg', 'image', 29515, '2018-11-12 17:04:53', '2018-11-12 17:04:53', NULL),
(9, 'uploads', '1/items', '14360', 'jpg', 'image/jpeg', 'image', 317946, '2018-11-12 17:05:21', '2018-11-12 17:05:21', NULL),
(10, 'uploads', '1/items', 'Uhud-gunu-sancagi-Musab-radiyallahu-anhu-tasidi.-Muslumanlar-dagildiklari-esnada-o-sancakla-birlikte', 'jpg', 'image/jpeg', 'image', 151778, '2018-11-12 17:34:42', '2018-11-12 17:34:42', NULL);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_mediables`
--

DROP TABLE IF EXISTS `dgi_mediables`;
CREATE TABLE IF NOT EXISTS `dgi_mediables` (
  `media_id` int(10) UNSIGNED NOT NULL,
  `mediable_type` varchar(152) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mediable_id` int(10) UNSIGNED NOT NULL,
  `tag` varchar(68) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`media_id`,`mediable_type`,`mediable_id`,`tag`),
  KEY `mediables_mediable_id_mediable_type_index` (`mediable_id`,`mediable_type`),
  KEY `mediables_tag_index` (`tag`),
  KEY `mediables_order_index` (`order`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_mediables`
--

INSERT INTO `dgi_mediables` (`media_id`, `mediable_type`, `mediable_id`, `tag`, `order`) VALUES
(1, 'App\\Models\\Common\\Item', 1, 'picture', 1),
(2, 'App\\Models\\Common\\Item', 2, 'picture', 1),
(3, 'App\\Models\\Common\\Item', 5, 'picture', 1),
(4, 'App\\Models\\Common\\Item', 40, 'picture', 1),
(5, 'App\\Models\\Common\\Item', 41, 'picture', 1),
(6, 'App\\Models\\Common\\Item', 42, 'picture', 1),
(7, 'App\\Models\\Common\\Item', 43, 'picture', 1),
(8, 'App\\Models\\Common\\Item', 44, 'picture', 1),
(9, 'App\\Models\\Common\\Item', 45, 'picture', 1),
(10, 'App\\Models\\Common\\Item', 46, 'picture', 1);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_migrations`
--

DROP TABLE IF EXISTS `dgi_migrations`;
CREATE TABLE IF NOT EXISTS `dgi_migrations` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_migrations`
--

INSERT INTO `dgi_migrations` (`id`, `migration`, `batch`) VALUES
(1, '2017_09_01_000000_create_accounts_table', 1),
(2, '2017_09_01_000000_create_bills_table', 1),
(3, '2017_09_01_000000_create_categories_table', 1),
(4, '2017_09_01_000000_create_companies_table', 1),
(5, '2017_09_01_000000_create_currencies_table', 1),
(6, '2017_09_01_000000_create_customers_table', 1),
(7, '2017_09_01_000000_create_invoices_table', 1),
(8, '2017_09_01_000000_create_items_table', 1),
(9, '2017_09_01_000000_create_jobs_table', 1),
(10, '2017_09_01_000000_create_modules_table', 1),
(11, '2017_09_01_000000_create_notifications_table', 1),
(12, '2017_09_01_000000_create_password_resets_table', 1),
(13, '2017_09_01_000000_create_payments_table', 1),
(14, '2017_09_01_000000_create_revenues_table', 1),
(15, '2017_09_01_000000_create_roles_table', 1),
(16, '2017_09_01_000000_create_sessions_table', 1),
(17, '2017_09_01_000000_create_settings_table', 1),
(18, '2017_09_01_000000_create_taxes_table', 1),
(19, '2017_09_01_000000_create_transfers_table', 1),
(20, '2017_09_01_000000_create_users_table', 1),
(21, '2017_09_01_000000_create_vendors_table', 1),
(22, '2017_09_19_delete_offline_file', 1),
(23, '2017_10_11_000000_create_bill_totals_table', 1),
(24, '2017_10_11_000000_create_invoice_totals_table', 1),
(25, '2017_11_16_000000_create_failed_jobs_table', 1),
(26, '2017_12_09_000000_add_currency_columns', 1),
(27, '2017_12_30_000000_create_mediable_tables', 1),
(28, '2018_01_03_000000_drop_attachment_column_bill_payments_table', 1),
(29, '2018_01_03_000000_drop_attachment_column_bills_table', 1),
(30, '2018_01_03_000000_drop_attachment_column_invoice_payments_table', 1),
(31, '2018_01_03_000000_drop_attachment_column_invoices_table', 1),
(32, '2018_01_03_000000_drop_attachment_column_payments_table', 1),
(33, '2018_01_03_000000_drop_attachment_column_revenues_table', 1),
(34, '2018_01_03_000000_drop_picture_column_items_table', 1),
(35, '2018_01_03_000000_drop_picture_column_users_table', 1),
(36, '2018_04_23_000000_add_category_column_invoices_bills', 1),
(37, '2018_04_26_000000_create_recurring_table', 1),
(38, '2018_04_30_000000_add_parent_column', 1),
(39, '2018_06_23_000000_modify_email_column', 1),
(40, '2018_06_30_000000_modify_enabled_column', 1),
(41, '2018_07_07_000000_modify_date_column', 1),
(42, '2020_01_01_000000_add_locale_column', 1);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_modules`
--

DROP TABLE IF EXISTS `dgi_modules`;
CREATE TABLE IF NOT EXISTS `dgi_modules` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `alias` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `modules_company_id_alias_deleted_at_unique` (`company_id`,`alias`,`deleted_at`),
  KEY `modules_company_id_index` (`company_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_modules`
--

INSERT INTO `dgi_modules` (`id`, `company_id`, `alias`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'offlinepayment', 1, '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL),
(2, 1, 'paypalstandard', 1, '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_module_histories`
--

DROP TABLE IF EXISTS `dgi_module_histories`;
CREATE TABLE IF NOT EXISTS `dgi_module_histories` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `module_id` int(11) NOT NULL,
  `category` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `version` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `module_histories_company_id_module_id_index` (`company_id`,`module_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_module_histories`
--

INSERT INTO `dgi_module_histories` (`id`, `company_id`, `module_id`, `category`, `version`, `description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 1, 'payment-gateways', '1.0.0', 'OfflinePayment yüklendi', '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL),
(2, 1, 2, 'payment-gateways', '1.0.0', 'PaypalStandard yüklendi', '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_notifications`
--

DROP TABLE IF EXISTS `dgi_notifications`;
CREATE TABLE IF NOT EXISTS `dgi_notifications` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_id` int(10) UNSIGNED NOT NULL,
  `notifiable_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_notifiable_id_notifiable_type_index` (`notifiable_id`,`notifiable_type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_password_resets`
--

DROP TABLE IF EXISTS `dgi_password_resets`;
CREATE TABLE IF NOT EXISTS `dgi_password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_payments`
--

DROP TABLE IF EXISTS `dgi_payments`;
CREATE TABLE IF NOT EXISTS `dgi_payments` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `paid_at` datetime NOT NULL,
  `amount` double(15,4) NOT NULL,
  `currency_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `currency_rate` double(15,8) NOT NULL,
  `vendor_id` int(11) DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `category_id` int(11) NOT NULL,
  `payment_method` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `parent_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `payments_company_id_index` (`company_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_permissions`
--

DROP TABLE IF EXISTS `dgi_permissions`;
CREATE TABLE IF NOT EXISTS `dgi_permissions` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_name_unique` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_permissions`
--

INSERT INTO `dgi_permissions` (`id`, `name`, `display_name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'read-admin-panel', 'Read Admin Panel', 'Read Admin Panel', '2018-10-21 11:51:53', '2018-10-21 11:51:53'),
(2, 'read-api', 'Read Api', 'Read Api', '2018-10-21 11:51:53', '2018-10-21 11:51:53'),
(3, 'create-auth-users', 'Create Auth Users', 'Create Auth Users', '2018-10-21 11:51:53', '2018-10-21 11:51:53'),
(4, 'read-auth-users', 'Read Auth Users', 'Read Auth Users', '2018-10-21 11:51:53', '2018-10-21 11:51:53'),
(5, 'update-auth-users', 'Update Auth Users', 'Update Auth Users', '2018-10-21 11:51:53', '2018-10-21 11:51:53'),
(6, 'delete-auth-users', 'Delete Auth Users', 'Delete Auth Users', '2018-10-21 11:51:53', '2018-10-21 11:51:53'),
(7, 'create-auth-roles', 'Create Auth Roles', 'Create Auth Roles', '2018-10-21 11:51:53', '2018-10-21 11:51:53'),
(8, 'read-auth-roles', 'Read Auth Roles', 'Read Auth Roles', '2018-10-21 11:51:53', '2018-10-21 11:51:53'),
(9, 'update-auth-roles', 'Update Auth Roles', 'Update Auth Roles', '2018-10-21 11:51:53', '2018-10-21 11:51:53'),
(10, 'delete-auth-roles', 'Delete Auth Roles', 'Delete Auth Roles', '2018-10-21 11:51:53', '2018-10-21 11:51:53'),
(11, 'create-auth-permissions', 'Create Auth Permissions', 'Create Auth Permissions', '2018-10-21 11:51:53', '2018-10-21 11:51:53'),
(12, 'read-auth-permissions', 'Read Auth Permissions', 'Read Auth Permissions', '2018-10-21 11:51:53', '2018-10-21 11:51:53'),
(13, 'update-auth-permissions', 'Update Auth Permissions', 'Update Auth Permissions', '2018-10-21 11:51:54', '2018-10-21 11:51:54'),
(14, 'delete-auth-permissions', 'Delete Auth Permissions', 'Delete Auth Permissions', '2018-10-21 11:51:54', '2018-10-21 11:51:54'),
(15, 'read-auth-profile', 'Read Auth Profile', 'Read Auth Profile', '2018-10-21 11:51:54', '2018-10-21 11:51:54'),
(16, 'update-auth-profile', 'Update Auth Profile', 'Update Auth Profile', '2018-10-21 11:51:54', '2018-10-21 11:51:54'),
(17, 'create-common-companies', 'Create Common Companies', 'Create Common Companies', '2018-10-21 11:51:54', '2018-10-21 11:51:54'),
(18, 'read-common-companies', 'Read Common Companies', 'Read Common Companies', '2018-10-21 11:51:54', '2018-10-21 11:51:54'),
(19, 'update-common-companies', 'Update Common Companies', 'Update Common Companies', '2018-10-21 11:51:54', '2018-10-21 11:51:54'),
(20, 'delete-common-companies', 'Delete Common Companies', 'Delete Common Companies', '2018-10-21 11:51:54', '2018-10-21 11:51:54'),
(21, 'create-common-import', 'Create Common Import', 'Create Common Import', '2018-10-21 11:51:54', '2018-10-21 11:51:54'),
(22, 'create-common-items', 'Create Common Items', 'Create Common Items', '2018-10-21 11:51:54', '2018-10-21 11:51:54'),
(23, 'read-common-items', 'Read Common Items', 'Read Common Items', '2018-10-21 11:51:54', '2018-10-21 11:51:54'),
(24, 'update-common-items', 'Update Common Items', 'Update Common Items', '2018-10-21 11:51:54', '2018-10-21 11:51:54'),
(25, 'delete-common-items', 'Delete Common Items', 'Delete Common Items', '2018-10-21 11:51:54', '2018-10-21 11:51:54'),
(26, 'delete-common-uploads', 'Delete Common Uploads', 'Delete Common Uploads', '2018-10-21 11:51:54', '2018-10-21 11:51:54'),
(27, 'create-incomes-invoices', 'Create Incomes Invoices', 'Create Incomes Invoices', '2018-10-21 11:51:55', '2018-10-21 11:51:55'),
(28, 'read-incomes-invoices', 'Read Incomes Invoices', 'Read Incomes Invoices', '2018-10-21 11:51:55', '2018-10-21 11:51:55'),
(29, 'update-incomes-invoices', 'Update Incomes Invoices', 'Update Incomes Invoices', '2018-10-21 11:51:55', '2018-10-21 11:51:55'),
(30, 'delete-incomes-invoices', 'Delete Incomes Invoices', 'Delete Incomes Invoices', '2018-10-21 11:51:55', '2018-10-21 11:51:55'),
(31, 'create-incomes-revenues', 'Create Incomes Revenues', 'Create Incomes Revenues', '2018-10-21 11:51:55', '2018-10-21 11:51:55'),
(32, 'read-incomes-revenues', 'Read Incomes Revenues', 'Read Incomes Revenues', '2018-10-21 11:51:55', '2018-10-21 11:51:55'),
(33, 'update-incomes-revenues', 'Update Incomes Revenues', 'Update Incomes Revenues', '2018-10-21 11:51:55', '2018-10-21 11:51:55'),
(34, 'delete-incomes-revenues', 'Delete Incomes Revenues', 'Delete Incomes Revenues', '2018-10-21 11:51:55', '2018-10-21 11:51:55'),
(35, 'create-incomes-customers', 'Create Incomes Customers', 'Create Incomes Customers', '2018-10-21 11:51:55', '2018-10-21 11:51:55'),
(36, 'read-incomes-customers', 'Read Incomes Customers', 'Read Incomes Customers', '2018-10-21 11:51:55', '2018-10-21 11:51:55'),
(37, 'update-incomes-customers', 'Update Incomes Customers', 'Update Incomes Customers', '2018-10-21 11:51:55', '2018-10-21 11:51:55'),
(38, 'delete-incomes-customers', 'Delete Incomes Customers', 'Delete Incomes Customers', '2018-10-21 11:51:56', '2018-10-21 11:51:56'),
(39, 'create-expenses-bills', 'Create Expenses Bills', 'Create Expenses Bills', '2018-10-21 11:51:56', '2018-10-21 11:51:56'),
(40, 'read-expenses-bills', 'Read Expenses Bills', 'Read Expenses Bills', '2018-10-21 11:51:56', '2018-10-21 11:51:56'),
(41, 'update-expenses-bills', 'Update Expenses Bills', 'Update Expenses Bills', '2018-10-21 11:51:56', '2018-10-21 11:51:56'),
(42, 'delete-expenses-bills', 'Delete Expenses Bills', 'Delete Expenses Bills', '2018-10-21 11:51:56', '2018-10-21 11:51:56'),
(43, 'create-expenses-payments', 'Create Expenses Payments', 'Create Expenses Payments', '2018-10-21 11:51:56', '2018-10-21 11:51:56'),
(44, 'read-expenses-payments', 'Read Expenses Payments', 'Read Expenses Payments', '2018-10-21 11:51:56', '2018-10-21 11:51:56'),
(45, 'update-expenses-payments', 'Update Expenses Payments', 'Update Expenses Payments', '2018-10-21 11:51:56', '2018-10-21 11:51:56'),
(46, 'delete-expenses-payments', 'Delete Expenses Payments', 'Delete Expenses Payments', '2018-10-21 11:51:56', '2018-10-21 11:51:56'),
(47, 'create-expenses-vendors', 'Create Expenses Vendors', 'Create Expenses Vendors', '2018-10-21 11:51:56', '2018-10-21 11:51:56'),
(48, 'read-expenses-vendors', 'Read Expenses Vendors', 'Read Expenses Vendors', '2018-10-21 11:51:57', '2018-10-21 11:51:57'),
(49, 'update-expenses-vendors', 'Update Expenses Vendors', 'Update Expenses Vendors', '2018-10-21 11:51:57', '2018-10-21 11:51:57'),
(50, 'delete-expenses-vendors', 'Delete Expenses Vendors', 'Delete Expenses Vendors', '2018-10-21 11:51:57', '2018-10-21 11:51:57'),
(51, 'create-banking-accounts', 'Create Banking Accounts', 'Create Banking Accounts', '2018-10-21 11:51:57', '2018-10-21 11:51:57'),
(52, 'read-banking-accounts', 'Read Banking Accounts', 'Read Banking Accounts', '2018-10-21 11:51:57', '2018-10-21 11:51:57'),
(53, 'update-banking-accounts', 'Update Banking Accounts', 'Update Banking Accounts', '2018-10-21 11:51:57', '2018-10-21 11:51:57'),
(54, 'delete-banking-accounts', 'Delete Banking Accounts', 'Delete Banking Accounts', '2018-10-21 11:51:57', '2018-10-21 11:51:57'),
(55, 'create-banking-transfers', 'Create Banking Transfers', 'Create Banking Transfers', '2018-10-21 11:51:57', '2018-10-21 11:51:57'),
(56, 'read-banking-transfers', 'Read Banking Transfers', 'Read Banking Transfers', '2018-10-21 11:51:58', '2018-10-21 11:51:58'),
(57, 'update-banking-transfers', 'Update Banking Transfers', 'Update Banking Transfers', '2018-10-21 11:51:58', '2018-10-21 11:51:58'),
(58, 'delete-banking-transfers', 'Delete Banking Transfers', 'Delete Banking Transfers', '2018-10-21 11:51:58', '2018-10-21 11:51:58'),
(59, 'read-banking-transactions', 'Read Banking Transactions', 'Read Banking Transactions', '2018-10-21 11:51:58', '2018-10-21 11:51:58'),
(60, 'create-settings-categories', 'Create Settings Categories', 'Create Settings Categories', '2018-10-21 11:51:58', '2018-10-21 11:51:58'),
(61, 'read-settings-categories', 'Read Settings Categories', 'Read Settings Categories', '2018-10-21 11:51:58', '2018-10-21 11:51:58'),
(62, 'update-settings-categories', 'Update Settings Categories', 'Update Settings Categories', '2018-10-21 11:51:58', '2018-10-21 11:51:58'),
(63, 'delete-settings-categories', 'Delete Settings Categories', 'Delete Settings Categories', '2018-10-21 11:51:58', '2018-10-21 11:51:58'),
(64, 'read-settings-settings', 'Read Settings Settings', 'Read Settings Settings', '2018-10-21 11:51:59', '2018-10-21 11:51:59'),
(65, 'update-settings-settings', 'Update Settings Settings', 'Update Settings Settings', '2018-10-21 11:51:59', '2018-10-21 11:51:59'),
(66, 'create-settings-taxes', 'Create Settings Taxes', 'Create Settings Taxes', '2018-10-21 11:51:59', '2018-10-21 11:51:59'),
(67, 'read-settings-taxes', 'Read Settings Taxes', 'Read Settings Taxes', '2018-10-21 11:51:59', '2018-10-21 11:51:59'),
(68, 'update-settings-taxes', 'Update Settings Taxes', 'Update Settings Taxes', '2018-10-21 11:51:59', '2018-10-21 11:51:59'),
(69, 'delete-settings-taxes', 'Delete Settings Taxes', 'Delete Settings Taxes', '2018-10-21 11:51:59', '2018-10-21 11:51:59'),
(70, 'create-settings-currencies', 'Create Settings Currencies', 'Create Settings Currencies', '2018-10-21 11:51:59', '2018-10-21 11:51:59'),
(71, 'read-settings-currencies', 'Read Settings Currencies', 'Read Settings Currencies', '2018-10-21 11:52:00', '2018-10-21 11:52:00'),
(72, 'update-settings-currencies', 'Update Settings Currencies', 'Update Settings Currencies', '2018-10-21 11:52:00', '2018-10-21 11:52:00'),
(73, 'delete-settings-currencies', 'Delete Settings Currencies', 'Delete Settings Currencies', '2018-10-21 11:52:00', '2018-10-21 11:52:00'),
(74, 'read-settings-modules', 'Read Settings Modules', 'Read Settings Modules', '2018-10-21 11:52:00', '2018-10-21 11:52:00'),
(75, 'update-settings-modules', 'Update Settings Modules', 'Update Settings Modules', '2018-10-21 11:52:00', '2018-10-21 11:52:00'),
(76, 'read-modules-home', 'Read Modules Home', 'Read Modules Home', '2018-10-21 11:52:00', '2018-10-21 11:52:00'),
(77, 'read-modules-tiles', 'Read Modules Tiles', 'Read Modules Tiles', '2018-10-21 11:52:01', '2018-10-21 11:52:01'),
(78, 'create-modules-item', 'Create Modules Item', 'Create Modules Item', '2018-10-21 11:52:01', '2018-10-21 11:52:01'),
(79, 'read-modules-item', 'Read Modules Item', 'Read Modules Item', '2018-10-21 11:52:01', '2018-10-21 11:52:01'),
(80, 'update-modules-item', 'Update Modules Item', 'Update Modules Item', '2018-10-21 11:52:01', '2018-10-21 11:52:01'),
(81, 'delete-modules-item', 'Delete Modules Item', 'Delete Modules Item', '2018-10-21 11:52:01', '2018-10-21 11:52:01'),
(82, 'create-modules-token', 'Create Modules Token', 'Create Modules Token', '2018-10-21 11:52:01', '2018-10-21 11:52:01'),
(83, 'update-modules-token', 'Update Modules Token', 'Update Modules Token', '2018-10-21 11:52:02', '2018-10-21 11:52:02'),
(84, 'read-modules-my', 'Read Modules My', 'Read Modules My', '2018-10-21 11:52:02', '2018-10-21 11:52:02'),
(85, 'read-install-updates', 'Read Install Updates', 'Read Install Updates', '2018-10-21 11:52:02', '2018-10-21 11:52:02'),
(86, 'update-install-updates', 'Update Install Updates', 'Update Install Updates', '2018-10-21 11:52:02', '2018-10-21 11:52:02'),
(87, 'read-notifications', 'Read Notifications', 'Read Notifications', '2018-10-21 11:52:02', '2018-10-21 11:52:02'),
(88, 'update-notifications', 'Update Notifications', 'Update Notifications', '2018-10-21 11:52:03', '2018-10-21 11:52:03'),
(89, 'read-reports-income-summary', 'Read Reports Income Summary', 'Read Reports Income Summary', '2018-10-21 11:52:03', '2018-10-21 11:52:03'),
(90, 'read-reports-expense-summary', 'Read Reports Expense Summary', 'Read Reports Expense Summary', '2018-10-21 11:52:03', '2018-10-21 11:52:03'),
(91, 'read-reports-income-expense-summary', 'Read Reports Income Expense Summary', 'Read Reports Income Expense Summary', '2018-10-21 11:52:03', '2018-10-21 11:52:03'),
(92, 'read-reports-profit-loss', 'Read Reports Profit Loss', 'Read Reports Profit Loss', '2018-10-21 11:52:03', '2018-10-21 11:52:03'),
(93, 'read-reports-tax-summary', 'Read Reports Tax Summary', 'Read Reports Tax Summary', '2018-10-21 11:52:03', '2018-10-21 11:52:03'),
(94, 'read-customer-panel', 'Read Customer Panel', 'Read Customer Panel', '2018-10-21 11:52:10', '2018-10-21 11:52:10'),
(95, 'read-customers-invoices', 'Read Customers Invoices', 'Read Customers Invoices', '2018-10-21 11:52:10', '2018-10-21 11:52:10'),
(96, 'update-customers-invoices', 'Update Customers Invoices', 'Update Customers Invoices', '2018-10-21 11:52:10', '2018-10-21 11:52:10'),
(97, 'read-customers-payments', 'Read Customers Payments', 'Read Customers Payments', '2018-10-21 11:52:10', '2018-10-21 11:52:10'),
(98, 'update-customers-payments', 'Update Customers Payments', 'Update Customers Payments', '2018-10-21 11:52:10', '2018-10-21 11:52:10'),
(99, 'read-customers-transactions', 'Read Customers Transactions', 'Read Customers Transactions', '2018-10-21 11:52:10', '2018-10-21 11:52:10'),
(100, 'read-customers-profile', 'Read Customers Profile', 'Read Customers Profile', '2018-10-21 11:52:10', '2018-10-21 11:52:10'),
(101, 'update-customers-profile', 'Update Customers Profile', 'Update Customers Profile', '2018-10-21 11:52:10', '2018-10-21 11:52:10');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_recurring`
--

DROP TABLE IF EXISTS `dgi_recurring`;
CREATE TABLE IF NOT EXISTS `dgi_recurring` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `recurable_id` int(10) UNSIGNED NOT NULL,
  `recurable_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `frequency` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `interval` int(11) NOT NULL DEFAULT '1',
  `started_at` datetime NOT NULL,
  `count` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `recurring_recurable_id_recurable_type_index` (`recurable_id`,`recurable_type`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_recurring`
--

INSERT INTO `dgi_recurring` (`id`, `company_id`, `recurable_id`, `recurable_type`, `frequency`, `interval`, `started_at`, `count`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 1, 'App\\Models\\Income\\Revenue', 'monthly', 1, '2018-10-31 18:23:26', 0, '2018-10-31 15:23:26', '2018-10-31 15:23:26', NULL);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_revenues`
--

DROP TABLE IF EXISTS `dgi_revenues`;
CREATE TABLE IF NOT EXISTS `dgi_revenues` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `paid_at` datetime NOT NULL,
  `amount` double(15,4) NOT NULL,
  `currency_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `currency_rate` double(15,8) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `category_id` int(11) NOT NULL,
  `payment_method` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `parent_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `revenues_company_id_index` (`company_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_revenues`
--

INSERT INTO `dgi_revenues` (`id`, `company_id`, `account_id`, `paid_at`, `amount`, `currency_code`, `currency_rate`, `customer_id`, `description`, `category_id`, `payment_method`, `reference`, `created_at`, `updated_at`, `deleted_at`, `parent_id`) VALUES
(1, 1, 1, '2018-10-31 18:23:26', 30.0000, 'USD', 1.00000000, 19, NULL, 3, 'offlinepayment.bank_transfer.2', NULL, '2018-10-31 15:23:26', '2018-10-31 15:23:26', NULL, 0);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_roles`
--

DROP TABLE IF EXISTS `dgi_roles`;
CREATE TABLE IF NOT EXISTS `dgi_roles` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_unique` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_roles`
--

INSERT INTO `dgi_roles` (`id`, `name`, `display_name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'Admin', 'Admin', '2018-10-21 11:51:53', '2018-10-21 11:51:53'),
(2, 'manager', 'Manager', 'Manager', '2018-10-21 11:52:04', '2018-10-21 11:52:04'),
(3, 'customer', 'Customer', 'Customer', '2018-10-21 11:52:10', '2018-10-21 11:52:10');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_role_permissions`
--

DROP TABLE IF EXISTS `dgi_role_permissions`;
CREATE TABLE IF NOT EXISTS `dgi_role_permissions` (
  `role_id` int(10) UNSIGNED NOT NULL,
  `permission_id` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `role_permissions_permission_id_foreign` (`permission_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_role_permissions`
--

INSERT INTO `dgi_role_permissions` (`role_id`, `permission_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(1, 11),
(1, 12),
(1, 13),
(1, 14),
(1, 15),
(1, 16),
(1, 17),
(1, 18),
(1, 19),
(1, 20),
(1, 21),
(1, 22),
(1, 23),
(1, 24),
(1, 25),
(1, 26),
(1, 27),
(1, 28),
(1, 29),
(1, 30),
(1, 31),
(1, 32),
(1, 33),
(1, 34),
(1, 35),
(1, 36),
(1, 37),
(1, 38),
(1, 39),
(1, 40),
(1, 41),
(1, 42),
(1, 43),
(1, 44),
(1, 45),
(1, 46),
(1, 47),
(1, 48),
(1, 49),
(1, 50),
(1, 51),
(1, 52),
(1, 53),
(1, 54),
(1, 55),
(1, 56),
(1, 57),
(1, 58),
(1, 59),
(1, 60),
(1, 61),
(1, 62),
(1, 63),
(1, 64),
(1, 65),
(1, 66),
(1, 67),
(1, 68),
(1, 69),
(1, 70),
(1, 71),
(1, 72),
(1, 73),
(1, 74),
(1, 75),
(1, 76),
(1, 77),
(1, 78),
(1, 79),
(1, 80),
(1, 81),
(1, 82),
(1, 83),
(1, 84),
(1, 85),
(1, 86),
(1, 87),
(1, 88),
(1, 89),
(1, 90),
(1, 91),
(1, 92),
(1, 93),
(2, 1),
(2, 15),
(2, 16),
(2, 17),
(2, 18),
(2, 19),
(2, 20),
(2, 21),
(2, 22),
(2, 23),
(2, 24),
(2, 25),
(2, 27),
(2, 28),
(2, 29),
(2, 30),
(2, 31),
(2, 32),
(2, 33),
(2, 34),
(2, 35),
(2, 36),
(2, 37),
(2, 38),
(2, 39),
(2, 40),
(2, 41),
(2, 42),
(2, 43),
(2, 44),
(2, 45),
(2, 46),
(2, 47),
(2, 48),
(2, 49),
(2, 50),
(2, 51),
(2, 52),
(2, 53),
(2, 54),
(2, 55),
(2, 56),
(2, 57),
(2, 58),
(2, 59),
(2, 60),
(2, 61),
(2, 62),
(2, 63),
(2, 64),
(2, 65),
(2, 66),
(2, 67),
(2, 68),
(2, 69),
(2, 70),
(2, 71),
(2, 72),
(2, 73),
(2, 74),
(2, 75),
(2, 85),
(2, 86),
(2, 87),
(2, 88),
(2, 89),
(2, 90),
(2, 91),
(2, 92),
(2, 93),
(3, 94),
(3, 95),
(3, 96),
(3, 97),
(3, 98),
(3, 99),
(3, 100),
(3, 101);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_sessions`
--

DROP TABLE IF EXISTS `dgi_sessions`;
CREATE TABLE IF NOT EXISTS `dgi_sessions` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int(11) NOT NULL,
  UNIQUE KEY `sessions_id_unique` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_settings`
--

DROP TABLE IF EXISTS `dgi_settings`;
CREATE TABLE IF NOT EXISTS `dgi_settings` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `key` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `settings_company_id_key_unique` (`company_id`,`key`),
  KEY `settings_company_id_index` (`company_id`)
) ENGINE=MyISAM AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_settings`
--

INSERT INTO `dgi_settings` (`id`, `company_id`, `key`, `value`) VALUES
(1, 1, 'general.default_account', '1'),
(2, 1, 'general.date_format', 'd M Y'),
(3, 1, 'general.date_separator', 'space'),
(4, 1, 'general.timezone', 'Europe/London'),
(5, 1, 'general.percent_position', 'after'),
(6, 1, 'general.invoice_number_prefix', 'INV-'),
(7, 1, 'general.invoice_number_digit', '5'),
(8, 1, 'general.invoice_number_next', '6'),
(9, 1, 'general.default_payment_method', 'offlinepayment.cash.1'),
(10, 1, 'general.email_protocol', 'mail'),
(11, 1, 'general.email_sendmail_path', '/usr/sbin/sendmail -bs'),
(12, 1, 'general.send_invoice_reminder', '0'),
(13, 1, 'general.schedule_invoice_days', '1,3,5,10'),
(14, 1, 'general.send_bill_reminder', '0'),
(15, 1, 'general.schedule_bill_days', '10,5,3,1'),
(16, 1, 'general.schedule_time', '09:00'),
(17, 1, 'general.admin_theme', 'skin-green-light'),
(18, 1, 'general.list_limit', '25'),
(19, 1, 'general.use_gravatar', '0'),
(20, 1, 'general.session_handler', 'file'),
(21, 1, 'general.session_lifetime', '30'),
(22, 1, 'general.file_size', '2'),
(23, 1, 'general.file_types', 'pdf,jpeg,jpg,png'),
(24, 1, 'general.company_name', 'BitirmeProjesi'),
(25, 1, 'general.company_email', 'bitirme@denme.com'),
(26, 1, 'general.default_currency', 'USD'),
(27, 1, 'general.default_locale', 'tr-TR'),
(28, 1, 'offlinepayment.methods', '[{\"code\":\"offlinepayment.cash.1\",\"name\":\"Cash\",\"order\":\"1\",\"description\":null},{\"code\":\"offlinepayment.bank_transfer.2\",\"name\":\"Bank Transfer\",\"order\":\"2\",\"description\":null}]');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_taxes`
--

DROP TABLE IF EXISTS `dgi_taxes`;
CREATE TABLE IF NOT EXISTS `dgi_taxes` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rate` double(15,4) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `taxes_company_id_index` (`company_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_taxes`
--

INSERT INTO `dgi_taxes` (`id`, `company_id`, `name`, `rate`, `enabled`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'Vergi Muaf', 0.0000, 1, '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL),
(2, 1, 'Normal Vergi', 5.0000, 1, '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL),
(3, 1, 'Satış Vergisi', 15.0000, 1, '2018-10-21 11:53:06', '2018-10-21 11:53:06', NULL);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_transfers`
--

DROP TABLE IF EXISTS `dgi_transfers`;
CREATE TABLE IF NOT EXISTS `dgi_transfers` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `payment_id` int(11) NOT NULL,
  `revenue_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `transfers_company_id_index` (`company_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_users`
--

DROP TABLE IF EXISTS `dgi_users`;
CREATE TABLE IF NOT EXISTS `dgi_users` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_logged_in_at` timestamp NULL DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `locale` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'tr-TR',
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_deleted_at_unique` (`email`,`deleted_at`)
) ENGINE=MyISAM AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_users`
--

INSERT INTO `dgi_users` (`id`, `name`, `email`, `password`, `remember_token`, `last_logged_in_at`, `enabled`, `created_at`, `updated_at`, `deleted_at`, `locale`) VALUES
(29, 'Muhammet', 'vrl.muhammet123s@gmail.com', '$2y$10$7GfDZnpAVuJ77FZvzAhVxuSYQe9Z11WBf7ZVawjsksoOYjivi7O8y', NULL, NULL, 1, '2018-10-29 14:30:13', '2018-10-29 14:30:13', NULL, 'tr-TR'),
(28, 'DenemeBanka', 'vrl.muhammet55600sad@gmail.com', '$2y$10$48tYrXPqDgizWGzcQDThWOXuysNfXj7UadvDOLNGMGkAAYoyho44u', NULL, NULL, 1, '2018-10-27 16:28:13', '2018-10-27 16:28:13', NULL, 'tr-TR'),
(27, 'Ali Yılmaz', 'deneme123@deneme.com', '$2y$10$JouAivghNQz3HIMNezlu9.1V4WhvQ3Tu8h6gCSpMB/IpMlq4RLAPm', NULL, NULL, 1, '2018-10-27 15:50:17', '2018-10-27 15:50:17', NULL, 'tr-TR'),
(1, 'Muhammet', 'deneme@deneme.com', '$2y$10$XWRFNkkOwaVCVWvXowcjXOmRA7sZ.soXRgJWN842ab0igKFh.w1VG', 'qrQ9xeI4NrgbQJixGpKLoFBOewxFaVaqJDRZn8vldCP2b44B7LjPUwcghNox', '2019-01-10 06:44:29', 1, NULL, '2019-01-10 06:44:29', NULL, 'tr-TR');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_user_companies`
--

DROP TABLE IF EXISTS `dgi_user_companies`;
CREATE TABLE IF NOT EXISTS `dgi_user_companies` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `company_id` int(10) UNSIGNED NOT NULL,
  `user_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`user_id`,`company_id`,`user_type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_user_companies`
--

INSERT INTO `dgi_user_companies` (`user_id`, `company_id`, `user_type`) VALUES
(1, 1, 'users'),
(2, 1, 'users'),
(3, 1, 'users'),
(4, 1, 'users'),
(5, 1, 'users'),
(6, 1, 'users'),
(7, 1, 'users'),
(9, 1, 'users'),
(10, 1, 'users'),
(24, 1, 'users'),
(27, 1, 'users'),
(28, 1, 'users'),
(29, 1, 'users');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_user_permissions`
--

DROP TABLE IF EXISTS `dgi_user_permissions`;
CREATE TABLE IF NOT EXISTS `dgi_user_permissions` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `permission_id` int(10) UNSIGNED NOT NULL,
  `user_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`user_id`,`permission_id`,`user_type`),
  KEY `user_permissions_permission_id_foreign` (`permission_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_user_roles`
--

DROP TABLE IF EXISTS `dgi_user_roles`;
CREATE TABLE IF NOT EXISTS `dgi_user_roles` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `user_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`,`user_type`),
  KEY `user_roles_role_id_foreign` (`role_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `dgi_user_roles`
--

INSERT INTO `dgi_user_roles` (`user_id`, `role_id`, `user_type`) VALUES
(1, 1, 'users'),
(2, 1, 'users'),
(3, 1, 'users'),
(4, 1, 'users'),
(5, 1, 'users'),
(6, 1, 'users'),
(7, 1, 'users'),
(9, 1, 'users'),
(10, 1, 'users'),
(24, 1, 'users'),
(27, 3, 'users'),
(28, 3, 'users'),
(29, 3, 'users');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dgi_vendors`
--

DROP TABLE IF EXISTS `dgi_vendors`;
CREATE TABLE IF NOT EXISTS `dgi_vendors` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tax_number` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `website` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `vendors_company_id_email_deleted_at_unique` (`company_id`,`email`,`deleted_at`),
  KEY `vendors_company_id_index` (`company_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
