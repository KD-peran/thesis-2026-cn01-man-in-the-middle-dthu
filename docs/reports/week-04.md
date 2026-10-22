# Báo Cáo Tiến Độ Tuần 04: Giải Pháp Phòng Thủ & Thực Nghiệm Kiểm Chứng

> **Thời gian:** 22/09/2026 — 28/09/2026  
> **Sinh viên thực hiện:** Nguyễn Thị Kỳ Duyên (MSSV: `0023410647`)  
> **Giảng viên hướng dẫn:** ThS. Trịnh Lê Hoàng Tuấn

---

## 1. Kết quả tuần vừa rồi
- Hoàn thành cấu hình tính năng **DHCP Snooping** và **Dynamic ARP Inspection (DAI)** trên Switch Cisco Catalyst 3750: Phân loại cổng Trusted (Gateway) và Untrusted (Client/Attacker).
- Cấu hình **Nginx Web Server** hỗ trợ giao thức TLS 1.3 và tiêu đề bảo mật **HSTS (`Strict-Transport-Security: max-age=31536000; includeSubDomains; preload`)**.
- Triển khai đường hầm mã hóa **VPN WireGuard** bảo vệ lưu lượng máy khách.
- Viết kịch bản Python `arp_monitor_detector.py` tự động phát hiện xung đột MAC-IP theo thời gian thực.
- **Chạy lại toàn bộ tấn công để kiểm chứng:**
  - Chạy lại ARP Spoofing $\rightarrow$ Bị Switch DAI Drop toàn bộ, log ghi nhận lỗi `%SW_DAI-4-DHCP_SNOOPING_DENY`.
  - Chạy lại Rogue DHCP $\rightarrow$ Bị DHCP Snooping chặn trên cổng Untrusted.
  - Chạy lại SSL Stripping $\rightarrow$ Trình duyệt tự động nâng cấp HTTPS, tấn công thất bại 100%.

---

## 2. Tóm tắt ngắn về kết quả tuần trước theo từng STT
- **STT 1 (Cấu hình DAI & Snooping trên Switch):** Đã hoàn thành 100%, kiểm thử và trích xuất log vi phạm.
- **STT 2 (Cấu hình Nginx HSTS):** Đã hoàn thành, kiểm tra đạt điểm A+ trên công cụ kiểm thử SSL.
- **STT 3 (Kiểm chứng vô hiệu hóa tấn công):** Đã hoàn thành 100%, ghi nhận kết quả vào bảng đối sánh định lượng trong `thuc-nghiem/ket-qua/bang_so_sanh_truoc_sau_phong_thu.md`.

---

## 3. Kế hoạch tuần tiếp theo

| STT | Nhiệm vụ cụ thể | Mức ưu tiên | Hạn hoàn thành | Sản phẩm dự kiến bàn giao |
|:---:|:---|:---:|:---:|:---|
| 1 | Đo kiểm định lượng độ trễ ping và băng thông khi bật DAI/VPN | Cao | 05/10/2026 | Bảng số liệu hiệu năng chi tiết |
| 2 | Hoàn thiện bản thảo Chương 4 (Kết luận và Hướng phát triển) | Cao | 05/10/2026 | Bản thảo toàn văn báo cáo |
| 3 | Biên dịch báo cáo LaTeX và xuất bản ra `docs/downloads/` | Vừa | 05/10/2026 | File `khoa-luan.pdf` hoàn chỉnh |
