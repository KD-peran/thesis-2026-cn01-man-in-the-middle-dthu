# AGENTS.md

Tài liệu cấu hình và quy chuẩn hoạt động của hệ thống Agent & Subagent trong dự án Nghiên cứu Niên luận / Khóa luận tốt nghiệp.

---

## 1. Thông Tin Học Vụ Chuẩn Định

* **Tên đề tài:** **Nghiên cứu kỹ thuật khai thác và phòng chống tấn công Man-in-the-Middle**
* **Mã số đề tài:** `2026.MITM.01`
* **Sinh viên thực hiện:** **Nguyễn Thị Kỳ Duyên** (MSSV: `0023410647` — Lớp: `ĐHCNTT23B-CS`)
* **Giảng viên hướng dẫn:** **ThS. Trịnh Lê Hoàng Tuấn**
* **Cơ sở đào tạo:** Trường Đại học Đồng Tháp (DTHU) — Khoa Công nghệ và Kỹ thuật
* **Ngành / Chuyên ngành:** Khoa học máy tính / Mạng Máy Tính và An Ninh (Khóa 2023 – 2027)

Mọi Agent và Subagent khi sinh nội dung báo cáo, slide hoặc tài liệu kỹ thuật bắt buộc phải tuân thủ nghiêm ngặt các thông tin học vụ trên.

---

## 2. Ba Quy Tắc Chống Bịa (Liêm Chính Học Thuật)

1. **Không bịa số liệu đo kiểm:** Mọi con số trong báo cáo và slide phải đối chiếu chính xác từ dữ liệu thực nghiệm trong `thuc-nghiem/` (tệp `bang_so_sanh_truoc_sau_phong_thu.md` và các file log bắt gói tin thực tế). Chưa đo thì để ô `TODO` và nêu rõ là đang thiếu, tuyệt đối không ước lượng hoặc lấy số cho có.
2. **Không bịa tài liệu tham khảo:** Không tự ý thêm nguồn không có thật vào `latex/tai-lieu-tham-khao.bib`. Mọi tiêu chuẩn RFC (RFC 826, RFC 1035, RFC 2131, RFC 6797, RFC 8446), sách giáo trình an ninh mạng chuẩn (Kurose & Ross, Stallings, Moxie Marlinspike, Cisco DAI Guide) phải chính xác thông tin xuất bản, tác giả, năm và DOI/URL.
3. **Không bịa dữ liệu học vụ:** Mọi thông tin về Trường, Khoa, Ngành, Lớp, MSSV, Giảng viên hướng dẫn phải đối chiếu chuẩn 100% từ bảng cấu hình hoặc `thu-tuc-khoa/de-cuong-khoa-luan.md`. Tuyệt đối không dùng mẫu của trường khác.

---

## 3. Kỷ Luật Git Nghiêm Cấm Tự Động Push

* Trợ lý AI có thể tạo commit cục bộ (`git commit`) khi hoàn thành các đơn vị công việc logic rõ ràng.
* **TUYỆT ĐỐI NGHIÊM CẤM tự ý chạy `git push`** lên remote repository (`origin`). Thao tác push bắt buộc phải do người dùng tự làm hoặc có lệnh yêu cầu rõ ràng từ người dùng.

---

## 4. Định Hướng Trọng Tâm Cốt Lõi (Scope Boundary - Chống Lệch Đề)

* **Trọng tâm 1 (Kỹ thuật then chốt - 100% công sức):**
  * Nghiên cứu cơ sở lý thuyết tấn công Man-in-the-Middle (MitM) và điểm yếu các giao thức mạng.
  * Phân tích 6 kỹ thuật dẫn đường: **ARP Spoofing/Poisoning**, **DNS Spoofing**, **DHCP Spoofing (Rogue DHCP Server)**, **ICMP Redirect**, **Rogue AP**, và **SSL Stripping**.
  * Phân tích các kỹ thuật tấn công phiên và dữ liệu: **Session Hijacking**, **Đánh cắp Cookie xác thực**, và **Giả mạo nội dung (Content Tampering / Malicious JavaScript Injection)**.
* **Trọng tâm 2 (Phòng thủ đa lớp & Kiểm chứng định lượng):**
  * Xây dựng mô hình Testbed Lab 5 thành phần (Kali Linux, 02 máy nạn nhân, Gateway, Web Server).
  * Triển khai giải pháp phòng thủ: **HTTPS/HSTS (RFC 6797)**, **Dynamic ARP Inspection (DAI)**, **DHCP Snooping**, **VPN WireGuard**, và **giám sát ARP bất thường**.
  * Chạy lại các đợt tấn công để chứng minh bị vô hiệu hóa hoàn toàn, lập bảng đối sánh định lượng trước/sau.

---

## 5. Quy Chuẩn Soạn Thảo Markdown

1. Mỗi tệp Markdown chỉ có duy nhất **1 tiêu đề cấp một (`#`)**, mở đầu ngay sau đó bằng hộp trích dẫn `> **Mục đích:** ...`.
2. **Ký hiệu toán học & mũi tên:** Tuyệt đối KHÔNG viết mã LaTeX thô như `$\rightarrow$`, `$\approx$`, `$\pm$`. BẮT BUỘC dùng ký tự Unicode trực tiếp: `→`, `⟶`, `←`, `↔`, `≈`, `±`, `≤`, `≥`, `×` để Docsify và GitHub hiển thị sắc nét.

---

## 6. Danh Sách Agent Chuyên Trách

### 6.1. Agent Cố vấn Đề cương (`co-van-de-cuong`)
* **Vai trò:** Định hướng phương pháp luận, rà soát tính khả thi kỹ thuật của mô hình tấn công và giải pháp phòng thủ MitM đề xuất.
* **Nguyên tắc:** Phản biện khoa học, đưa ra gợi ý và tiêu chí so sánh, không quyết định thay sinh viên.

### 6.2. Agent Soạn thảo Chương Báo cáo (`soan-chuong-bao-cao`)
* **Vai trò:** Chắp bút và chuẩn hóa nội dung các chương báo cáo học thuật từ cơ sở lý thuyết, phân tích kỹ thuật dẫn đường đến giải pháp phòng vệ đa lớp.
* **Đảm bảo:** Trích dẫn tài liệu tham khảo chính xác theo chuẩn BibLaTeX trong `latex/tai-lieu-tham-khao.bib`, đồng bộ chuẩn hóa mã nguồn LaTeX (`latex/chuong/`) và ấn phẩm xuất bản.

### 6.3. Agent Rà soát Trước nộp (`ra-soat-truoc-nop`)
* **Vai trò:** Kiểm định chất lượng toàn diện trước các mốc báo cáo tiến độ và trước ngày bảo vệ đề tài chính thức.
* **Đảm bảo:** Đối chiếu nội dung báo cáo với Rubric chấm điểm của Khoa Công nghệ và Kỹ thuật (`huong-dan/rubric-cham-khoa-luan.md`), kiểm tra tính toàn vẹn của mã nguồn PoC và số liệu thực nghiệm.
