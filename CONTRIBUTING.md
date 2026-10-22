# HƯỚNG DẪN QUẢN TRỊ DỰ ÁN VÀ ĐÓNG GÓP (CONTRIBUTING)

Dự án: **Nghiên cứu kỹ thuật khai thác và phòng chống tấn công Man-in-the-Middle**  
Sinh viên thực hiện: **Nguyễn Thị Kỳ Duyên** | Giảng viên hướng dẫn: **ThS. Trịnh Lê Hoàng Tuấn**  
Cơ sở đào tạo: **Trường Đại học Đồng Tháp (DTHU) — Khoa Công nghệ và Kỹ thuật**

---

## 1. Nguyên tắc làm việc trên Git

- Nhánh chính là `main`. Mọi bổ sung hoặc hiệu chỉnh nội dung nên được commit rõ ràng với thông điệp súc tích (ví dụ: `docs(latex): update chapter 3 defense evaluation`, `feat(code): add arp spoofing poc with scapy`).
- **Không commit các tệp rác và tệp tạm:**
  - File tạm sinh ra trong quá trình biên dịch LaTeX: `.aux`, `.log`, `.bcf`, `.bbl`, `.toc`, `.lof`, `.lot`, `.out`, `.synctex.gz`.
  - Thông tin đăng nhập, mật khẩu quản trị mạng hoặc file cấu hình chứa thông tin nhạy cảm thực tế.

---

## 2. Quy trình cập nhật nội dung học thuật

1. **Khi có số liệu đo kiểm mới:**
   - Cập nhật số liệu thô và log vào `thuc-nghiem/du-lieu/`.
   - Cập nhật bảng đối sánh trong `thuc-nghiem/ket-qua/bang_so_sanh_truoc_sau_phong_thu.md` và chương báo cáo `latex/chuong/03-giai-phap-phong-chong-va-thuc-nghiem-kiem-chung.tex`.
2. **Khi cập nhật tài liệu tham khảo:**
   - Thêm bản ghi BibTeX đầy đủ (tác giả, tên tài liệu, năm xuất bản, tổ chức, DOI/URL nếu có) vào `latex/tai-lieu-tham-khao.bib`.
   - Kiểm tra tính nhất quán trích dẫn thông qua script:
     ```powershell
     node .github/scripts/kiem_tra_trich_dan.js
     ```
3. **Khi chuẩn bị báo cáo tiến độ tuần:**
   - Cập nhật báo cáo tuần mới vào `docs/reports/week-*.md`.
   - Cập nhật bảng theo dõi tổng thể trong `docs/weekly-changelog.md`.
