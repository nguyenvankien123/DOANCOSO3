-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: finalterm
-- ======================================================
-- Database schema for Shopping Application
-- Backend: Spring Boot 3.2
-- Frontend: Android Compose
-- ======================================================

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Create Database
CREATE DATABASE IF NOT EXISTS finalterm;
USE finalterm;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_product` (`user_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (1,1,1,1,'2026-05-18 08:51:38','2026-05-18 08:51:38'),(2,1,5,2,'2026-05-18 08:51:38','2026-05-18 08:51:38'),(3,2,2,1,'2026-05-18 08:51:38','2026-05-18 08:51:38');
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Điện thoại','Điện thoại di động các hãng','2026-05-18 08:51:38','2026-05-18 08:51:38'),(2,'Laptop','Máy tính xách tay','2026-05-18 08:51:38','2026-05-18 08:51:38'),(3,'Phụ kiện','Phụ kiện điện thoại & máy tính','2026-05-18 08:51:38','2026-05-18 08:51:38'),(4,'Đồ gia dụng','Đồ dùng trong gia đình','2026-05-18 08:51:38','2026-05-18 08:51:38'),(5,'Thời trang','Quần áo thời trang','2026-05-18 08:51:38','2026-05-18 08:51:38');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(12,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,1,1,1,25000000.00,'2026-05-18 08:51:38'),(2,1,5,2,5990000.00,'2026-05-18 08:51:38'),(3,2,2,1,20000000.00,'2026-05-18 08:51:38');
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `total_price` decimal(12,2) NOT NULL,
  `status` varchar(50) DEFAULT 'pending',
  `shipping_address` text,
  `payment_method` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,1,30990000.00,'delivered','123 Hà Nội, Hà Nội','credit_card','2026-05-18 08:51:38','2026-05-18 08:51:38'),(2,2,20000000.00,'processing','456 TP HCM, TP HCM','bank_transfer','2026-05-18 08:51:38','2026-05-18 08:51:38');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int NOT NULL,
  `name` varchar(200) NOT NULL,
  `description` text,
  `price` decimal(12,2) NOT NULL,
  `discount` int DEFAULT '0',
  `rating` float DEFAULT '0',
  `sold` int DEFAULT '0',
  `image` varchar(255) DEFAULT NULL,
  `stock` int NOT NULL DEFAULT '100',
  `shop_name` varchar(100) DEFAULT NULL,
  `eta` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,1,'iPhone 15 Pro','iPhone 15 Pro 128GB',25000000.00,5,4.8,245,NULL,50,'Apple Store','2-3 ngày','2026-05-18 08:51:38','2026-05-18 08:51:38'),(2,1,'Samsung Galaxy S24','Galaxy S24 256GB',20000000.00,10,4.6,189,NULL,75,'Samsung Store','1-2 ngày','2026-05-18 08:51:38','2026-05-18 08:51:38'),(3,2,'MacBook Pro M3','MacBook Pro 14 inch M3',45000000.00,0,4.9,78,NULL,20,'Apple Store','3-5 ngày','2026-05-18 08:51:38','2026-05-18 08:51:38'),(4,2,'Dell XPS 15','Dell XPS 15 i7',28000000.00,15,4.7,156,NULL,35,'Dell Vietnam','2-3 ngày','2026-05-18 08:51:38','2026-05-18 08:51:38'),(5,3,'AirPods Pro','AirPods Pro (2nd Gen)',5990000.00,10,4.8,420,NULL,100,'Apple Store','1 ngày','2026-05-18 08:51:38','2026-05-18 08:51:38'),(6,3,'Samsung Galaxy Buds','Galaxy Buds2 Pro',3990000.00,5,4.5,310,NULL,80,'Samsung Store','1-2 ngày','2026-05-18 08:51:38','2026-05-18 08:51:38'),(7,4,'Nồi cơm điện','Nồi cơm điện 2L',890000.00,20,4.4,567,NULL,150,'Điện máy Xanh','2 ngày','2026-05-18 08:51:38','2026-05-18 08:51:38'),(8,5,'Áo phông nam','Áo phông cotton 100%',150000.00,30,4.3,1230,NULL,500,'Fashion Store','1 ngày','2026-05-18 08:51:38','2026-05-18 08:51:38');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `user_id` int NOT NULL,
  `rating` int NOT NULL,
  `comment` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,1,1,5,'iPhone 15 Pro quá tuyệt vời! Chất lượng camera rất tốt, pin dùng cả ngày không hết','2026-05-18 08:55:03'),(2,1,2,4,'Sản phẩm tốt nhưng giá hơi đắt. Giao hàng nhanh, đóng gói cẩn thận','2026-05-18 08:55:03'),(3,2,1,4,'Samsung Galaxy S24 chạy rất mượt, màn hình đẹp. Hài lòng với mua hàng','2026-05-18 08:55:03'),(4,2,2,5,'Tuyệt vời! Màn hình AMOLED sáng và sắc nét, pin không được bảo đảm','2026-05-18 08:55:03'),(5,3,1,5,'MacBook Pro M3 siêu nhanh, xử lý công việc rất tốt. Giá cao nhưng xứng đáng','2026-05-18 08:55:03'),(6,4,2,4,'Dell XPS 15 tốt nhưng nóng hơi nhiều khi chạy game. Thiết kế rất đẹp','2026-05-18 08:55:03'),(7,5,1,5,'AirPods Pro âm thanh rất tốt, chống ồn hiệu quả. Rất hài lòng','2026-05-18 08:55:03'),(8,6,2,4,'Samsung Galaxy Buds2 Pro rất khỏe, chất âm tốt, pin tốt','2026-05-18 08:55:03'),(9,7,1,4,'Nồi cơm điện chất lượng tốt, nấu cơm rất ngon, bền lâu','2026-05-18 08:55:03'),(10,8,2,5,'Áo phông cotton chất lượng cao, mặc rất thoải mái và không xù lông sau giặt','2026-05-18 08:55:03');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `role` varchar(50) NOT NULL DEFAULT 'user',
  `address` text,
  `avatar` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'user1@example.com','0901234567','$2y$10$uIr5LFIR37oQPslj8nF1U.Ztz2NN4zzEYKlWD/bJZt/3E6QIGQZ62','Nguyễn Văn A','user','Hà Nội',NULL,'2026-05-18 08:51:38','2026-05-18 11:29:05'),(2,'user2@example.com','0912345678','$2y$10$uIr5LFIR37oQPslj8nF1U.Ztz2NN4zzEYKlWD/bJZt/3E6QIGQZ62','Trần Thị B','user','TP HCM',NULL,'2026-05-18 08:51:38','2026-05-18 11:29:05'),(3,'admin@example.com','0999999999','$2y$10$uIr5LFIR37oQPslj8nF1U.Ztz2NN4zzEYKlWD/bJZt/3E6QIGQZ62','Admin','admin','Hà Nội',NULL,'2026-05-18 08:51:38','2026-05-18 11:29:05');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-18 18:49:06
