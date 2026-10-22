# Ấn Phẩm & Bản In Niên Luận Chính Thức

> **Mục đích:** Trang tổng hợp và **đọc trực tuyến** các ấn phẩm học thuật chính thức được biên dịch từ mã nguồn LaTeX chuẩn quốc tế của đề tài Niên luận chuyên ngành Mạng Máy Tính và An Ninh (Trường Đại học Đồng Tháp).

<div class="badge-bar">
  <span class="badge">📄 Báo cáo: 49 trang PDF</span>
  <span class="badge">📊 Slide Beamer: 23 slide</span>
  <span class="badge">🖥️ Slide PowerPoint: .pptx</span>
  <span class="badge">👨‍🏫 GVHD: ThS. Trịnh Lê Hoàng Tuấn</span>
  <span class="badge">👩‍🎓 SV: Nguyễn Thị Kỳ Duyên (0023410647)</span>
</div>

---

## 🖥️ Bộ Đọc Ấn Phẩm PDF Trực Tuyến (Online PDF Viewer)

Quý Thầy/Cô và các bạn sinh viên có thể xem trực tiếp toàn bộ tài liệu ngay trên trình duyệt mà không cần phải tải về:

<div class="pdf-viewer-card">
  <div class="pdf-tab-bar">
    <button class="pdf-tab-btn active" id="tabReportBtn">
      <span>📄 Báo Cáo Niên Luận (PDF)</span>
    </button>
    <button class="pdf-tab-btn" id="tabSlideBtn">
      <span>📊 Slide Thuyết Trình (PDF)</span>
    </button>
    <span class="pdf-badge-status" id="pdfActiveBadge">📄 Báo Cáo Niên Luận Toàn Văn (49 trang)</span>
    <div class="pdf-action-links">
      <a href="downloads/khoa-luan.pdf" id="pdfOpenNewBtn" target="_blank" class="pdf-action-btn" title="Mở file PDF trong tab mới">
        <span>↗️ Mở Tab Mới</span>
      </a>
      <a href="downloads/khoa-luan.pdf" id="pdfDownloadBtn" download="Bao_cao_Nien_luan_0023410647_NguyenThiKyDuyen.pdf" class="pdf-action-btn" title="Tải file PDF về máy">
        <span>⬇️ Tải PDF</span>
      </a>
      <a href="../slide/Slide_Bao_cao_0023410647_NguyenThiKyDuyen.pptx" download class="pdf-action-btn" title="Tải file Slide PowerPoint .pptx">
        <span>🖥️ Tải PPTX</span>
      </a>
    </div>
  </div>
  <div class="pdf-frame-wrapper">
    <object id="pdfViewerObject" data="downloads/khoa-luan.pdf" type="application/pdf" width="100%" height="860px">
      <iframe id="pdfViewerFrame" src="downloads/khoa-luan.pdf" width="100%" height="860px" frameborder="0">
        <p style="padding: 24px; color: #fff; text-align: center;">
          Trình duyệt của bạn không hỗ trợ nhúng trực tiếp PDF.<br><br>
          <a href="downloads/khoa-luan.pdf" target="_blank" style="color: #38bdf8; font-weight: bold; text-decoration: underline;">
            👉 Bấm vào đây để mở và xem Báo Cáo Niên Luận PDF trong tab mới
          </a>
        </p>
      </iframe>
    </object>
  </div>
</div>

---

## 1. Báo Cáo Niên Luận Toàn Văn (PDF)

Bản in chính thức được định dạng theo quy cách nghiêm ngặt năm 2026 của Khoa Công nghệ và Kỹ thuật — Trường Đại học Đồng Tháp:
- **Phông chữ:** Times New Roman chuẩn học thuật (`mathptmx`), cỡ chữ 13pt, khoảng cách dòng `Multiple = 1.3`, giãn đoạn `6pt`.
- **Quy chuẩn lề trang:** Lề trái 3.0cm; Lề trên, dưới và phải 2.0cm.
- **Hệ thống cấu trúc:** Đầy đủ bìa chính (viền đôi nghệ thuật), bìa lót, Lời cam đoan, Lời cảm ơn, Tóm tắt tiếng Việt & Abstract tiếng Anh, Mục lục, Danh mục từ viết tắt & thuật ngữ, Danh mục bảng biểu và hình vẽ.
- **Tài liệu tham khảo:** Trích dẫn 100% chuẩn BibLaTeX/Biber khớp với RFC (RFC 826, RFC 1035, RFC 2131, RFC 6797, RFC 8446) và các nghiên cứu uy tín của IEEE/ACM.

* **Tên tệp:** `khoa-luan.pdf`
* **Dung lượng:** ~481 KB
* **Quy mô:** **49 trang**
* **Trạng thái:** Đã biên dịch hoàn tất, không có lỗi cảnh báo học thuật.
* **Tải về:** [⬇️ Tải xuống Báo Cáo Niên Luận Toàn Văn (PDF)](downloads/khoa-luan.pdf ':ignore')

---

## 2. Slide Thuyết Trình Bảo Vệ (Beamer Presentation)

Bộ slide trình bày súc tích trong 15 — 20 phút bảo vệ trước Hội đồng chấm niên luận chuyên ngành Mạng Máy Tính và An Ninh:
- Tích hợp sơ đồ mạng TikZ trực quan phân tích luồng tấn công Man-in-the-Middle.
- Sơ đồ mô hình phòng thử nghiệm Testbed Lab 5 node (Switch Cisco, Gateway, 2 Nạn nhân, Kali Linux, Web Server Nginx).
- Bảng đối sánh định lượng trước và sau khi kích hoạt các giải pháp phòng vệ (Dynamic ARP Inspection, DHCP Snooping, HTTPS/HSTS, WireGuard VPN).
- Bộ tiêu chí đáp ứng Rubric đánh giá niên luận theo thang điểm 10 của Khoa CN&KT.

* **Tên tệp PDF:** `slide-bao-ve.pdf` (LaTeX Beamer)
* **Tên tệp PPTX:** `Slide_Bao_cao_0023410647_NguyenThiKyDuyen.pptx` (PowerPoint 16:9)
* **Quy mô:** **23 slide Beamer**
* **Chủ đề màu:** DTHU Navy & Teal Blue
* **Tải về:**
  * [⬇️ Tải xuống Slide Bảo Vệ (PDF Beamer)](downloads/slide-bao-ve.pdf ':ignore')
  * [🖥️ Tải xuống Slide Bảo Vệ (PowerPoint PPTX)](../slide/Slide_Bao_cao_0023410647_NguyenThiKyDuyen.pptx ':ignore')

---

## 3. Quy Trình Biên Dịch Lại Từ Mã Nguồn LaTeX

Nếu quý Thầy/Cô hoặc Sinh viên muốn tự biên dịch lại từ mã nguồn:

### Cách 1: Sử dụng Menu tương tác 1-chạm (Khuyên dùng)
```powershell
# Chạy từ thư mục gốc của repository
.\tool.ps1
# Nhập [2] để biên dịch Báo cáo Niên luận (khoa-luan.tex)
# Nhập [3] để biên dịch Slide Beamer (slide-bao-ve.tex)
# Nhập [5] hoặc [A] để tự động biên dịch cả hai và đồng bộ sang docs/downloads/
# Nhập [6] hoặc [P] để tự động đóng gói toàn bộ thư mục MSSV_HoTen (0023410647_NguyenThiKyDuyen)
```

### Cách 2: Sử dụng Script build nhanh PowerShell
```powershell
powershell -ExecutionPolicy Bypass -File .\build.ps1 khoa-luan.tex slide-bao-ve.tex
```

Mọi tệp PDF xuất ra sẽ nằm tại thư mục `latex/outputs/` và tự động cập nhật sang `docs/downloads/` phục vụ xem trực tiếp trên GitHub Pages.
