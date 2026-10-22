# MASTER PROMPT & FRAMEWORK TÁI LẬP REPOSITORY NGHIÊN CỨU & KHÓA LUẬN KỸ THUẬT

> **Mục đích:** Tệp này chứa toàn bộ **Câu lệnh Master Prompt (Prompt Template)** và **Bộ khung xương chuẩn (Architecture Framework)** được đúc kết từ repository thực tế. Khi bắt đầu một đề tài khóa luận tốt nghiệp, đồ án chuyên ngành, niên luận hay đề tài nghiên cứu khoa học mới, bạn chỉ cần:
> 1. Điền thông tin vào phần **BẢNG BIẾN SỐ CẤU HÌNH (CONFIG)** ở đầu prompt.
> 2. Sao chép (Copy) toàn bộ nội dung trong khung **MASTER PROMPT** bên dưới.
> 3. Dán (Paste) vào trợ lý AI (Claude Code, Antigravity/Gemini CLI, Cursor, ChatGPT, GitHub Copilot...).
> AI sẽ tự động khởi tạo 100% cấu trúc thư mục, quy tắc làm việc, hệ thống tài liệu Web Docsify trực quan (`docs/index.html`), hệ thống ấn phẩm LaTeX chuẩn học thuật (`latex/`), kịch bản điều khiển 1-chạm (`tool.ps1`, `build.ps1`) và quy trình CI/CD tự động!

---

## 📖 Hướng Dẫn Sử Dụng Nhanh (3 Bước)

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│ Bước 1: Mở tệp này, chỉnh sửa các thông tin trong bảng [CẤU HÌNH ĐỀ TÀI MỚI] │
│         (Tên đề tài, Trường, Khoa, Giảng viên, Sinh viên, Trọng tâm 1 & 2...)│
├─────────────────────────────────────────────────────────────────────────────┤
│ Bước 2: Tạo một thư mục dự án mới trên máy tính:                            │
│         mkdir thesis-202X-ten-de-tai && cd thesis-202X-ten-de-tai           │
│         git init                                                            │
├─────────────────────────────────────────────────────────────────────────────┤
│ Bước 3: Copy toàn bộ khối lệnh MASTER PROMPT bên dưới và dán vào AI.       │
│         AI sẽ thiết lập toàn bộ repo theo chuẩn mực cao nhất từ A - Z!      │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

# 🚀 KHỐI LỆNH MASTER PROMPT (COPY TỪ ĐÂY)

```markdown
Bạn là một Kiến trúc sư Hệ thống phần mềm & Cố vấn Nghiên cứu Học thuật cao cấp. 
Nhiệm vụ của bạn là khởi tạo và thiết lập TOÀN BỘ CẤU TRÚC REPOSITORY HOÀN CHỈNH từ thư mục rỗng cho một đề tài nghiên cứu khoa học / khóa luận tốt nghiệp đại học, kế thừa 100% tiêu chuẩn cấu trúc, quy tắc kỷ luật, giao diện xem tài liệu Docsify hiện đại và hệ thống xuất bản LaTeX chuyên nghiệp theo thông tin cấu hình dưới đây:

==============================================================================
[BẢNG CẤU HÌNH ĐỀ TÀI MỚI - NGƯỜI DÙNG CHỈNH SỬA TẠI ĐÂY]
==============================================================================
- TÊN ĐỀ TÀI: [Điền tên đề tài, ví dụ: "Nghiên cứu ứng dụng Blockchain và IoT trong minh bạch hóa dữ liệu kho hàng hóa"]
- CƠ SỞ ĐÀO TẠO: [Điền tên trường, ví dụ: "Trường Đại học Đồng Tháp (DTHU)"]
- KHOA / VIỆN: [Điền tên khoa, ví dụ: "Khoa Công nghệ và Kỹ thuật"]
- NGÀNH / CHUYÊN NGÀNH: [Điền ngành học, ví dụ: "Khoa học máy tính / Mạng máy tính và An ninh"]
- KHÓA HỌC / NĂM BẢO VỆ: [Ví dụ: "Khóa 2023 - 2027 / Bảo vệ năm 2026"]
- SINH VIÊN THỰC HIỆN: [Điền họ tên SV, ví dụ: "Huỳnh Thanh Duy"]
- MÃ SỐ SINH VIÊN (MSSV): [Ví dụ: "0023410957"]
- LỚP SINH HOẠT: [Ví dụ: "ĐHCNTT23B-CS"]
- GIẢNG VIÊN HƯỚNG DẪN: [Điền học hàm học vị + họ tên, ví dụ: "ThS. Lê Minh Hiếu"]
- ĐỊNH HƯỚNG TRỌNG TÂM CỐT LÕI (SCOPE BOUNDARY - CHỐNG LỆCH ĐỀ):
  + TRỌNG TÂM 1 (Kỹ thuật then chốt 100% công sức): [Ví dụ: "Tập trung chuyên sâu vào an toàn kênh truyền lúc gửi từ thiết bị biên IoT lên máy chủ (mTLS X.509, ECDSA ký số, Anti-replay, Store & Forward SQLite)"]
  + TRỌNG TÂM 2 (Phân hệ lưu trữ / bổ trợ bất biến): [Ví dụ: "Ghi dữ liệu hợp lệ từ cơ sở dữ liệu vào 1 bảng sổ cái Blockchain để bảo toàn tính bất biến; không phân tích dàn trải lan man ngoài phạm vi này"]
- DANH SÁCH MODULE MÃ NGUỒN (code/):
  + Module 1: [Ví dụ: "code/iot/ - Thiết bị biên, mô phỏng và bàn thử nghiệm"]
  + Module 2: [Ví dụ: "code/backend/ - Dịch vụ tiếp nhận API, Ingestion, Relayer"]
  + Module 3: [Ví dụ: "code/blockchain/ - Hợp đồng thông minh và kịch bản triển khai"]
==============================================================================

YÊU CẦU BẠN THỰC HIỆN ĐẦY ĐỦ CÁC BƯỚC THIẾT LẬP SAU ĐÂY:

---

### GIAI ĐOẠN 1: TẠO CÂY THƯ MỤC CHUẨN MỰC
Khởi tạo cấu trúc cây thư mục sạch sẽ, phân định trách nhiệm rõ ràng:
```text
thesis-repo/
├── AGENTS.md                                # Quy tắc làm việc cho các trợ lý AI dòng lệnh
├── CLAUDE.md                                # Quy chuẩn làm việc gốc cho Claude Code
├── CONTRIBUTING.md                          # Quy định đóng góp, commit và kỷ luật Git
├── Cau-truc-toan-repo.md                    # Bản đồ cấu trúc toàn bộ repository
├── README.md                                # Trang tổng quan đề tài và hướng dẫn vận hành
├── build.ps1                                # Kịch bản PowerShell build nhanh LaTeX từ root
├── tool.ps1                                 # Menu điều khiển trung tâm tương tác 1-chạm (CLI Hub)
│
├── .github/                                 # Cấu hình GitHub Actions, Scripts & Copilot
│   ├── copilot-instructions.md              # Ràng buộc hành vi cho GitHub Copilot
│   ├── instructions/                        # Quy tắc tự động nạp theo từng thư mục (.instructions.md)
│   ├── scripts/                             # Script Python kiểm tra tính nhất quán trích dẫn
│   │   └── kiem_tra_trich_dan.py
│   └── workflows/                           # CI/CD: Tự động build LaTeX & Deploy Docsify Pages
│       ├── build-latex.yml
│       └── deploy-pages.yml
│
├── .claude/                                 # Hệ thống Subagents, Skills và Slash Commands
│   ├── agents/                              # co-van-de-cuong.md, soan-chuong-bao-cao.md, ra-soat-truoc-nop.md
│   └── skills/                              # viet-chuong-bao-cao, kiem-tra-tai-lieu-tham-khao, viet-bao-cao-tuan, ghi-bien-ban-tuan
│
├── code/                                    # MÃ NGUỒN TOÀN BỘ HỆ THỐNG
│   ├── README.md                            # Hướng dẫn kiến trúc, biến môi trường, cách chạy
│   ├── .env.example                         # Cấu hình mẫu môi trường bí mật
│   └── (các module đã khai báo ở bảng cấu hình)
│
├── bao-cao/                                 # BẢN THẢO BÁO CÁO KHÓA LUẬN (MARKDOWN NGUYÊN BẢN)
│   ├── 00-loi-cam-doan-cam-on.md            # Cam đoan, cảm ơn, tóm tắt tiếng Việt & tiếng Anh
│   ├── 00-loi-mo-dau.md                     # Tính cấp thiết, mục tiêu, đối tượng, phương pháp
│   ├── 00-danh-muc-tu-viet-tat-va-thuat-ngu.md
│   ├── 01-tong-quan-bai-toan-va-co-so-cong-nghe.md
│   ├── 02-phan-tich-va-thiet-ke-he-thong.md
│   ├── 03-hien-thuc-hoa-danh-gia-an-ninh-va-thuc-nghiem.md
│   ├── 04-ket-luan.md                       # Đánh giá kết quả đạt được, hạn chế, hướng phát triển
│   ├── 05-phu-luc.md                        # Hướng dẫn cài đặt, mã nguồn cốt lõi, log mẫu
│   └── tai-lieu-tham-khao.bib               # Danh mục BibTeX tài liệu tham khảo chuẩn quốc tế
│
├── latex/                                   # ẤN PHẨM KHÓA LUẬN CHÍNH THỨC (LATEX CHUẨN XUẤT BẢN)
│   ├── khoa-luan.tex                        # Master LaTeX file điều phối toàn bộ báo cáo
│   ├── slide-bao-ve.tex                     # Beamer LaTeX slide thuyết trình bảo vệ
│   ├── chuong/                              # Modular từng chương (.tex) tương ứng với bao-cao/
│   │   ├── 00-loi-cam-doan-cam-on.tex
│   │   ├── 00-loi-mo-dau.tex
│   │   ├── 01-tong-quan-bai-toan-va-co-so-cong-nghe.tex
│   │   ├── 02-phan-tich-va-thiet-ke-he-thong.tex
│   │   ├── 03-hien-thuc-hoa-danh-gia-an-ninh-va-thuc-nghiem.tex
│   │   ├── 04-ket-luan.tex
│   │   └── 05-phu-luc.tex
│   ├── images/                              # Logo trường, sơ đồ kiến trúc, biểu đồ thực nghiệm
│   ├── scripts/                             # Script biên dịch tự động pdflatex + biber
│   │   ├── build.ps1                        # Cho Windows PowerShell (tự động dọn file rác)
│   │   └── build.sh                         # Cho Linux / macOS / Git Bash
│   └── outputs/                             # Thư mục chứa PDF đầu ra (tự sinh, .gitignore)
│
├── docs/                                    # TRANG TÀI LIỆU WEB & DASHBOARD TIẾN ĐỘ (DOCSIFY)
│   ├── index.html                           # Điểm neo máy chủ web Docsify cực đẹp (hỗ trợ Dark mode, Mermaid, KaTeX)
│   ├── _sidebar.md                          # Menu điều hướng đa cấp Docsify
│   ├── README.md                            # Trang chủ tài liệu web
│   ├── weekly-changelog.md                  # Bảng theo dõi tiến độ tổng hợp các tuần
│   ├── system-diagrams.md                   # Tổng hợp toàn bộ sơ đồ kiến trúc bằng Mermaid
│   ├── publications.md                      # Trang đọc và tải ấn phẩm PDF chính thức
│   ├── reports/                             # Báo cáo tiến độ tuần dạng TÓM TẮT ĐÚNG 3 MỤC (week-01.md, week-02.md...)
│   ├── research/                            # Nghiên cứu chuyên sâu WHAT / WHY / HOW dạng văn nói đọc hiểu (TONG_HOP_*.md)
│   └── downloads/                           # Chứa bản sao PDF để đọc/tải trực tiếp trên trình duyệt
│
├── thu-tuc-khoa/                            # HỒ SƠ HỌC VỤ & THỦ TỤC KHOA
│   ├── 1.Don-dang-ky-de-tai.md              # Đơn đăng ký đề tài chính thức
│   ├── 2.Ke-hoach-thuc-hien.md              # Bảng kế hoạch tiến độ từng tuần nộp khoa
│   └── de-cuong-khoa-luan.md                # Đề cương chi tiết đã duyệt (Single Source of Truth)
│
├── huong-dan/                               # TIÊU CHÍ ĐÁNH GIÁ & HƯỚNG DẪN
│   └── rubric-cham-khoa-luan.md             # Rubric chấm điểm của Hội đồng chấm đề tài
│
└── thuc-nghiem/                             # DỮ LIỆU ĐO KIỂM THỰC NGHIỆM ĐỊNH LƯỢNG
    ├── du-lieu/                             # Lưu vết dữ liệu thô (log, packet, kết quả trần)
    └── ket-qua/                             # Bảng biểu định lượng, so sánh trước/sau khi áp dụng giải pháp
```

---

### GIAI ĐOẠN 2: THIẾT LẬP BỘ QUY TẮC KỶ LUẬT HỌC THUẬT & AI (CLAUDE.md / AGENTS.md)
Tạo file `CLAUDE.md` và `AGENTS.md` ở thư mục gốc chứa các quy tắc bất biến sau:
1. **Ba quy tắc chống bịa (Liêm chính học thuật):**
   - **Không bịa số liệu:** Mọi con số trong báo cáo và slide phải truy xuất được về tệp cụ thể trong `thuc-nghiem/ket-qua/`. Chưa đo thì để ô `TODO` và nêu rõ là đang thiếu, tuyệt đối không ước lượng hoặc lấy số cho có.
   - **Không bịa tài liệu tham khảo:** Không tự ý thêm mục vào file `.bib`. Không bịa tên tác giả, năm xuất bản, mã DOI. Cần tài liệu thì ghi chú rõ ràng là cần tìm.
   - **Không bịa thông tin học vụ:** Mọi thông tin về Trường, Khoa, Ngành, Lớp, MSSV, Giảng viên hướng dẫn phải đối chiếu chuẩn 100% từ bảng cấu hình hoặc `thu-tuc-khoa/de-cuong-khoa-luan.md`. Tuyệt đối không dùng mẫu của trường khác.
2. **Kỷ luật Git nghiêm cấm tự động Push:**
   - Trợ lý AI có thể commit cục bộ (`git commit`) khi hoàn thành công việc, nhưng **TUYỆT ĐỐI NGHIÊM CẤM tự ý chạy `git push`** lên remote repository (`origin`). Thao tác push bắt buộc phải do người dùng tự làm hoặc có lệnh yêu cầu rõ ràng.
3. **Định hướng trọng tâm cốt lõi - Quy tắc chống lệch đề (Scope Boundary):**
   - **Trọng tâm 1:** Dồn 100% công sức nghiên cứu, viết tài liệu và lập trình vào trọng tâm kỹ thuật đã nêu ở bảng cấu hình.
   - **Trọng tâm 2:** Đối với phân hệ bổ trợ (như Blockchain/Cloud...), bản chất nhiệm vụ chỉ là lưu trữ bảo toàn dữ liệu bất biến từ cơ sở dữ liệu đã chuẩn hóa. Tuyệt đối không bàn luận lan man, phân tích dàn trải làm loãng đề tài.
4. **Quy chuẩn Markdown:**
   - Mỗi file chỉ có 1 tiêu đề cấp một (`#`), mở đầu bằng `## Mục đích`.
   - **Ký hiệu toán học & mũi tên:** Tuyệt đối KHÔNG viết mã LaTeX thô như `$\rightarrow$`, `$\approx$`, `$\pm$`. BẮT BUỘC dùng ký tự Unicode trực tiếp: `→`, `⟶`, `←`, `↔`, `≈`, `±`, `≤`, `≥`, `×` để Docsify và GitHub hiển thị sắc nét.

---

### GIAI ĐOẠN 3: THIẾT KẾ QUY CHUẨN THEO DÕI TIẾN ĐỘ TUẦN (DOCS/)
Hệ thống `docs/` phục vụ việc sinh viên và giảng viên theo dõi tiến độ thực tế hàng tuần:

#### 1. Báo cáo tiến độ tuần (`docs/reports/week-*.md`):
Chỉ viết dạng **TÓM TẮT ĐƠN GIẢN ĐÚNG 3 MỤC CHÍNH**, không lan man:
- **Mục 1: Kết quả tuần vừa rồi:** Liệt kê vắn tắt các việc đã hoàn thành và minh chứng/link đối chiếu ngắn gọn.
- **Mục 2: Tóm tắt ngắn về kết quả tuần trước theo từng STT:** Đối chiếu ngắn gọn kết quả thực tế tương ứng với từng STT 1, 2, 3... trong bảng kế hoạch của tuần trước đó.
- **Mục 3: Kế hoạch tuần tiếp theo:** Bảng cô đọng gồm các cột: `STT | Nhiệm vụ cụ thể | Mức ưu tiên (Cao/Vừa) | Hạn hoàn thành | Sản phẩm dự kiến bàn giao`.

#### 2. Báo cáo nghiên cứu chuyên sâu hàng tuần (`docs/research/TONG_HOP_*.md`):
Mỗi tuần đi kèm 1 bài nghiên cứu giải thích cặn kẽ khía cạnh kỹ thuật đã làm:
- **Cấu trúc 3 câu hỏi bắt buộc:**
  + **What (Là gì?):** Bản chất công nghệ, thành phần, cấu trúc dữ liệu hoặc thuật toán là gì?
  + **Why (Tại sao?):** Vì sao phải dùng? Giải quyết vấn đề nhức nhối nào trong thực tế? Rủi ro chí mạng nếu không dùng là gì?
  + **How (Làm như thế nào?):** Các bước hiện thực hóa chi tiết, cấu hình/mã nguồn mẫu có chú thích, phương pháp kiểm thử và đo lường thực nghiệm.
- **Văn phong bắt buộc ("văn nói đọc hiểu dễ nhìn"):**
  + Ngôn từ gần gũi, mang tính giảng giải sư phạm trực quan (như kỹ sư giàu kinh nghiệm giải thích bản chất cho đồng nghiệp, tránh văn phong hàn lâm khô khan).
  + Luôn có ví dụ thực tiễn gắn liền với bài toán của đề tài để minh họa.
  + Trình bày trực quan: Sử dụng hộp ghi chú GitHub-style (`> [!NOTE]`, `> [!TIP]`, `> [!IMPORTANT]`, `> [!WARNING]`), bảng so sánh đa chiều, sơ đồ Mermaid/ASCII và các khối mã nguồn có chú thích từng dòng.

#### 3. Tệp máy chủ Docsify (`docs/index.html`):
Thiết lập trang Single-Page Application dùng Docsify v4 Vue Theme với đầy đủ tính năng:
- Hỗ trợ công thức toán học KaTeX.
- Hỗ trợ vẽ sơ đồ Mermaid trực tiếp từ khối code ````mermaid`.
- Tính năng Search toàn văn, Copy Code nút bấm, Phóng to ảnh (Zoom-image).
- Dark Mode toggle chuyển đổi nền sáng/tối mượt mà.
- Khối xác thực truy cập bảo vệ nội dung học vụ (Auth Gate) qua LocalStorage.
- Liên kết tải trực tiếp các ấn phẩm PDF tại `docs/downloads/`.

---

### GIAI ĐOẠN 4: HỆ THỐNG SOẠN THẢO LATEX CHUẨN XUẤT BẢN (`latex/`)
Thiết lập toàn bộ khung LaTeX cho báo cáo khóa luận (`khoa-luan.tex`) và slide thuyết trình (`slide-bao-ve.tex`):
1. **Gói ngôn ngữ tiếng Việt hoàn chỉnh:**
   - Dùng bảng mã `\usepackage[T5]{fontenc}`, `\usepackage[utf8]{inputenc}`, `\usepackage[vietnamese]{babel}` (chuẩn vntex, tương thích MiKTeX và TeX Live).
2. **Quản lý trích dẫn tài liệu tham khảo hiện đại:**
   - Dùng `\usepackage[backend=biber,style=numeric,sorting=none]{biblatex}` kết hợp `\addbibresource{../bao-cao/tai-lieu-tham-khao.bib}`.
3. **Phân chia mô-đun các chương trong `latex/chuong/`:**
   - Master file `khoa-luan.tex` chỉ việc `\input{chuong/00-...}`, `\input{chuong/01-...}`.
4. **Script biên dịch tự động (`latex/scripts/build.ps1` & `latex/scripts/build.sh`):**
   - Tự động phát hiện MiKTeX/TeX Live trên PATH của Windows/Linux.
   - Tự động chạy quy trình: `pdflatex` → `biber` → `pdflatex` (2 lần) để cập nhật đầy đủ chỉ số trang, mục lục, danh mục hình và mã trích dẫn.
   - Tự động di chuyển tệp PDF xuất ra vào thư mục `latex/outputs/`.
   - Tự động dọn dẹp toàn bộ tệp rác trung gian (`.aux`, `.bbl`, `.bcf`, `.blg`, `.log`, `.toc`, `.out`, `.nav`, `.snm`, `.synctex.gz`...).

---

### GIAI ĐOẠN 5: MENU ĐIỀU KHIỂN TRUNG TÂM 1-CHẠM (`tool.ps1` & `build.ps1`)
Tạo script PowerShell `tool.ps1` ngay thư mục gốc để người dùng tương tác chỉ bằng cách chọn số:
- Menu tương tác hiển thị rõ ràng:
  + `[1]` [DOCS DASHBOARD] Mở máy chủ Docsify xem tài liệu trên localhost:3000 hoặc trình duyệt.
  + `[2]` [LATEX BÁO CÁO] Biên dịch Báo cáo Khóa luận LaTeX (`khoa-luan.tex` → `latex/outputs/khoa-luan.pdf`).
  + `[3]` [LATEX SLIDE] Biên dịch Slide bảo vệ Beamer (`slide-bao-ve.tex` → `latex/outputs/slide-bao-ve.pdf`).
  + `[4]` [CHẠY TEST-BENCH/CODE] Khởi chạy mã nguồn hoặc môi trường thử nghiệm nhanh.
  + `[5] / [A]` [BIÊN DỊCH TẤT CẢ] Chạy liên hoàn toàn bộ hệ thống LaTeX và sao chép PDF vào `docs/downloads/`.
  + `[O]` Mở các thư mục chứa file PDF trong Windows Explorer.
  + `[0] / [Q]` Thoát chương trình.
- Đồng thời tạo tệp `build.ps1` ở thư mục gốc nhận tham số (ví dụ: `.\build.ps1 khoa-luan.tex`) để thuận tiện build nhanh từ bất cứ đâu.

---

### GIAI ĐOẠN 6: TỰ ĐỘNG HÓA CI/CD VÀ KIỂM TRA TỰ ĐỘNG (.github/)
1. **GitHub Actions `deploy-pages.yml`:** Tự động kích hoạt khi có commit vào nhánh `main` thư mục `docs/**`, đóng gói thư mục `docs/` và triển khai lên GitHub Pages.
2. **GitHub Actions `build-latex.yml`:** Chạy trên container `texlive/texlive:latest-full`, tự động biên dịch `khoa-luan.tex` và `slide-bao-ve.tex`, xuất bản thành GitHub Release/Artifacts.
3. **Script Python `.github/scripts/kiem_tra_trich_dan.py`:** Tự động quét tất cả lệnh `\cite{key}` trong các file `.tex` và đối chiếu với `tai-lieu-tham-khao.bib`. Nếu phát hiện trích dẫn ma (chưa có trong file .bib), script sẽ báo lỗi cảnh báo để bảo toàn liêm chính học thuật.

---

HÃY BẮT ĐẦU TẠO LẬP TỪNG TỆP TIN CỤ THỂ THEO ĐÚNG CẤU HÌNH TRÊN!
```

---

# 🛠️ NỘI DUNG MẪU CHI TIẾT CỦA CÁC TỆP CỐT LÕI (REFERENCE CODE)

Dưới đây là mã nguồn chuẩn mẫu của các tệp quan trọng nhất mà bạn có thể tham chiếu hoặc yêu cầu AI nạp vào repo mới:

### 1. Tệp `docs/index.html` (Trang Web Docsify Chuẩn Đẹp)

```html
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Khóa Luận Tốt Nghiệp - Dashboard Tiến Độ & Tài Liệu Nghiên Cứu</title>
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0">

  <!-- Google Fonts: Inter & JetBrains Mono -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">

  <!-- Docsify Vue Theme -->
  <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/docsify@4/lib/themes/vue.css">
  <!-- KaTeX Math Styling -->
  <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/katex@latest/dist/katex.min.css">

  <style>
    :root {
      --theme-color: #0284c7;
      --sidebar-width: 290px;
      --text-color: #1e293b;
      --bg-color: #f8fafc;
      --sidebar-bg: #ffffff;
      --sidebar-border: #e2e8f0;
    }
    body.dark-mode {
      --text-color: #f1f5f9;
      --bg-color: #0f172a;
      --sidebar-bg: #1e293b;
      --sidebar-border: #334155;
      background-color: #0f172a !important;
      color: #f1f5f9 !important;
    }
    body { font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; font-size: 15px; }
    code, pre { font-family: 'JetBrains Mono', monospace !important; }
    .markdown-section pre > code { font-size: 13.5px; }
    /* Dark mode toggle button */
    .theme-toggle-btn {
      position: fixed; bottom: 20px; right: 20px; z-index: 9999;
      background: #0284c7; color: #fff; border: none; border-radius: 50%;
      width: 44px; height: 44px; font-size: 20px; cursor: pointer;
      box-shadow: 0 4px 12px rgba(0,0,0,0.2); transition: all 0.2s;
    }
    .theme-toggle-btn:hover { transform: scale(1.08); }
  </style>
</head>
<body>
  <div id="app">Đang tải tài liệu nghiên cứu...</div>
  <button class="theme-toggle-btn" id="themeToggle" title="Chuyển chế độ Sáng/Tối">🌓</button>

  <script>
    window.$docsify = {
      name: 'Khóa Luận Tốt Nghiệp',
      repo: '',
      loadSidebar: true,
      subMaxLevel: 3,
      auto2top: true,
      search: {
        placeholder: 'Tìm kiếm nội dung, tuần, từ khóa...',
        noData: 'Không tìm thấy kết quả phù hợp',
        depth: 4
      },
      copyCode: { buttonText: 'Sao chép', errorText: 'Lỗi', successText: 'Đã chép' },
      pagination: { previousText: 'Bài trước', nextText: 'Bài tiếp theo' },
      markdown: {
        renderer: {
          code: function(code, lang) {
            if (lang === "mermaid") {
              return ('<div class="mermaid">' + code + "</div>");
            }
            return this.origin.code.apply(this, arguments);
          }
        }
      }
    };
  </script>

  <!-- Docsify Core -->
  <script src="//cdn.jsdelivr.net/npm/docsify@4"></script>
  <!-- Plugins: Search, Copy-code, Zoom-image, Pagination -->
  <script src="//cdn.jsdelivr.net/npm/docsify/lib/plugins/search.min.js"></script>
  <script src="//cdn.jsdelivr.net/npm/docsify-copy-code/dist/docsify-copy-code.min.js"></script>
  <script src="//cdn.jsdelivr.net/npm/docsify/lib/plugins/zoom-image.min.js"></script>
  <script src="//cdn.jsdelivr.net/npm/docsify-pagination/dist/docsify-pagination.min.js"></script>
  <!-- Mermaid & KaTeX -->
  <script src="//cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
  <script src="//cdn.jsdelivr.net/npm/katex@latest/dist/katex.min.js"></script>
  <script src="//cdn.jsdelivr.net/npm/docsify-katex@latest/dist/docsify-katex.js"></script>

  <script>
    mermaid.initialize({ startOnLoad: false, theme: 'default' });
    // Dark mode logic
    const toggleBtn = document.getElementById('themeToggle');
    if (localStorage.getItem('theme') === 'dark') {
      document.body.classList.add('dark-mode');
    }
    toggleBtn.addEventListener('click', () => {
      document.body.classList.toggle('dark-mode');
      localStorage.setItem('theme', document.body.classList.contains('dark-mode') ? 'dark' : 'light');
    });
  </script>
</body>
</html>
```

---

### 2. Tệp `latex/scripts/build.ps1` (Script Biên Dịch LaTeX Tự Động Trên Windows)

```powershell
# Build bản LaTeX của khóa luận (báo cáo hoặc slide bảo vệ) bằng PowerShell trên Windows.
# Dùng pdflatex + biber trực tiếp, tự động dọn tệp rác.

param(
    [Parameter(Mandatory = $true, ValueFromRemainingArguments = $true)]
    [string[]]$TexFiles
)

$ErrorActionPreference = "Stop"

# Tự động thêm MiKTeX vào PATH nếu có
$MiktexPath = "$env:LOCALAPPDATA\Programs\MiKTeX\miktex\bin\x64"
if (Test-Path $MiktexPath) {
    if ($env:PATH -notmatch [regex]::Escape($MiktexPath)) {
        $env:PATH = "$MiktexPath;$env:PATH"
    }
}

# Tạo thư mục outputs nếu chưa có
if (!(Test-Path "outputs")) {
    New-Item -ItemType Directory -Path "outputs" | Out-Null
}

foreach ($tex in $TexFiles) {
    $base = [System.IO.Path]::GetFileNameWithoutExtension($tex)
    Write-Host "==> [BẮT ĐẦU BIÊN DỊCH]: $tex" -ForegroundColor Cyan

    & pdflatex -interaction=nonstopmode -halt-on-error "$tex"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Lỗi biên dịch pdflatex cho $tex"
        exit 1
    }

    if (Test-Path "$base.bcf") {
        Write-Host "==> [CHẠY BIBER]: $base" -ForegroundColor Yellow
        try {
            & biber "$base"
        } catch {
            Write-Warning "biber báo lỗi hoặc không có mục trích dẫn nào mới."
        }
    }

    & pdflatex -interaction=nonstopmode -halt-on-error "$tex"
    & pdflatex -interaction=nonstopmode -halt-on-error "$tex"

    if (Test-Path "$base.pdf") {
        Move-Item "$base.pdf" -Destination "outputs\" -Force
        Write-Host "==> [THÀNH CÔNG] Đã chuyển $base.pdf vào thư mục outputs/" -ForegroundColor Green
    }

    # Tự động dọn sạch các tệp rác trung gian
    $exts = @("aux", "bbl", "bcf", "blg", "fdb_latexmk", "fls", "log", "nav", "out", "run.xml", "snm", "synctex.gz", "toc", "lof", "lot")
    foreach ($ext in $exts) {
        if (Test-Path "$base.$ext") {
            Remove-Item "$base.$ext" -Force -ErrorAction SilentlyContinue
        }
    }
}
Write-Host "==> Toàn bộ quá trình biên dịch đã hoàn tất an toàn!" -ForegroundColor Green
```

---

### 3. Tệp `tool.ps1` (Trung Tâm Điều Khiển 1-Chạm Bằng PowerShell)

```powershell
<#
.SYNOPSIS
    Trung Tâm Điều Khiển & Khởi Chạy Công Cụ (Tool Launcher Hub)
.DESCRIPTION
    Menu tương tác 1-chạm giúp xem tài liệu, biên dịch LaTeX, kiểm tra trích dẫn và mở thư mục PDF.
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Target = ""
)

$ErrorActionPreference = "Continue"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$rootDir = $PSScriptRoot
if (-not $rootDir) { $rootDir = (Get-Location).Path }

function Show-Header {
    Clear-Host
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host "   TRUNG TÂM ĐIỀU KHIỂN & KHỞI CHẠY CÔNG CỤ (TOOL LAUNCHER HUB)       " -ForegroundColor Yellow
    Write-Host "   Hệ thống Quản lý Tiến độ & Xuất bản Khóa luận / Nghiên cứu Khoa học" -ForegroundColor White
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Show-Menu {
    Write-Host "--- [ CHỨC NĂNG CHÍNH ] ---" -ForegroundColor Green
    Write-Host "  [1]  [DOCS DASHBOARD] Khởi chạy máy chủ xem Docsify trên localhost:3000" -ForegroundColor White
    Write-Host "  [2]  [LATEX BÁO CÁO]  Biên dịch Báo cáo Khóa luận (khoa-luan.tex -> outputs/)" -ForegroundColor White
    Write-Host "  [3]  [LATEX SLIDE]    Biên dịch Slide thuyết trình bảo vệ (slide-bao-ve.tex)" -ForegroundColor White
    Write-Host "  [4]  [KIỂM TRA CITATION] Đối chiếu trích dẫn trong LaTeX với file .bib" -ForegroundColor White
    Write-Host "  [5] hoặc [A] [BIÊN DỊCH TẤT CẢ] Build toàn bộ PDF và cập nhật vào docs/downloads/" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "--- [ TIỆN ÍCH ] ---" -ForegroundColor Green
    Write-Host "  [O]  Mở thư mục chứa file PDF (latex/outputs) trong Windows Explorer" -ForegroundColor Cyan
    Write-Host "----------------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "  [0] hoặc [Q] : Thoát chương trình" -ForegroundColor DarkYellow
    Write-Host "======================================================================" -ForegroundColor Cyan
}

function Invoke-Task {
    param([string]$choice)
    switch ($choice) {
        "1" {
            Write-Host "Khởi chạy máy chủ Docsify xem tài liệu..." -ForegroundColor Yellow
            $docsDir = Join-Path $rootDir "docs"
            Start-Process "http://localhost:3000"
            npx -y serve -l 3000 "$docsDir"
        }
        "2" {
            Write-Host "Biên dịch Báo cáo Khóa luận..." -ForegroundColor Yellow
            $scriptPath = Join-Path $rootDir "build.ps1"
            powershell -ExecutionPolicy Bypass -File $scriptPath "khoa-luan.tex"
        }
        "3" {
            Write-Host "Biên dịch Slide thuyết trình bảo vệ..." -ForegroundColor Yellow
            $scriptPath = Join-Path $rootDir "build.ps1"
            powershell -ExecutionPolicy Bypass -File $scriptPath "slide-bao-ve.tex"
        }
        "4" {
            Write-Host "Đang kiểm tra tính nhất quán của tài liệu tham khảo..." -ForegroundColor Yellow
            $checkScript = Join-Path $rootDir ".github\scripts\kiem_tra_trich_dan.py"
            python $checkScript
        }
        "5" {
            Write-Host "Biên dịch toàn bộ hệ thống ấn phẩm..." -ForegroundColor Yellow
            $scriptPath = Join-Path $rootDir "build.ps1"
            powershell -ExecutionPolicy Bypass -File $scriptPath "khoa-luan.tex" "slide-bao-ve.tex"
            # Tự động đồng bộ sang docs/downloads/ để xem online
            $srcDir = Join-Path $rootDir "latex\outputs"
            $dstDir = Join-Path $rootDir "docs\downloads"
            if (!(Test-Path $dstDir)) { New-Item -ItemType Directory -Path $dstDir | Out-Null }
            Copy-Item "$srcDir\*.pdf" -Destination $dstDir -Force
            Write-Host "Đã đồng bộ PDF sang docs/downloads/!" -ForegroundColor Green
        }
        "O" {
            $pdfFolder = Join-Path $rootDir "latex\outputs"
            if (Test-Path $pdfFolder) { Start-Process explorer.exe $pdfFolder }
            else { Write-Host "Chưa có thư mục outputs/." -ForegroundColor Red }
        }
        default { Write-Host "Lựa chọn không hợp lệ." -ForegroundColor Red }
    }
}

if ($Target -ne "") {
    Invoke-Task $Target
    exit 0
}

while ($true) {
    Show-Header
    Show-Menu
    $choice = Read-Host "Nhập lựa chọn của bạn (ví dụ: 1, 2, 3, A, O, Q)"
    if ($choice -in @("0", "Q", "q", "exit")) {
        Write-Host "Tạm biệt!" -ForegroundColor Cyan
        break
    }
    Invoke-Task $choice
    Write-Host "`nNhấn phím bất kỳ để tiếp tục..." -ForegroundColor Gray
    [Console]::ReadKey($true) | Out-Null
}
```

---

### 4. Tệp `build.ps1` (Script Proxy Gọi Build Tại Thư Mục Gốc)

```powershell
# Script hỗ trợ build nhanh từ thư mục gốc của repository
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$TexFiles = @("khoa-luan.tex")
)

$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$latexDir = Join-Path $PSScriptRoot "latex"

if (!(Test-Path $latexDir)) {
    Write-Error "Không tìm thấy thư mục latex/."
    exit 1
}

Write-Host "==> Chuyển vào thư mục latex để thực hiện biên dịch..." -ForegroundColor Cyan
Push-Location $latexDir
try {
    .\scripts\build.ps1 @TexFiles
} finally {
    Pop-Location
}

Write-Host "`n==> Hoàn tất! File PDF đầu ra nằm tại:" -ForegroundColor Green
foreach ($tex in $TexFiles) {
    $base = [System.IO.Path]::GetFileNameWithoutExtension($tex)
    $pdfPath = Join-Path $latexDir "outputs\$base.pdf"
    if (Test-Path $pdfPath) {
        Write-Host "    -> $pdfPath" -ForegroundColor Yellow
    }
}
```

---

### 5. Tệp `latex/khoa-luan.tex` (Bản Mẫu LaTeX Master Chuẩn Báo Cáo)

```latex
\documentclass[12pt,a4paper,oneside]{report}

% --- GÓI TIẾNG VIỆT & BẢNG MÃ CHUẨN ---
\usepackage[T5]{fontenc}
\usepackage[utf8]{inputenc}
\usepackage[vietnamese]{babel}

% --- ĐỊNH DẠNG TRANG & LỀ CHUẨN LUẬN VĂN ---
\usepackage[top=2.5cm, bottom=2.5cm, left=3.0cm, right=2.0cm]{geometry}
\usepackage{setspace}
\onehalfspacing % Giãn dòng 1.5 lines

% --- GÓI TOÁN HỌC & BẢNG BIỂU ---
\usepackage{amsmath, amssymb, amsfonts}
\usepackage{graphicx}
\usepackage{tabularx}
\usepackage{booktabs}
\usepackage{caption}
\usepackage{subcaption}

% --- TRÍCH DẪN TÀI LIỆU THAM KHẢO (BIBLATEX + BIBER) ---
\usepackage[backend=biber, style=numeric, sorting=none]{biblatex}
\addbibresource{../bao-cao/tai-lieu-tham-khao.bib}

% --- MÃ NGUỒN & LIÊN KẾT SIÊU VĂN BẢN ---
\usepackage{listings}
\usepackage{xcolor}
\usepackage[colorlinks=true, linkcolor=blue, citecolor=red, urlcolor=teal]{hyperref}

\begin{document}

% --- TRANG BÌA & CÁC TRANG HỌC VỤ BAN ĐẦU ---
\input{chuong/00-loi-cam-doan-cam-on.tex}
\input{chuong/00-loi-mo-dau.tex}

\tableofcontents
\newpage
\listoffigures
\newpage
\listoftables
\newpage

% --- CÁC CHƯƠNG CHÍNH ---
\input{chuong/01-tong-quan-bai-toan-va-co-so-cong-nghe.tex}
\input{chuong/02-phan-tich-va-thiet-ke-he-thong.tex}
\input{chuong/03-hien-thuc-hoa-danh-gia-an-ninh-va-thuc-nghiem.tex}
\input{chuong/04-ket-luan.tex}

% --- TÀI LIỆU THAM KHẢO & PHỤ LỤC ---
\newpage
\printbibliography[heading=bibintoc, title={TÀI LIỆU THAM KHẢO}]

\newpage
\appendix
\input{chuong/05-phu-luc.tex}

\end{document}
```

---

### 6. Tệp `.github/scripts/kiem_tra_trich_dan.py` (Kiểm Tra Liêm Chính Trích Dẫn)

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script đối chiếu các khóa trích dẫn \cite{key} trong LaTeX với file .bib.
Giúp đảm bảo 100% tài liệu trích dẫn trong văn bản đều có mặt trong danh mục.
"""

import os
import re
import sys

def get_cited_keys(tex_dir):
    cited = set()
    pattern = re.compile(r'\\cite(?:\[[^\]]*\])?\{([^}]+)\}')
    for root, _, files in os.walk(tex_dir):
        for f in files:
            if f.endswith('.tex'):
                path = os.path.join(root, f)
                with open(path, 'r', encoding='utf-8', errors='ignore') as fp:
                    for line in fp:
                        if line.strip().startswith('%'):
                            continue
                        matches = pattern.findall(line)
                        for m in matches:
                            keys = [k.strip() for k in m.split(',')]
                            cited.update(keys)
    return cited

def get_bib_keys(bib_path):
    if not os.path.exists(bib_path):
        print(f"[CẢNH BÁO] Không tìm thấy file: {bib_path}")
        return set()
    bib_keys = set()
    pattern = re.compile(r'@\w+\s*\{\s*([^,\s]+)\s*,')
    with open(bib_path, 'r', encoding='utf-8', errors='ignore') as fp:
        for line in fp:
            m = pattern.search(line)
            if m:
                bib_keys.add(m.group(1).strip())
    return bib_keys

def main():
    root_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
    tex_dir = os.path.join(root_dir, 'latex')
    bib_path = os.path.join(root_dir, 'bao-cao', 'tai-lieu-tham-khao.bib')

    cited_keys = get_cited_keys(tex_dir)
    bib_keys = get_bib_keys(bib_path)

    print(f"[*] Tổng số trích dẫn trong tệp LaTeX: {len(cited_keys)}")
    print(f"[*] Tổng số mục trong file .bib: {len(bib_keys)}")

    missing = cited_keys - bib_keys
    if missing:
        print(f"\n[LỖI LIÊM CHÍNH HỌC THUẬT] Phát hiện {len(missing)} khóa trích dẫn chưa có trong .bib:")
        for k in sorted(missing):
            print(f"   -> ❌ {k}")
        sys.exit(1)
    else:
        print("\n[CHÚC MỪNG] Tất cả các trích dẫn đều hợp lệ và nhất quán 100%!")
        sys.exit(0)

if __name__ == '__main__':
    main()
```

---

## 🎯 Tóm Lại: Quy Trình Áp Dụng Cho Đề Tài Mới

1. **Khởi tạo:** Tạo thư mục repo mới và dán Master Prompt trên vào AI.
2. **Theo dõi tiến độ hàng tuần:**
   - Mỗi tuần tạo 1 file báo cáo tiến độ `docs/reports/week-XX.md` (3 mục ngắn gọn).
   - Mỗi tuần tạo 1 bài nghiên cứu `docs/research/TONG_HOP_XX.md` (What/Why/How văn nói).
   - Chạy `powershell .\tool.ps1` → Chọn `[1]` để xem Docsify trên trình duyệt.
3. **Phát triển mã nguồn:** Viết mã trong `code/`, lưu kết quả thực nghiệm trong `thuc-nghiem/ket-qua/`.
4. **Biên dịch xuất bản:** Chạy `powershell .\tool.ps1` → Chọn `[2]` hoặc `[5]` để nhận ngay bản in PDF tuyệt đẹp, chuẩn quy cách nhà trường!
