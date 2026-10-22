# Ấn Phẩm Đề Tài Nghiên Cứu & Hướng Dẫn Biên Dịch (Publications)

> **Mục đích:** Cung cấp liên kết đọc và tải trực tiếp các ấn phẩm chính thức của đề tài (Báo cáo nghiên cứu toàn văn và Slide Beamer thuyết trình bảo vệ), kèm hướng dẫn chi tiết quy trình tự động hóa biên dịch từ mã nguồn mở LaTeX.

---

## 📚 1. Danh Mục Ấn Phẩm Chính Thức

### 1.1. Báo Cáo Toàn Văn Đề Tài (PDF)
- **Tên tài liệu:** Báo cáo Niên luận / Khóa luận tốt nghiệp chuyên ngành Mạng Máy Tính và An Ninh.
- **Tiêu đề:** *Nghiên cứu kỹ thuật khai thác và phòng chống tấn công Man-in-the-Middle*
- **Quy mô:** 40 trang chuẩn học thuật ĐH Đồng Tháp, 4 chương chi tiết, đầy đủ bìa, mục lục, hình vẽ TikZ và danh mục tài liệu tham khảo BibTeX.
- **Tải tệp PDF:** [Tải Báo cáo toàn văn (khoa-luan.pdf)](downloads/khoa-luan.pdf)

### 1.2. Slide Thuyết Trình Bảo Vệ (Beamer Presentation)
- **Tên tài liệu:** Slide báo cáo bảo vệ trước Hội đồng khoa học.
- **Quy mô:** 22 slides chuẩn Beamer LaTeX, tích hợp sơ đồ mạng, bảng ma trận đối sánh định lượng và kết luận.
- **Tải tệp PDF:** [Tải Slide thuyết trình bảo vệ (slide-bao-ve.pdf)](downloads/slide-bao-ve.pdf)

---

## ⚙️ 2. Quy Trình Biên Dịch Lại Từ Mã Nguồn LaTeX

Dự án cung cấp kịch bản tự động hóa 1-chạm giúp người dùng dễ dàng biên dịch lại toàn bộ ấn phẩm từ mã nguồn:

### Cách 1: Sử dụng Menu tương tác Tool Launcher Hub (Khuyên dùng)
```powershell
powershell -ExecutionPolicy Bypass -File .\tool.ps1
```
- Nhập `[2]` để biên dịch riêng Báo cáo toàn văn (`khoa-luan.pdf`).
- Nhập `[3]` để biên dịch riêng Slide bảo vệ (`slide-bao-ve.pdf`).
- Nhập `[5]` hoặc `[A]` để tự động biên dịch toàn bộ hệ thống ấn phẩm và sao chép vào `docs/downloads/`.

### Cách 2: Sử dụng Script build nhanh từ thư mục gốc
```powershell
powershell -ExecutionPolicy Bypass -File .\build.ps1 khoa-luan.tex
powershell -ExecutionPolicy Bypass -File .\build.ps1 slide-bao-ve.tex
```
Toàn bộ tệp PDF đầu ra sẽ tự động được làm sạch các file rác trung gian (`.aux`, `.bbl`, `.bcf`, `.log`, `.toc`...) và đặt gọn gàng trong thư mục `latex/outputs/`.
