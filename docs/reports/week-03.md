# Báo Cáo Tiến Độ Tuần 03: Thực Nghiệm Khai Thác PoC & Thu Thập Dữ Liệu

> **Thời gian:** 15/09/2026 — 21/09/2026  
> **Sinh viên thực hiện:** Nguyễn Thị Kỳ Duyên (MSSV: `0023410647`)  
> **Giảng viên hướng dẫn:** TS. Lương Thái Ngọc

---

## 1. Kết quả tuần vừa rồi
- Hoàn thành viết và kiểm thử kịch bản Python Scapy `code/attacks/arp_spoof.py`: Thực hiện đầu độc ARP Cache hai chiều thành công sau 1.2 giây, có tính năng bắt tín hiệu ngắt (Ctrl+C) để tự động khôi phục bảng ARP an toàn.
- Bắt trọn vẹn thông tin đăng nhập tài khoản người dùng (`admin` / `P@ssword2026!`) truyền qua HTTP bản rõ trên ứng dụng DVWA.
- Thực nghiệm thành công kỹ thuật SSL Stripping bằng Bettercap: Hạ cấp liên kết HTTPS xuống HTTP và thu thập mã định danh phiên `PHPSESSID`.
- Thực hiện kịch bản DNS Spoofing chuyển hướng tên miền `portal.dthu.edu.vn` sang máy chủ web giả mạo trên Kali Linux.

---

## 2. Tóm tắt ngắn về kết quả tuần trước theo từng STT
- **STT 1 (Viết script ARP Spoofing Scapy):** Đã hoàn thành 100%, hoạt động ổn định trên giao diện `eth0`.
- **STT 2 (Tấn công bắt mật khẩu HTTP):** Đã hoàn thành, lưu trữ minh chứng trong `thuc-nghiem/du-lieu/sample_stolen_credentials.json`.
- **STT 3 (Thử nghiệm SSL Stripping):** Đã hoàn thành, tạo file caplet `ssl_strip_bettercap.cap`.

---

## 3. Kế hoạch tuần tiếp theo

| STT | Nhiệm vụ cụ thể | Mức ưu tiên | Hạn hoàn thành | Sản phẩm dự kiến bàn giao |
|:---:|:---|:---:|:---:|:---|
| 1 | Cấu hình DHCP Snooping & Dynamic ARP Inspection (DAI) trên Cisco Switch | Cao | 28/09/2026 | File cấu hình `cisco_dai_dhcp_snooping.cfg` |
| 2 | Cấu hình Nginx HTTPS hỗ trợ HSTS theo RFC 6797 | Cao | 28/09/2026 | File cấu hình `nginx_https_hsts.conf` |
| 3 | Chạy lại toàn bộ các kịch bản tấn công để kiểm chứng tính năng phòng vệ | Cao | 28/09/2026 | Log chặn vi phạm và bảng so sánh |
