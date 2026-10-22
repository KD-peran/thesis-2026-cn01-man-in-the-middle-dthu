# HỆ THỐNG DỮ LIỆU ĐO KIỂM THỰC NGHIỆM ĐỀ TÀI MAN-IN-THE-MIDDLE

> **Đề tài:** Nghiên cứu kỹ thuật khai thác và phòng chống tấn công Man-in-the-Middle  
> **Sinh viên:** Nguyễn Thị Kỳ Duyên (MSSV: `0023410647` — Lớp: `ĐHCNTT23B-CS`)  
> **Giảng viên hướng dẫn:** TS. Lương Thái Ngọc  
> **Cơ sở đào tạo:** Trường Đại học Đồng Tháp — Khoa Công nghệ và Kỹ thuật

---

## 🎯 Mục Đích Của Thư Mục Thực Nghiệm

Thư mục này lưu trữ toàn bộ các minh chứng đo kiểm định lượng, tệp nhật ký ghi vết (Log files), dữ liệu bắt gói tin và bảng tổng hợp đối sánh trước và sau khi kích hoạt các giải pháp an ninh phòng chống tấn công Man-in-the-Middle.

---

## 📁 Cấu Trúc Thư Mục

```text
thuc-nghiem/
├── README.md                                  # Hướng dẫn quy trình đo kiểm thực nghiệm
├── du-lieu/                                   # Nhật ký lưu vết và dữ liệu thô
│   ├── sample_arp_poisoning.log               # Nhật ký gói tin ARP Spoofing gửi đi từ Kali
│   ├── sample_dai_switch_violations.log       # Log của Cisco Switch khi chặn và Drop ARP giả
│   └── sample_stolen_credentials.json         # Mẫu dữ liệu tài khoản và Cookie bị bắt được
└── ket-qua/                                   # Bảng phân tích và đối sánh định lượng
    └── bang_so_sanh_truoc_sau_phong_thu.md    # Bảng ma trận so sánh chi tiết hiệu quả phòng vệ
```

---

## 🔬 Tóm Tắt Quy Trình 5 Bước Thực Nghiệm

1. **Bước 1 (Đo kiểm baseline):** Thiết lập mạng LAN hoạt động bình thường, ghi nhận tốc độ và độ trễ ping cơ sở ($< 1$ms).
2. **Bước 2 (Thực thi tấn công MitM):** Kích hoạt ARP Poisoning, DNS Spoofing, SSL Stripping; ghi lại thông tin tài khoản và Cookie bị lộ.
3. **Bước 3 (Kích hoạt giải pháp phòng thủ):** Bật Dynamic ARP Inspection (DAI), DHCP Snooping trên Switch, HTTPS/HSTS trên Web Server và VPN WireGuard.
4. **Bước 4 (Chạy lại tấn công):** Tái lập toàn bộ các kịch bản tấn công ở Bước 2 để kiểm chứng khả năng vô hiệu hóa.
5. **Bước 5 (Tổng hợp số liệu):** Lập bảng đối sánh định lượng 100% các tiêu chí kỹ thuật.
