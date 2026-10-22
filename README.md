# Nghiên Cứu Kỹ Thuật Khai Thác Và Phòng Chống Tấn Công Man-in-the-Middle

## Mục đích

Kho tài liệu, kịch bản thực nghiệm tấn công (Proof-of-Concept), bộ cấu hình phòng thủ đa lớp và công cụ tự động hóa phục vụ đề tài nghiên cứu chuyên ngành Mạng Máy Tính và An Ninh, Khoa Công nghệ và Kỹ thuật, Trường Đại học Đồng Tháp.

**Tên đề tài đầy đủ:** **Nghiên cứu kỹ thuật khai thác và phòng chống tấn công Man-in-the-Middle**

---

## Bắt đầu từ đâu

Năm bước khởi đầu cho sinh viên và người cộng tác:

1. **Khai báo danh tính Git (nếu làm việc trên kho Git):**

   ```bash
   git config user.name "Nguyen Thi Ky Duyen"
   git config user.email "0023410647@student.dthu.edu.vn"
   ```

2. **Đọc hồ sơ thủ tục và đề cương đã duyệt:**
   - Đề cương chi tiết: [thu-tuc-khoa/de-cuong-khoa-luan.md](thu-tuc-khoa/de-cuong-khoa-luan.md).
   - Đơn đăng ký đề tài: [thu-tuc-khoa/1.Don-dang-ky-de-tai.md](thu-tuc-khoa/1.Don-dang-ky-de-tai.md).
   - Kế hoạch tiến độ thực hiện: [thu-tuc-khoa/2.Ke-hoach-thuc-hien.md](thu-tuc-khoa/2.Ke-hoach-thuc-hien.md).

3. **Nắm rõ quy chế và rubric chấm điểm:**
   - Rubric chấm điểm: [huong-dan/rubric-cham-khoa-luan.md](huong-dan/rubric-cham-khoa-luan.md).

4. **Khởi chạy tài liệu trực quan (Docsify Web Dashboard):**
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\tool.ps1 1
   ```

5. **Đọc quy chuẩn phối hợp và công cụ:** [CLAUDE.md](CLAUDE.md) và [CONTRIBUTING.md](CONTRIBUTING.md).

---

## Thông tin đề tài chuẩn xác

| Mục | Nội dung |
|:---|:---|
| **Mã đề tài** | `2026.MITM.01` |
| **Tên đề tài** | **Nghiên cứu kỹ thuật khai thác và phòng chống tấn công Man-in-the-Middle** |
| **Sinh viên thực hiện** | **Nguyễn Thị Kỳ Duyên** |
| **Mã số sinh viên** | `0023410647` |
| **Lớp sinh hoạt** | `ĐHCNTT23B-CS` |
| **Ngành / Chuyên ngành** | Khoa học máy tính / Mạng Máy Tính và An Ninh |
| **Khóa đào tạo** | `2023 – 2027` |
| **Giáo viên hướng dẫn** | **TS. Lương Thái Ngọc** |
| **Cơ sở đào tạo** | Khoa Công nghệ và Kỹ thuật — Trường Đại học Đồng Tháp (DTHU) |
| **Thời gian thực hiện** | Năm học 2026 — 2027 |

---

## Bài toán kỹ thuật

Trong kiến trúc mạng TCP/IP, các giao thức sơ khai (ARP, DNS, DHCP, HTTP) được thiết kế không có cơ chế xác thực nguồn gốc và kiểm tra toàn vẹn gói tin:
1. **Lỗ hổng phân giải địa chỉ ARP (RFC 826):** Bản tin ARP không có trạng thái, chấp nhận cập nhật tự nguyện (Gratuitous ARP) khiến kẻ tấn công dễ dàng đầu độc ARP Cache hai chiều.
2. **Lỗ hổng phân giải tên miền DNS (RFC 1035):** Thiếu cơ chế ký số nguồn gốc, kẻ tấn công đứng ở giữa có thể giả mạo bản ghi DNS để chuyển hướng người dùng đến máy chủ lừa đảo.
3. **Lỗ hổng cấp phát địa chỉ DHCP (RFC 2131):** Thiếu kiểm soát cổng, Rogue DHCP Server có thể cấp phát Gateway giả mạo cho toàn bộ mạng LAN.
4. **Hạ cấp giao thức bảo mật (SSL Stripping):** Kẻ tấn công bóc tách các liên kết HTTPS thành HTTP bản rõ để thu thập thông tin tài khoản, Cookie phiên (`PHPSESSID`) và can thiệp sửa đổi nội dung trang web.

---

## Giải pháp và Phạm vi

### Trong phạm vi nghiên cứu:
- Xây dựng mô hình phòng thử nghiệm an toàn độc lập (Testbed Lab) gồm 5 thành phần: 01 Kali Linux (Attacker), 02 máy nạn nhân (Victim 1 - Windows, Victim 2 - Linux), 01 Gateway/Router và 01 Web Server Nginx.
- Triển khai kịch bản tấn công PoC: ARP Poisoning hai chiều, DNS Spoofing, SSL Stripping, đánh cắp mật khẩu và Cookie phiên, giả mạo nội dung trang web.
- Triển khai giải pháp phòng thủ đa lớp (Defense-in-Depth):
  - **HTTPS / HSTS (RFC 6797):** Bắt buộc trình duyệt chỉ kết nối HTTPS, vô hiệu hóa SSL Stripping.
  - **Dynamic ARP Inspection (DAI):** Switch kiểm tra gói tin ARP đối chiếu với DHCP Snooping Binding Table, Drop lập tức gói ARP giả mạo.
  - **DHCP Snooping:** Phân chia cổng Trusted / Untrusted trên Switch, loại bỏ Rogue DHCP Server.
  - **Mạng riêng ảo (VPN WireGuard):** Mã hóa toàn bộ dữ liệu tầng mạng, bảo vệ dữ liệu trước mọi hành vi nghe lén.
  - **Phát hiện ARP bất thường:** Công cụ Python tự động cảnh báo xung đột MAC-IP theo thời gian thực.
- Chạy lại các cuộc tấn công để kiểm chứng tính năng phòng vệ và lập bảng đối sánh định lượng trước/sau.

### Ngoài phạm vi đề tài:
- Không tiến hành tấn công vào các hệ thống mạng thực tế đang vận hành của Nhà trường hoặc cơ quan khi chưa được cấp thẩm quyền.

---

## Cấu trúc Repository

```text
thesis-2026-cn01-man-in-the-middle-dthu/
├── AGENTS.md                 # Quy tắc làm việc cho các trợ lý AI
├── CLAUDE.md                 # Hướng dẫn chi tiết cho Claude Code và liêm chính học thuật
├── CONTRIBUTING.md           # Quy định đóng góp, commit và kỷ luật Git
├── Cau-truc-toan-repo.md     # Bản đồ cấu trúc toàn bộ repository
├── README.md                 # Trang tổng quan đề tài và hướng dẫn vận hành (Tệp này)
├── build.ps1                 # Script build nhanh khóa luận LaTeX từ thư mục gốc
├── tool.ps1                  # Trung tâm điều khiển toàn bộ công cụ dự án (CLI Hub 1-chạm)
│
├── docs/                     # TRANG TÀI LIỆU WEB & DASHBOARD TIẾN ĐỘ (DOCSIFY)
│   ├── index.html            # Điểm neo máy chủ web Docsify cực đẹp
│   ├── system-diagrams.md    # Tổng hợp sơ đồ kiến trúc & luồng tấn công bằng Mermaid
│   ├── publications.md       # Đọc và tải ấn phẩm PDF chính thức
│   ├── reports/              # Báo cáo tiến độ tuần dạng tóm tắt đúng 3 mục
│   ├── research/             # Nghiên cứu chuyên sâu WHAT / WHY / HOW
│   └── downloads/            # Chứa bản sao PDF (khoa-luan.pdf, slide-bao-ve.pdf)
│
├── latex/                    # ẤN PHẨM KHÓA LUẬN CHÍNH THỨC (LATEX CHUẨN XUẤT BẢN)
│   ├── khoa-luan.tex         # Master LaTeX file điều phối toàn bộ báo cáo
│   ├── slide-bao-ve.tex      # Beamer LaTeX slide thuyết trình bảo vệ
│   ├── tai-lieu-tham-khao.bib# Danh mục BibTeX tài liệu tham khảo chuẩn quốc tế
│   ├── chuong/               # File .tex các chương 1, 2, 3, 4, mở đầu, cam đoan, phụ lục
│   ├── outputs/              # File PDF đầu ra: khoa-luan.pdf (40 trang), slide-bao-ve.pdf (22 trang)
│   └── scripts/              # Script biên dịch tự động pdflatex + biber (build.ps1 / build.sh)
│
├── code/                     # MÃ NGUỒN TOÀN BỘ HỆ THỐNG
│   ├── README.md             # Hướng dẫn kiến trúc, biến môi trường, cách chạy
│   ├── lab-setup/            # Kịch bản Docker Compose và Switch Cisco
│   ├── attacks/              # Kịch bản tấn công PoC (arp_spoof.py, dns_spoof.py, ssl_strip...)
│   └── defense/              # Cấu hình phòng thủ (Cisco DAI, Nginx HSTS, WireGuard, ARP Monitor)
│
├── thu-tuc-khoa/             # HỒ SƠ HỌC VỤ & THỦ TỤC KHOA
│   ├── 1.Don-dang-ky-de-tai.md
│   ├── 2.Ke-hoach-thuc-hien.md
│   └── de-cuong-khoa-luan.md # Đề cương chi tiết đã duyệt (Single Source of Truth)
│
└── thuc-nghiem/              # DỮ LIỆU ĐO KIỂM THỰC NGHIỆM ĐỊNH LƯỢNG
    ├── du-lieu/              # File nhật ký lưu vết (arp poisoning log, DAI switch log, credentials)
    └── ket-qua/              # Bảng ma trận đối sánh trước và sau khi kích hoạt giải pháp
```

---

## Lệnh hay dùng (Tool Launcher Hub)

### 1. Trung tâm điều khiển chính (Khuyên dùng):
Chạy menu tương tác 1-chạm:
```powershell
powershell -ExecutionPolicy Bypass -File .\tool.ps1
```

Các phím tắt trực tiếp:
- `.\tool.ps1 1` : Mở máy chủ Docsify xem tài liệu trên localhost:3000
- `.\tool.ps1 2` : Biên dịch Báo cáo toàn văn (`khoa-luan.tex` $\rightarrow$ `outputs/khoa-luan.pdf`)
- `.\tool.ps1 3` : Biên dịch Slide Beamer bảo vệ (`slide-bao-ve.tex` $\rightarrow$ `outputs/slide-bao-ve.pdf`)
- `.\tool.ps1 4` : Kiểm tra đối chiếu trích dẫn BibTeX
- `.\tool.ps1 5` : Biên dịch toàn bộ ấn phẩm và sao chép vào `docs/downloads/`
- `.\tool.ps1 O` : Mở thư mục chứa file PDF trong Windows Explorer

### 2. Biên dịch nhanh bằng `build.ps1`:
```powershell
powershell -ExecutionPolicy Bypass -File .\build.ps1 khoa-luan.tex
powershell -ExecutionPolicy Bypass -File .\build.ps1 slide-bao-ve.tex
```

---

## Liêm Chính Học Thuật

1. **Không bịa số liệu:** Mọi con số trong báo cáo và slide đều truy xuất từ các phép đo thực tế trong `thuc-nghiem/ket-qua/`.
2. **Không bịa tài liệu tham khảo:** 100% tài liệu trích dẫn đều có mặt và đối chiếu chính xác trong `latex/tai-lieu-tham-khao.bib`.
3. **Không tự ý push Git:** Trợ lý AI tuyệt đối không tự ý thực hiện `git push` lên remote repository nếu không có yêu cầu trực tiếp từ người dùng.