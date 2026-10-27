-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 12, 2026 at 07:14 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `crm-db`
--

-- --------------------------------------------------------

--
-- Table structure for table `activities`
--

CREATE TABLE `activities` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `userId` varchar(191) DEFAULT NULL,
  `leadId` varchar(191) DEFAULT NULL,
  `contactId` varchar(191) DEFAULT NULL,
  `dealId` varchar(191) DEFAULT NULL,
  `type` enum('NOTE_ADDED','CALL_LOGGED','EMAIL_SENT','MEETING_HELD','STAGE_CHANGED','STATUS_CHANGED','LEAD_CONVERTED','TASK_CREATED','TASK_COMPLETED') NOT NULL,
  `title` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `activities`
--

INSERT INTO `activities` (`id`, `tenantId`, `userId`, `leadId`, `contactId`, `dealId`, `type`, `title`, `description`, `metadata`, `createdAt`) VALUES
('cmv1ysfb30005toycr25m38th', 'TENANT-08492', 'cmuo3wl50000ltoeojmmdwqth', NULL, 'cmv1ysfaq0003toycmjhnrc3b', NULL, 'NOTE_ADDED', 'Contact \'Stiv Smith\' was created', 'Company: Global, Type: Enterprise Client', NULL, '2026-10-10 05:39:21.855'),
('cmv1yua31000dtoyc4mvl5h77', 'TENANT-08492', 'cmuo3wl50000ltoeojmmdwqth', 'cmv1yua2l000btoycolttbs7x', NULL, NULL, 'NOTE_ADDED', 'Lead \'abd\' was created', 'Source: Direct Outreach, Estimated Value: $250000', NULL, '2026-10-10 05:40:48.397');

-- --------------------------------------------------------

--
-- Table structure for table `communications`
--

CREATE TABLE `communications` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `userId` varchar(191) DEFAULT NULL,
  `contactId` varchar(191) DEFAULT NULL,
  `leadId` varchar(191) DEFAULT NULL,
  `channel` varchar(191) NOT NULL DEFAULT 'EMAIL',
  `direction` varchar(191) NOT NULL DEFAULT 'OUTBOUND',
  `sender` varchar(191) NOT NULL,
  `recipient` varchar(191) NOT NULL,
  `subject` varchar(191) DEFAULT NULL,
  `body` text NOT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'SENT',
  `provider` varchar(191) DEFAULT 'INTERNAL',
  `errorDetails` varchar(191) DEFAULT NULL,
  `attachments` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`attachments`)),
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `contacts`
--

CREATE TABLE `contacts` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `assignedUserId` varchar(191) DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `company` varchar(191) DEFAULT NULL,
  `email` varchar(191) DEFAULT NULL,
  `phone` varchar(191) DEFAULT NULL,
  `type` varchar(191) DEFAULT 'Enterprise Client',
  `title` varchar(191) DEFAULT NULL,
  `status` varchar(191) DEFAULT 'Active',
  `lastActivity` datetime(3) DEFAULT NULL,
  `totalValue` decimal(12,2) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `contacts`
--

INSERT INTO `contacts` (`id`, `tenantId`, `assignedUserId`, `name`, `company`, `email`, `phone`, `type`, `title`, `status`, `lastActivity`, `totalValue`, `createdAt`, `updatedAt`) VALUES
('cmv1ysfaq0003toycmjhnrc3b', 'TENANT-08492', 'cmuo3wl50000ltoeojmmdwqth', 'Stiv Smith', 'Global', 'smith@gmail.com', '4894394849', 'Enterprise Client', NULL, 'Active', '2026-10-10 05:39:21.839', 0.00, '2026-10-10 05:39:21.842', '2026-10-10 05:39:21.842');

-- --------------------------------------------------------

--
-- Table structure for table `deals`
--

CREATE TABLE `deals` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `contactId` varchar(191) DEFAULT NULL,
  `leadId` varchar(191) DEFAULT NULL,
  `assignedUserId` varchar(191) DEFAULT NULL,
  `title` varchar(191) NOT NULL,
  `customer` varchar(191) DEFAULT NULL,
  `value` decimal(12,2) NOT NULL DEFAULT 0.00,
  `stage` enum('NEW_LEAD','CONTACTED','QUALIFIED','OPPORTUNITY','PROPOSAL','NEGOTIATION','WON','LOST') NOT NULL DEFAULT 'NEW_LEAD',
  `probability` int(11) NOT NULL DEFAULT 50,
  `expectedClose` datetime(3) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ebox_messages`
--

CREATE TABLE `ebox_messages` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `senderId` varchar(191) NOT NULL,
  `senderName` varchar(191) NOT NULL,
  `recipient` varchar(191) NOT NULL DEFAULT 'Kiaan Tech Team',
  `subject` varchar(191) NOT NULL,
  `message` text NOT NULL,
  `priority` varchar(191) NOT NULL DEFAULT 'Normal',
  `isEncrypted` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `erp_projects`
--

CREATE TABLE `erp_projects` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `dealId` varchar(191) DEFAULT NULL,
  `contactId` varchar(191) DEFAULT NULL,
  `assignedUserId` varchar(191) DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `client` varchar(191) NOT NULL,
  `budget` decimal(12,2) NOT NULL DEFAULT 0.00,
  `spent` decimal(12,2) NOT NULL DEFAULT 0.00,
  `progress` int(11) NOT NULL DEFAULT 0,
  `status` varchar(191) NOT NULL DEFAULT 'In Progress',
  `manager` varchar(191) DEFAULT NULL,
  `deadline` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hr_candidates`
--

CREATE TABLE `hr_candidates` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `phone` varchar(191) DEFAULT NULL,
  `role` varchar(191) NOT NULL,
  `stage` varchar(191) NOT NULL DEFAULT 'Applied',
  `score` int(11) NOT NULL DEFAULT 85,
  `experience` varchar(191) DEFAULT NULL,
  `resumeUrl` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hr_employees`
--

CREATE TABLE `hr_employees` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `employeeId` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `phone` varchar(191) DEFAULT NULL,
  `department` varchar(191) NOT NULL,
  `designation` varchar(191) NOT NULL,
  `salary` decimal(12,2) NOT NULL DEFAULT 0.00,
  `joiningDate` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `status` varchar(191) NOT NULL DEFAULT 'Active',
  `payrollStatus` varchar(191) NOT NULL DEFAULT 'Processed',
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_items`
--

CREATE TABLE `inventory_items` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `sku` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `category` varchar(191) NOT NULL DEFAULT 'Hardware',
  `warehouse` varchar(191) NOT NULL DEFAULT 'Austin Central',
  `quantity` int(11) NOT NULL DEFAULT 0,
  `minThreshold` int(11) NOT NULL DEFAULT 50,
  `unitCost` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status` varchar(191) NOT NULL DEFAULT 'Optimal',
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `invoiceNumber` varchar(191) NOT NULL,
  `customerId` varchar(191) DEFAULT NULL,
  `customerName` varchar(191) NOT NULL,
  `customerEmail` varchar(191) DEFAULT NULL,
  `dealId` varchar(191) DEFAULT NULL,
  `projectId` varchar(191) DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `subtotal` decimal(12,2) NOT NULL DEFAULT 0.00,
  `tax` decimal(12,2) NOT NULL DEFAULT 0.00,
  `discount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status` varchar(191) NOT NULL DEFAULT 'Sent',
  `dueDate` datetime(3) DEFAULT NULL,
  `issueDate` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`items`)),
  `notes` text DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `knowledge_articles`
--

CREATE TABLE `knowledge_articles` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `title` varchar(191) NOT NULL,
  `category` varchar(191) NOT NULL,
  `content` text NOT NULL,
  `views` int(11) NOT NULL DEFAULT 0,
  `isPublished` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `knowledge_articles`
--

INSERT INTO `knowledge_articles` (`id`, `tenantId`, `title`, `category`, `content`, `views`, `isPublished`, `createdAt`, `updatedAt`) VALUES
('cmv1ydo0h0001toyc6ox2u1mq', 'TENANT-08492', 'ff', 'CRM & Pipeline', 'aaa', 0, 1, '2026-10-10 05:27:53.295', '2026-10-10 05:27:53.295');

-- --------------------------------------------------------

--
-- Table structure for table `leads`
--

CREATE TABLE `leads` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `assignedUserId` varchar(191) DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `company` varchar(191) NOT NULL,
  `email` varchar(191) DEFAULT NULL,
  `phone` varchar(191) DEFAULT NULL,
  `source` varchar(191) DEFAULT NULL,
  `territory` varchar(191) DEFAULT NULL,
  `status` enum('NEW','CONTACTED','QUALIFIED','PROPOSAL','WON','LOST') NOT NULL DEFAULT 'NEW',
  `qualification` varchar(191) DEFAULT NULL,
  `score` int(11) NOT NULL DEFAULT 75,
  `estimatedValue` decimal(12,2) DEFAULT NULL,
  `convertedToContactId` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `leads`
--

INSERT INTO `leads` (`id`, `tenantId`, `assignedUserId`, `name`, `company`, `email`, `phone`, `source`, `territory`, `status`, `qualification`, `score`, `estimatedValue`, `convertedToContactId`, `createdAt`, `updatedAt`) VALUES
('cmv1yua2l000btoycolttbs7x', 'TENANT-08492', 'cmuo3wl50000ltoeojmmdwqth', 'abd', 'solar', 'abd@gmail.com', NULL, 'Direct Outreach', 'North America', 'NEW', NULL, 85, 250000.00, NULL, '2026-10-10 05:40:48.380', '2026-10-10 05:40:48.380');

-- --------------------------------------------------------

--
-- Table structure for table `ledger_accounts`
--

CREATE TABLE `ledger_accounts` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `code` varchar(191) NOT NULL,
  `accountName` varchar(191) NOT NULL,
  `type` varchar(191) NOT NULL,
  `balance` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status` varchar(191) NOT NULL DEFAULT 'Reconciled',
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notes`
--

CREATE TABLE `notes` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `authorId` varchar(191) DEFAULT NULL,
  `leadId` varchar(191) DEFAULT NULL,
  `contactId` varchar(191) DEFAULT NULL,
  `dealId` varchar(191) DEFAULT NULL,
  `content` text NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `production_orders`
--

CREATE TABLE `production_orders` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `orderNumber` varchar(191) NOT NULL,
  `productName` varchar(191) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `bomCode` varchar(191) DEFAULT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'Scheduled',
  `startDate` datetime(3) DEFAULT NULL,
  `completionDate` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `purchase_orders`
--

CREATE TABLE `purchase_orders` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `poNumber` varchar(191) DEFAULT NULL,
  `vendor` varchar(191) NOT NULL,
  `items` text NOT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status` varchar(191) NOT NULL DEFAULT 'Pending Approval',
  `eta` varchar(191) DEFAULT NULL,
  `date` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sales_orders`
--

CREATE TABLE `sales_orders` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `dealId` varchar(191) DEFAULT NULL,
  `contactId` varchar(191) DEFAULT NULL,
  `projectId` varchar(191) DEFAULT NULL,
  `orderNumber` varchar(191) DEFAULT NULL,
  `customer` varchar(191) NOT NULL,
  `items` text NOT NULL,
  `total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status` varchar(191) NOT NULL DEFAULT 'Processing',
  `date` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `support_tickets`
--

CREATE TABLE `support_tickets` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `ticketNumber` varchar(191) NOT NULL,
  `title` varchar(191) NOT NULL,
  `description` text NOT NULL,
  `category` varchar(191) NOT NULL DEFAULT 'Technical',
  `priority` varchar(191) NOT NULL DEFAULT 'Medium',
  `status` varchar(191) NOT NULL DEFAULT 'Open',
  `assignedUserId` varchar(191) DEFAULT NULL,
  `contactId` varchar(191) DEFAULT NULL,
  `slaHours` int(11) NOT NULL DEFAULT 24,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tasks`
--

CREATE TABLE `tasks` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `assignedUserId` varchar(191) DEFAULT NULL,
  `leadId` varchar(191) DEFAULT NULL,
  `contactId` varchar(191) DEFAULT NULL,
  `dealId` varchar(191) DEFAULT NULL,
  `title` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `priority` enum('LOW','MEDIUM','HIGH','URGENT') NOT NULL DEFAULT 'MEDIUM',
  `status` enum('PENDING','IN_PROGRESS','COMPLETED','CANCELLED') NOT NULL DEFAULT 'PENDING',
  `dueDate` datetime(3) DEFAULT NULL,
  `reminder` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tenants`
--

CREATE TABLE `tenants` (
  `id` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `domain` varchar(191) DEFAULT NULL,
  `subscription` varchar(191) DEFAULT 'ACTIVE',
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `parentId` varchar(191) DEFAULT NULL,
  `settings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`settings`)),
  `status` varchar(191) DEFAULT 'ACTIVE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tenants`
--

INSERT INTO `tenants` (`id`, `name`, `domain`, `subscription`, `createdAt`, `updatedAt`, `parentId`, `settings`, `status`) VALUES
('cmunoyqx50000tovon49iw6gx', 'Tenant B Logistics', 'tenant-b.com', 'ACTIVE', '2026-09-30 05:55:34.217', '2026-09-30 05:55:34.217', NULL, NULL, 'ACTIVE'),
('TENANT-08492', 'nErgy Enterprise Logistics', 'nergy.io', 'ACTIVE', '2026-09-30 05:52:09.743', '2026-09-30 05:52:09.743', NULL, NULL, 'ACTIVE');

-- --------------------------------------------------------

--
-- Table structure for table `territories`
--

CREATE TABLE `territories` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `code` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `region` varchar(191) NOT NULL,
  `states` varchar(191) DEFAULT NULL,
  `managerId` varchar(191) DEFAULT NULL,
  `targetQuota` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status` varchar(191) NOT NULL DEFAULT 'Active',
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` varchar(191) NOT NULL,
  `tenantId` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `passwordHash` varchar(191) NOT NULL,
  `role` enum('BUSINESS_OWNER','CUSTOMER','CONTENT_CREATOR','CONTENT_BUILDER','INFLUENCER','AFFILIATE_PARTNER','AI_MARKETING_PRO','HR','OPERATIONS_SALES_ADMIN','FINANCE_COMPLIANCE_ADMIN','CRM_PRO','SUPER_ADMIN') NOT NULL DEFAULT 'CRM_PRO',
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `avatar` longtext DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `tenantId`, `name`, `email`, `passwordHash`, `role`, `isActive`, `avatar`, `createdAt`, `updatedAt`) VALUES
('cmuo3wl3c0001toeory5wre6k', 'TENANT-08492', 'Business Owner', 'business.owner@nergy.io', '$2b$10$6NZnagCPFaHjKOfMDVqDxu5.jXIVdbGUhVHpnNU8aQCFfVkxgNmXe', 'BUSINESS_OWNER', 1, 'data:image/jpeg;base64,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zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzTTTzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzgTzzwzhTTTzzzzzzjjzTzzzzzzzzzxTzzzzzzzzxTzzzzjzzxzTzzzwxDjyxzzzzzzzzzxTzzzzzzzxCzzzzRzzDTzzzzzgQzzzzzzzzzzzzzxTzzzzzzzgzzzzzzxQzxDzzzzzzzzzzzzzzzzzzzxTzzzzzzzjzzzyjwTzzzjSjyhzzzzzzzzzzzzzzzxTzzzzzzywDzzhyxzyTDxSzyxTzzzzzzzzzzzzzzxTzzzzzzyizzyzTzzzijzyjziQjCzzzzzzzzzzzzxTzzzzzzzwBTyhzxzzzzjTBAzzzzzyDDzzzzzzzzxTzzzzzzzyjTyzjyjTzzzwzjTzzyjCyzzzzzzzzzxTzzzzzzzzyjTwzzwjwRzjyRzzjixxSzzzzzzzzzxTzzzzzzzzzzywzzzzzzxDiQzhwzjyQzTzzzzzzzxTzzzzzzzzzzzzzzzziQwwgDSzzwTgyTTzzzzzzzxTzzzzzzzzzzzzzzxhzTzzzxzzzhzzzzzzzzzzzzxTzzzzzzzzzzzzzzzxQRDTzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzyzzzzzzzzzwzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzxizTzzzDSjzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzziSxzzzgzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzyzjDThzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzwxzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzz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', '2026-09-30 12:53:47.589', '2026-10-10 05:21:19.062'),
('cmuo3wl3m0003toeoslzck7oq', 'TENANT-08492', 'Customer', 'customer@nergy.io', '$2b$10$6NZnagCPFaHjKOfMDVqDxu5.jXIVdbGUhVHpnNU8aQCFfVkxgNmXe', 'CUSTOMER', 1, 'data:image/jpeg;base64,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zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzTTTzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzgTzzwzhTTTzzzzzzjjzTzzzzzzzzzxTzzzzzzzzxTzzzzjzzxzTzzzwxDjyxzzzzzzzzzxTzzzzzzzxCzzzzRzzDTzzzzzgQzzzzzzzzzzzzzxTzzzzzzzgzzzzzzxQzxDzzzzzzzzzzzzzzzzzzzxTzzzzzzzjzzzyjwTzzzjSjyhzzzzzzzzzzzzzzzxTzzzzzzywDzzhyxzyTDxSzyxTzzzzzzzzzzzzzzxTzzzzzzyizzyzTzzzijzyjziQjCzzzzzzzzzzzzxTzzzzzzzwBTyhzxzzzzjTBAzzzzzyDDzzzzzzzzxTzzzzzzzyjTyzjyjTzzzwzjTzzyjCyzzzzzzzzzxTzzzzzzzzyjTwzzwjwRzjyRzzjixxSzzzzzzzzzxTzzzzzzzzzzywzzzzzzxDiQzhwzjyQzTzzzzzzzxTzzzzzzzzzzzzzzzziQwwgDSzzwTgyTTzzzzzzzxTzzzzzzzzzzzzzzxhzTzzzxzzzhzzzzzzzzzzzzxTzzzzzzzzzzzzzzzxQRDTzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzyzzzzzzzzzwzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzxizTzzzDSjzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzziSxzzzgzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzyzjDThzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzwxzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzz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', '2026-09-30 12:53:47.603', '2026-10-08 10:46:20.084'),
('cmuo3wl3t0005toeocyz1uqqk', 'TENANT-08492', 'Content Creator', 'content.creator@nergy.io', '$2b$10$6NZnagCPFaHjKOfMDVqDxu5.jXIVdbGUhVHpnNU8aQCFfVkxgNmXe', 'CONTENT_CREATOR', 1, NULL, '2026-09-30 12:53:47.609', '2026-09-30 12:53:47.609'),
('cmuo3wl3y0007toeoj027rocg', 'TENANT-08492', 'Content Builder', 'content.builder@nergy.io', '$2b$10$6NZnagCPFaHjKOfMDVqDxu5.jXIVdbGUhVHpnNU8aQCFfVkxgNmXe', 'CONTENT_BUILDER', 1, NULL, '2026-09-30 12:53:47.614', '2026-09-30 12:53:47.614'),
('cmuo3wl420009toeo92vzkhro', 'TENANT-08492', 'Influencer', 'influencer@nergy.io', '$2b$10$6NZnagCPFaHjKOfMDVqDxu5.jXIVdbGUhVHpnNU8aQCFfVkxgNmXe', 'INFLUENCER', 1, NULL, '2026-09-30 12:53:47.619', '2026-09-30 12:53:47.619'),
('cmuo3wl48000btoeoqg47fegq', 'TENANT-08492', 'Affiliate Partner', 'affiliate.partner@nergy.io', '$2b$10$6NZnagCPFaHjKOfMDVqDxu5.jXIVdbGUhVHpnNU8aQCFfVkxgNmXe', 'AFFILIATE_PARTNER', 1, NULL, '2026-09-30 12:53:47.624', '2026-09-30 12:53:47.624'),
('cmuo3wl4f000dtoeonzy8q5jg', 'TENANT-08492', 'AI Marketing Pro', 'ai.marketing@nergy.io', '$2b$10$6NZnagCPFaHjKOfMDVqDxu5.jXIVdbGUhVHpnNU8aQCFfVkxgNmXe', 'AI_MARKETING_PRO', 1, NULL, '2026-09-30 12:53:47.631', '2026-09-30 12:53:47.631');
INSERT INTO `users` (`id`, `tenantId`, `name`, `email`, `passwordHash`, `role`, `isActive`, `avatar`, `createdAt`, `updatedAt`) VALUES
('cmuo3wl4k000ftoeojzegitnl', 'TENANT-08492', 'HR', 'hr@nergy.io', '$2b$10$6NZnagCPFaHjKOfMDVqDxu5.jXIVdbGUhVHpnNU8aQCFfVkxgNmXe', 'HR', 1, 'data:image/jpeg;base64,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zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzTTTzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzzzgTzzwzhTTTzzzzzzjjzTzzzzzzzzzxTzzzzzzzzxTzzzzjzzxzTzzzwxDjyxzzzzzzzzzxTzzzzzzzxCzzzzRzzDTzzzzzgQzzzzzzzzzzzzzxTzzzzzzzgzzzzzzxQzxDzzzzzzzzzzzzzzzzzzzxTzzzzzzzjzzzyjwTzzzjSjyhzzzzzzzzzzzzzzzxTzzzzzzywDzzhyxzyTDxSzyxTzzzzzzzzzzzzzzxTzzzzzzyizzyzTzzzijzyjziQjCzzzzzzzzzzzzxTzzzzzzzwBTyhzxzzzzjTBAzzzzzyDDzzzzzzzzxTzzzzzzzyjTyzjyjTzzzwzjTzzyjCyzzzzzzzzzxTzzzzzzzzyjTwzzwjwRzjyRzzjixxSzzzzzzzzzxTzzzzzzzzzzywzzzzzzxDiQzhwzjyQzTzzzzzzzxTzzzzzzzzzzzzzzzziQwwgDSzzwTgyTTzzzzzzzxTzzzzzzzzzzzzzzxhzTzzzxzzzhzzzzzzzzzzzzxTzzzzzzzzzzzzzzzxQRDTzzzzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzyzzzzzzzzzwzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzxizTzzzDSjzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzziSxzzzgzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzyzjDThzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzwxzzzzzzzzzzzzzzzxTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxTzzzzzzzz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', '2026-09-30 12:53:47.637', '2026-10-08 07:24:16.704'),
('cmuo3wl4p000htoeo3taieysg', 'TENANT-08492', 'Operations/Sales Admin', 'operations.admin@nergy.io', '$2b$10$6NZnagCPFaHjKOfMDVqDxu5.jXIVdbGUhVHpnNU8aQCFfVkxgNmXe', 'OPERATIONS_SALES_ADMIN', 1, NULL, '2026-09-30 12:53:47.641', '2026-09-30 12:53:47.641'),
('cmuo3wl4u000jtoeo2m4cmegr', 'TENANT-08492', 'Finance/Compliance Admin', 'finance.admin@nergy.io', '$2b$10$6NZnagCPFaHjKOfMDVqDxu5.jXIVdbGUhVHpnNU8aQCFfVkxgNmXe', 'FINANCE_COMPLIANCE_ADMIN', 1, NULL, '2026-09-30 12:53:47.646', '2026-09-30 12:53:47.646'),
('cmuo3wl50000ltoeojmmdwqth', 'TENANT-08492', 'CRM Pro', 'crm.pro@nergy.io', '$2b$10$6NZnagCPFaHjKOfMDVqDxu5.jXIVdbGUhVHpnNU8aQCFfVkxgNmXe', 'CRM_PRO', 1, NULL, '2026-09-30 12:53:47.652', '2026-09-30 12:53:47.652'),
('cmuo3wl55000ntoeo8qagixl1', 'TENANT-08492', 'Super Admin', 'super.admin@nergy.io', '$2b$10$6NZnagCPFaHjKOfMDVqDxu5.jXIVdbGUhVHpnNU8aQCFfVkxgNmXe', 'SUPER_ADMIN', 1, NULL, '2026-09-30 12:53:47.658', '2026-09-30 12:53:47.658');

-- --------------------------------------------------------

--
-- Table structure for table `_prisma_migrations`
--

CREATE TABLE `_prisma_migrations` (
  `id` varchar(36) NOT NULL,
  `checksum` varchar(64) NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) NOT NULL,
  `logs` text DEFAULT NULL,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `applied_steps_count` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `_prisma_migrations`
--

INSERT INTO `_prisma_migrations` (`id`, `checksum`, `finished_at`, `migration_name`, `logs`, `rolled_back_at`, `started_at`, `applied_steps_count`) VALUES
('16710b09-429f-48cc-be2d-dae4f26178a0', '48a4f431e1725ff8eab1985529e3a8c89ae0f307528826a054315b35f4cba297', '2026-09-30 05:37:37.123', '20260930053733_init_crm_schema', NULL, NULL, '2026-09-30 05:37:33.937', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activities`
--
ALTER TABLE `activities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `activities_tenantId_idx` (`tenantId`),
  ADD KEY `activities_tenantId_createdAt_idx` (`tenantId`,`createdAt`),
  ADD KEY `activities_leadId_idx` (`leadId`),
  ADD KEY `activities_contactId_idx` (`contactId`),
  ADD KEY `activities_dealId_idx` (`dealId`),
  ADD KEY `activities_userId_idx` (`userId`);

--
-- Indexes for table `communications`
--
ALTER TABLE `communications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `communications_tenantId_idx` (`tenantId`),
  ADD KEY `communications_contactId_idx` (`contactId`),
  ADD KEY `communications_leadId_idx` (`leadId`),
  ADD KEY `communications_userId_idx` (`userId`);

--
-- Indexes for table `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `contacts_tenantId_idx` (`tenantId`),
  ADD KEY `contacts_tenantId_email_idx` (`tenantId`,`email`),
  ADD KEY `contacts_assignedUserId_idx` (`assignedUserId`);

--
-- Indexes for table `deals`
--
ALTER TABLE `deals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `deals_tenantId_idx` (`tenantId`),
  ADD KEY `deals_tenantId_stage_idx` (`tenantId`,`stage`),
  ADD KEY `deals_contactId_idx` (`contactId`),
  ADD KEY `deals_leadId_idx` (`leadId`),
  ADD KEY `deals_assignedUserId_idx` (`assignedUserId`);

--
-- Indexes for table `ebox_messages`
--
ALTER TABLE `ebox_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ebox_messages_tenantId_idx` (`tenantId`);

--
-- Indexes for table `erp_projects`
--
ALTER TABLE `erp_projects`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `erp_projects_dealId_key` (`dealId`),
  ADD KEY `erp_projects_tenantId_idx` (`tenantId`),
  ADD KEY `erp_projects_contactId_idx` (`contactId`),
  ADD KEY `erp_projects_dealId_idx` (`dealId`),
  ADD KEY `erp_projects_assignedUserId_fkey` (`assignedUserId`);

--
-- Indexes for table `hr_candidates`
--
ALTER TABLE `hr_candidates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `hr_candidates_tenantId_idx` (`tenantId`);

--
-- Indexes for table `hr_employees`
--
ALTER TABLE `hr_employees`
  ADD PRIMARY KEY (`id`),
  ADD KEY `hr_employees_tenantId_idx` (`tenantId`);

--
-- Indexes for table `inventory_items`
--
ALTER TABLE `inventory_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inventory_items_tenantId_idx` (`tenantId`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoices_tenantId_idx` (`tenantId`),
  ADD KEY `invoices_customerId_idx` (`customerId`),
  ADD KEY `invoices_dealId_idx` (`dealId`),
  ADD KEY `invoices_projectId_idx` (`projectId`);

--
-- Indexes for table `knowledge_articles`
--
ALTER TABLE `knowledge_articles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `knowledge_articles_tenantId_idx` (`tenantId`);

--
-- Indexes for table `leads`
--
ALTER TABLE `leads`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `leads_convertedToContactId_key` (`convertedToContactId`),
  ADD KEY `leads_tenantId_idx` (`tenantId`),
  ADD KEY `leads_tenantId_status_idx` (`tenantId`,`status`),
  ADD KEY `leads_assignedUserId_idx` (`assignedUserId`),
  ADD KEY `leads_createdAt_idx` (`createdAt`);

--
-- Indexes for table `ledger_accounts`
--
ALTER TABLE `ledger_accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ledger_accounts_tenantId_idx` (`tenantId`);

--
-- Indexes for table `notes`
--
ALTER TABLE `notes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notes_tenantId_idx` (`tenantId`),
  ADD KEY `notes_leadId_idx` (`leadId`),
  ADD KEY `notes_contactId_idx` (`contactId`),
  ADD KEY `notes_dealId_idx` (`dealId`),
  ADD KEY `notes_authorId_idx` (`authorId`);

--
-- Indexes for table `production_orders`
--
ALTER TABLE `production_orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `production_orders_tenantId_idx` (`tenantId`);

--
-- Indexes for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `purchase_orders_tenantId_idx` (`tenantId`);

--
-- Indexes for table `sales_orders`
--
ALTER TABLE `sales_orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sales_orders_tenantId_idx` (`tenantId`),
  ADD KEY `sales_orders_dealId_idx` (`dealId`),
  ADD KEY `sales_orders_projectId_idx` (`projectId`),
  ADD KEY `sales_orders_contactId_idx` (`contactId`);

--
-- Indexes for table `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `support_tickets_tenantId_idx` (`tenantId`),
  ADD KEY `support_tickets_assignedUserId_idx` (`assignedUserId`),
  ADD KEY `support_tickets_contactId_idx` (`contactId`);

--
-- Indexes for table `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tasks_tenantId_idx` (`tenantId`),
  ADD KEY `tasks_tenantId_status_idx` (`tenantId`,`status`),
  ADD KEY `tasks_assignedUserId_idx` (`assignedUserId`),
  ADD KEY `tasks_dueDate_idx` (`dueDate`),
  ADD KEY `tasks_leadId_fkey` (`leadId`),
  ADD KEY `tasks_contactId_fkey` (`contactId`),
  ADD KEY `tasks_dealId_fkey` (`dealId`);

--
-- Indexes for table `tenants`
--
ALTER TABLE `tenants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tenants_parentId_fkey` (`parentId`);

--
-- Indexes for table `territories`
--
ALTER TABLE `territories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `territories_tenantId_idx` (`tenantId`),
  ADD KEY `territories_managerId_idx` (`managerId`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_tenantId_email_key` (`tenantId`,`email`),
  ADD KEY `users_tenantId_idx` (`tenantId`),
  ADD KEY `users_email_idx` (`email`);

--
-- Indexes for table `_prisma_migrations`
--
ALTER TABLE `_prisma_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activities`
--
ALTER TABLE `activities`
  ADD CONSTRAINT `activities_contactId_fkey` FOREIGN KEY (`contactId`) REFERENCES `contacts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `activities_dealId_fkey` FOREIGN KEY (`dealId`) REFERENCES `deals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `activities_leadId_fkey` FOREIGN KEY (`leadId`) REFERENCES `leads` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `activities_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `activities_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `communications`
--
ALTER TABLE `communications`
  ADD CONSTRAINT `communications_contactId_fkey` FOREIGN KEY (`contactId`) REFERENCES `contacts` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `communications_leadId_fkey` FOREIGN KEY (`leadId`) REFERENCES `leads` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `communications_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `communications_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `contacts`
--
ALTER TABLE `contacts`
  ADD CONSTRAINT `contacts_assignedUserId_fkey` FOREIGN KEY (`assignedUserId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `contacts_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `deals`
--
ALTER TABLE `deals`
  ADD CONSTRAINT `deals_assignedUserId_fkey` FOREIGN KEY (`assignedUserId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `deals_contactId_fkey` FOREIGN KEY (`contactId`) REFERENCES `contacts` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `deals_leadId_fkey` FOREIGN KEY (`leadId`) REFERENCES `leads` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `deals_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ebox_messages`
--
ALTER TABLE `ebox_messages`
  ADD CONSTRAINT `ebox_messages_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `erp_projects`
--
ALTER TABLE `erp_projects`
  ADD CONSTRAINT `erp_projects_assignedUserId_fkey` FOREIGN KEY (`assignedUserId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `erp_projects_contactId_fkey` FOREIGN KEY (`contactId`) REFERENCES `contacts` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `erp_projects_dealId_fkey` FOREIGN KEY (`dealId`) REFERENCES `deals` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `erp_projects_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `hr_candidates`
--
ALTER TABLE `hr_candidates`
  ADD CONSTRAINT `hr_candidates_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `hr_employees`
--
ALTER TABLE `hr_employees`
  ADD CONSTRAINT `hr_employees_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `inventory_items`
--
ALTER TABLE `inventory_items`
  ADD CONSTRAINT `inventory_items_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `invoices_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `contacts` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `invoices_dealId_fkey` FOREIGN KEY (`dealId`) REFERENCES `deals` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `invoices_projectId_fkey` FOREIGN KEY (`projectId`) REFERENCES `erp_projects` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `invoices_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `knowledge_articles`
--
ALTER TABLE `knowledge_articles`
  ADD CONSTRAINT `knowledge_articles_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `leads`
--
ALTER TABLE `leads`
  ADD CONSTRAINT `leads_assignedUserId_fkey` FOREIGN KEY (`assignedUserId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `leads_convertedToContactId_fkey` FOREIGN KEY (`convertedToContactId`) REFERENCES `contacts` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `leads_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ledger_accounts`
--
ALTER TABLE `ledger_accounts`
  ADD CONSTRAINT `ledger_accounts_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `notes`
--
ALTER TABLE `notes`
  ADD CONSTRAINT `notes_authorId_fkey` FOREIGN KEY (`authorId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `notes_contactId_fkey` FOREIGN KEY (`contactId`) REFERENCES `contacts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `notes_dealId_fkey` FOREIGN KEY (`dealId`) REFERENCES `deals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `notes_leadId_fkey` FOREIGN KEY (`leadId`) REFERENCES `leads` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `notes_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `production_orders`
--
ALTER TABLE `production_orders`
  ADD CONSTRAINT `production_orders_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  ADD CONSTRAINT `purchase_orders_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `sales_orders`
--
ALTER TABLE `sales_orders`
  ADD CONSTRAINT `sales_orders_contactId_fkey` FOREIGN KEY (`contactId`) REFERENCES `contacts` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `sales_orders_dealId_fkey` FOREIGN KEY (`dealId`) REFERENCES `deals` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `sales_orders_projectId_fkey` FOREIGN KEY (`projectId`) REFERENCES `erp_projects` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `sales_orders_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD CONSTRAINT `support_tickets_assignedUserId_fkey` FOREIGN KEY (`assignedUserId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `support_tickets_contactId_fkey` FOREIGN KEY (`contactId`) REFERENCES `contacts` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `support_tickets_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tasks`
--
ALTER TABLE `tasks`
  ADD CONSTRAINT `tasks_assignedUserId_fkey` FOREIGN KEY (`assignedUserId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `tasks_contactId_fkey` FOREIGN KEY (`contactId`) REFERENCES `contacts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tasks_dealId_fkey` FOREIGN KEY (`dealId`) REFERENCES `deals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tasks_leadId_fkey` FOREIGN KEY (`leadId`) REFERENCES `leads` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tasks_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tenants`
--
ALTER TABLE `tenants`
  ADD CONSTRAINT `tenants_parentId_fkey` FOREIGN KEY (`parentId`) REFERENCES `tenants` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `territories`
--
ALTER TABLE `territories`
  ADD CONSTRAINT `territories_managerId_fkey` FOREIGN KEY (`managerId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `territories_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_tenantId_fkey` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
