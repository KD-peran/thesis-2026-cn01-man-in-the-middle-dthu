# MÃ NGUỒN VÀ KỊCH BẢN THỰC NGHIỆM ĐỀ TÀI MAN-IN-THE-MIDDLE

> **Đề tài:** Nghiên cứu kỹ thuật khai thác và phòng chống tấn công Man-in-the-Middle  
> **Sinh viên thực hiện:** Nguyễn Thị Kỳ Duyên (MSSV: `0023410647` — Lớp: `ĐHCNTT23B-CS`)  
> **Giảng viên hướng dẫn:** TS. Lương Thái Ngọc  
> **Cơ sở đào tạo:** Trường Đại học Đồng Tháp (DTHU) — Khoa Công nghệ và Kỹ thuật

---

## 📁 Cấu Trúc Thư Mục Mã Nguồn

```text
code/
├── README.md                          # Tài liệu hướng dẫn kiến trúc và cách vận hành
├── .env.example                       # File mẫu cấu hình biến môi trường
│
├── lab-setup/                         # Dựng môi trường phòng thử nghiệm (Testbed Lab)
│   ├── docker-compose.yml             # Khởi chạy Nginx, DVWA, DNS Server trên container
│   └── cisco_switch_config.cfg        # Cấu hình Switch Cisco Catalyst (VLAN, Access, Trunk)
│
├── attacks/                           # Bộ công cụ khai thác và dẫn đường (PoC)
│   ├── arp_spoof.py                   # Tấn công ARP Cache Poisoning hai chiều (Scapy)
│   ├── dns_spoof.py                   # Tấn công DNS Spoofing bắt và giả mạo truy vấn tên miền
│   ├── ssl_strip_bettercap.cap        # Kịch bản Bettercap hạ cấp HTTPS -> HTTP và bắt Cookie
│   └── content_injection.py           # Kịch bản chèn mã độc JavaScript / can thiệp dữ liệu
│
└── defense/                           # Bộ giải pháp phòng thủ và ngăn chặn
    ├── cisco_dai_dhcp_snooping.cfg    # Cấu hình DHCP Snooping & Dynamic ARP Inspection (DAI)
    ├── nginx_https_hsts.conf          # Cấu hình Nginx HTTPS + HSTS tiêu chuẩn RFC 6797
    ├── arp_monitor_detector.py        # Công cụ giám sát và phát hiện ARP Spoofing thời gian thực
    └── wireguard_vpn_client.conf      # File cấu hình kênh truyền mã hóa VPN WireGuard
```

---

## 🚀 Hướng Dẫn Vận Hành Từng Kịch Bản

### 1. Dựng môi trường Web Server và Nạn nhân
```bash
cd lab-setup
docker-compose up -d
```
Hệ thống sẽ khởi chạy:
- Web Server HTTP/HTTPS thử nghiệm (cổng 80 và 443).
- Ứng dụng kiểm thử lỗ hổng Damn Vulnerable Web Application (DVWA) tại `http://192.168.10.100/login.php`.

### 2. Chạy thử nghiệm tấn công ARP Spoofing
Trên máy tấn công Kali Linux:
```bash
sudo python3 attacks/arp_spoof.py -t 192.168.10.10 -g 192.168.10.1 -i eth0
```

### 3. Chạy thử nghiệm tấn công DNS Spoofing
```bash
sudo python3 attacks/dns_spoof.py -d "portal.dthu.edu.vn" -f 192.168.10.50
```

### 4. Chạy Bettercap SSL Stripping
```bash
sudo bettercap -iface eth0 -caplet attacks/ssl_strip_bettercap.cap
```

### 5. Kích hoạt giải pháp phòng thủ
- **Trên Cisco Switch:** Nạp file cấu hình `defense/cisco_dai_dhcp_snooping.cfg` để bật tính năng DHCP Snooping và DAI.
- **Trên Web Server Nginx:** Sao chép file cấu hình `defense/nginx_https_hsts.conf` vào `/etc/nginx/conf.d/` và tải lại service:
  ```bash
  sudo nginx -t && sudo systemctl reload nginx
  ```
- **Kích hoạt công cụ giám sát ARP thời gian thực:**
  ```bash
  sudo python3 defense/arp_monitor_detector.py -i eth0 -g 192.168.10.1
  ```
