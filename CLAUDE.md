# CLAUDE.md

Hướng dẫn cho Claude Code / Trợ lý AI khi làm việc trên repository này.

## Sứ Mệnh & Thông Tin Học Vụ Chuẩn

Đây là kho của **đề tài nghiên cứu Niên luận / Khóa luận chuyên ngành** Mạng Máy Tính và An Ninh, Khoa Công nghệ và Kỹ thuật, Trường Đại học Đồng Tháp:
- **Tên đề tài:** **Nghiên cứu kỹ thuật khai thác và phòng chống tấn công Man-in-the-Middle**
- **Mã số đề tài:** `2026.MITM.01`
- **Sinh viên thực hiện:** **Nguyễn Thị Kỳ Duyên** (MSSV: `0023410647` — Lớp: `ĐHCNTT23B-CS`)
- **Giảng viên hướng dẫn:** **TS. Lương Thái Ngọc**
- **Cơ sở đào tạo:** Trường Đại học Đồng Tháp (DTHU) — Khoa Công nghệ và Kỹ thuật
- **Khóa đào tạo:** 2023 – 2027 (Thời gian thực hiện: Năm học 2026 – 2027)

---

## Ba Quy Tắc Chống Bịa (Liêm Chính Học Thuật)

Đây là những quy tắc bất biến quan trọng nhất. Vi phạm một trong ba là lỗi liêm chính học thuật:

1. **Không bịa số liệu đo kiểm:** Mọi con số trong báo cáo và slide phải đối chiếu chính xác từ dữ liệu thực nghiệm trong `thuc-nghiem/` (tệp `bang_so_sanh_truoc_sau_phong_thu.md` và các log thực tế). Chưa đo thì để ô `TODO` và nêu rõ là đang thiếu, tuyệt đối không ước lượng hoặc lấy số cho có.
2. **Không bịa tài liệu tham khảo:** Không tự ý thêm nguồn không có thật vào `latex/tai-lieu-tham-khao.bib`. Mọi chuẩn RFC (RFC 826, RFC 1035, RFC 2131, RFC 6797, RFC 8446), sách giáo trình chuẩn (Kurose & Ross, Stallings, Moxie Marlinspike, Cisco DAI Guide) phải chính xác thông tin xuất bản, tác giả, năm và DOI/URL.
3. **Không bịa dữ liệu học vụ:**
   - Cơ sở đào tạo duy nhất: **Trường Đại học Đồng Tháp (DTHU) — Khoa Công nghệ và Kỹ thuật**.
   - Sinh viên thực hiện: **Nguyễn Thị Kỳ Duyên** (MSSV: `0023410647` — Lớp: `ĐHCNTT23B-CS`).
   - Giảng viên hướng dẫn: **TS. Lương Thái Ngọc**.
   - Ngành / Chuyên ngành: **Khoa học máy tính / Mạng Máy Tính và An Ninh** (Khóa 2023 – 2027).
   - Tuyệt đối KHÔNG suy đoán, không sử dụng tên trường khác. Mọi thông tin học vụ bắt buộc đối chiếu với `thu-tuc-khoa/de-cuong-khoa-luan.md`.

---

## Kỷ Luật Git Nghiêm Cấm Tự Động Push

- Trợ lý AI có thể tạo commit cục bộ (`git commit`) khi hoàn thành các đơn vị công việc logic rõ ràng.
- **TUYỆT ĐỐI NGHIÊM CẤM tự ý chạy `git push`** lên remote repository (`origin`). Thao tác push bắt buộc phải do người dùng tự làm hoặc có lệnh yêu cầu rõ ràng từ người dùng.

---

## Định Hướng Trọng Tâm Cốt Lõi (Scope Boundary - Chống Lệch Đề)

- **Trọng tâm 1 (Kỹ thuật then chốt - 100% công sức):**
  - Nghiên cứu cơ sở lý thuyết tấn công Man-in-the-Middle (MitM).
  - Phân tích 6 kỹ thuật dẫn đường: **ARP Spoofing/Poisoning**, **DNS Spoofing**, **DHCP Spoofing (Rogue DHCP Server)**, **ICMP Redirect**, **Rogue AP**, và **SSL Stripping**.
  - Phân tích các kỹ thuật tấn công phiên và dữ liệu: **Session Hijacking**, **Đánh cắp Cookie xác thực**, và **Giả mạo nội dung (Content Tampering / Malicious JavaScript Injection)**.
- **Trọng tâm 2 (Phòng thủ đa lớp & Kiểm chứng định lượng):**
  - Xây dựng mô hình Testbed Lab 5 thành phần (Kali Linux, 02 máy nạn nhân, Gateway, Web Server).
  - Triển khai giải pháp phòng thủ: **HTTPS/HSTS (RFC 6797)**, **Dynamic ARP Inspection (DAI)**, **DHCP Snooping**, **VPN WireGuard**, và **giám sát ARP bất thường**.
  - Chạy lại các đợt tấn công để chứng minh bị vô hiệu hóa hoàn toàn, lập bảng đối sánh định lượng trước/sau.

---

## Quy Chuẩn Soạn Thảo Markdown

1. Mỗi tệp Markdown chỉ có duy nhất **1 tiêu đề cấp một (`#`)**, mở đầu ngay sau đó bằng hộp trích dẫn `> **Mục đích:** ...`.
2. **Ký hiệu toán học & mũi tên:** Tuyệt đối KHÔNG viết mã LaTeX thô như `$\rightarrow$`, `$\approx$`, `$\pm$`. BẮT BUỘC dùng ký tự Unicode trực tiếp: `→`, `⟶`, `←`, `↔`, `≈`, `±`, `≤`, `≥`, `×` để Docsify và GitHub hiển thị sắc nét.

---

## Điều Hướng Cấu Trúc Toàn Repo

| Loại nội dung | Thư mục |
|:---|:---|
| **Báo cáo LaTeX toàn văn** | `latex/khoa-luan.tex` và các chương trong `latex/chuong/` |
| **Slide Beamer bảo vệ** | `latex/slide-bao-ve.tex` |
| **Mã nguồn PoC & Phòng thủ** | `code/` (`lab-setup/`, `attacks/`, `defense/`) |
| **Tài liệu Web Docsify** | `docs/` (`reports/`, `research/`, `system-diagrams.md`) |
| **Dữ liệu thực nghiệm** | `thuc-nghiem/` (`du-lieu/`, `ket-qua/`) |
| **Hồ sơ thủ tục khoa** | `thu-tuc-khoa/` (`1.Don-dang-ky-de-tai.md`, `de-cuong-khoa-luan.md`) |
