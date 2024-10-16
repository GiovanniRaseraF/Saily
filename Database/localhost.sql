-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jul 12, 2024 at 08:26 AM
-- Server version: 10.5.25-MariaDB-cll-lve
-- PHP Version: 8.3.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `huracanp_login_database`
--
CREATE DATABASE IF NOT EXISTS `huracanp_login_database` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `huracanp_login_database`;

-- --------------------------------------------------------

--
-- Table structure for table `boats`
--

CREATE TABLE `boats` (
  `boat_id` varchar(20) NOT NULL,
  `mqtt_user` varchar(10) NOT NULL,
  `mqtt_password` varchar(100) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `boats`
--

INSERT INTO `boats` (`boat_id`, `mqtt_user`, `mqtt_password`, `user_id`) VALUES
('qwertyuiop', 'test', 'test', 1),
('0x0001', 'test', 'test', 1),
('0x0002', 'test', 'test', 2),
('0x0003', 'test', 'test', 2),
('0x0004', 'test', 'test', 3),
('0x0005', 'test', 'test', 4),
('0x0006', 'test', 'test', 5),
('0x0007', 'test', 'test', 5),
('0x0008', 'test', 'test', 5);

-- --------------------------------------------------------

--
-- Table structure for table `user_account`
--

CREATE TABLE `user_account` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `user_email` varchar(500) NOT NULL,
  `password_hash` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `user_account`
--

INSERT INTO `user_account` (`user_id`, `user_email`, `password_hash`) VALUES
(0, 'zero', '$2a$10$1mwuFEn94P3NlfmtSQL/cec00cm6Tn7hJLItSoH6/gT3FzxDV.qiG'),
(1, 'g.rasera@huracanmarine.com', '$2a$10$ii4b6pmQXygk35vcpkF9Qe5BzSKQd5lcd8dLXt.zsKoQX2FUOZsF6'),
(2, 'g.sossai@huracanmarine.com', '$2a$10$ii4b6pmQXygk35vcpkF9Qe5BzSKQd5lcd8dLXt.zsKoQX2FUOZsF6'),
(3, 'l.scomazzon@huracanmarine.com', '$2a$10$ii4b6pmQXygk35vcpkF9Qe5BzSKQd5lcd8dLXt.zsKoQX2FUOZsF6'),
(4, 'b.ghizzo@huracanmarine.com', '$2a$10$ii4b6pmQXygk35vcpkF9Qe5BzSKQd5lcd8dLXt.zsKoQX2FUOZsF6'),
(5, 'f.moro@huracanmarine.com', '$2a$10$ii4b6pmQXygk35vcpkF9Qe5BzSKQd5lcd8dLXt.zsKoQX2FUOZsF6');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;