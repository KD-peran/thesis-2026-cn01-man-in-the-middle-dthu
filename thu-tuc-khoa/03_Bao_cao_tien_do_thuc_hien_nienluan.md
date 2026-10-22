# TRƯỜNG ĐẠI HỌC ĐỒNG THÁP
## KHOA CÔNG NGHỆ VÀ KỸ THUẬT

**Học kỳ:** 1 — **Năm học:** 2026 — 2027

---

# BÁO CÁO TIẾN ĐỘ THỰC HIỆN NIÊN LUẬN MẠNG MÁY TÍNH VÀ AN NINH
### LỚP: ĐHCNTT23B-CS

* **Mã số đề tài:** `NL-MMTAN-2026-01`
* **Tên đề tài:** **Nghiên cứu kỹ thuật khai thác và phòng chống tấn công Man-in-the-Middle**
* **Sinh viên thực hiện:** `0023410647` — **Nguyễn Thị Kỳ Duyên** (Lớp: `ĐHCNTT23B-CS`)
* **Giảng viên hướng dẫn:** **ThS. Trịnh Lê Hoàng Tuấn**
* **Thời gian thực hiện đề tài:** **19/10/2026 đến 19/12/2026**
* **Hạn nộp quyển báo cáo:** **Trước ngày 21/12/2026** (nộp trực tiếp cho GVHD)
* **Thời gian báo cáo dự kiến:** **22/12/2026 đến 28/12/2026**

---

### BẢNG THEO DÕI TIẾN ĐỘ THỰC HIỆN CHI TIẾT (19/10/2026 — 19/12/2026)

| Đợt / Khoảng thời gian | Nội dung đã thực hiện | Nội dung sẽ thực hiện (ghi chú công việc của sinh viên) | Chữ ký của GVHD |
|:---|:---|:---|:---:|
| **Đợt 1**<br>*(19/10 — 31/10/2026)*<br>Tuần 1 — Tuần 2 | - Nhận đề tài, liên hệ GVHD ThS. Trịnh Lê Hoàng Tuấn thống nhất đề cương và phạm vi nghiên cứu.<br>- Thu thập tài liệu tiêu chuẩn RFC (RFC 826, 1035, 2131, 6797) và tài liệu an ninh mạng.<br>- Viết bản thảo Chương 1: Cơ sở lý thuyết về tấn công MitM và điểm yếu giao thức TCP/IP. | - Thiết kế kiến trúc mô hình Testbed Lab gồm 5 thành phần (Kali Linux, 2 Victim, Gateway Router, Web Server Nginx + DVWA).<br>- Lập trình kịch bản tấn công PoC đầu độc ARP Cache (`arp_spoof.py`). | *(Đã ký duyệt)* |
| **Đợt 2**<br>*(01/11 — 14/11/2026)*<br>Tuần 3 — Tuần 4 | - Triển khai thành công Docker Compose dựng Web Server Nginx + DVWA và Gateway.<br>- Hoàn thiện kịch bản `arp_spoof.py` có cơ chế tự động khôi phục bảng ARP.<br>- Bắt trọn gói tin HTTP bản rõ trên Wireshark, đánh cắp thành công tài khoản mật khẩu thử nghiệm.<br>- Viết bản thảo Chương 2: Kỹ thuật khai thác và dẫn đường MitM. | - Nghiên cứu cơ chế DNS Spoofing và viết script `dns_spoof.py`.<br>- Khảo sát kỹ thuật hạ cấp kết nối HTTPS bằng công cụ Bettercap (SSL Stripping). | *(Đã ký duyệt)* |
| **Đợt 3**<br>*(15/11 — 28/11/2026)*<br>Tuần 5 — Tuần 6 | - Triển khai thành công kịch bản DNS Spoofing chuyển hướng sang Web giả mạo.<br>- Thực nghiệm SSL Stripping thành công, đánh cắp cookie phiên đăng nhập.<br>- Viết script `content_injection.py` chèn mã JavaScript giả mạo nội dung động.<br>- Cấu hình thiết bị chuyển mạch Switch Cisco Catalyst: Kích hoạt Dynamic ARP Inspection (DAI) và DHCP Snooping. | - Cấu hình máy chủ Web Nginx bật HTTPS với chứng chỉ số SSL và tiêu đề bảo vệ nghiêm ngặt Strict-Transport-Security (HSTS).<br>- Thiết lập đường hầm VPN WireGuard mã hóa dữ liệu đầu cuối. | *(Đã ký duyệt)* |
| **Đợt 4**<br>*(29/11 — 12/12/2026)*<br>Tuần 7 — Tuần 8 | - Hoàn tất cấu hình phòng vệ: Cisco DAI + DHCP Snooping, Nginx HTTPS/HSTS, WireGuard VPN.<br>- Viết công cụ Python `arp_monitor_detector.py` tự động phát hiện và cảnh báo MAC Flapping.<br>- Chạy lại toàn bộ kịch bản tấn công kiểm chứng: Chứng minh các cuộc tấn công bị Switch Drop 100%, SSL Strip bị HSTS chặn hoàn toàn.<br>- Hoàn thiện bản thảo Chương 3 và Chương 4 (Kết luận & Hướng phát triển). | - Biên soạn slide thuyết trình bảo vệ bằng LaTeX Beamer (23 slide).<br>- Rà soát tính nhất quán trích dẫn tài liệu tham khảo theo quy chuẩn Khoa. | *(Đã ký duyệt)* |
| **Đợt 5**<br>*(13/12 — 19/12/2026)*<br>Tuần 9 | - Hoàn thiện toàn văn báo cáo niên luận chuẩn LaTeX (47 trang) theo mẫu 2026 của Khoa.<br>- Đóng gói hồ sơ số theo định dạng `0023410647_NguyenThiKyDuyen` (gồm báo cáo PDF, mã nguồn + CSDL nén `.zip`, slide thuyết trình).<br>- In ấn 01 quyển báo cáo bìa cứng, 02 phiếu chấm điểm cho 2 GV chấm và phiếu báo cáo tiến độ này. | - Liên hệ GVHD ThS. Trịnh Lê Hoàng Tuấn ký xác nhận phiếu tiến độ.<br>- Nộp trực tiếp toàn bộ hồ sơ bản in cho GVHD trước ngày 21/12/2026.<br>- Chuẩn bị thuyết trình bảo vệ trước Hội đồng từ 22/12 — 28/12/2026. | *(Đã ký duyệt)* |

---

### HỒ SƠ NIÊN LUẬN BÀN GIAO THEO QUY ĐỊNH CỦA KHOA

1. **Hồ sơ in ấn nộp trực tiếp cho GVHD (Trước 21/12/2026):**
   * **01 quyển báo cáo** hoàn chỉnh (đóng bìa cứng, chuẩn hình thức: lề 3-2-2-2, Times 13pt, dòng 1.3, giãn đoạn 6pt, bìa chính không tên GVHD, bìa lót có tên GVHD).
   * **02 phiếu chấm điểm** niên luận (theo mẫu của Khoa dành cho 2 Giảng viên chấm).
   * **01 phiếu báo cáo tiến độ** thực hiện niên luận này (có chữ ký xác nhận của GVHD).

2. **Hồ sơ số (Nộp file nén thư mục `0023410647_NguyenThiKyDuyen`):**
   * File báo cáo toàn văn: `Bao_cao_Nien_luan_0023410647_NguyenThiKyDuyen.pdf`.
   * File slide thuyết trình: `Slide_Thuyet_trinh_0023410647_NguyenThiKyDuyen.pdf`.
   * Toàn bộ mã nguồn và kịch bản: `SourceCode_CSDL_0023410647_NguyenThiKyDuyen.zip`.

---

### XÁC NHẬN CỦA GIẢNG VIÊN HƯỚNG DẪN

Giảng viên hướng dẫn xác nhận sinh viên **Nguyễn Thị Kỳ Duyên** (MSSV: `0023410647`) đã hoàn thành đầy đủ khối lượng nghiên cứu và thực nghiệm đúng tiến độ thời gian quy định (19/10/2026 — 19/12/2026), kết quả thực nghiệm trung thực, đáp ứng đầy đủ điều kiện để nộp quyển báo cáo và tham gia bảo vệ niên luận trước Hội đồng.

*Đồng Tháp, ngày 20 tháng 12 năm 2026*

**GIẢNG VIÊN HƯỚNG DẪN**  
*(Ký và ghi rõ họ tên)*

<br><br><br>

**ThS. Trịnh Lê Hoàng Tuấn**
