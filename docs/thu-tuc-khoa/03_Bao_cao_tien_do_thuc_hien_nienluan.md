# TRƯỜNG ĐẠI HỌC ĐỒNG THÁP
## KHOA CÔNG NGHỆ VÀ KỸ THUẬT

**Học kỳ:** 1 — **Năm học:** 2026 — 2027

---

# BÁO CÁO TIẾN ĐỘ THỰC HIỆN NIÊN LUẬN MẠNG MÁY TÍNH VÀ AN NINH
### LỚP: ĐHCNTT23B-CS

* **Mã số đề tài:** `NL-MMTAN-2026-01`
* **Tên đề tài:** **Nghiên cứu kỹ thuật khai thác và phòng chống tấn công Man-in-the-Middle**
* **Mã số và họ tên sinh viên thực hiện:**
  * `0023410647` — **Nguyễn Thị Kỳ Duyên** (Lớp: ĐHCNTT23B-CS)
* **Giảng viên hướng dẫn:** **TS. Lương Thái Ngọc**

---

### BẢNG THEO DÕI TIẾN ĐỘ THỰC HIỆN CHI TIẾT

| Đợt / Ngày báo cáo | Nội dung đã thực hiện | Nội dung sẽ thực hiện (ghi chú công việc của từng sinh viên) | Chữ ký của GVHD |
|:---|:---|:---|:---:|
| **Đợt 1**<br>*(15/09/2026)* | - Đăng ký tên đề tài nghiên cứu về tấn công Man-in-the-Middle.<br>- Thu thập tài liệu, các tiêu chuẩn RFC (RFC 826, RFC 1035, RFC 2131, RFC 6797) và tài liệu học thuật.<br>- Hoàn thành Đơn đăng ký và Kế hoạch thực hiện tổng quan. | - Xây dựng đề cương chi tiết các chương của niên luận.<br>- Phác thảo sơ đồ mạng Testbed Lab gồm 5 thành phần (Kali, Victim 1, Victim 2, Gateway, Web Server). | *(Đã ký duyệt)* |
| **Đợt 2**<br>*(30/09/2026)* | - Hoàn thành Đề cương chi tiết (4 chương).<br>- Thiết lập môi trường ảo hóa Docker Testbed: Web Server Nginx + DVWA, Gateway Router VyOS.<br>- Khảo sát cấu trúc bảng ARP và cơ chế phân giải tên miền DNS. | - Soạn thảo Chương 1: Cơ sở lý thuyết về tấn công MitM và các điểm yếu giao thức TCP/IP.<br>- Viết kịch bản tấn công thử nghiệm ARP Cache Poisoning bằng Scapy/Python. | *(Đã ký duyệt)* |
| **Đợt 3**<br>*(15/10/2026)* | - Hoàn thiện bản thảo Chương 1.<br>- Lập trình hoàn chỉnh script `arp_spoof.py` với cơ chế phục hồi bảng ARP khi kết thúc.<br>- Thực nghiệm bắt gói tin HTTP bản rõ bằng Wireshark và đánh cắp thông tin đăng nhập thành công. | - Soạn thảo Chương 2: Các kỹ thuật khai thác và dẫn đường MitM (DNS Spoofing, DHCP Spoofing, SSL Stripping, Content Tampering).<br>- Viết script `dns_spoof.py` và cấu hình Bettercap SSL Strip. | *(Đã ký duyệt)* |
| **Đợt 4**<br>*(31/10/2026)* | - Hoàn thiện bản thảo Chương 2.<br>- Triển khai thành công kịch bản DNS Spoofing chuyển hướng sang trang giả mạo.<br>- Thực nghiệm SSL Stripping hạ cấp HTTPS xuống HTTP, bắt trọn Cookie và session token.<br>- Viết script `content_injection.py` sửa đổi gói tin động. | - Soạn thảo Chương 3: Giải pháp phòng chống và thực nghiệm kiểm chứng.<br>- Cấu hình thiết bị Switch Cisco Catalyst: Dynamic ARP Inspection (DAI) và DHCP Snooping.<br>- Cấu hình Nginx bật HTTPS TLS 1.3 và tiêu đề Strict-Transport-Security (HSTS). | *(Đã ký duyệt)* |
| **Đợt 5**<br>*(15/11/2026)* | - Cấu hình hoàn tất Cisco DAI và DHCP Snooping trên Switch phòng lab.<br>- Thiết lập thành công chứng chỉ số SSL và HSTS trên Nginx Web Server.<br>- Thiết lập mạng riêng ảo VPN WireGuard mã hóa kênh truyền nội bộ.<br>- Viết công cụ `arp_monitor_detector.py` giám sát cảnh báo ARP bất thường. | - Chạy lại toàn bộ các kịch bản tấn công để kiểm chứng hiệu quả vô hiệu hóa của từng giải pháp phòng thủ.<br>- Thu thập log vi phạm trên Switch và đo đạc số liệu định lượng trước/sau phòng thủ. | *(Đã ký duyệt)* |
| **Đợt 6**<br>*(30/11/2026)* | - Hoàn thành đo kiểm thực nghiệm: Chứng minh tấn công ARP Spoofing bị Switch drop 100%, SSL Strip bị HSTS vô hiệu hóa 100%, WireGuard bảo vệ toàn vẹn dữ liệu.<br>- Hoàn thiện bản thảo Chương 3 và Chương 4 (Kết luận & Hướng phát triển). | - Biên soạn slide thuyết trình bảo vệ bằng LaTeX Beamer.<br>- Kiểm tra đối chiếu trích dẫn tài liệu tham khảo BibLaTeX theo chuẩn trường DTHU.<br>- In ấn báo cáo thử nghiệm xin ý kiến GVHD. | *(Đã ký duyệt)* |
| **Đợt 7**<br>*(15/12/2026)* | - Tiếp thu ý kiến đóng góp của GVHD, chỉnh sửa định dạng theo chuẩn Word/LaTeX 2026 của Khoa.<br>- Hoàn thành slide bảo vệ (22 slide).<br>- Chuẩn bị sản phẩm demo trực quan trên Testbed Lab. | - Hoàn thiện hồ sơ nghiệm thu, chuẩn bị bảo vệ trước Hội đồng đánh giá niên luận. | *(Đã ký duyệt)* |

---

### XÁC NHẬN CỦA GIẢNG VIÊN HƯỚNG DẪN

Giảng viên hướng dẫn xác nhận sinh viên **Nguyễn Thị Kỳ Duyên** đã hoàn thành đầy đủ các nội dung theo đúng tiến độ đề ra, kết quả thực nghiệm trung thực, đáp ứng đầy đủ yêu cầu của một Niên luận chuyên ngành Mạng Máy Tính và An Ninh.

*Đồng Tháp, ngày 20 tháng 12 năm 2026*

**GIẢNG VIÊN HƯỚNG DẪN**  
*(Ký và ghi rõ họ tên)*

<br><br><br>

**TS. Lương Thái Ngọc**
