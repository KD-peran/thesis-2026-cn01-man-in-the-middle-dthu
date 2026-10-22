# Bản Đồ Cấu Trúc Toàn Bộ Repository Đề Tài Nghiên Cứu

> **Đề tài:** Nghiên cứu kỹ thuật khai thác và phòng chống tấn công Man-in-the-Middle  
> **Mã đề tài:** `2026.MITM.01`  
> **Sinh viên thực hiện:** Nguyễn Thị Kỳ Duyên (MSSV: `0023410647` — Lớp: `ĐHCNTT23B-CS`)  
> **Giảng viên hướng dẫn:** TS. Lương Thái Ngọc  
> **Cơ sở đào tạo:** Trường Đại học Đồng Tháp (DTHU) — Khoa Công nghệ và Kỹ thuật

---

## 🗺️ Cây Thư Mục Toàn Bộ Dự Án

```text
thesis-2026-cn01-man-in-the-middle-dthu/
├── AGENTS.md                                # Quy tắc làm việc cho các trợ lý AI dòng lệnh
├── CLAUDE.md                                # Quy chuẩn làm việc gốc cho Claude Code
├── CONTRIBUTING.md                          # Quy định đóng góp, commit và kỷ luật Git
├── Cau-truc-toan-repo.md                    # Bản đồ cấu trúc toàn bộ repository (Tệp này)
├── README.md                                # Trang tổng quan đề tài và hướng dẫn vận hành
├── build.ps1                                # Kịch bản PowerShell build nhanh LaTeX từ root
├── tool.ps1                                 # Menu điều khiển trung tâm tương tác 1-chạm (CLI Hub)
│
├── .github/                                 # Cấu hình GitHub Actions, Scripts & Copilot
│   ├── copilot-instructions.md              # Ràng buộc hành vi cho GitHub Copilot
│   ├── scripts/                             # Script kiểm tra tính nhất quán trích dẫn
│   │   └── kiem_tra_trich_dan.py
│   └── workflows/                           # CI/CD: Tự động build LaTeX & Deploy Docsify Pages
│       ├── build-latex.yml
│       └── deploy-pages.yml
│
├── docs/                                    # TRANG TÀI LIỆU WEB & DASHBOARD TIẾN ĐỘ (DOCSIFY)
│   ├── index.html                           # Điểm neo máy chủ web Docsify cực đẹp (hỗ trợ Dark mode, Mermaid, KaTeX)
│   ├── _sidebar.md                          # Menu điều hướng đa cấp Docsify
│   ├── README.md                            # Trang chủ tài liệu web
│   ├── weekly-changelog.md                  # Bảng theo dõi tiến độ tổng hợp các tuần
│   ├── system-diagrams.md                   # Tổng hợp toàn bộ sơ đồ kiến trúc & luồng tấn công bằng Mermaid
│   ├── publications.md                      # Trang đọc và tải ấn phẩm PDF chính thức
│   ├── reports/                             # Báo cáo tiến độ tuần dạng TÓM TẮT ĐÚNG 3 MỤC
│   │   ├── week-01.md
│   │   ├── week-02.md
│   │   ├── week-03.md
│   │   └── week-04.md
│   ├── research/                            # Nghiên cứu chuyên sâu WHAT / WHY / HOW dạng văn nói đọc hiểu
│   │   └── TONG_HOP_KY_THUAT_MITM_VA_PHONG_CHONG.md
│   └── downloads/                           # Chứa bản sao PDF để đọc/tải trực tiếp trên trình duyệt
│       ├── khoa-luan.pdf
│       └── slide-bao-ve.pdf
│
├── latex/                                   # ẤN PHẨM BÁO CÁO CHÍNH THỨC (LATEX CHUẨN XUẤT BẢN)
│   ├── khoa-luan.tex                        # Master LaTeX file điều phối toàn bộ báo cáo
│   ├── slide-bao-ve.tex                     # Beamer LaTeX slide thuyết trình bảo vệ
│   ├── tai-lieu-tham-khao.bib               # Danh mục BibTeX tài liệu tham khảo chuẩn quốc tế
│   ├── chuong/                              # Modular từng chương (.tex)
│   │   ├── 00-danh-muc-tu-viet-tat-va-thuat-ngu.tex
│   │   ├── 00-loi-cam-doan-cam-on.tex
│   │   ├── 00-loi-mo-dau.tex
│   │   ├── 01-tong-quan-va-co-so-ly-thuyet-mitm.tex
│   │   ├── 02-ky-thuat-khai-thac-va-dan-duong-mitm.tex
│   │   ├── 03-giai-phap-phong-chong-va-thuc-nghiem-kiem-chung.tex
│   │   ├── 04-ket-luan-va-huong-phat-trien.tex
│   │   └── 05-phu-luc.tex
│   ├── images/                              # Logo trường, sơ đồ kiến trúc, biểu đồ thực nghiệm
│   ├── scripts/                             # Script biên dịch tự động pdflatex + biber
│   │   ├── build.ps1                        # Cho Windows PowerShell (tự động dọn file rác)
│   │   └── build.sh                         # Cho Linux / macOS / Git Bash
│   └── outputs/                             # Thư mục chứa PDF đầu ra (tự sinh, .gitignore)
│       ├── khoa-luan.pdf                    # Báo cáo toàn văn hoàn chỉnh (40 trang)
│       └── slide-bao-ve.pdf                 # Slide Beamer thuyết trình bảo vệ (22 trang)
│
├── code/                                    # MÃ NGUỒN TOÀN BỘ HỆ THỐNG
│   ├── README.md                            # Hướng dẫn kiến trúc, biến môi trường, cách chạy
│   ├── .env.example                         # Cấu hình mẫu môi trường phòng Lab
│   ├── lab-setup/                           # Kịch bản dựng phòng thử nghiệm Docker & Switch
│   │   ├── docker-compose.yml
│   │   └── cisco_switch_config.cfg
│   ├── attacks/                             # Kịch bản tấn công PoC
│   │   ├── arp_spoof.py                     # ARP Cache Poisoning hai chiều (Scapy)
│   │   ├── dns_spoof.py                     # DNS Spoofing
│   │   ├── ssl_strip_bettercap.cap          # SSL Stripping bằng Bettercap
│   │   └── content_injection.py             # Tiêm mã JavaScript qua NFQUEUE
│   └── defense/                             # Cấu hình và công cụ phòng thủ
│       ├── cisco_dai_dhcp_snooping.cfg      # Cấu hình Cisco DAI & DHCP Snooping
│       ├── nginx_https_hsts.conf            # Cấu hình Nginx HTTPS + HSTS RFC 6797
│       ├── arp_monitor_detector.py          # Kịch bản giám sát ARP bất thường thời gian thực
│       └── wireguard_vpn_client.conf        # Cấu hình VPN WireGuard Client
│
├── thu-tuc-khoa/                            # HỒ SƠ HỌC VỤ & THỦ TỤC KHOA
│   ├── 1.Don-dang-ky-de-tai.md              # Đơn đăng ký đề tài chính thức
│   ├── 2.Ke-hoach-thuc-hien.md              # Bảng kế hoạch tiến độ từng tuần nộp khoa
│   ├── de-cuong-khoa-luan.md                # Đề cương chi tiết đã duyệt (Single Source of Truth)
│   └── README.md
│
├── huong-dan/                               # TIÊU CHÍ ĐÁNH GIÁ & HƯỚNG DẪN
│   └── rubric-cham-khoa-luan.md             # Rubric chấm điểm của Hội đồng
│
└── thuc-nghiem/                             # DỮ LIỆU ĐO KIỂM THỰC NGHIỆM ĐỊNH LƯỢNG
    ├── README.md                            # Quy trình đo kiểm
    ├── du-lieu/                             # Lưu vết dữ liệu thô (log, packet, credentials)
    │   ├── sample_arp_poisoning.log
    │   ├── sample_dai_switch_violations.log
    │   └── sample_stolen_credentials.json
    └── ket-qua/                             # Bảng biểu định lượng, so sánh trước/sau khi phòng vệ
        └── bang_so_sanh_truoc_sau_phong_thu.md
```
