# Báo Cáo Tiến Độ Tuần 02: Cơ Sở Lý Thuyết & Phân Tích Kỹ Thuật Dẫn Đường

> **Thời gian:** 08/09/2026 — 14/09/2026  
> **Sinh viên thực hiện:** Nguyễn Thị Kỳ Duyên (MSSV: `0023410647`)  
> **Giảng viên hướng dẫn:** TS. Lương Thái Ngọc

---

## 1. Kết quả tuần vừa rồi
- Nghiên cứu sâu sắc cơ chế hoạt động và điểm yếu không xác thực của các giao thức tầng 2 và tầng 7 (ARP, DNS, DHCP, HTTP).
- Hoàn thành bản thảo Chương 1: *Tổng quan và cơ sở lý thuyết về tấn công Man-in-the-Middle*.
- Phân tích cặn kẽ 6 kỹ thuật dẫn đường: ARP Spoofing, DNS Spoofing, DHCP Spoofing, ICMP Redirect, Rogue AP và SSL Stripping (Moxie Marlinspike).
- Phân tích các kỹ thuật tấn công phiên: Session Hijacking, đánh cắp Cookie thiếu cờ Secure/HttpOnly và kỹ thuật giả mạo nội dung (Tampering).

---

## 2. Tóm tắt ngắn về kết quả tuần trước theo từng STT
- **STT 1 (Nghiên cứu tài liệu RFC):** Đã hoàn thành 100%, trích xuất đầy đủ mã lỗi và cấu trúc tiêu đề gói tin.
- **STT 2 (Phân tích 6 kỹ thuật dẫn đường):** Đã hoàn thành, tổng hợp thành ma trận so sánh toàn diện trong Chương 2.
- **STT 3 (Cài đặt công cụ Kali):** Đã hoàn thành cài đặt Scapy 2.5, Bettercap 2.32, Wireshark và thư viện Python.

---

## 3. Kế hoạch tuần tiếp theo

| STT | Nhiệm vụ cụ thể | Mức ưu tiên | Hạn hoàn thành | Sản phẩm dự kiến bàn giao |
|:---:|:---|:---:|:---:|:---|
| 1 | Lập trình kịch bản PoC ARP Spoofing hai chiều bằng Scapy (`arp_spoof.py`) | Cao | 21/09/2026 | Script `arp_spoof.py` có tự động restore |
| 2 | Thực hiện tấn công bắt gói tin HTTP POST chứa mật khẩu dạng bản rõ | Cao | 21/09/2026 | File log mẫu bắt mật khẩu |
| 3 | Thử nghiệm kỹ thuật SSL Stripping bằng Bettercap trên máy nạn nhân | Vừa | 21/09/2026 | File cấu hình caplet và kết quả Cookie |
