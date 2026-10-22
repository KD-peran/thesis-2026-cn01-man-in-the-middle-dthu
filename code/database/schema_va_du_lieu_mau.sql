-- =============================================================================
-- TRƯỜNG ĐẠI HỌC ĐỒNG THÁP - KHOA CÔNG NGHỆ VÀ KỸ THUẬT
-- ĐỀ TÀI NIÊN LUẬN: NGHIÊN CỨU KỸ THUẬT KHAI THÁC VÀ PHÒNG CHỐNG TẤN CÔNG MAN-IN-THE-MIDDLE
-- Sinh viên thực hiện: Nguyễn Thị Kỳ Duyên (MSSV: 0023410647)
-- Giảng viên hướng dẫn: ThS. Trịnh Lê Hoàng Tuấn
-- Thời gian thực hiện: 19/10/2026 - 19/12/2026
-- =============================================================================

CREATE DATABASE IF NOT EXISTS `mitm_security_lab` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `mitm_security_lab`;

-- -----------------------------------------------------------------------------
-- 1. Bảng lưu trữ tài khoản người dùng và thông tin xác thực
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `nguoi_dung`;
CREATE TABLE `nguoi_dung` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `ten_dang_nhap` VARCHAR(50) NOT NULL UNIQUE,
  `mat_khau_hash` VARCHAR(255) NOT NULL,
  `ho_va_ten` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL UNIQUE,
  `vai_tro` ENUM('ADMIN', 'GIANG_VIEN', 'SINH_VIEN', 'QUAN_TRI_MANG') DEFAULT 'SINH_VIEN',
  `trang_thai` TINYINT(1) DEFAULT 1,
  `ngay_tao` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `nguoi_dung` (`id`, `ten_dang_nhap`, `mat_khau_hash`, `ho_va_ten`, `email`, `vai_tro`) VALUES
(1, 'admin_system', '$2y$12$e8YQ3L8nQGvW5mE6c1Q4kO0h7Z9u8v7w6x5y4z3a2b1c0d', 'Quản trị viên Hệ thống', 'admin@dthu.edu.vn', 'ADMIN'),
(2, 'gv_hoangtuan', '$2y$12$k9L2P5vW1nE3c7Q9kO4h8Z2u5v6w7x8y9z0a1b2c3d4e5f', 'ThS. Trịnh Lê Hoàng Tuấn', 'tlhtuan@dthu.edu.vn', 'GIANG_VIEN'),
(3, 'sv_kyduyen', '$2y$12$m1N3O5vW2nE4c8Q0kO5h9Z3u6v7w8x9y0z1a2b3c4d5e6f', 'Nguyễn Thị Kỳ Duyên', '0023410647@student.dthu.edu.vn', 'SINH_VIEN'),
(4, 'victim_user01', '$2y$12$j4K6L8vW3nE5c9Q1kO6h0Z4u7v8w9x0y1z2a3b4c5d6e7f', 'Máy nạn nhân Thử nghiệm 01', 'victim01@lab.local', 'SINH_VIEN'),
(5, 'victim_user02', '$2y$12$h7I9J0vW4nE6c0Q2kO7h1Z5u8v9w0x1y2z3a4b5c6d7e8f', 'Máy nạn nhân Thử nghiệm 02', 'victim02@lab.local', 'SINH_VIEN');

-- -----------------------------------------------------------------------------
-- 2. Bảng quản lý phiên làm việc (Session Management & Cookie Hijacking Test)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `phien_dang_nhap`;
CREATE TABLE `phien_dang_nhap` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `session_token` VARCHAR(128) NOT NULL UNIQUE,
  `dia_chi_ip` VARCHAR(45) NOT NULL,
  `user_agent` TEXT NOT NULL,
  `co_secure` TINYINT(1) DEFAULT 1 COMMENT '1: Bật HTTPS Only (Secure flag), 0: Không an toàn',
  `co_httponly` TINYINT(1) DEFAULT 1 COMMENT '1: Chống XSS đọc cookie (HttpOnly)',
  `samesite_policy` ENUM('Strict', 'Lax', 'None') DEFAULT 'Strict',
  `thoi_gian_tao` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `het_han_luc` DATETIME NOT NULL,
  `trang_thai` ENUM('ACTIVE', 'EXPIRED', 'HIJACKED_DETECTED', 'REVOKED') DEFAULT 'ACTIVE',
  FOREIGN KEY (`user_id`) REFERENCES `nguoi_dung`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `phien_dang_nhap` (`user_id`, `session_token`, `dia_chi_ip`, `user_agent`, `co_secure`, `co_httponly`, `samesite_policy`, `het_han_luc`, `trang_thai`) VALUES
(3, 'dthu_sess_7a8f9b2c3d4e5f60718293a4b5c6d7e8', '192.168.10.10', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/129.0.0.0', 1, 1, 'Strict', '2026-12-21 23:59:59', 'ACTIVE'),
(4, 'dthu_sess_insecure_88a91c0e33f21b77a0', '192.168.10.10', 'Mozilla/5.0 (Windows NT 10.0; Win64) Firefox/131.0', 0, 0, 'None', '2026-11-15 12:00:00', 'HIJACKED_DETECTED');

-- -----------------------------------------------------------------------------
-- 3. Cơ sở dữ liệu ràng buộc DHCP Snooping Binding Database
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `dhcp_snooping_bindings`;
CREATE TABLE `dhcp_snooping_bindings` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `dia_chi_mac` VARCHAR(17) NOT NULL,
  `dia_chi_ip` VARCHAR(15) NOT NULL,
  `lease_seconds` INT NOT NULL DEFAULT 86400,
  `vlan_id` INT NOT NULL DEFAULT 10,
  `interface_port` VARCHAR(30) NOT NULL,
  `is_trusted_port` TINYINT(1) DEFAULT 0,
  `cap_nhat_luc` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `unique_mac_vlan` (`dia_chi_mac`, `vlan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `dhcp_snooping_bindings` (`dia_chi_mac`, `dia_chi_ip`, `lease_seconds`, `vlan_id`, `interface_port`, `is_trusted_port`) VALUES
('00:50:56:EA:01:01', '192.168.10.1', 604800, 10, 'GigabitEthernet0/1', 1),
('00:50:56:EA:01:02', '192.168.10.2', 604800, 10, 'GigabitEthernet0/2', 1),
('00:0C:29:AA:BB:CC', '192.168.10.10', 86400, 10, 'FastEthernet0/10', 0),
('00:0C:29:DD:EE:FF', '192.168.10.20', 86400, 10, 'FastEthernet0/11', 0),
('08:00:27:11:22:33', '192.168.10.50', 86400, 10, 'FastEthernet0/24', 0);

-- -----------------------------------------------------------------------------
-- 4. Bảng nhật ký cảnh báo phát hiện ARP Spoofing và tấn công MitM
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `canh_bao_tan_cong_mitm`;
CREATE TABLE `canh_bao_tan_cong_mitm` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `loai_tan_cong` ENUM('ARP_SPOOFING', 'DNS_SPOOFING', 'ROGUE_DHCP', 'SSL_STRIP', 'CONTENT_INJECTION') NOT NULL,
  `ip_muc_tieu` VARCHAR(45) NOT NULL,
  `mac_that` VARCHAR(17),
  `mac_gia_mao` VARCHAR(17) NOT NULL,
  `ip_ke_tan_cong` VARCHAR(45),
  `muc_do_nguy_hiem` ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') DEFAULT 'HIGH',
  `hanh_dong_da_xu_ly` VARCHAR(255) NOT NULL,
  `thoi_gian_ghi_nhan` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `canh_bao_tan_cong_mitm` (`loai_tan_cong`, `ip_muc_tieu`, `mac_that`, `mac_gia_mao`, `ip_ke_tan_cong`, `muc_do_nguy_hiem`, `hanh_dong_da_xu_ly`, `thoi_gian_ghi_nhan`) VALUES
('ARP_SPOOFING', '192.168.10.1', '00:50:56:EA:01:01', '08:00:27:11:22:33', '192.168.10.50', 'CRITICAL', 'DAI Drop packet tai Fa0/24; Khoa cong port-security; Gui alert toi admin', '2026-11-12 14:32:10'),
('DNS_SPOOFING', '192.168.10.10', NULL, '08:00:27:11:22:33', '192.168.10.50', 'HIGH', 'Chuyen huong truy van ve DNS goc hop le 192.168.10.2; Chuyen sang DoH', '2026-11-14 09:15:22'),
('SSL_STRIP', '192.168.10.10', NULL, '08:00:27:11:22:33', '192.168.10.50', 'HIGH', 'Kich hoat HSTS max-age=31536000 preload; Trinh duyet tu choi ha cap HTTP', '2026-11-18 16:45:00');

-- =============================================================================
-- HOÀN TẤT KHỞI TẠO CSDL PHÒNG THỬ NGHIỆM VÀ ĐO KIỂM TẤN CÔNG MITM
-- =============================================================================
