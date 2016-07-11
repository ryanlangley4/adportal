-- phpMyAdmin SQL Dump
-- version 4.6.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 10, 2016 at 05:35 PM
-- Server version: 5.7.12-log
-- PHP Version: 7.0.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `adportal`
--

-- --------------------------------------------------------

--
-- Table structure for table `hashtable`
--

CREATE TABLE `hashtable` (
  `id` int(253) NOT NULL,
  `hash` varchar(160) NOT NULL,
  `time_expire` varchar(20) NOT NULL,
  `email` varchar(254) NOT NULL,
  `notified` varchar(10) NOT NULL DEFAULT 'FALSE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tempcooldown`
--

CREATE TABLE `tempcooldown` (
  `id` int(253) NOT NULL,
  `emailaddress` varchar(253) NOT NULL,
  `cooldown_expire` int(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `hashtable`
--
ALTER TABLE `hashtable`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `hash` (`hash`);

--
-- Indexes for table `tempcooldown`
--
ALTER TABLE `tempcooldown`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `hashtable`
--
ALTER TABLE `hashtable`
  MODIFY `id` int(253) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tempcooldown`
--
ALTER TABLE `tempcooldown`
  MODIFY `id` int(253) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
