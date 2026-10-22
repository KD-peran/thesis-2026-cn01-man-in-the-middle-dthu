# RUBRIC VÀ TIÊU CHÍ ĐÁNH GIÁ NIÊN LUẬN (KHOA CN&KT — DTHU)

Tài liệu này tích hợp chuẩn đánh giá chính thức theo **Phiếu chấm điểm niên luận CNPM / MMT&AN** (Ban hành năm 2026 bởi Bộ môn Khoa học Máy tính — Khoa Công nghệ và Kỹ thuật, Trường Đại học Đồng Tháp) và hướng dẫn chi tiết giúp sinh viên đạt kết quả tối đa.

---

## 1. BẢNG ĐIỂM CHÍNH THỨC CỦA HỘI ĐỒNG (THANG ĐIỂM 10)

| TT | Nhóm tiêu chí đánh giá | Tiêu chí chi tiết | Điểm tối đa | Minh chứng đề tài MitM cần đáp ứng |
|:---:|:---|:---|:---:|:---|
| **1** | **QUYỂN BÁO CÁO** | **Hình thức:**<br>• Đúng mẫu quy định năm 2026 (lề 3-2-2-2 cm, Times 13pt, giãn dòng 1.3, giãn đoạn 6pt).<br>• Bìa chính (không tên GVHD), bìa lót (có tên GVHD).<br>• Đầy đủ mục lục, danh mục hình, danh mục bảng biểu.<br>• Tài liệu tham khảo đúng chuẩn IEEE/BibLaTeX. | **1.0 đ** | Báo cáo biên dịch qua LaTeX (`khoa-luan.pdf`), 100% khớp danh mục tài liệu tham khảo với file `.bib`, không có trích dẫn mồ côi. |
| | | **Nội dung:**<br>• Cấu trúc 3 phần logic: Mở đầu, Nội dung (4 chương), Kết luận.<br>• Kiến thức chuyên sâu: Phân tích tường tận cơ chế tấn công MitM, 6 kỹ thuật dẫn đường, điểm yếu giao thức TCP/IP.<br>• Kết luận: Kết quả đạt được, hạn chế trung thực, hướng phát triển tương lai. | **3.0 đ** | Trình bày chi tiết lý thuyết ARP, DNS, DHCP, HTTP, SSL/TLS, Dynamic ARP Inspection (DAI), DHCP Snooping, HSTS, VPN. |
| **2** | **SẢN PHẨM** | **Giao diện đẹp:**<br>• Thân thiện, trực quan, dễ thao tác.<br>• Phù hợp chức năng mô phỏng tấn công và giám sát an ninh.<br>• Màu sắc hài hòa, cảnh báo rõ ràng. | **1.0 đ** | Trang tài liệu web Docsify trực quan, dashboard giám sát mạng và giao diện web demo DVWA sinh động. |
| | | **Demo / Mô hình:**<br>• Chức năng đáp ứng đầy đủ yêu cầu kịch bản đề tài.<br>• Ít lỗi, chạy ổn định, tin cậy cao.<br>• Sáng tạo: Phát triển công cụ tự động hóa phát hiện tấn công. | **3.0 đ** | Testbed Lab 5 node (Kali, 2 Victim, Gateway, Web Server); demo PoC thành công và cấu hình phòng thủ trên Switch Cisco, Nginx HTTPS/HSTS, WireGuard VPN. |
| **3** | **TRÌNH BÀY BÁO CÁO** | **Thuyết trình:**<br>• Mạch lạc, rõ ràng, tự tin, đúng thời lượng quy định.<br>• Slide Beamer LaTeX chuyên nghiệp, sơ đồ mạng trực quan.<br>• Trả lời thuyết phục các câu hỏi chất vấn của Hội đồng. | **2.0 đ** | Slide bảo vệ 22 slide (`slide-bao-ve.pdf`), giải thích rành mạch cơ chế bắt gói tin và giải pháp chặn đứng tại Switch tầng 2. |
| | **TỔNG ĐIỂM** | *(Thang điểm 10.0)* | **10.0 đ** | |
| | **ĐIỂM CỘNG** | *(Dành cho sản phẩm xuất sắc hoặc bài báo khoa học)* | **1.0 đ** | Tối đa 1.0 điểm cộng thưởng cho công trình chất lượng vượt trội. |

---

## 2. HƯỚNG DẪN ĐẠT ĐIỂM TỐI ĐA CHO TỪNG TIÊU CHÍ

### Tiêu chí 1: Quyển báo cáo (4.0 điểm)
* **Hình thức (1.0 đ):** Sử dụng hệ thống biên dịch `latex/khoa-luan.tex` với cấu hình lề và font chữ chuẩn hóa từ `05_Huong_dan_trinh_bay_bao_cao_2026.md`. Đảm bảo các bảng biểu có tiêu đề bên trên và hình ảnh có tiêu đề bên dưới.
* **Nội dung (3.0 đ):** Viết đầy đủ 4 chương theo cấu trúc logic: Cơ sở lý thuyết -> Kỹ thuật dẫn đường -> Giải pháp phòng thủ & Thực nghiệm -> Kết luận & Hướng phát triển.

### Tiêu chí 2: Sản phẩm thực nghiệm (4.0 điểm)
* **Mô hình Testbed (3.0 đ):** Triển khai đầy đủ môi trường ảo hóa Docker compose gồm Web Server Nginx, ứng dụng DVWA, và các máy trạm nạn nhân.
* **Khai thác PoC & Phòng thủ:** Chạy thành công các script `arp_spoof.py`, `dns_spoof.py`, SSL Stripping và kịch bản phòng thủ Switch Cisco DAI (`cisco_dai_dhcp_snooping.cfg`), Nginx HSTS (`nginx_https_hsts.conf`), VPN Client (`wireguard_vpn_client.conf`).
* **Tính sáng tạo (1.0 đ):** Cung cấp công cụ daemon Python `arp_monitor_detector.py` giám sát ARP flapping độc lập.

### Tiêu chí 3: Trình bày và phản biện (2.0 điểm)
* Sử dụng file `slide-bao-ve.pdf` (22 trang slide) được biên soạn bằng LaTeX Beamer.
* Tập trung nêu bật: Vấn đề -> Giải pháp kỹ thuật -> Kết quả đo kiểm định lượng trước/sau phòng thủ.
