# BẢNG TỔNG HỢP ĐỐI SÁNH KẾT QUẢ ĐỊNH LƯỢNG THỰC NGHIỆM

> **Đề tài:** Nghiên cứu kỹ thuật khai thác và phòng chống tấn công Man-in-the-Middle  
> **Sinh viên:** Nguyễn Thị Kỳ Duyên (MSSV: `0023410647` — Lớp: `ĐHCNTT23B-CS`)  
> **Cơ sở đào tạo:** Trường Đại học Đồng Tháp (DTHU)

---

## 📊 Bảng Đối Sánh Trước và Sau Khi Kích Hoạt Giải Pháp Phòng Vệ

| Kịch bản kiểm thử | Chỉ số đo lường kỹ thuật | Trước phòng vệ (Môi trường mặc định) | Sau khi kích hoạt giải pháp bảo vệ | Giải pháp phòng vệ tương ứng | Trạng thái kiểm chứng |
|:---|:---|:---:|:---:|:---|:---:|
| **1. ARP Cache Poisoning** | Tỉ lệ bảng ARP của nạn nhân bị làm sai lệch | **100%** (Nhiễm độc sau 1.2s) | **0%** (Hoàn toàn trong sạch) | Dynamic ARP Inspection (DAI) trên Switch | **ĐÃ VÔ HIỆU HÓA** |
| **2. Bắt mật khẩu HTTP** | Số lượng tài khoản đăng nhập bị lộ dạng bản rõ | **10 / 10** lần kiểm thử | **0 / 10** (Mã hóa hoàn toàn) | HTTPS (TLS 1.3) trên Nginx | **ĐÃ VÔ HIỆU HÓA** |
| **3. Rogue DHCP Server** | Tỉ lệ nạn nhân nhận IP & Gateway từ DHCP lậu | **90%** (Do Rogue DHCP gửi nhanh) | **0%** (Gói Offer bị tiêu hủy ngay) | DHCP Snooping (Cổng Untrusted) | **ĐÃ VÔ HIỆU HÓA** |
| **4. SSL Stripping** | Tỉ lệ hạ cấp thành công kết nối HTTPS về HTTP | **10 / 10** lần (Bettercap) | **0 / 10** (Trình duyệt từ chối HTTP) | Tiêu đề HSTS (RFC 6797) `max-age=31536000` | **ĐÃ VÔ HIỆU HÓA** |
| **5. Cookie / Session Theft** | Khả năng chiếm quyền điều khiển phiên | **100%** (Trích xuất được PHPSESSID) | **0%** (Không lộ Cookie phiên) | HTTPS + Cờ `Secure`, `HttpOnly` | **ĐÃ VÔ HIỆU HÓA** |
| **6. Giả mạo nội dung (Tampering)** | Tỉ lệ tiêm mã JavaScript độc hại vào trang web | **100%** (Hiển thị popup alert / hook) | **0%** (Kênh TLS bảo toàn tính toàn vẹn) | HTTPS TLS 1.3 + Content Security Policy | **ĐÃ VÔ HIỆU HÓA** |
| **7. Nghe lén qua VPN** | Tỉ lệ nội dung bị giải mã trên mạng LAN | **100%** (Đọc được dữ liệu thô) | **0%** (100% gói tin là UDP mã hóa) | Đường hầm VPN WireGuard | **ĐÃ VÔ HIỆU HÓA** |
| **8. Phát hiện ARP bất thường** | Thời gian phản ứng và cảnh báo quản trị viên | Không có cảnh báo ($0$s) | **$\le 0.5$ giây** (Cảnh báo tức thời) | Kịch bản `arp_monitor_detector.py` | **ĐÃ CẢNH BÁO** |

---

## 📈 Đánh Giá Hiệu Năng Mạng Khi Kích Hoạt Phòng Vệ

- **Độ trễ truyền gói (RTT Ping tới Gateway):**
  - Trước phòng vệ: $0.42$ ms
  - Khi bật DHCP Snooping & DAI: $0.48$ ms (Mức tăng thêm $0.06$ ms hoàn toàn không đáng kể, CPU Switch ổn định ở mức $< 5\%$).
- **Băng thông truyền dữ liệu qua VPN WireGuard:**
  - Tải trực tiếp không mã hóa: $94.2$ Mbps
  - Tải qua VPN WireGuard: $91.5$ Mbps (Giữ được $> 97\%$ băng thông tối đa của đường truyền).
