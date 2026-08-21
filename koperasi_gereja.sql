-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 06, 2026 at 04:42 AM
-- Server version: 10.4.20-MariaDB
-- PHP Version: 7.3.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `koperasi_gereja`
--

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tb_admin`
--

CREATE TABLE `tb_admin` (
  `id_admin` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `nama_lengkap` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `no_hp` varchar(15) DEFAULT NULL,
  `foto_profil` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_admin`
--

INSERT INTO `tb_admin` (`id_admin`, `username`, `password_hash`, `nama_lengkap`, `email`, `no_hp`, `foto_profil`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'admin', '123', 'Administrator ', 'admin@koperasigereja.com', '082214136784', '/storage/admin_foto/admin_1779819691_8393.jpg', 1, '2026-05-22 09:54:27', '2026-08-05 21:49:44');

-- --------------------------------------------------------

--
-- Table structure for table `tb_angsuran`
--

CREATE TABLE `tb_angsuran` (
  `id_angsuran` int(11) NOT NULL,
  `id_pinjaman` int(11) NOT NULL,
  `angsuran_ke` int(11) NOT NULL,
  `jumlah_angsuran` decimal(15,2) NOT NULL,
  `jumlah_pokok` decimal(15,2) DEFAULT NULL,
  `jumlah_bunga` decimal(15,2) DEFAULT NULL,
  `denda` decimal(15,2) DEFAULT 0.00,
  `tgl_jatuh_tempo` date NOT NULL,
  `tgl_bayar` date DEFAULT NULL,
  `id_metode_bayar` int(11) DEFAULT NULL,
  `bukti_bayar` text DEFAULT NULL,
  `status` enum('belum_bayar','sebagian','lunas','tunggakan','menunggu_verifikasi') DEFAULT 'belum_bayar',
  `status_bayar` enum('belum_bayar','menunggu_verifikasi','lunas','ditolak') DEFAULT 'belum_bayar',
  `keterangan` text DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tb_detail_transaksi_toko`
--

CREATE TABLE `tb_detail_transaksi_toko` (
  `id_detail` int(11) NOT NULL,
  `id_transaksi_toko` int(11) NOT NULL,
  `id_produk` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `harga_satuan` decimal(15,2) NOT NULL,
  `subtotal` decimal(15,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tb_iuran`
--

CREATE TABLE `tb_iuran` (
  `id_iuran` int(11) NOT NULL,
  `id_jemaat` int(11) NOT NULL,
  `jenis_iuran` enum('wajib','sukarela') DEFAULT 'wajib',
  `id_jenis_iuran` int(11) NOT NULL DEFAULT 1,
  `bulan` int(2) NOT NULL,
  `tahun` int(4) NOT NULL,
  `nominal` decimal(15,2) NOT NULL,
  `tgl_jatuh_tempo` date DEFAULT NULL,
  `tgl_bayar` date DEFAULT NULL,
  `status` enum('belum_bayar','menunggu_verifikasi','lunas','ditolak') DEFAULT 'belum_bayar',
  `bukti_bayar` varchar(255) DEFAULT NULL,
  `id_metode_bayar` int(11) DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `keterangan_iuran` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_iuran`
--

INSERT INTO `tb_iuran` (`id_iuran`, `id_jemaat`, `jenis_iuran`, `id_jenis_iuran`, `bulan`, `tahun`, `nominal`, `tgl_jatuh_tempo`, `tgl_bayar`, `status`, `bukti_bayar`, `id_metode_bayar`, `keterangan`, `keterangan_iuran`, `created_at`, `updated_at`) VALUES
(1, 1, 'wajib', 1, 7, 2026, '50000.00', '2026-07-31', '2026-07-11', 'lunas', '/storage/bukti_iuran/iuran_1_1783779709.jpg', NULL, 'Pembayaran diverifikasi', NULL, '2026-07-11 07:20:15', '2026-07-11 07:28:54'),
(2, 1, 'sukarela', 1, 7, 2026, '0.00', '2026-07-31', '2026-07-12', 'menunggu_verifikasi', '/storage/bukti_iuran/iuran_2_1783874343.jpg', NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-12 09:39:03'),
(3, 1, 'wajib', 1, 8, 2026, '50000.00', '2026-08-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(4, 1, 'sukarela', 1, 8, 2026, '0.00', '2026-08-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(5, 1, 'wajib', 1, 9, 2026, '50000.00', '2026-09-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(6, 1, 'sukarela', 1, 9, 2026, '0.00', '2026-09-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(7, 1, 'wajib', 1, 10, 2026, '50000.00', '2026-10-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(8, 1, 'sukarela', 1, 10, 2026, '0.00', '2026-10-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(9, 1, 'wajib', 1, 11, 2026, '50000.00', '2026-11-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(10, 1, 'sukarela', 1, 11, 2026, '0.00', '2026-11-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(11, 1, 'wajib', 1, 12, 2026, '50000.00', '2026-12-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(12, 1, 'sukarela', 1, 12, 2026, '0.00', '2026-12-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(13, 1, 'wajib', 1, 1, 2027, '50000.00', '2027-01-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(14, 1, 'sukarela', 1, 1, 2027, '0.00', '2027-01-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(15, 1, 'wajib', 1, 2, 2027, '50000.00', '2027-02-28', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(16, 1, 'sukarela', 1, 2, 2027, '0.00', '2027-02-28', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(17, 1, 'wajib', 1, 3, 2027, '50000.00', '2027-03-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(18, 1, 'sukarela', 1, 3, 2027, '0.00', '2027-03-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(19, 1, 'wajib', 1, 4, 2027, '50000.00', '2027-04-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(20, 1, 'sukarela', 1, 4, 2027, '0.00', '2027-04-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(21, 1, 'wajib', 1, 5, 2027, '50000.00', '2027-05-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(22, 1, 'sukarela', 1, 5, 2027, '0.00', '2027-05-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(23, 1, 'wajib', 1, 6, 2027, '50000.00', '2027-06-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(24, 1, 'sukarela', 1, 6, 2027, '0.00', '2027-06-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(25, 1, 'wajib', 1, 7, 2027, '50000.00', '2027-07-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(26, 1, 'sukarela', 1, 7, 2027, '0.00', '2027-07-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(27, 1, 'wajib', 1, 8, 2027, '50000.00', '2027-08-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(28, 1, 'sukarela', 1, 8, 2027, '0.00', '2027-08-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(29, 1, 'wajib', 1, 9, 2027, '50000.00', '2027-09-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(30, 1, 'sukarela', 1, 9, 2027, '0.00', '2027-09-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(31, 1, 'wajib', 1, 10, 2027, '50000.00', '2027-10-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(32, 1, 'sukarela', 1, 10, 2027, '0.00', '2027-10-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(33, 1, 'wajib', 1, 11, 2027, '50000.00', '2027-11-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(34, 1, 'sukarela', 1, 11, 2027, '0.00', '2027-11-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(35, 1, 'wajib', 1, 12, 2027, '50000.00', '2027-12-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(36, 1, 'sukarela', 1, 12, 2027, '0.00', '2027-12-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-11 07:20:15', '2026-07-11 14:20:15'),
(37, 13, 'wajib', 1, 7, 2026, '50000.00', '2026-07-31', '2026-07-16', 'lunas', '/storage/bukti_iuran/iuran_37_1784184178.jpg', NULL, 'Pembayaran diverifikasi', NULL, '2026-07-15 23:35:56', '2026-07-15 23:47:02'),
(38, 13, 'sukarela', 1, 7, 2026, '0.00', '2026-07-31', '2026-07-16', 'lunas', '/storage/bukti_iuran/iuran_38_1784184201.jpg', NULL, 'Pembayaran diverifikasi', NULL, '2026-07-15 23:35:56', '2026-07-15 23:46:56'),
(39, 13, 'wajib', 1, 8, 2026, '50000.00', '2026-08-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(40, 13, 'sukarela', 1, 8, 2026, '0.00', '2026-08-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(41, 13, 'wajib', 1, 9, 2026, '50000.00', '2026-09-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(42, 13, 'sukarela', 1, 9, 2026, '0.00', '2026-09-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(43, 13, 'wajib', 1, 10, 2026, '50000.00', '2026-10-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(44, 13, 'sukarela', 1, 10, 2026, '0.00', '2026-10-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(45, 13, 'wajib', 1, 11, 2026, '50000.00', '2026-11-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(46, 13, 'sukarela', 1, 11, 2026, '0.00', '2026-11-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(47, 13, 'wajib', 1, 12, 2026, '50000.00', '2026-12-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(48, 13, 'sukarela', 1, 12, 2026, '0.00', '2026-12-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(49, 13, 'wajib', 1, 1, 2027, '50000.00', '2027-01-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(50, 13, 'sukarela', 1, 1, 2027, '0.00', '2027-01-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(51, 13, 'wajib', 1, 2, 2027, '50000.00', '2027-02-28', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(52, 13, 'sukarela', 1, 2, 2027, '0.00', '2027-02-28', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(53, 13, 'wajib', 1, 3, 2027, '50000.00', '2027-03-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(54, 13, 'sukarela', 1, 3, 2027, '0.00', '2027-03-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(55, 13, 'wajib', 1, 4, 2027, '50000.00', '2027-04-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(56, 13, 'sukarela', 1, 4, 2027, '0.00', '2027-04-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(57, 13, 'wajib', 1, 5, 2027, '50000.00', '2027-05-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(58, 13, 'sukarela', 1, 5, 2027, '0.00', '2027-05-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(59, 13, 'wajib', 1, 6, 2027, '50000.00', '2027-06-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(60, 13, 'sukarela', 1, 6, 2027, '0.00', '2027-06-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(61, 13, 'wajib', 1, 7, 2027, '50000.00', '2027-07-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(62, 13, 'sukarela', 1, 7, 2027, '0.00', '2027-07-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(63, 13, 'wajib', 1, 8, 2027, '50000.00', '2027-08-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(64, 13, 'sukarela', 1, 8, 2027, '0.00', '2027-08-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(65, 13, 'wajib', 1, 9, 2027, '50000.00', '2027-09-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(66, 13, 'sukarela', 1, 9, 2027, '0.00', '2027-09-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(67, 13, 'wajib', 1, 10, 2027, '50000.00', '2027-10-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(68, 13, 'sukarela', 1, 10, 2027, '0.00', '2027-10-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(69, 13, 'wajib', 1, 11, 2027, '50000.00', '2027-11-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(70, 13, 'sukarela', 1, 11, 2027, '0.00', '2027-11-30', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(71, 13, 'wajib', 1, 12, 2027, '50000.00', '2027-12-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56'),
(72, 13, 'sukarela', 1, 12, 2027, '0.00', '2027-12-31', NULL, 'belum_bayar', NULL, NULL, NULL, NULL, '2026-07-15 23:35:56', '2026-07-16 06:35:56');

-- --------------------------------------------------------

--
-- Table structure for table `tb_jemaat`
--

CREATE TABLE `tb_jemaat` (
  `id_jemaat` int(11) NOT NULL,
  `no_anggota` varchar(20) NOT NULL,
  `nama_lengkap` varchar(100) NOT NULL,
  `nik` varchar(16) DEFAULT NULL,
  `tempat_lahir` varchar(50) DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `lingkungan` varchar(50) DEFAULT NULL,
  `no_hp` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `foto_profil` text DEFAULT NULL,
  `saldo_simpanan_pokok` decimal(15,2) DEFAULT 0.00,
  `saldo_simpanan_wajib` decimal(15,2) DEFAULT 0.00,
  `saldo_simpanan_sukarela` decimal(15,2) DEFAULT 0.00,
  `is_active` tinyint(1) DEFAULT 1,
  `tgl_bergabung` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_jemaat`
--

INSERT INTO `tb_jemaat` (`id_jemaat`, `no_anggota`, `nama_lengkap`, `nik`, `tempat_lahir`, `tanggal_lahir`, `alamat`, `lingkungan`, `no_hp`, `email`, `password_hash`, `foto_profil`, `saldo_simpanan_pokok`, `saldo_simpanan_wajib`, `saldo_simpanan_sukarela`, `is_active`, `tgl_bergabung`, `created_at`, `updated_at`) VALUES
(1, 'J001', 'Budi Santoso', '3171010101900001', 'Jakarta', '1990-01-01', 'Jl. Merdeka No.1, Jakarta', 'Petrus', '081234567890', 'budi@email.com', '$2y$10$J1ijR9MscYdzODT/oU1euOqqQY9s0JLg3tQMTVQymY3P3pQ4WWe..', NULL, '500000.00', '250000.00', '100000.00', 1, '2024-01-15', '2026-05-22 17:04:34', '2026-07-11 05:38:56'),
(2, 'J002', 'Siti Maryamm', '3171020202900002', 'Bandung', '1992-02-02', 'Jl. Asia Afrika No.2, Bandung', NULL, '081234567891', 'siti@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, '500000.00', '25000.00', '0.00', 1, '2024-02-20', '2026-05-22 17:04:34', '2026-05-22 12:43:53'),
(3, 'J003', 'Ahmad Hidayat', '3171030303900003', 'Surabaya', '1991-03-03', 'Jl. Pemuda No.3, Surabaya', NULL, '081234567892', 'ahmad@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, '500000.00', '0.00', '50000.00', 1, '2024-03-10', '2026-05-22 17:04:34', '2026-05-22 17:04:35'),
(4, 'J004', 'Maria Ulfah', '3171040404900004', 'Medan', '1994-04-04', 'Jl. Sudirman No.4, Medan', NULL, '081234567893', 'maria@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, '500000.00', '250000.00', '75000.00', 1, '2024-04-05', '2026-05-22 17:04:34', '2026-05-22 17:04:34'),
(5, 'J005', 'Joko Widodo', '3171050505900005', 'Semarang', '1995-05-05', 'Jl. Diponegoro No.5, Semarang', NULL, '081234567894', 'joko@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, '500000.00', '250000.00', '0.00', 1, '2024-05-12', '2026-05-22 17:04:34', '2026-05-22 17:04:34'),
(6, 'J006', 'Dewi Sartika', '3171060606900006', 'Makassar', '1996-06-06', 'Jl. Urip Sumoharjo No.6, Makassar', NULL, '081234567895', 'dewi@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, '500000.00', '250000.00', '150000.00', 1, '2024-06-18', '2026-05-22 17:04:34', '2026-05-22 17:04:34'),
(7, 'J007', 'Rizki Fadillah', '3171070707900007', 'Palembang', '1997-07-07', 'Jl. Veteran No.7, Palembang', NULL, '081234567896', 'rizki@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, '500000.00', '250000.00', '200000.00', 1, '2024-07-22', '2026-05-22 17:04:34', '2026-05-22 17:04:34'),
(8, 'J008', 'Nurul Hikmah', '3171080808900008', 'Yogyakarta', '1998-08-08', 'Jl. Malioboro No.8, Yogyakarta', NULL, '081234567897', 'nurul@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, '500000.00', '250000.00', '50000.00', 1, '2024-08-30', '2026-05-22 17:04:34', '2026-05-22 17:04:34'),
(9, 'J009', 'Hendra Gunawan', '3171090909900009', 'Bali', '1999-09-09', 'Jl. Sunset Road No.9, Bali', NULL, '081234567898', 'hendra@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, '500000.00', '250000.00', '125000.00', 1, '2024-09-14', '2026-05-22 17:04:34', '2026-05-22 17:04:34'),
(10, 'J010', 'Ratna Sari', '3171101010000010', 'Manado', '2000-10-10', 'Jl. Boulevard No.10, Manado', '3', '081234567899', 'ratna@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, '500000.00', '250000.00', '0.00', 1, '2024-10-01', '2026-05-22 17:04:34', '2026-05-31 01:15:39'),
(12, '123', 'Lilis', NULL, NULL, NULL, 'diski', 'Petrus', '082161712792', 'lilis@gmail.com', '$2y$10$TWonqvVLYg3w1UUWLM42auTCaQj.NcuSSuokrYqGeIfsOlSBIuD4m', NULL, '0.00', '0.00', '0.00', 1, '2026-07-11', '2026-07-11 06:31:01', '2026-07-12 09:37:04'),
(13, '122', 'Santo', NULL, NULL, NULL, 'Medan', 'Petrus', '082161712792', 'santo@gmail.com', '$2y$10$6uZJ8brFzhjGCQzYRIdVrOYWZhR5HUvpOUk86uTsMDOtgrlOKziva', NULL, '100000.00', '50000.00', '900000.00', 1, '2026-07-16', '2026-07-15 23:31:41', '2026-07-15 23:59:39'),
(15, '6', 'S.P.Lumban Gaol , S.H', NULL, NULL, NULL, NULL, 'St.Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6760000.00', '4180180.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(16, '8', 'Waras. P. Malau', NULL, NULL, NULL, NULL, 'St.Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6720000.00', '6307500.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(17, '13', 'Elbina Sijabat', NULL, NULL, NULL, NULL, 'St.Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6620000.00', '4819770.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(18, '14', 'Febrina Pinem', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6710000.00', '84103.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(19, '15', 'Fachrial Ginting, S.H', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6710000.00', '87361.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(20, '17', 'Merdeka L. Yani Sitepu', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6480000.00', '554471.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(21, '18', 'Kartini Br Purba', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6190000.00', '2366994.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(22, '19', 'Mely Purba', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6460000.00', '4100544.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(23, '22', 'Ricardo Pane', NULL, NULL, NULL, NULL, 'St. Elisabeth', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6310000.00', '1058234.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(24, '24', 'Mahdalena E.Hutasoit', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5860000.00', '1251854.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(25, '30', 'Rosmelaty Br Padang', NULL, NULL, NULL, NULL, 'St. Petrus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6550000.00', '450133.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(26, '32', 'Dara Fungki Kaban', NULL, NULL, NULL, NULL, 'St. Elisabeth', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6160000.00', '643506.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(27, '37', 'Risman Purba', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6310000.00', '1286151.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(28, '41', 'Edison Sinaga', NULL, NULL, NULL, NULL, 'St. Yohanes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6830000.00', '2505517.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(29, '45', 'Purnama Br Sihombing', NULL, NULL, NULL, NULL, 'St. Yohanes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6300000.00', '3666163.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(30, '46', 'Drs Alexander Samosir', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6850000.00', '1207636.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(31, '49', 'Ir. Tariagam Sitorus', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5130000.00', '1012653.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(32, '54', 'Clara Sihombing', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6810000.00', '4223657.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(33, '55', 'Mangandar Sihombing', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6810000.00', '2181602.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(34, '56', 'Dahlan Marbun', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '7030000.00', '1819784.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(35, '60', 'Jonni D. Saragih', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6670000.00', '1701767.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(36, '63', 'Victor Hutagalung, S.E', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6550000.00', '2765221.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(37, '67', 'Marsiani Sembiring', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6770000.00', '14422717.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(38, '79', 'Tenafase Gee', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5820000.00', '5014526.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(39, '81', 'Ngampeken Ginting', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6300000.00', '3016478.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(40, '94', 'Ratna Sigiro, S.Pd', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6670000.00', '12253213.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(41, '99', 'Merpin Sianturi, S.T', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6060000.00', '1453230.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(42, '100', 'Dorlina Gurning', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6230000.00', '2019721.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(43, '102', 'Martaulina Hutagalung', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3340000.00', '3058734.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(44, '103', 'Surhani Br Sinaga', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6080000.00', '2488498.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(45, '109', 'Meslina Sitepu', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6440000.00', '89895.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(46, '110', 'Marim Br Barus', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5760000.00', '4096608.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(47, '112', 'Charles Banjarnahor', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6570000.00', '27323211.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(48, '114', 'Audensius Simbolon', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6520000.00', '746116.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(49, '127', 'Mangihut Sinambela', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5690000.00', '2381532.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(50, '132', 'Hotma Romasi Sitinjak', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6520000.00', '4046722.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(51, '133', 'Delila Ririsma Pospos', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6490000.00', '128411.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(52, '136', 'Perlindungan L.Batu', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6190000.00', '5686363.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(53, '138', 'Melda Kartika', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6510000.00', '2184582.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(54, '144', 'Asnawati Br Tarigan', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5550000.00', '74391.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(55, '146', 'Tarbunga Simanjorang', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5870000.00', '57814.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(56, '147', 'Mian Marta Simamora', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6630000.00', '11624077.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(57, '148', 'Eli Akim Panjaitan', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5890000.00', '1709024.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(58, '150', 'Jhon Piter Sinaga', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6120000.00', '401004.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(59, '151', 'Mardiambok Siboro', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4530000.00', '274149.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(60, '152', 'Aritme Br Manullang', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5740000.00', '907234.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(61, '153', 'Walburga Netti', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5550000.00', '1581953.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(62, '155', 'Elista Silalahi', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4620000.00', '1210424.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(63, '157', 'Sariati Sinaga', NULL, NULL, NULL, NULL, 'St. Petrus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6350000.00', '556402.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(64, '170', 'Linsa Br Silitonga', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5870000.00', '1083397.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(65, '174', 'Janter Simare-mare', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5960000.00', '2792746.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(66, '175', 'Japar Tumanggor', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6170000.00', '503187.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(67, '179', 'Dumas Siburian', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5240000.00', '1765723.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(68, '180', 'Nina Maryati', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3510000.00', '333812.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(69, '182', 'F.M.Roselly Sinaga', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5720000.00', '3642903.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(70, '185', 'Jhon Aprianta Pandia', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6170000.00', '218578.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(71, '188', 'Leowarton Hutauruk', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5930000.00', '631220.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(72, '189', 'Ridwan R. Sagala', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5930000.00', '3281289.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(73, '191', 'Sabardi Sianipar', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5780000.00', '2835576.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(74, '193', 'Rohanna M. Damanik', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5820000.00', '496354.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(75, '194', 'Jaurat Situmorang', NULL, NULL, NULL, NULL, 'St. lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5590000.00', '2919654.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(76, '196', 'Gosta Sianipar', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6110000.00', '1626060.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(77, '198', 'Poltak Manullang', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6220000.00', '115119.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(78, '199', 'Christoforus A.M. Samosir', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6230000.00', '15282122.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(79, '213', 'Fery Samson Purba', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5260000.00', '3017813.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(80, '216', 'Menni Br Sitanggang', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5380000.00', '1277809.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(81, '224', 'Paska Ria Manullang', NULL, NULL, NULL, NULL, 'St. Yohanes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5820000.00', '2417143.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(82, '227', 'Siswati Sembiring', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '6930000.00', '5045179.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(83, '230', 'Pinondang Saragih', NULL, NULL, NULL, NULL, 'St. Agnes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5720000.00', '90372.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(84, '231', 'Sirun Limbong', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4820000.00', '738995.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(85, '233', 'Masa Ginting', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5480000.00', '6137588.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(86, '234', 'Pasti Tarigan', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5780000.00', '7516570.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(87, '235', 'Ramsida Manik', NULL, NULL, NULL, NULL, 'St. Yohanes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '7470000.00', '1016773.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(88, '242', 'Bukti Ginting', NULL, NULL, NULL, NULL, 'St. Paulus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3590000.00', '146506.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(89, '244', 'Amerius Hasugian', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5740000.00', '12503550.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(90, '249', 'Rosmia Br Sinambela', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5630000.00', '41745.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(91, '253', 'Leni Marlina Sigiro', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5670000.00', '4055104.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(92, '254', 'Fidelis Tambunan', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5550000.00', '299872.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(93, '259', 'Emiliani Hutagalung', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4240000.00', '4080204.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(94, '261', 'Asima Br Sihotang', NULL, NULL, NULL, NULL, 'St. Agnes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4560000.00', '3580648.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(95, '262', 'Jabatan Manullang', NULL, NULL, NULL, NULL, 'St. Yohanes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4690000.00', '2939744.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(96, '263', 'Jander Jonas Tarihoran', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5610000.00', '5218743.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(97, '264', 'Ambrosius Hotman', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4560000.00', '24522063.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(98, '269', 'Jisca Laura Ginting, S.H', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5350000.00', '169029.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(99, '270', 'Santa Monica Ginting', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5290000.00', '239306.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(100, '271', 'Agre Moses Ginting', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5260000.00', '377398.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(101, '273', 'Selamat Purba', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3760000.00', '362420.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(102, '274', 'Simon Marpaung', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5390000.00', '1976366.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(103, '275', 'Delima Sinambela', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4850000.00', '1818982.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(104, '276', 'Sharon Yudha Ginting', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5270000.00', '85154.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(105, '277', 'Halomoan Sinaga', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5100000.00', '285675.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(106, '282', 'Mariati Silaen', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5400000.00', '5630744.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(107, '284', 'Raskita Sembiring', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5340000.00', '7328362.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(108, '285', 'Armaida Sembiring', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4480000.00', '51774.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(109, '286', 'Robert K. Padang', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4510000.00', '5993.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(110, '287', 'Zulfitter Perangin-angin', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4950000.00', '41837.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(111, '288', 'Rosanna Surbakti', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4830000.00', '40679.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(112, '291', 'Ramsidin Sitohang', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5140000.00', '4810878.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(113, '295', 'Bonar Edison Gurning', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5270000.00', '842689.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(114, '297', 'Rohana Sitindoan', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4790000.00', '1644088.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(115, '301', 'Hotler Sijabat', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4760000.00', '1102602.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(116, '302', 'Mularia Sihotang', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5090000.00', '1739635.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(117, '303', 'Oscar Raja Sijabat', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4640000.00', '823162.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(118, '304', 'Vincencius Sijabat', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4610000.00', '752703.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(119, '305', 'Sarah Olivia Sijabat', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4670000.00', '938812.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(120, '306', 'Onesimus D. Sijabat', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4670000.00', '1225314.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(121, '310', 'Peber Julius Simbolon', NULL, NULL, NULL, NULL, 'St. Yohanes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5270000.00', '783842.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(122, '316', 'Rosdiana Situmorang', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5120000.00', '1716057.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(123, '318', 'Rosinta Br Marbun', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5090000.00', '379315.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(124, '320', 'Porman L. Hutagalung', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4090000.00', '1787409.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(125, '321', 'Numbur Br Bangun', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5090000.00', '25430773.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(126, '322', 'Desnaria Pandia', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '5120000.00', '36042723.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(127, '323', 'James Jhon Pandia', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4940000.00', '298960.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(128, '324', 'Merlina sinabariba', NULL, NULL, NULL, NULL, 'St. Agustinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4635000.00', '6861586.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(129, '331', 'Christian M. Sigalingging', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4930000.00', '43453530.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(130, '332', 'Caecilia E. Samosir', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4940000.00', '11431124.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(131, '335', 'Albertus Ginting', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4610000.00', '4233341.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(132, '339', 'Firman Marbun', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4400000.00', '527143.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(133, '340', 'Waldemar Marbun', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4460000.00', '1099808.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(134, '341', 'Lucia Marbun', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4460000.00', '896247.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(135, '342', 'Ucok Vier Sihotang', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3440000.00', '1285853.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(136, '343', 'Putri Julianti Purba', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4430000.00', '4998582.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(137, '344', 'Adrianus Rico purba', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4430000.00', '1770325.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(138, '345', 'Yoana D.Purba', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4430000.00', '6277643.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(139, '346', 'Marito Rajagukguk', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4550000.00', '3980005.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(140, '348', 'Mareni Sibuea', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4550000.00', '1816609.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(141, '350', 'Fransiska Hutahayan', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4550000.00', '1736146.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(142, '353', 'Yosef Rafaela Sinaga', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4580000.00', '2601311.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(143, '354', 'Sesilia Monica', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4580000.00', '189556.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(144, '355', 'Yosef Dwi Santosa', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4610000.00', '8871657.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(145, '357', 'Apriani J. Manalu', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4430000.00', '516581.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(146, '358', 'Adrian Ivanovsky', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4610000.00', '7250599.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(147, '359', 'Aurelia RA Samosir', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4610000.00', '18039469.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(148, '361', 'Wanti Agustina', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4550000.00', '2980400.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(149, '363', 'Rahmat Sujianto', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4520000.00', '487113.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(150, '365', 'Remina Mandalahi', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4520000.00', '17131313.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(151, '366', 'Martha Br Tamba', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4370000.00', '3143536.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(152, '368', 'Jerrico Pandia', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4250000.00', '202661.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(153, '369', 'Widyah Frichechi', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3860000.00', '1128770.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(154, '370', 'Herlina Simorangkir', NULL, NULL, NULL, NULL, 'St. Elisabeth', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4090000.00', '1002559.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(155, '373', 'Theresia Chistika', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4310000.00', '6455325.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(156, '376', 'Chrisvina Simanjorang', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4310000.00', '26981872.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(157, '379', 'Rias Pelawi', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4310000.00', '3740117.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(158, '381', 'Oscar Tarigan', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4220000.00', '371488.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(159, '382', 'Maria Valentina Banjarnahor', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3200000.00', '764970.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(160, '383', 'Francius Fernando Banjarnahor', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3200000.00', '612885.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(161, '384', 'Alfredo', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4280000.00', '342962.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(162, '385', 'Julio Osvaldo', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3200000.00', '590579.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(163, '387', 'Retni Tampubolon', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4010000.00', '9044601.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(164, '388', 'Margareth Lumban Gaol', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4280000.00', '4046114.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(165, '389', 'Lestria Lumban Gaol', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4280000.00', '4046114.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(166, '390', 'Stevanus Kevin Tambunan', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4250000.00', '125002.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(167, '393', 'Dorisna Limbong', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4160000.00', '6593412.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(168, '394', 'Miskridani Sinaga', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4340000.00', '5024409.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(169, '395', 'Agustina', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4220000.00', '2984413.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(170, '397', 'Lia Rosari Sagala', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4220000.00', '692047.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(171, '398', 'Erico Cahaya Sagala', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4220000.00', '643303.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(172, '400', 'Brigita Sinaga', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3980000.00', '1150870.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(173, '401', 'Fritz Ratewa Depari', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3830000.00', '70947.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(174, '402', 'Erick Wiwanta Depari', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3830000.00', '72435.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(175, '403', 'Anasttasia Depari', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3500000.00', '1365320.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(176, '404', 'Alexius Sagala', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '4010000.00', '519606.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(177, '407', 'Tengtengena Ginting', NULL, NULL, NULL, NULL, 'St. Petrus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3890000.00', '7330899.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(178, '409', 'Fransiskus Situmorang', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3860000.00', '133848.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(179, '410', 'Amos Rumora Situmorang', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3560000.00', '1160575.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(180, '411', 'Felix Jansen Damanik', NULL, NULL, NULL, NULL, 'St. Petrus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3980000.00', '1224616.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(181, '412', 'Endy Hakim Damanik', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3920000.00', '543292.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(182, '413', 'Fransiskus Hengki', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3920000.00', '1392139.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(183, '414', 'Laurensius Alvin Tanaka', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3770000.00', '1683604.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(184, '415', 'Clara Chelche Arios', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3320000.00', '2479630.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(185, '416', 'Samuel Lamsihar Arios', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3320000.00', '2609948.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(186, '417', 'Joy Natalia Arios', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3320000.00', '2517476.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(187, '419', 'Rehmalemna Br Sebayang', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3770000.00', '1560112.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(188, '420', 'Love Weniska Ge\'e', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3770000.00', '2656759.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(189, '421', 'Febrian Suranta Ge\'e', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3770000.00', '3073927.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(190, '422', 'Pius Tri Putra Ge\'e', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3770001.00', '2968176.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(191, '423', 'Sampurno Damanik', NULL, NULL, NULL, NULL, 'St. Petrus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3890000.00', '497594.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(192, '425', 'Demanta Br Sinaga', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3800000.00', '50134.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(193, '426', 'Rini Irmawati Situmeang', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3920000.00', '2382125.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(194, '427', 'Regina Marpaung', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3920000.00', '2926818.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(195, '428', 'Jenni Br Siahaan', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3200000.00', '4262865.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(196, '429', 'Risda Br Sihotang', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2990000.00', '3230290.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44');
INSERT INTO `tb_jemaat` (`id_jemaat`, `no_anggota`, `nama_lengkap`, `nik`, `tempat_lahir`, `tanggal_lahir`, `alamat`, `lingkungan`, `no_hp`, `email`, `password_hash`, `foto_profil`, `saldo_simpanan_pokok`, `saldo_simpanan_wajib`, `saldo_simpanan_sukarela`, `is_active`, `tgl_bergabung`, `created_at`, `updated_at`) VALUES
(197, '430', 'Pattar Hobby Simbolon', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3890000.00', '5447229.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(198, '433', 'Anastasia Br Ginting', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3830000.00', '5252625.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(199, '436', 'Irma Fitriani Br Marbun', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3800000.00', '1446328.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(200, '437', 'Kanisius Sihotang', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3890000.00', '23550341.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(201, '438', 'Alexander Sihotang', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3890000.00', '23550341.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(202, '439', 'Donly Dona Nainggolan', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3860000.00', '2741259.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(203, '440', 'Sesilia Eryani Sitanggang', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3890000.00', '10811520.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(204, '443', 'Putri Magdanlena Sianturi', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3890000.00', '709837.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(205, '444', 'Gabriel Reza Sebayang', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3980000.00', '8570979.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(206, '445', 'Yosua Nodi Sebayang', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3980000.00', '7220041.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(207, '446', 'Vincensius Ronan Pelawi', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3980000.00', '1592156.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(208, '448', 'Lamro Sihotang', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3890000.00', '25566415.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(209, '449', 'Siti Maria Hutagalung', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3890000.00', '25539883.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(210, '451', 'Siti Manir Zendrato', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3830000.00', '596907.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(211, '452', 'Herlina Br Sidabuttar', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3860000.00', '1148428.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(212, '455', 'Sondang Gultom', NULL, NULL, NULL, NULL, 'St. Agustinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3830000.00', '118644.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(213, '457', 'Tiamsa Situmorang', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3860000.00', '3563594.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(214, '458', 'Agnes Eva Br Barus', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3410000.00', '949932.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(215, '459', 'Joseph Jairo Sagala', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3710000.00', '596515.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(216, '460', 'Fiza Rosanti Nainggolan', NULL, NULL, NULL, NULL, 'St. Elisabeth', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3440000.00', '1103785.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(217, '461', 'Laura Ciciloia Depari', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3440000.00', '62649.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(218, '462', 'Dewi Darmawaty', NULL, NULL, NULL, NULL, 'St. Elisabeth', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3230000.00', '170777.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(219, '464', 'Ihut Mala Rumahorbo', NULL, NULL, NULL, NULL, 'St. Yohanes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3650000.00', '375009.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(220, '465', 'Bonur Lumban Siantar', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3650000.00', '2988520.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(221, '466', 'Krisna Novita Siregar', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3560000.00', '153107.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(222, '468', 'Doinisius Hutagalung', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3530000.00', '1641392.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(223, '469', 'Damaris Br Hutagalung', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3530000.00', '1641392.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(224, '470', 'Lempinar Pangaribuan', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3620000.00', '1426230.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(225, '471', 'Riska Emeninta Tarigan', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3470000.00', '222565.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(226, '472', 'Martinus Rumahorbo', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3440000.00', '2651621.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(227, '473', 'Kristina Pasaribu', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3530000.00', '370126.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(228, '474', 'Josafat Perangin-angin', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3500000.00', '3437132.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(229, '475', 'Donny Lumban Gaol', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3350000.00', '281479.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(230, '476', 'Jekson Lumban Gaol', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3620000.00', '70433.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(231, '478', 'Ade Kurnia Hutagalung', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3590000.00', '91648.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(232, '479', 'Albertus Siregar', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3530000.00', '435920.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(233, '480', 'Lisna Afriana Siburian', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3590000.00', '538209.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(234, '481', 'Rubin Br Sihotang', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3620000.00', '7416238.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(235, '482', 'Valentinus Simarmata', NULL, NULL, NULL, NULL, 'St. Petrus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3170000.00', '267648.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(236, '484', 'Nellina Br Purba', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3380000.00', '427420.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(237, '485', 'Lamsery Br Sinaga', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3290000.00', '154521.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(238, '486', 'Nesha Br Sembiring', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3590000.00', '170670.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(239, '487', 'Suhut Sinaga', NULL, NULL, NULL, NULL, 'St. Agustinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3770000.00', '925245.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(240, '488', 'Ron Chalasta', NULL, NULL, NULL, NULL, 'St. Paulus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3470000.00', '45952.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(241, '489', 'Drs. Jonter Rajagukguk', NULL, NULL, NULL, NULL, 'St. Paulus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3530000.00', '1015955.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(242, '491', 'Steven Richart', NULL, NULL, NULL, NULL, 'St. Paulus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3500000.00', '68515.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(243, '492', 'Hendra Hutabarat', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3500000.00', '59132906.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(244, '493', 'Yoliana Perangin-angin', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3470000.00', '42145.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(245, '495', 'Bernadetta Silaban', NULL, NULL, NULL, NULL, 'St. Elisabeth', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3200000.00', '1629568.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(246, '496', 'Mesdawati Br Purba', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3380000.00', '50107.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(247, '497', 'Ober Silalahi', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3380000.00', '675509.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(248, '498', 'Alvaro Gintinng', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3230000.00', '5404785.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(249, '499', 'Karolina Br Barus', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3380000.00', '8204412.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(250, '500', 'Pengarapen Ginting', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3410000.00', '6338429.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(251, '501', 'Asteria', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3230000.00', '1535838.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(252, '503', 'Hendra Sinaga', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3530000.00', '1642499.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(253, '504', 'Valentino Sihotang', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3530000.00', '23949857.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(254, '505', 'Adi Ignasius Sihotang', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3530000.00', '23988116.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(255, '506', 'Angelina Rini Sinaga', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3500000.00', '1002542.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(256, '507', 'Derita Luksiana Simbolon', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3440000.00', '2857088.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(257, '508', 'Rosdiana Sinaga', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3440000.00', '687570.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(258, '509', 'Nina Alvina Br Padang', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3500000.00', '4007.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(259, '510', 'Nico Alfrezi Padang', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3470000.00', '9432.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(260, '511', 'Rois Alfredo Padang', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3470000.00', '5467.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(261, '514', 'Gabriel Tarigan', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3500000.00', '3597310.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(262, '515', 'Gaudensius Tarigan', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3500000.00', '4005408.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(263, '516', 'Gratia Tarigan', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3500000.00', '2764036.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(264, '517', 'Merci Santrina Nadaek', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3260000.00', '5193745.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(265, '518', 'Roslinda Simalango', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3260000.00', '2664648.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(266, '520', 'Nikmat Pelawi', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3620000.00', '4928662.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(267, '521', 'Emia', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3920000.00', '8539856.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(268, '522', 'Viyanti Sari Itah Nila', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3920000.00', '92877368.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(269, '523', 'Laurensia Hutauruk', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3140000.00', '98272.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(270, '524', 'Lorika Sinaga', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3260000.00', '2815441.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(271, '525', 'Margaretha Manullang', NULL, NULL, NULL, NULL, 'St. Yohanes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2720000.00', '1739870.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(272, '526', 'Risma Sijabat', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3140000.00', '3113089.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(273, '527', 'Justan Bnjarnahor', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3260000.00', '8657717.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(274, '529', 'Sherli Evalina Manalu', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3200000.00', '100439.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(275, '530', 'Rido Damanik', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3260000.00', '147103.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(276, '531', 'Dea Juli Artha Sinaga', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3260000.00', '1731295.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(277, '532', 'Dolin Tria Bio Sinaga', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3260000.00', '2490102.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(278, '533', 'Evalina Rustani Sianipar', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3230000.00', '3380630.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(279, '534', 'Melita Maxima Br Simbolon', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2450000.00', '23616575.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(280, '536', 'Yohana Caecilia', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3260000.00', '1132438.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(281, '537', 'Relli Nabungkek', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3260000.00', '3378004.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(282, '538', 'Boni Christi Ginting', NULL, NULL, NULL, NULL, 'St. Paulus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '970000.00', '42015.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(283, '539', 'Rimson Tambunan', NULL, NULL, NULL, NULL, 'St. Yohanes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3260000.00', '327262.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(284, '540', 'Rita Oktapina Sihaloho', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3260000.00', '1422219.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(285, '541', 'Mastika Br Marpaung', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3260000.00', '4263057.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(286, '542', 'Debora Nainggolan', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3260000.00', '1495237.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(287, '543', 'Heru Simarmata', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3230000.00', '8059087.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(288, '544', 'Feronika Barus', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3140000.00', '3705057.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(289, '546', 'Hotdiana Br Sitohang', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3230000.00', '8203586.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(290, '547', 'Tria Kristianta Barus', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2600000.00', '468721.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(291, '548', 'Donna Anjelina Sitanggang', NULL, NULL, NULL, NULL, 'St. Elisabeth', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3230000.00', '1289528.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(292, '549', 'Henri Pakpahan', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3110000.00', '355396.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(293, '550', 'Falleri Br Ginting', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3080000.00', '278091.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(294, '551', 'Martalena Br Sembiring', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3020000.00', '1197301.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(295, '553', 'Prissy Gurning', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3230000.00', '745236.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(296, '554', 'Melson Ignatius Rumahorbo', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3020000.00', '4954095.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(297, '558', 'Citra Caecilia Br Situmorang', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2445000.00', '458408.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(298, '559', 'Kartiman Purba', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3080000.00', '773263.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(299, '560', 'Firman syahPutra', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3020000.00', '135933.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(300, '561', 'Alvaro Pandiangan', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2210000.00', '1435641.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(301, '563', 'Serafin Simbolon', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3140000.00', '694723.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(302, '564', 'Caludia Clarisya Simbolon', NULL, NULL, NULL, NULL, 'St. rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3140000.00', '911534.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(303, '565', 'Maria Selly Octavyanty', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2900000.00', '1695794.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(304, '566', 'Semangat Barus', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3020000.00', '4551499.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(305, '567', 'Hardyanto Sinaga', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2730000.00', '797665.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(306, '571', 'Artayanti Simalango', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2900000.00', '1218795.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(307, '572', 'Friska Sagala', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3140000.00', '4219903.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(308, '573', 'Bambang Ginting', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3170000.00', '17252.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(309, '576', 'Bellania Br Ginting', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3110000.00', '6623.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(310, '577', 'Hanna Winda Marbun', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3140000.00', '1492969.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(311, '578', 'Briggita Hosianna Marbun', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3140000.00', '1152324.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(312, '579', 'Beatrix Br Ginting', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '3140000.00', '50381.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(313, '580', 'Perananta Sembiring', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2390000.00', '3510062.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(314, '581', 'Rufina Stella Br Pinem', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2390000.00', '5216995.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(315, '582', 'Mikhael Maher Marbun', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2930000.00', '7579068.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(316, '583', 'Parlin Panjaitan', NULL, NULL, NULL, NULL, 'St. Paulus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2900000.00', '380515.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(317, '584', 'Victor Sitohang', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2750000.00', '1802162.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(318, '585', 'Florensia Sitohang', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2750000.00', '19648242.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(319, '586', 'Parayoga Limbong', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2780000.00', '609533.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(320, '587', 'Irfandi Limbong', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2780000.00', '4776333.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(321, '588', 'Maria Limbong', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2780000.00', '557490.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(322, '589', 'Tiodoris Simare-mare', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2930000.00', '894371.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(323, '590', 'Bontor Torang Silalahi', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2900000.00', '5621.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(324, '591', 'Reja Maruli Tua Sitorus', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2870000.00', '2724777.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(325, '592', 'Teti Amelia Sitorus', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2840000.00', '2291179.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(326, '593', 'Ananta Stea Sembiring', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2360000.00', '3434275.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(327, '594', 'Rospita Br Manullang', NULL, NULL, NULL, NULL, 'St. Yohanes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2900000.00', '2087366.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(328, '595', 'Jakop Sebastian Tanaka', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2900000.00', '1489303.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(329, '596', 'Maria Melani Apni', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2870000.00', '1812052.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(330, '597', 'Risma Simatupang', NULL, NULL, NULL, NULL, 'St. Elisabeth', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2600000.00', '1368412.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(331, '598', 'Ridwan Nainggolan', NULL, NULL, NULL, NULL, 'St. Elisabeth', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2900000.00', '1247478.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(332, '599', 'Farel Sembiring', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2870000.00', '231581.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(333, '600', 'Nusantara Sembiring', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2870000.00', '235611.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(334, '601', 'Pratiwi Hutahaean', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2840000.00', '39538774.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(335, '602', 'Stefanus Situmorang', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2780000.00', '41569312.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(336, '603', 'Sartana Hutagalung', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2880000.00', '3139058.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(337, '604', 'Mawar Indah Sinurat', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2390000.00', '2270469.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(338, '605', 'Junior Gurning', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2900000.00', '4124540.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(339, '606', 'Maria Agrevina Sitorus', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2240000.00', '817704.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(340, '607', 'Nova Valentina Siregar', NULL, NULL, NULL, NULL, 'St. Agustinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2600000.00', '478838.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(341, '608', 'Hendry Gurusinga', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2900000.00', '1817141.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(342, '609', 'Sautmauli Manurung', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2870000.00', '5467191.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(343, '610', 'Maria Sitompul', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2870000.00', '10467181.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(344, '611', 'Fransiska Nainggolan', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2870000.00', '1903313.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(345, '612', 'Dame Br Hutagaol', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2900000.00', '4145605.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(346, '613', 'Raymond Hutagalung', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2420000.00', '800146.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(347, '614', 'Hackta Situmorang', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2570000.00', '142592.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(348, '615', 'Santi Br Hutagalung', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1490000.00', '881892.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(349, '616', 'Herry Hutagalung', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1520000.00', '887346.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(350, '621', 'Dennis Louis', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2870000.00', '285659.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(351, '622', 'Deisa Yohana Tambunan', NULL, NULL, NULL, NULL, 'St. Yohanes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2900000.00', '563701.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(352, '623', 'Edwin Syahrial Simboln', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2960000.00', '613075.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(353, '624', 'Pardingotan Situmorang', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2870000.00', '1111754.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(354, '625', 'Franki Nainggolan', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2840000.00', '3786904.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(355, '627', 'Rudi LumbanGaol', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2840000.00', '13038013.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(356, '628', 'Rekson Ginting', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2840000.00', '1262376.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(357, '630', 'Anna Pardosi', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2780000.00', '27391701.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(358, '631', 'Samuel Samosir', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2780000.00', '10666644.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(359, '632', 'Jan Reinhart', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2810000.00', '15216.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(360, '633', 'Deo Gratia Manalu', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2810000.00', '1336943.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(361, '635', 'Bertina Siboro', NULL, NULL, NULL, NULL, 'St. Agnes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2810000.00', '8636586.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(362, '636', 'Erlinda Manalu', NULL, NULL, NULL, NULL, 'St. Agnes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2660000.00', '3504230.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(363, '639', 'Ramel Simalango', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2540000.00', '913169.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(364, '640', 'Ivan Simbolon', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2750000.00', '876766.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(365, '641', 'Katarina Simbolon', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1850000.00', '1736069.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(366, '642', 'Benediktus Lumbangaol', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2750000.00', '870569.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(367, '644', 'Mitra Lumbangaol', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2720000.00', '10998543.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(368, '645', 'Suryati Sipayung', NULL, NULL, NULL, NULL, 'St. Yohanes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2360000.00', '1000295.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(369, '650', 'Carolus Pelawi', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2780000.00', '6180067.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(370, '651', 'Rahman Sagala', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2810000.00', '2512573.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(371, '652', 'Leonard Marpaung', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2780000.00', '1275768.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(372, '653', 'Erwin Sagala', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2780000.00', '4765415.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(373, '654', 'Rembangi Surbakti', NULL, NULL, NULL, NULL, 'St. Petrus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2180000.00', '1605196.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(374, '655', 'Eva Sadella Sembiring', NULL, NULL, NULL, NULL, 'St. Petrus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2180000.00', '1790827.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(375, '656', 'Resa Samantha Surbakti', NULL, NULL, NULL, NULL, 'St. Petrus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2180000.00', '1605196.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(376, '657', 'Rethana Surbakti', NULL, NULL, NULL, NULL, 'St. Petrus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2180000.00', '1605196.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(377, '658', 'Redemptus Surbakti', NULL, NULL, NULL, NULL, 'St. Petrus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2180000.00', '1497757.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(378, '659', 'Matias Bondar', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2480000.00', '94441.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(379, '660', 'Manujur Mateus Gurning', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2210000.00', '2951256.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(380, '661', 'Debi Norvita Silalahi', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2210000.00', '3061330.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(381, '662', 'Artha De Matthew Gurning', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2210000.00', '3088612.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(382, '663', 'Frans Laurensius Sitinjak', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2540000.00', '125612.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(383, '664', 'Fransiska Juliana Sitinjak', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2540000.00', '166870.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(384, '666', 'Restu Usaha Banjarnahor', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2570000.00', '1218809.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(385, '667', 'Noviyanti Br Rumahorbo', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2390000.00', '5464938.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(386, '668', 'Hindol Tamba', NULL, NULL, NULL, NULL, 'St. Petrus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2510000.00', '1511580.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(387, '669', 'Daniel Hutahean', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2450000.00', '5526965.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(388, '670', 'Robinhot Lumban Gaol', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2540000.00', '6125855.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(389, '672', 'Anwar Jenri Hasoloan Saing', NULL, NULL, NULL, NULL, 'St. Agnes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2540000.00', '4514148.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(390, '673', 'Boy Sitorus', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1790000.00', '1749671.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(391, '674', 'Agus Iwan Sihaloho', NULL, NULL, NULL, NULL, 'St. Agustinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2390000.00', '39361.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(392, '675', 'Uduran Br Sibagariang', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2420000.00', '15235251.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44');
INSERT INTO `tb_jemaat` (`id_jemaat`, `no_anggota`, `nama_lengkap`, `nik`, `tempat_lahir`, `tanggal_lahir`, `alamat`, `lingkungan`, `no_hp`, `email`, `password_hash`, `foto_profil`, `saldo_simpanan_pokok`, `saldo_simpanan_wajib`, `saldo_simpanan_sukarela`, `is_active`, `tgl_bergabung`, `created_at`, `updated_at`) VALUES
(393, '676', 'Jasni Sebayang', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2570000.00', '32832252.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(394, '677', 'Rika Rehulina Sitepu', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2480000.00', '532419.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(395, '678', 'Banjir Sahat Tua Parhusip', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2540000.00', '1454335.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(396, '679', 'Bertauli Reulina Simbolon', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2540000.00', '28411818.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(397, '680', 'Efelin Theresia Br Siregar', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2540000.00', '95676.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(398, '681', 'Ahem Gurusinga', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2540000.00', '1358936.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(399, '682', 'Danial Sembiring', NULL, NULL, NULL, NULL, 'St. Paulus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2420000.00', '1119114.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(400, '683', 'Jhordi Adrian Simbolon', NULL, NULL, NULL, NULL, 'St. Yohanes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2180000.00', '867875.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(401, '686', 'Las Nur Br Purba', NULL, NULL, NULL, NULL, 'St. Yohanes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2510000.00', '524170.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(402, '687', 'Benni Pasaribu', NULL, NULL, NULL, NULL, 'St. Yohanes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2510000.00', '114405.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(403, '688', 'Ermawati Br Girsang', NULL, NULL, NULL, NULL, 'St. Yohanes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2510000.00', '9606776.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(404, '689', 'Teresia Adelia Br Simbolon', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1550000.00', '1121368.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(405, '690', 'Mariati Sinaga', NULL, NULL, NULL, NULL, 'St. Yohanes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2510000.00', '3668643.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(406, '691', 'Doris Lumban Gaol', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2510000.00', '7857922.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(407, '692', 'Trisna Romauli Lumban Gaol', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2510000.00', '1995245.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(408, '693', 'Cayden Orvieto Simbolon', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2510000.00', '641316.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(409, '694', 'Betty Marlia Sihite', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2270000.00', '378695.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(410, '696', 'Ranto Samosir', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2420000.00', '760000.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(411, '697', 'Yodhi Sitorus', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1760000.00', '1202352.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(412, '698', 'Rosminem Pasaribu', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2300000.00', '26479.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(413, '700', 'Masli Naibaho', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2420000.00', '2993621.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(414, '702', 'Alexander Banjarnahor', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2480000.00', '27560956.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(415, '703', 'Darsono Gultom', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2450000.00', '886083.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(416, '704', 'Anastasia Sembiring', NULL, NULL, NULL, NULL, 'St. Elisabeth', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2300000.00', '81584.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(417, '705', 'Rifka Chardiana', NULL, NULL, NULL, NULL, 'St. Elisabeth', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2450000.00', '2494154.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(418, '706', 'Nurtika Br Ginting', NULL, NULL, NULL, NULL, 'St. Paulus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1190000.00', '159815.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(419, '707', 'Sherli Tambunan', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2450000.00', '571557.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(420, '708', 'Ari Lasso Simanullang', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2060000.00', '8076.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(421, '709', 'Krisna Gurning', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2450000.00', '748643.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(422, '710', 'Sanaria Sihombing', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2450000.00', '1030520.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(423, '711', 'Benny Ginting', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2420000.00', '216666.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(424, '712', 'Rawati Lumaria Sinaga', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2360000.00', '1820109.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(425, '713', 'Apriani Br Tarigan', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2270000.00', '89484.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(426, '714', 'Edi Putra Ginting', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1880000.00', '1233495.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(427, '715', 'Budi Utama Situmorang', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2150000.00', '2263555.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(428, '716', 'Calista Nathania Situmorang', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2150000.00', '2273066.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(429, '717', 'Beryl Aushalom Situmorang', NULL, NULL, NULL, NULL, 'St. Martinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2150000.00', '2218029.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(430, '718', 'Iganatius Marbun', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2210000.00', '1300349.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(431, '719', 'Samuel Simbolon', NULL, NULL, NULL, NULL, 'St. Yohanes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2000000.00', '3322946.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(432, '720', 'Siti Mariani Br Manalu', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2150000.00', '76982.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(433, '721', 'Santa Clara Putri', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2150000.00', '29904.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(434, '722', 'Tami Surbakti', NULL, NULL, NULL, NULL, 'St. Paulus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '790000.00', '55631.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(435, '723', 'Antonius Sitanggang', NULL, NULL, NULL, NULL, 'St. Agnes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2180000.00', '178616.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(436, '724', 'Antonia Sitanggang', NULL, NULL, NULL, NULL, 'St. Agnes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2180000.00', '436229.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(437, '725', 'Elvina Ekaristi Surbakti', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2060000.00', '518599.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(438, '726', 'Merpin Sinaga', NULL, NULL, NULL, NULL, 'St. Agustinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2030000.00', '3531367.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(439, '727', 'Alfarez Panjaitan', NULL, NULL, NULL, NULL, 'St. Paulus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2150000.00', '210179.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(440, '728', 'Ana Surianta Surbakti', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2150000.00', '394663.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(441, '729', 'Brian Aichal Tarigan', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2090000.00', '53206.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(442, '730', 'Fransiskus Sitanggang', NULL, NULL, NULL, NULL, 'St. Agnes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2180000.00', '417631.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(443, '731', 'Sri Rahayu Pinem', NULL, NULL, NULL, NULL, 'St. Petrus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2120000.00', '645918.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(444, '732', 'Sri Murni Pinem', NULL, NULL, NULL, NULL, 'St. Petrus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2000000.00', '130715.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(445, '733', 'Petrus Simanullang', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2180000.00', '1631996.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(446, '734', 'Fernando Simanullang', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2180000.00', '1115747.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(447, '735', 'Julia Monica Silaban', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2030000.00', '3653361.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(448, '736', 'Katarina Revalina Kaban', NULL, NULL, NULL, NULL, 'St. Elisabeth', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1880000.00', '1471962.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(449, '737', 'Nikolas Rikki Kaban', NULL, NULL, NULL, NULL, 'St. Elisabeth', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1850000.00', '726811.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(450, '738', 'Jhon Lambok Sinaga', NULL, NULL, NULL, NULL, 'St. Yohanes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2180000.00', '2796925.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(451, '739', 'Stevan Marpaung', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2180000.00', '574181.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(452, '740', 'Agusniar Marpaung, S.Pd', NULL, NULL, NULL, NULL, 'St. Paulus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2150000.00', '193993.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(453, '741', 'Dwiman Panjaitan', NULL, NULL, NULL, NULL, 'St. Paulus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2150000.00', '221607.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(454, '742', 'Alan Soichi Pasaribu', NULL, NULL, NULL, NULL, 'St. Agnes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1430000.00', '563337.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(455, '744', 'Refa Boru Gurusinga', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2180000.00', '838560.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(456, '745', 'Frans Leonel Gurusinga', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2180000.00', '1033452.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(457, '746', 'Josafat Ginting', NULL, NULL, NULL, NULL, 'St. Paulus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2060000.00', '74086.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(458, '747', 'Filla Delviana Br Barus', NULL, NULL, NULL, NULL, 'St. Paulus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2030000.00', '276797.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(459, '748', 'Giovanni Ginting', NULL, NULL, NULL, NULL, 'St. Paulus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2060000.00', '340992.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(460, '749', 'Marsudin Situmorang', NULL, NULL, NULL, NULL, 'St. Agustinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1880000.00', '772324.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(461, '750', 'Ida Siahaan', NULL, NULL, NULL, NULL, 'St. Agustinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1880000.00', '104268.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(462, '751', 'Kusrini Br Manihuruk', NULL, NULL, NULL, NULL, 'St. Clara', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2090000.00', '214115.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(463, '752', 'Friszt Camelio Nainggolan', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2150000.00', '4594014.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(464, '754', 'Elsa angelika Pane', NULL, NULL, NULL, NULL, 'St. Elisabeth', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1880000.00', '1017207.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(465, '755', 'Feri Indra Pane', NULL, NULL, NULL, NULL, 'St. Elisabeth', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1880000.00', '1017207.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(466, '756', 'Daud Silaban', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2030000.00', '1479194.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(467, '757', 'Horas Sinaga', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2150000.00', '7791722.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(468, '758', 'Diana', NULL, NULL, NULL, NULL, 'St. Agnes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1910000.00', '759845.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(469, '759', 'Indri Maria Sinaga', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2150000.00', '5540264.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(470, '761', 'Sabarina Br Ginting', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2060000.00', '2109170.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(471, '762', 'Leonardo Simbolon', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1710000.00', '317418.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(472, '763', 'Rona Siringo-ringo', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2030000.00', '392274.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(473, '764', 'Naik Raja Sihotang', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2120000.00', '485980.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(474, '765', 'Reginata Shabby Sinaga', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '710000.00', '505854.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(475, '766', 'Nurhawati L.Siantar', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2060000.00', '455255.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(476, '767', 'Sry Hartata Br Sinaga', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1970000.00', '16423.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(477, '768', 'Grecia Sinaga', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2060000.00', '960310.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(478, '769', 'Kristoforus Simbolon', NULL, NULL, NULL, NULL, 'St. Maria', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2000000.00', '1734460.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(479, '770', 'Josua Siburian', NULL, NULL, NULL, NULL, 'St. Yohanes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2090000.00', '1235261.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(480, '771', 'Desi Kristinova', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1460000.00', '1847729.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(481, '772', 'Fany Anastasya', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1220000.00', '1353194.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(482, '774', 'Lion San Midora Kaban', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2000000.00', '925367.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(483, '775', 'Toba Johannes Sinaga', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2060000.00', '459938.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(484, '776', 'Kaira Sai Rotua Purba', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2030000.00', '1443444.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(485, '777', 'Matinus Purba', NULL, NULL, NULL, NULL, 'St. Fransiskus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2030000.00', '1443444.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(486, '778', 'Agus Raya Simbolon', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2090000.00', '454738.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(487, '779', 'Deliati Manik', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2090000.00', '457818.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(488, '780', 'Sesilia Br Simbolon', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2090000.00', '451858.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(489, '781', 'Yohana Simbolon', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2090000.00', '378651.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(490, '782', 'Juita Hasugian', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2060000.00', '1581677.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(491, '783', 'Lince Situmorang', NULL, NULL, NULL, NULL, 'St. Yoseph', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2090000.00', '1331589.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(492, '784', 'Dumaria Br Sitinjak', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1640000.00', '973112.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(493, '785', 'Andus Kaban', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2030000.00', '1902763.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(494, '786', 'Gunadi Hutahean', NULL, NULL, NULL, NULL, 'St. Stefanus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2030000.00', '31011803.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(495, '788', 'Marheppi Tarigan', NULL, NULL, NULL, NULL, 'St. Agustinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1940000.00', '948455.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(496, '789', 'Sambele Kaban', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2030000.00', '1599481.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(497, '790', 'Santa Septiana Br Marbun', NULL, NULL, NULL, NULL, 'St. Gabriel', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2060000.00', '510346.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(498, '791', 'Benita Aurelia Sagala', NULL, NULL, NULL, NULL, 'St. Agnes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2060000.00', '197618.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(499, '792', 'Samueltha Barus', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1910000.00', '1411105.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(500, '793', 'Harry Susanto Tambunan', NULL, NULL, NULL, NULL, 'St. Elisabeth', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2000000.00', '44369.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(501, '794', 'Remida Sitinjak', NULL, NULL, NULL, NULL, 'St. Elisabeth', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2000000.00', '19287.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(502, '796', 'Aprida Br Barus', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1940000.00', '1255571.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(503, '797', 'Putri Permata Gurning', NULL, NULL, NULL, NULL, 'St. Rafael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2060000.00', '890253.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(504, '798', 'Fransiskus Siringo-ringo', NULL, NULL, NULL, NULL, 'St. Lidwina', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2060000.00', '4269131.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(505, '799', 'Mathias Alvaro Sagala', NULL, NULL, NULL, NULL, 'St. Agustinus', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2060000.00', '695832.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(506, '800', 'Chelsea Laurensia Sutanto', NULL, NULL, NULL, NULL, 'St. Elisabeth', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2000000.00', '196598.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(507, '801', 'Julius Sutarto Tambunan', NULL, NULL, NULL, NULL, 'St. Elisabeth', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1970000.00', '749170.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(508, '802', 'Victor Sitinjak, S.H', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2030000.00', '1295883.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(509, '803', 'Purnama Nadeak', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2000000.00', '2786315.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(510, '804', 'Basanova Br Sitinjak', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2030000.00', '1521721.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(511, '805', 'Thresia Sitinjak', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2030000.00', '1446489.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(512, '806', 'Christian Sitinjak', NULL, NULL, NULL, NULL, 'St. Lusia', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2030000.00', '1599482.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(513, '807', 'Samuel Silalahi Haloho', NULL, NULL, NULL, NULL, 'St. Agnes', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2060000.00', '20351.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(514, '808', 'Jarusman Silalahi', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1940000.00', '519189.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(515, '809', 'Samuel Jefri Silalahi', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '1940000.00', '1371211.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(516, '810', 'Delpryanto Ginting', NULL, NULL, NULL, NULL, 'St. Mikhael', NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2060000.00', '1551453.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 20:39:44'),
(517, '811', 'Lilis Suryani Br Ginting', '28401942-1365-31', NULL, '2026-07-01', NULL, NULL, NULL, NULL, '$2y$10$JeT6NaRSx6GCXZ1vYh.fFOeH.75ilD2NfwxX3xK/8CwVOf3mUSMSm', NULL, '0.00', '2060000.00', '1513082.00', 1, '2026-07-01', '2026-07-28 20:39:44', '2026-07-28 13:43:21'),
(521, '812', 'when', '548461331', 'medan', '1999-08-06', 'medan', NULL, '887546161', 'when@gmail.com', '123', NULL, '0.00', '0.00', '200000.00', 1, '2026-08-06', '2026-08-05 15:42:42', '2026-08-05 22:46:05');

-- --------------------------------------------------------

--
-- Table structure for table `tb_jenis_iuran`
--

CREATE TABLE `tb_jenis_iuran` (
  `id_jenis_iuran` int(11) NOT NULL,
  `nama_jenis` varchar(50) NOT NULL,
  `kode` varchar(20) NOT NULL,
  `is_wajib` tinyint(1) DEFAULT 0,
  `nominal_default` decimal(15,2) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_jenis_iuran`
--

INSERT INTO `tb_jenis_iuran` (`id_jenis_iuran`, `nama_jenis`, `kode`, `is_wajib`, `nominal_default`, `is_active`, `created_at`) VALUES
(1, 'Iuran Wajib', 'WAJIB', 1, '50000.00', 1, '2026-07-11 13:51:22'),
(2, 'Iuran Sukarela', 'SUKARELA', 0, NULL, 1, '2026-07-11 13:51:22');

-- --------------------------------------------------------

--
-- Table structure for table `tb_jenis_simpanan`
--

CREATE TABLE `tb_jenis_simpanan` (
  `id_jenis_simpanan` int(11) NOT NULL,
  `nama_simpanan` varchar(50) NOT NULL,
  `is_wajib` tinyint(1) DEFAULT 0,
  `nominal_minimum` decimal(15,2) DEFAULT 0.00,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_jenis_simpanan`
--

INSERT INTO `tb_jenis_simpanan` (`id_jenis_simpanan`, `nama_simpanan`, `is_wajib`, `nominal_minimum`, `is_active`) VALUES
(1, 'Simpanan Pokok', 1, '50000.00', 1),
(2, 'Simpanan Wajib', 1, '25000.00', 1),
(3, 'Simpanan Sukarela', 0, '10000.00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tb_kategori_produk`
--

CREATE TABLE `tb_kategori_produk` (
  `id_kategori` int(11) NOT NULL,
  `nama_kategori` varchar(50) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tb_log_activity`
--

CREATE TABLE `tb_log_activity` (
  `id_log` int(11) NOT NULL,
  `id_user` int(11) DEFAULT NULL,
  `role_user` enum('admin','jemaat') DEFAULT NULL,
  `aksi` varchar(100) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_log_activity`
--

INSERT INTO `tb_log_activity` (`id_log`, `id_user`, `role_user`, `aksi`, `deskripsi`, `ip_address`, `user_agent`, `created_at`) VALUES
(1, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.1.1', NULL, '2026-05-24 11:57:29'),
(2, 1, 'admin', 'Tambah Jemaat', 'Menambah jemaat: Budi Santoso', '192.168.1.1', NULL, '2026-05-23 11:57:29'),
(3, 1, 'admin', 'Update Status Pinjaman', 'Pinjaman ID 1 disetujui', '192.168.1.1', NULL, '2026-05-22 11:57:29'),
(4, 1, 'admin', 'Tambah Produk', 'Menambah produk pinjaman: Pinjaman Reguler', '192.168.1.1', NULL, '2026-05-21 11:57:29'),
(5, 1, 'admin', 'Edit Metode Bayar', 'Mengedit metode BCA', '192.168.1.1', NULL, '2026-05-20 11:57:29'),
(6, 1, 'admin', 'Hapus Jemaat', 'Menghapus jemaat ID: 10', '192.168.1.1', NULL, '2026-05-19 11:57:29'),
(7, 1, 'admin', 'Ubah Pengaturan', 'Mengubah bunga default menjadi 1.5%', '192.168.1.1', NULL, '2026-05-18 11:57:29'),
(8, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.1.1', NULL, '2026-05-17 11:57:29'),
(9, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.3', 'Dart/3.11 (dart:io)', '2026-05-24 05:06:15'),
(10, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.3', 'Dart/3.11 (dart:io)', '2026-05-24 05:08:55'),
(11, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.3', 'Dart/3.11 (dart:io)', '2026-05-24 05:11:43'),
(12, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.3', 'Dart/3.11 (dart:io)', '2026-05-24 05:18:51'),
(13, 1, 'admin', 'Edit Jemaat', 'Mengedit jemaat ID: 11 - Fransa Dirgawan Zebuaaa', '192.168.2.3', 'Dart/3.11 (dart:io)', '2026-05-24 05:19:52'),
(14, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.3', 'Dart/3.11 (dart:io)', '2026-05-24 05:27:12'),
(15, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.3', 'Dart/3.11 (dart:io)', '2026-05-24 12:02:05'),
(16, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.3', 'Dart/3.11 (dart:io)', '2026-05-24 12:09:38'),
(17, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.15', 'curl/8.19.0', '2026-05-24 12:14:09'),
(18, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.15', 'curl/8.19.0', '2026-05-24 12:14:12'),
(19, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.3', 'Dart/3.11 (dart:io)', '2026-05-24 12:24:15'),
(20, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.3', 'Dart/3.11 (dart:io)', '2026-05-24 12:33:44'),
(21, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.3', 'Dart/3.11 (dart:io)', '2026-05-24 13:03:47'),
(22, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.3', 'Dart/3.11 (dart:io)', '2026-05-24 13:05:41'),
(23, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.3', 'Dart/3.11 (dart:io)', '2026-05-24 13:06:36'),
(24, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.3', 'Dart/3.11 (dart:io)', '2026-05-24 13:09:37'),
(25, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.3', 'Dart/3.11 (dart:io)', '2026-05-24 13:11:35'),
(26, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 10:13:37'),
(27, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 10:16:25'),
(28, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 10:18:27'),
(29, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 10:25:51'),
(30, 1, 'admin', 'Update Status Pinjaman', 'Pinjaman ID 1 (PJM001) diubah status menjadi dicairkan', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 10:26:08'),
(31, 1, 'admin', 'Update Status Pinjaman', 'Pinjaman ID 3 (PJM003) diubah status menjadi dicairkan', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 10:26:45'),
(32, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 10:33:23'),
(33, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 10:46:01'),
(34, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 10:48:36'),
(35, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 10:51:42'),
(36, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.17', 'curl/8.19.0', '2026-05-26 10:58:28'),
(37, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 11:11:00'),
(38, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.17', 'curl/8.19.0', '2026-05-26 11:12:15'),
(39, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.17', 'curl/8.19.0', '2026-05-26 11:12:30'),
(40, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 11:13:03'),
(41, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 11:19:44'),
(42, 1, 'admin', 'Ganti Password', 'Admin mengganti password', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 11:20:10'),
(43, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 11:20:31'),
(44, 1, 'admin', 'Update Profil', 'Admin mengupdate profil', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 11:24:26'),
(45, 1, 'admin', 'Update Profil', 'Admin mengupdate profil', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 11:24:36'),
(46, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 11:27:43'),
(47, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 11:34:59'),
(48, 1, 'admin', 'Edit Jemaat', 'Mengedit jemaat ID: 11 - Fransa Dirgawan Zebuaaa', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 11:35:08'),
(49, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 12:03:07'),
(50, 1, 'admin', 'Update Status Pinjaman', 'Pinjaman ID 6 (PJM20260526870) diubah status menjadi ditolak dengan alasan: Ga mampu wkwk', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 12:03:21'),
(51, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 12:17:26'),
(52, 1, 'admin', 'Update Status Pinjaman', 'Pinjaman ID 7 (PJM20260526313) diubah status menjadi disetujui', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 12:18:07'),
(53, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 12:30:00'),
(54, 1, 'admin', 'Update Status Pinjaman', 'Pinjaman ID 7 (PJM20260526313) diubah status menjadi dicairkan', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 12:30:07'),
(55, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 12:35:32'),
(56, 1, 'admin', 'Update Status Pinjaman', 'Pinjaman ID 8 (PJM20260526937) diubah status menjadi disetujui', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 12:35:57'),
(57, 1, 'admin', 'Update Status Pinjaman', 'Pinjaman ID 8 (PJM20260526937) diubah status menjadi dicairkan', '192.168.2.21', 'Dart/3.11 (dart:io)', '2026-05-26 12:36:29'),
(58, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.14', 'Dart/3.11 (dart:io)', '2026-05-26 13:47:25'),
(59, 1, 'admin', 'Update Status Pinjaman', 'Pinjaman ID 9 (PJM20260526340) diubah status menjadi disetujui', '192.168.2.14', 'Dart/3.11 (dart:io)', '2026-05-26 13:47:43'),
(60, 1, 'admin', 'Update Status Pinjaman', 'Pinjaman ID 9 (PJM20260526340) diubah status menjadi dicairkan', '192.168.2.14', 'Dart/3.11 (dart:io)', '2026-05-26 13:47:47'),
(61, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.14', 'Dart/3.11 (dart:io)', '2026-05-26 14:06:45'),
(62, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.17', 'curl/8.19.0', '2026-05-26 14:09:46'),
(63, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.14', 'Dart/3.11 (dart:io)', '2026-05-26 14:25:18'),
(64, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.14', 'Dart/3.11 (dart:io)', '2026-05-26 14:38:48'),
(65, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.17', 'curl/8.19.0', '2026-05-26 14:41:31'),
(66, 1, 'admin', 'Verifikasi Angsuran', 'Pembayaran angsuran ke-8 telah diverifikasi - ID Angsuran: 20', '192.168.2.17', 'curl/8.19.0', '2026-05-26 14:42:51'),
(67, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.14', 'Dart/3.11 (dart:io)', '2026-05-26 14:43:38'),
(68, 1, 'admin', 'Verifikasi Angsuran', 'Pembayaran angsuran ke-1 telah diverifikasi - ID Angsuran: 13', '192.168.2.14', 'Dart/3.11 (dart:io)', '2026-05-26 14:43:47'),
(69, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.14', 'Dart/3.11 (dart:io)', '2026-05-26 14:47:02'),
(70, 1, 'admin', 'Verifikasi Angsuran', 'Pembayaran angsuran ke-2 telah diverifikasi - ID Angsuran: 14', '192.168.2.14', 'Dart/3.11 (dart:io)', '2026-05-26 14:47:21'),
(71, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.14', 'Dart/3.11 (dart:io)', '2026-05-26 14:48:25'),
(72, 1, 'admin', 'Verifikasi Angsuran', 'Pembayaran angsuran ke-3 ditolak - ID Angsuran: 15', '192.168.2.17', 'curl/8.19.0', '2026-05-26 14:52:06'),
(73, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.14', 'Dart/3.11 (dart:io)', '2026-05-26 14:53:34'),
(74, 1, 'admin', 'Verifikasi Angsuran', 'Pembayaran angsuran ke-12 ditolak - ID Angsuran: 24', '192.168.2.14', 'Dart/3.11 (dart:io)', '2026-05-26 14:53:42'),
(75, 1, 'admin', 'Verifikasi Angsuran', 'Pembayaran angsuran ke-1 telah diverifikasi - ID Angsuran: 1', '192.168.2.14', 'Dart/3.11 (dart:io)', '2026-05-26 14:53:44'),
(76, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.14', 'Dart/3.11 (dart:io)', '2026-05-26 14:58:51'),
(77, 1, 'admin', 'Tambah Simpanan', 'Menambah simpanan untuk jemaat ID 11 sebesar Rp 20.000', '192.168.2.14', 'Dart/3.11 (dart:io)', '2026-05-26 15:04:43'),
(78, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.2.14', 'Dart/3.11 (dart:io)', '2026-05-26 15:16:34'),
(79, 1, 'admin', 'Login', 'Admin login ke sistem', '10.156.79.84', 'Dart/3.11 (dart:io)', '2026-05-31 01:13:25'),
(80, 1, 'admin', 'Edit Jemaat', 'Mengedit jemaat ID: 11 - Fransa Dirgawan Zebuaaaaa', '10.156.79.84', 'Dart/3.11 (dart:io)', '2026-05-31 01:14:01'),
(81, 1, 'admin', 'Edit Jemaat', 'Mengedit jemaat ID: 11 - Fransa Dirgawan Zebuaaaaa', '10.156.79.84', 'Dart/3.11 (dart:io)', '2026-05-31 01:15:10'),
(82, 1, 'admin', 'Edit Jemaat', 'Mengedit jemaat ID: 10 - Ratna Sari', '10.156.79.84', 'Dart/3.11 (dart:io)', '2026-05-31 01:15:39'),
(83, 1, 'admin', 'Tambah Simpanan', 'Menambah simpanan untuk jemaat ID 11 sebesar Rp 5.000.000', '10.156.79.84', 'Dart/3.11 (dart:io)', '2026-05-31 01:33:05'),
(84, 1, 'admin', 'Login', 'Admin login ke sistem', '10.156.79.84', 'Dart/3.11 (dart:io)', '2026-05-31 01:37:51'),
(85, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 05:43:16'),
(86, 1, 'admin', 'Update Status Pinjaman', 'Pinjaman ID 13 (PJM20260711211) diubah status menjadi disetujui', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 05:43:46'),
(87, 1, 'admin', 'Update Status Pinjaman', 'Pinjaman ID 13 (PJM20260711211) diubah status menjadi dicairkan', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 05:43:51'),
(88, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 05:45:21'),
(89, 1, 'admin', 'Verifikasi Angsuran', 'Pembayaran angsuran ke-1 telah diverifikasi - ID Angsuran: 26', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 05:45:35'),
(90, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 05:54:04'),
(91, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 05:59:08'),
(92, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 06:17:32'),
(93, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.5', 'curl/8.19.0', '2026-07-11 06:18:31'),
(94, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 06:20:12'),
(95, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 06:29:34'),
(96, 1, 'admin', 'Tambah Jemaat', 'Menambah jemaat: Lilis (No Anggota: 123)', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 06:31:01'),
(97, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 06:38:17'),
(98, 1, 'admin', 'Update Status Pinjaman', 'Pinjaman ID 14 (PJM20260711152) diubah status menjadi disetujui', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 06:38:31'),
(99, 1, 'admin', 'Update Status Pinjaman', 'Pinjaman ID 14 (PJM20260711152) diubah status menjadi dicairkan', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 06:38:32'),
(100, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 06:40:05'),
(101, 1, 'admin', 'Verifikasi Angsuran', 'Pembayaran angsuran ke-1 telah diverifikasi - ID Angsuran: 38', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 06:40:15'),
(102, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 07:00:21'),
(103, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.5', 'curl/8.19.0', '2026-07-11 07:18:20'),
(104, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 07:20:56'),
(105, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 07:22:06'),
(106, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 07:30:33'),
(107, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 07:45:09'),
(108, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-11 07:47:07'),
(109, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-12 07:27:20'),
(110, 1, 'admin', 'Hapus Metode Bayar', 'Menghapus metode pembayaran: Gopay', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-12 07:32:28'),
(111, 1, 'admin', 'Update Status Pinjaman', 'Pinjaman ID 12 (PJM20260711293) diubah status menjadi ditolak dengan alasan: jaminan tidak ada', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-12 07:41:18'),
(112, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-12 07:45:24'),
(113, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-12 07:47:09'),
(114, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-12 09:09:33'),
(115, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-12 09:37:27'),
(116, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-12 09:39:22'),
(117, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-12 09:58:50'),
(118, 1, 'admin', 'Login', 'Admin login ke sistem', '10.10.15.32', 'Dart/3.12 (dart:io)', '2026-07-15 22:56:59'),
(119, 1, 'admin', 'Login', 'Admin login ke sistem', '10.10.15.32', 'Dart/3.12 (dart:io)', '2026-07-15 23:27:41'),
(120, 1, 'admin', 'Tambah Jemaat', 'Menambah jemaat: Santo (No Anggota: 122)', '10.10.15.32', 'Dart/3.12 (dart:io)', '2026-07-15 23:31:41'),
(121, 1, 'admin', 'Tambah Simpanan', 'Menambah simpanan untuk jemaat ID 13 sebesar Rp 100.000', '10.10.15.32', 'Dart/3.12 (dart:io)', '2026-07-15 23:32:49'),
(122, 1, 'admin', 'Login', 'Admin login ke sistem', '10.10.15.32', 'Dart/3.12 (dart:io)', '2026-07-15 23:46:34'),
(123, 1, 'admin', 'Login', 'Admin login ke sistem', '10.10.15.32', 'Dart/3.12 (dart:io)', '2026-07-15 23:47:57'),
(124, 1, 'admin', 'Tambah Simpanan', 'Menambah simpanan untuk jemaat ID 13 sebesar Rp 50.000', '10.10.15.32', 'Dart/3.12 (dart:io)', '2026-07-15 23:48:35'),
(125, 1, 'admin', 'Tambah Simpanan', 'Menambah simpanan untuk jemaat ID 13 sebesar Rp 900.000', '10.10.15.32', 'Dart/3.12 (dart:io)', '2026-07-15 23:48:51'),
(126, 1, 'admin', 'Login', 'Admin login ke sistem', '10.10.15.32', 'Dart/3.12 (dart:io)', '2026-07-16 00:00:14'),
(127, 1, 'admin', 'Update Status Pinjaman', 'Pinjaman ID 16 (PJM20260716956) diubah status menjadi disetujui', '10.10.15.32', 'Dart/3.12 (dart:io)', '2026-07-16 00:01:09'),
(128, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-22 08:01:59'),
(129, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-22 08:24:44'),
(130, 1, 'admin', 'Tambah Jemaat', 'Menambah jemaat: DIMAS (No Anggota: J023)', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-22 08:37:13'),
(131, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-22 08:53:16'),
(132, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-22 08:55:39'),
(133, 1, 'admin', 'Edit Jemaat', 'Mengedit jemaat ID: 14 - DIMAS', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-22 08:56:00'),
(134, 1, 'admin', 'Hapus Jemaat', 'Menghapus jemaat ID: 14', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-22 08:56:08'),
(135, 1, 'admin', 'Login', 'Admin login ke sistem', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-28 13:40:19'),
(136, 1, 'admin', 'Edit Jemaat', 'Mengedit jemaat ID: 517 - Lilis Suryani Br Ginting', '192.168.100.78', 'Dart/3.12 (dart:io)', '2026-07-28 13:43:21'),
(137, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 15:25:38'),
(138, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 15:29:26'),
(139, 1, 'admin', 'Tambah Jemaat', 'Menambah jemaat: hahdhdg (No Anggota: 123637181)', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 15:30:00'),
(140, 1, 'admin', 'Edit Jemaat', 'Mengedit jemaat ID: 518 - bdbajjahs', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 15:30:11'),
(141, 1, 'admin', 'Tambah Simpanan', 'Menambah simpanan untuk jemaat ID 518 sebesar Rp 500.000', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 15:33:31'),
(142, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 15:36:21'),
(143, 1, 'admin', 'Tambah Jemaat', 'Menambah jemaat: damn (No Anggota: ANG-0518)', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 15:38:46'),
(144, 1, 'admin', 'Tambah Jemaat', 'Menambah jemaat: why (No Anggota: ANG-0520)', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 15:39:22'),
(145, 1, 'admin', 'Tambah Jemaat', 'Menambah jemaat: when (No Anggota: 812)', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 15:42:42'),
(146, 1, 'admin', 'Hapus Jemaat', 'Menghapus jemaat ID: 520', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 15:43:03'),
(147, 1, 'admin', 'Hapus Jemaat', 'Menghapus jemaat ID: 519', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 15:43:07'),
(148, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 15:45:29'),
(149, 1, 'admin', 'Tambah Simpanan', 'Menambah simpanan untuk jemaat ID 521 sebesar Rp 100.000 (Saldo Otomatis Bertambah)', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 15:46:05'),
(150, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 15:46:53'),
(151, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 15:48:02'),
(152, 1, 'admin', 'Update Status Pinjaman', 'Pinjaman ID 17 (PJM20260805609) diubah status menjadi disetujui', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 15:48:08'),
(153, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 15:48:42'),
(154, 1, 'admin', 'Update Status Pinjaman', 'Pinjaman ID 17 (PJM20260805609) diubah status menjadi dicairkan', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 15:48:59'),
(155, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 15:49:51'),
(156, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 16:51:40'),
(157, 1, 'admin', 'Verifikasi Angsuran', 'Pembayaran angsuran ke-1 telah diverifikasi - ID Angsuran: 60', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 16:51:46'),
(158, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 16:52:34'),
(159, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 16:55:53'),
(160, 1, 'admin', 'Verifikasi Angsuran', 'Pembayaran angsuran ke-2 telah diverifikasi - ID Angsuran: 61', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 16:56:29'),
(161, 1, 'admin', 'Verifikasi Angsuran', 'Pembayaran angsuran ke-2 telah diverifikasi - ID Angsuran: 27', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 16:56:32'),
(162, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 17:13:28'),
(163, 1, 'admin', 'Update Status Pinjaman', 'Pinjaman ID 18 (PJM20260806239) diubah status menjadi ditolak dengan alasan: tidak ada upload jaminan', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 17:13:44'),
(164, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 17:23:59'),
(165, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 17:29:48'),
(166, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 17:32:42'),
(167, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 17:34:47'),
(168, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 17:36:23'),
(169, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 17:38:43'),
(170, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 17:46:49'),
(171, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 17:55:23'),
(172, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 17:56:43'),
(173, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 18:10:13'),
(174, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 18:45:29'),
(175, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 18:51:30'),
(176, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 19:15:38'),
(177, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 19:16:39'),
(178, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 19:17:44'),
(179, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 19:18:44'),
(180, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 19:36:18'),
(181, 1, 'admin', 'Update Status Pinjaman', 'Pinjaman ID 27 (PJM20260806947) diubah status menjadi ditolak dengan alasan: malas', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 19:37:04'),
(182, 1, 'admin', 'Login', 'Admin login ke sistem', '10.159.117.239', 'Dart/3.12 (dart:io)', '2026-08-05 19:39:18');

-- --------------------------------------------------------

--
-- Table structure for table `tb_metode_pembayaran`
--

CREATE TABLE `tb_metode_pembayaran` (
  `id_metode` int(11) NOT NULL,
  `nama_metode` varchar(50) NOT NULL,
  `kode_metode` varchar(20) DEFAULT NULL,
  `atas_nama` varchar(100) DEFAULT NULL,
  `nomor_rekening` varchar(50) DEFAULT NULL,
  `bank_nama` varchar(50) DEFAULT NULL,
  `icon` text DEFAULT NULL,
  `data_petunjuk` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`data_petunjuk`)),
  `qr_code_data` text DEFAULT NULL,
  `is_qris` tinyint(1) DEFAULT 0,
  `biaya_admin_persen` decimal(5,2) DEFAULT 0.00,
  `is_active` tinyint(1) DEFAULT 1,
  `urutan` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_metode_pembayaran`
--

INSERT INTO `tb_metode_pembayaran` (`id_metode`, `nama_metode`, `kode_metode`, `atas_nama`, `nomor_rekening`, `bank_nama`, `icon`, `data_petunjuk`, `qr_code_data`, `is_qris`, `biaya_admin_persen`, `is_active`, `urutan`, `created_at`) VALUES
(1, 'Tunai', 'CASH', NULL, NULL, NULL, NULL, NULL, NULL, 0, '0.00', 1, 1, '2026-05-22 09:54:27'),
(2, 'Transfer BCA', 'BCA', 'Koperasi Gereja Kasih', '1234567890', 'BCA', NULL, NULL, NULL, 0, '0.00', 1, 2, '2026-05-22 09:54:27'),
(3, 'Transfer BRI', 'BRI', 'Koperasi Gereja Kasih', '0987654321', 'BRI', NULL, NULL, NULL, 0, '0.00', 1, 3, '2026-05-22 09:54:27'),
(4, 'QRIS', 'QRIS', 'Koperasi Gereja Kasih', NULL, 'QRIS', NULL, NULL, NULL, 1, '0.00', 1, 4, '2026-05-22 09:54:27'),
(6, 'QR Code 2', 'QRIS', 'Bank Gereja', NULL, NULL, NULL, NULL, NULL, 1, '0.00', 1, 0, '2026-05-24 04:23:39');

-- --------------------------------------------------------

--
-- Table structure for table `tb_notifikasi`
--

CREATE TABLE `tb_notifikasi` (
  `id_notifikasi` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `role_user` enum('admin','jemaat') DEFAULT NULL,
  `judul` varchar(100) DEFAULT NULL,
  `pesan` text DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `link_redirect` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tb_pengaturan_umum`
--

CREATE TABLE `tb_pengaturan_umum` (
  `id_setting` int(11) NOT NULL,
  `kode_setting` varchar(50) NOT NULL,
  `nama_setting` varchar(100) DEFAULT NULL,
  `nilai_setting` text DEFAULT NULL,
  `tipe_data` enum('string','integer','decimal','boolean','json') DEFAULT 'string',
  `keterangan` text DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_pengaturan_umum`
--

INSERT INTO `tb_pengaturan_umum` (`id_setting`, `kode_setting`, `nama_setting`, `nilai_setting`, `tipe_data`, `keterangan`, `updated_by`, `updated_at`) VALUES
(1, 'DEFAULT_BUNGA_PINJAMAN', 'Bunga Default Pinjaman (%)', '1', 'integer', 'Bunga pinjaman jika tidak memilih produk', NULL, '2026-05-26 10:54:53'),
(2, 'MAKSIMAL_TENOR_BULAN', 'Maksimal Tenor (bulan)', '24', 'integer', 'Maksimal tenor pinjaman dalam bulan', NULL, '2026-05-26 10:54:53'),
(3, 'DENDA_PER_HARI_PERSEN', 'Denda per hari (%)', '0.1', 'decimal', 'Persen denda dari angsuran per hari', NULL, '2026-05-26 10:54:53'),
(4, 'AUTO_SIMPAN_WAJIB', 'Auto Simpan Wajib per Bulan', '50000', 'integer', 'Nominal simpanan wajib otomatis', NULL, '2026-05-26 10:54:53'),
(5, 'KOPERASI_NAME', 'Nama Koperasi', 'Koperasi Gereja Kasih', 'string', 'Nama koperasi tampilan', NULL, '2026-05-26 10:54:53'),
(6, 'KOPERASI_LOGO', 'URL Logo Koperasi', '/storage/logo/logo_1779653470.jpg', 'string', 'Logo tampilan', NULL, '2026-05-24 13:11:10'),
(7, 'KOPERASI_ALAMAT', 'Alamat Koperasi', 'Jl. Gereja No. 1, Jakarta', 'string', 'Alamat lengkap koperasi', NULL, '2026-05-26 10:54:53'),
(8, 'KOPERASI_TELP', 'No Telepon Koperasi', '(021) 12345678', 'string', 'Nomor telepon koperasi', NULL, '2026-05-26 10:54:53'),
(9, 'KOPERASI_EMAIL', 'Email Koperasi', 'koperasi@ gereja.com', 'string', 'Email resmi koperasi', NULL, '2026-05-26 10:54:53'),
(10, 'KOPERASI_DESKRIPSI', 'Deskripsi Koperasi', 'Melayani kebutuhan jemaat dengan sistem syariah', 'string', 'Deskripsi singkat koperasi', NULL, '2026-05-26 10:54:53');

-- --------------------------------------------------------

--
-- Table structure for table `tb_pinjaman`
--

CREATE TABLE `tb_pinjaman` (
  `id_pinjaman` int(11) NOT NULL,
  `id_jemaat` int(11) NOT NULL,
  `id_produk_pinjaman` int(11) NOT NULL,
  `kode_pinjaman` varchar(50) DEFAULT NULL,
  `jumlah_pinjaman` decimal(15,2) NOT NULL,
  `tenor` int(11) NOT NULL,
  `bunga_persen` decimal(5,2) NOT NULL,
  `biaya_admin` decimal(15,2) DEFAULT 0.00,
  `biaya_asuransi` decimal(15,2) DEFAULT 0.00,
  `total_pinjaman` decimal(15,2) GENERATED ALWAYS AS (`jumlah_pinjaman` + `biaya_admin` + `biaya_asuransi`) STORED,
  `angsuran_per_bulan` decimal(15,2) NOT NULL,
  `status` enum('diajukan','disetujui','dicairkan','ditolak','lunas','macet') DEFAULT 'diajukan',
  `tgl_pengajuan` date NOT NULL,
  `tgl_disetujui` date DEFAULT NULL,
  `tgl_pencairan` date DEFAULT NULL,
  `tgl_jatuh_tempo_pertama` date DEFAULT NULL,
  `alasan_ditolak` text DEFAULT NULL,
  `id_admin_approve` int(11) DEFAULT NULL,
  `catatan_internal` text DEFAULT NULL,
  `jaminan` varchar(255) DEFAULT NULL,
  `deskripsi_jaminan` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_pinjaman`
--

INSERT INTO `tb_pinjaman` (`id_pinjaman`, `id_jemaat`, `id_produk_pinjaman`, `kode_pinjaman`, `jumlah_pinjaman`, `tenor`, `bunga_persen`, `biaya_admin`, `biaya_asuransi`, `angsuran_per_bulan`, `status`, `tgl_pengajuan`, `tgl_disetujui`, `tgl_pencairan`, `tgl_jatuh_tempo_pertama`, `alasan_ditolak`, `id_admin_approve`, `catatan_internal`, `jaminan`, `deskripsi_jaminan`, `created_at`, `updated_at`) VALUES
(26, 1, 1, 'PJM20260806686', '64000000.00', 12, '1.50', '0.00', '0.00', '6293333.33', 'diajukan', '2026-08-06', NULL, NULL, NULL, NULL, NULL, NULL, '/storage/jaminan/jaminan_1_1785982708_123.jpg', 'hahahha', '2026-08-05 19:18:28', '2026-08-06 02:18:28'),
(27, 521, 1, 'PJM20260806947', '67000000.00', 12, '1.50', '0.00', '0.00', '6588333.33', 'ditolak', '2026-08-06', NULL, NULL, NULL, 'malas', NULL, NULL, '/storage/jaminan/jaminan_521_1785983678_879.jpg', 'gsgsg', '2026-08-05 19:34:38', '2026-08-05 19:37:04');

-- --------------------------------------------------------

--
-- Table structure for table `tb_produk`
--

CREATE TABLE `tb_produk` (
  `id_produk` int(11) NOT NULL,
  `id_kategori` int(11) DEFAULT NULL,
  `kode_produk` varchar(50) DEFAULT NULL,
  `nama_produk` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `harga_beli` decimal(15,2) DEFAULT NULL,
  `harga_jual` decimal(15,2) NOT NULL,
  `stok` int(11) DEFAULT 0,
  `satuan` varchar(20) DEFAULT NULL,
  `foto_produk` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tb_produk_pinjaman`
--

CREATE TABLE `tb_produk_pinjaman` (
  `id_produk_pinjaman` int(11) NOT NULL,
  `nama_produk` varchar(100) NOT NULL,
  `tenor_min` int(11) DEFAULT 1,
  `tenor_max` int(11) DEFAULT 12,
  `tenor_default` int(11) DEFAULT 6,
  `bunga_persen` decimal(5,2) DEFAULT 1.00,
  `biaya_admin` decimal(15,2) DEFAULT 0.00,
  `asuransi_persen` decimal(5,2) DEFAULT 0.00,
  `denda_perhari_persen` decimal(5,2) DEFAULT 0.10,
  `maksimal_pinjaman` decimal(15,2) DEFAULT NULL,
  `minimal_pinjaman` decimal(15,2) DEFAULT NULL,
  `syarat_minimal_simpanan_wajib` decimal(15,2) DEFAULT 0.00,
  `is_active` tinyint(1) DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_produk_pinjaman`
--

INSERT INTO `tb_produk_pinjaman` (`id_produk_pinjaman`, `nama_produk`, `tenor_min`, `tenor_max`, `tenor_default`, `bunga_persen`, `biaya_admin`, `asuransi_persen`, `denda_perhari_persen`, `maksimal_pinjaman`, `minimal_pinjaman`, `syarat_minimal_simpanan_wajib`, `is_active`, `created_by`, `created_at`) VALUES
(1, 'Pinjaman Usaha', 1, 60, 3, '1.50', '0.00', '0.00', '0.10', '100000000.00', '1000000.00', '0.00', 1, NULL, '2026-05-22 09:54:27'),
(2, 'Pinjaman Kesehatan', 1, 60, 3, '1.50', '0.00', '0.00', '0.10', '100000000.00', '1000000.00', '0.00', 1, NULL, '2026-05-22 09:54:27'),
(3, 'Pinjaman Pendidikan', 1, 60, 12, '1.50', '0.00', '0.00', '0.10', '100000000.00', '1000000.00', '0.00', 1, NULL, '2026-05-22 09:54:27');

-- --------------------------------------------------------

--
-- Table structure for table `tb_role`
--

CREATE TABLE `tb_role` (
  `id_role` int(11) NOT NULL,
  `nama_role` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_role`
--

INSERT INTO `tb_role` (`id_role`, `nama_role`) VALUES
(2, 'admin'),
(4, 'bendahara'),
(3, 'jemaat'),
(1, 'super_admin');

-- --------------------------------------------------------

--
-- Table structure for table `tb_transaksi_simpanan`
--

CREATE TABLE `tb_transaksi_simpanan` (
  `id_transaksi_simpanan` int(11) NOT NULL,
  `id_jemaat` int(11) NOT NULL,
  `id_jenis_simpanan` int(11) NOT NULL,
  `id_metode` int(11) NOT NULL,
  `id_admin` int(11) DEFAULT NULL,
  `jumlah` decimal(15,2) NOT NULL,
  `kode_transaksi` varchar(50) DEFAULT NULL,
  `bukti_transfer` text DEFAULT NULL,
  `status` enum('pending','sukses','gagal','refund') DEFAULT 'sukses',
  `catatan` text DEFAULT NULL,
  `tgl_transaksi` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_transaksi_simpanan`
--

INSERT INTO `tb_transaksi_simpanan` (`id_transaksi_simpanan`, `id_jemaat`, `id_jenis_simpanan`, `id_metode`, `id_admin`, `jumlah`, `kode_transaksi`, `bukti_transfer`, `status`, `catatan`, `tgl_transaksi`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 1, '500000.00', 'SMP001', NULL, 'sukses', 'Simpanan Pokok', '2024-01-15', '2026-05-22 17:04:35', '2026-05-22 17:04:35'),
(2, 1, 2, 1, 1, '25000.00', 'SMP002', NULL, 'sukses', 'Simpanan Wajib Jan', '2024-01-31', '2026-05-22 17:04:35', '2026-05-22 17:04:35'),
(3, 1, 2, 1, 1, '25000.00', 'SMP003', NULL, 'sukses', 'Simpanan Wajib Feb', '2024-02-28', '2026-05-22 17:04:35', '2026-05-22 17:04:35'),
(4, 1, 3, 1, 1, '100000.00', 'SMP004', NULL, 'sukses', 'Simpanan Sukarela', '2024-03-15', '2026-05-22 17:04:35', '2026-05-22 17:04:35'),
(5, 2, 1, 1, 1, '500000.00', 'SMP005', NULL, 'sukses', 'Simpanan Pokok', '2024-02-20', '2026-05-22 17:04:35', '2026-05-22 17:04:35'),
(6, 2, 2, 1, 1, '25000.00', 'SMP006', NULL, 'sukses', 'Simpanan Wajib Feb', '2024-02-28', '2026-05-22 17:04:35', '2026-05-22 17:04:35'),
(7, 3, 1, 1, 1, '500000.00', 'SMP007', NULL, 'sukses', 'Simpanan Pokok', '2024-03-10', '2026-05-22 17:04:35', '2026-05-22 17:04:35'),
(8, 3, 3, 1, 1, '50000.00', 'SMP008', NULL, 'sukses', 'Simpanan Sukarela', '2024-04-05', '2026-05-22 17:04:35', '2026-05-22 17:04:35'),
(9, 11, 2, 1, 1, '20000.00', 'SMP20260526515', NULL, 'sukses', NULL, '2026-05-26', '2026-05-26 15:04:42', '2026-05-26 22:04:42'),
(10, 11, 3, 1, 1, '5000000.00', 'SMP20260531647', NULL, 'sukses', NULL, '2026-05-31', '2026-05-31 01:33:05', '2026-05-31 08:33:05'),
(11, 13, 1, 1, 1, '100000.00', 'SMP20260716766', NULL, 'sukses', 'Tunai', '2026-07-16', '2026-07-15 23:32:49', '2026-07-16 06:32:49'),
(12, 13, 2, 1, 1, '50000.00', 'SMP20260716981', NULL, 'sukses', 'Tunai', '2026-07-16', '2026-07-15 23:48:35', '2026-07-16 06:48:35'),
(13, 13, 3, 1, 1, '900000.00', 'SMP20260716364', NULL, 'sukses', 'Tunai', '2026-07-16', '2026-07-15 23:48:51', '2026-07-16 06:48:51'),
(14, 518, 1, 1, 1, '500000.00', 'SMP20260805431', NULL, 'sukses', 'simpan', '2026-08-05', '2026-08-05 15:33:31', '2026-08-05 22:33:31'),
(15, 521, 3, 1, 1, '100000.00', 'SMP20260805160', NULL, 'sukses', 'sedekah', '2026-08-05', '2026-08-05 15:46:05', '2026-08-05 22:46:05');

--
-- Triggers `tb_transaksi_simpanan`
--
DELIMITER $$
CREATE TRIGGER `after_simpanan_sukses` AFTER INSERT ON `tb_transaksi_simpanan` FOR EACH ROW BEGIN
    IF NEW.status = 'sukses' THEN
        -- Update saldo jemaat sesuai jenis simpanan
        IF NEW.id_jenis_simpanan = 1 THEN -- Simpanan Pokok
            UPDATE tb_jemaat SET saldo_simpanan_pokok = saldo_simpanan_pokok + NEW.jumlah 
            WHERE id_jemaat = NEW.id_jemaat;
        ELSEIF NEW.id_jenis_simpanan = 2 THEN -- Simpanan Wajib
            UPDATE tb_jemaat SET saldo_simpanan_wajib = saldo_simpanan_wajib + NEW.jumlah 
            WHERE id_jemaat = NEW.id_jemaat;
        ELSE -- Sukarela dll
            UPDATE tb_jemaat SET saldo_simpanan_sukarela = saldo_simpanan_sukarela + NEW.jumlah 
            WHERE id_jemaat = NEW.id_jemaat;
        END IF;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `tb_admin`
--
ALTER TABLE `tb_admin`
  ADD PRIMARY KEY (`id_admin`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `tb_angsuran`
--
ALTER TABLE `tb_angsuran`
  ADD PRIMARY KEY (`id_angsuran`),
  ADD UNIQUE KEY `unique_angsuran` (`id_pinjaman`,`angsuran_ke`),
  ADD KEY `id_metode_bayar` (`id_metode_bayar`),
  ADD KEY `updated_by` (`updated_by`),
  ADD KEY `idx_pinjaman` (`id_pinjaman`),
  ADD KEY `idx_tempo` (`tgl_jatuh_tempo`),
  ADD KEY `idx_status` (`status`);

--
-- Indexes for table `tb_detail_transaksi_toko`
--
ALTER TABLE `tb_detail_transaksi_toko`
  ADD PRIMARY KEY (`id_detail`),
  ADD KEY `id_transaksi_toko` (`id_transaksi_toko`),
  ADD KEY `id_produk` (`id_produk`);

--
-- Indexes for table `tb_iuran`
--
ALTER TABLE `tb_iuran`
  ADD PRIMARY KEY (`id_iuran`),
  ADD KEY `id_jemaat` (`id_jemaat`);

--
-- Indexes for table `tb_jemaat`
--
ALTER TABLE `tb_jemaat`
  ADD PRIMARY KEY (`id_jemaat`),
  ADD UNIQUE KEY `no_anggota` (`no_anggota`),
  ADD UNIQUE KEY `nik` (`nik`),
  ADD KEY `idx_no_anggota` (`no_anggota`),
  ADD KEY `idx_status` (`is_active`),
  ADD KEY `idx_lingkungan` (`lingkungan`);

--
-- Indexes for table `tb_jenis_iuran`
--
ALTER TABLE `tb_jenis_iuran`
  ADD PRIMARY KEY (`id_jenis_iuran`),
  ADD UNIQUE KEY `kode` (`kode`);

--
-- Indexes for table `tb_jenis_simpanan`
--
ALTER TABLE `tb_jenis_simpanan`
  ADD PRIMARY KEY (`id_jenis_simpanan`),
  ADD UNIQUE KEY `nama_simpanan` (`nama_simpanan`);

--
-- Indexes for table `tb_kategori_produk`
--
ALTER TABLE `tb_kategori_produk`
  ADD PRIMARY KEY (`id_kategori`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Indexes for table `tb_log_activity`
--
ALTER TABLE `tb_log_activity`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `idx_user` (`id_user`),
  ADD KEY `idx_tanggal` (`created_at`);

--
-- Indexes for table `tb_metode_pembayaran`
--
ALTER TABLE `tb_metode_pembayaran`
  ADD PRIMARY KEY (`id_metode`),
  ADD UNIQUE KEY `nama_metode` (`nama_metode`);

--
-- Indexes for table `tb_notifikasi`
--
ALTER TABLE `tb_notifikasi`
  ADD PRIMARY KEY (`id_notifikasi`),
  ADD KEY `idx_user` (`id_user`,`is_read`);

--
-- Indexes for table `tb_pengaturan_umum`
--
ALTER TABLE `tb_pengaturan_umum`
  ADD PRIMARY KEY (`id_setting`),
  ADD UNIQUE KEY `kode_setting` (`kode_setting`),
  ADD KEY `updated_by` (`updated_by`);

--
-- Indexes for table `tb_pinjaman`
--
ALTER TABLE `tb_pinjaman`
  ADD PRIMARY KEY (`id_pinjaman`),
  ADD UNIQUE KEY `kode_pinjaman` (`kode_pinjaman`),
  ADD KEY `id_produk_pinjaman` (`id_produk_pinjaman`),
  ADD KEY `id_admin_approve` (`id_admin_approve`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_jemaat` (`id_jemaat`);

--
-- Indexes for table `tb_produk`
--
ALTER TABLE `tb_produk`
  ADD PRIMARY KEY (`id_produk`),
  ADD UNIQUE KEY `kode_produk` (`kode_produk`),
  ADD KEY `id_kategori` (`id_kategori`);

--
-- Indexes for table `tb_produk_pinjaman`
--
ALTER TABLE `tb_produk_pinjaman`
  ADD PRIMARY KEY (`id_produk_pinjaman`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `tb_role`
--
ALTER TABLE `tb_role`
  ADD PRIMARY KEY (`id_role`),
  ADD UNIQUE KEY `nama_role` (`nama_role`);

--
-- Indexes for table `tb_transaksi_simpanan`
--
ALTER TABLE `tb_transaksi_simpanan`
  ADD PRIMARY KEY (`id_transaksi_simpanan`),
  ADD UNIQUE KEY `kode_transaksi` (`kode_transaksi`),
  ADD KEY `id_jenis_simpanan` (`id_jenis_simpanan`),
  ADD KEY `id_metode` (`id_metode`),
  ADD KEY `id_admin` (`id_admin`),
  ADD KEY `idx_jemaat` (`id_jemaat`),
  ADD KEY `idx_tanggal` (`tgl_transaksi`),
  ADD KEY `idx_status` (`status`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_admin`
--
ALTER TABLE `tb_admin`
  MODIFY `id_admin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tb_angsuran`
--
ALTER TABLE `tb_angsuran`
  MODIFY `id_angsuran` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT for table `tb_detail_transaksi_toko`
--
ALTER TABLE `tb_detail_transaksi_toko`
  MODIFY `id_detail` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_iuran`
--
ALTER TABLE `tb_iuran`
  MODIFY `id_iuran` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT for table `tb_jemaat`
--
ALTER TABLE `tb_jemaat`
  MODIFY `id_jemaat` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=522;

--
-- AUTO_INCREMENT for table `tb_jenis_iuran`
--
ALTER TABLE `tb_jenis_iuran`
  MODIFY `id_jenis_iuran` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tb_jenis_simpanan`
--
ALTER TABLE `tb_jenis_simpanan`
  MODIFY `id_jenis_simpanan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tb_kategori_produk`
--
ALTER TABLE `tb_kategori_produk`
  MODIFY `id_kategori` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_log_activity`
--
ALTER TABLE `tb_log_activity`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=183;

--
-- AUTO_INCREMENT for table `tb_metode_pembayaran`
--
ALTER TABLE `tb_metode_pembayaran`
  MODIFY `id_metode` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tb_notifikasi`
--
ALTER TABLE `tb_notifikasi`
  MODIFY `id_notifikasi` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_pengaturan_umum`
--
ALTER TABLE `tb_pengaturan_umum`
  MODIFY `id_setting` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `tb_pinjaman`
--
ALTER TABLE `tb_pinjaman`
  MODIFY `id_pinjaman` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `tb_produk`
--
ALTER TABLE `tb_produk`
  MODIFY `id_produk` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_produk_pinjaman`
--
ALTER TABLE `tb_produk_pinjaman`
  MODIFY `id_produk_pinjaman` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tb_role`
--
ALTER TABLE `tb_role`
  MODIFY `id_role` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tb_transaksi_simpanan`
--
ALTER TABLE `tb_transaksi_simpanan`
  MODIFY `id_transaksi_simpanan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tb_angsuran`
--
ALTER TABLE `tb_angsuran`
  ADD CONSTRAINT `tb_angsuran_ibfk_1` FOREIGN KEY (`id_pinjaman`) REFERENCES `tb_pinjaman` (`id_pinjaman`) ON DELETE CASCADE,
  ADD CONSTRAINT `tb_angsuran_ibfk_2` FOREIGN KEY (`id_metode_bayar`) REFERENCES `tb_metode_pembayaran` (`id_metode`),
  ADD CONSTRAINT `tb_angsuran_ibfk_3` FOREIGN KEY (`updated_by`) REFERENCES `tb_admin` (`id_admin`);

--
-- Constraints for table `tb_iuran`
--
ALTER TABLE `tb_iuran`
  ADD CONSTRAINT `tb_iuran_ibfk_1` FOREIGN KEY (`id_jemaat`) REFERENCES `tb_jemaat` (`id_jemaat`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
