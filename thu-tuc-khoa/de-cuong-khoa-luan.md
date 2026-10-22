# ĐỀ CƯƠNG CHI TIẾT ĐỀ TÀI NGHIÊN CỨU

* **Tên đề tài:** **Nghiên cứu kỹ thuật khai thác và phòng chống tấn công Man-in-the-Middle**
* **Mã đề tài:** `2026.MITM.01`
* **Sinh viên thực hiện:** **Nguyễn Thị Kỳ Duyên** (MSSV: `0023410647` — Lớp: `ĐHCNTT23B-CS`)
* **Ngành đào tạo:** Khoa học máy tính — **Chuyên ngành:** Mạng Máy Tính và An Ninh
* **Giảng viên hướng dẫn:** **ThS. Trịnh Lê Hoàng Tuấn**
* **Cơ sở đào tạo:** Trường Đại học Đồng Tháp (DTHU) — Khoa Công nghệ và Kỹ thuật

---

## 1. Tính Cấp Thiết và Mục Tiêu Nghiên Cứu

### 1.1. Tính cấp thiết
Trong kiến trúc bộ giao thức TCP/IP, các giao thức sơ khai như ARP (RFC 826), DNS (RFC 1035), DHCP (RFC 2131) được thiết kế dựa trên giả định môi trường mạng nội bộ (LAN) là an toàn. Điểm yếu chí mạng của chúng là hoàn toàn thiếu cơ chế xác thực nguồn gốc và kiểm tra toàn vẹn gói tin.

Lợi dụng điểm yếu này, kẻ tấn công có thể chèn mình vào vị trí trung gian giữa nạn nhân và điểm kết nối ngoài (Gateway / Web Server) để thực hiện cuộc tấn công Man-in-the-Middle (MitM). Kẻ tấn công không chỉ dừng lại ở việc nghe lén mật khẩu, đánh cắp Cookie phiên làm việc mà còn có thể giả mạo nội dung trang web hoặc tiêm mã độc vào trình duyệt người dùng. Do đó, việc nghiên cứu bài bản cả hai chiều: cơ chế khai thác và giải pháp phòng chống đa lớp là vô cùng cần thiết.

### 1.2. Mục tiêu nghiên cứu
1. Làm rõ bản chất lý thuyết, cơ chế hoạt động của tấn công Man-in-the-Middle.
2. Phân tích chi tiết 6 kỹ thuật dẫn đường: ARP Spoofing, DNS Spoofing, DHCP Spoofing, ICMP Redirect, Rogue AP, SSL Stripping.
3. Phân tích các kiểu tấn công khai thác phiên và dữ liệu: Session Hijacking, đánh cắp Cookie, giả mạo nội dung (Tampering).
4. Thiết lập mô hình phòng thử nghiệm 5 thành phần (Kali Linux, 02 máy nạn nhân, Gateway, Web Server) và thực thi thành công các kịch bản tấn công PoC.
5. Triển khai các giải pháp phòng thủ: HTTPS/HSTS, chứng chỉ số PKI, Dynamic ARP Inspection (DAI), DHCP Snooping, VPN WireGuard và công cụ giám sát ARP thời gian thực.
6. Chạy lại tấn công để chứng minh các giải pháp đã vô hiệu hóa hoàn toàn các mối đe dọa.

---

## 2. Đối Tượng và Phạm Vi Nghiên Cứu

* **Đối tượng:** Các giao thức ARP, DNS, DHCP, ICMP, HTTP/HTTPS; các kỹ thuật tấn công MitM; cơ chế phòng vệ DAI, DHCP Snooping, HSTS, VPN.
* **Phạm vi:** Triển khai trên môi trường phòng thử nghiệm mạng an toàn độc lập (VLAN 10: `192.168.10.0/24`).

---

## 3. Nội Dung Chi Tiết Của Đề Tài

### PHẦN MỞ ĐẦU
- Tính cấp thiết, mục tiêu, đối tượng, phương pháp và ý nghĩa khoa học của đề tài.

### CHƯƠNG 1: TỔNG QUAN VÀ CƠ SỞ LÝ THUYẾT VỀ TẤN CÔNG MAN-IN-THE-MIDDLE
- 1.1 Khái niệm cơ bản về Man-in-the-Middle (MitM).
- 1.2 Mục tiêu của kẻ tấn công: Nghe lén, đánh cắp định danh, sửa đổi dữ liệu, DoS có chọn lọc.
- 1.3 Phân loại các pha tấn công: Pha dẫn đường và pha khai thác nội dung.
- 1.4 Điểm yếu cố hữu của các giao thức mạng: ARP (RFC 826), DNS (RFC 1035), DHCP (RFC 2131), HTTP bản rõ.
- 1.5 So sánh mô hình truyền thông bình thường và khi bị MitM can thiệp.

### CHƯƠNG 2: CÁC KỸ THUẬT KHAI THÁC VÀ DẪN ĐƯỜNG TRONG TẤN CÔNG MITM
- 2.1 Các kỹ thuật dẫn đường lưu lượng:
  + 2.1.1 ARP Spoofing / ARP Cache Poisoning (đầu độc hai chiều, Gratuitous ARP).
  + 2.1.2 DNS Spoofing / DNS Cache Poisoning (bắt truy vấn UDP 53, trả về IP giả mạo).
  + 2.1.3 DHCP Spoofing (Rogue DHCP Server kết hợp DHCP Starvation).
  + 2.1.4 ICMP Redirect (thông điệp ICMP Type 5 ép đổi Next-hop).
  + 2.1.5 Rogue AP (Evil Twin / Karma, thu hút thiết bị Wi-Fi).
  + 2.1.6 SSL Stripping (bóc tách HTTPS thành HTTP, vượt qua kiểm tra cơ bản).
- 2.2 Các kiểu tấn công vào phiên và dữ liệu người dùng:
  + 2.2.1 Chiếm đoạt phiên làm việc (Session Hijacking).
  + 2.2.2 Đánh cắp Cookie xác thực (Cookie thiếu cờ `Secure`, `HttpOnly`).
  + 2.2.3 Giả mạo nội dung (Content Tampering / Malicious JavaScript Injection).
- 2.3 Ma trận so sánh các kỹ thuật dẫn đường.

### CHƯƠNG 3: GIẢI PHÁP PHÒNG CHỐNG VÀ THỰC NGHIỆM KIỂM CHỨNG
- 3.1 Các giải pháp phòng chống MitM:
  + 3.1.1 HTTPS và cơ chế HSTS (RFC 6797) triệt tiêu SSL Stripping.
  + 3.1.2 Chứng chỉ số PKI và xác thực danh tính máy chủ.
  + 3.1.3 Kỹ thuật DHCP Snooping trên Switch và xây dựng Binding Database.
  + 3.1.4 Kỹ thuật Dynamic ARP Inspection (DAI) trên Switch ngăn chặn ARP Poisoning.
  + 3.1.5 Mạng riêng ảo (VPN WireGuard/IPsec) mã hóa đầu cuối.
  + 3.1.6 Hệ thống giám sát và cảnh báo ARP bất thường thời gian thực.
- 3.2 Thiết kế mô hình phòng thử nghiệm (Testbed Lab 5 thành phần).
- 3.3 Kịch bản thực nghiệm tấn công trước khi phòng vệ (PoC):
  + Thực nghiệm ARP Poisoning + bắt mật khẩu HTTP qua Wireshark.
  + Thực nghiệm DNS Spoofing chuyển hướng về trang web lừa đảo.
  + Thực nghiệm SSL Stripping đánh cắp Cookie phiên.
- 3.4 Triển khai giải pháp phòng vệ và kiểm chứng vô hiệu hóa tấn công:
  + Cấu hình HTTPS/HSTS trên Nginx $\rightarrow$ Chạy lại SSL Stripping $\rightarrow$ Thất bại.
  + Cấu hình DHCP Snooping trên Switch $\rightarrow$ Chạy lại Rogue DHCP $\rightarrow$ Bị Drop.
  + Cấu hình Dynamic ARP Inspection $\rightarrow$ Chạy lại ARP Poisoning $\rightarrow$ Bị Drop, log lỗi.
  + Thiết lập VPN WireGuard $\rightarrow$ Chạy lại Sniffing $\rightarrow$ Dữ liệu mã hóa 100\%.
  + Vận hành công cụ giám sát ARP $\rightarrow$ Phát hiện và cảnh báo tức thì.
- 3.5 Bảng đối sánh kết quả định lượng thực nghiệm trước và sau phòng vệ.

### CHƯƠNG 4: KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN
- 4.1 Đánh giá kết quả đạt được.
- 4.2 Những đóng góp chính của đề tài.
- 4.3 Những hạn chế còn tồn tại.
- 4.4 Hướng phát triển trong tương lai (IPv6 MitM, Machine Learning IDS, SDN).

---

## 4. Dự Kiến Sản Phẩm Bàn Giao

1. Quyển báo cáo toàn văn chuẩn LaTeX (40 trang).
2. Bộ slide Beamer LaTeX thuyết trình bảo vệ (22 trang).
3. Thư mục mã nguồn `code/` chứa đầy đủ script PoC tấn công và cấu hình phòng thủ.
4. Thư mục `thuc-nghiem/` chứa log mẫu và bảng số liệu định lượng.
5. Trang Web Docsify trực quan theo dõi tiến độ.
