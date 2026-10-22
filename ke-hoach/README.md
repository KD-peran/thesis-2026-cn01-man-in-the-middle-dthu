# KẾ HOẠCH VÀ BÁO CÁO TIẾN ĐỘ HÀNG TUẦN

**Đề tài:** Nghiên cứu kỹ thuật khai thác và phòng chống tấn công Man-in-the-Middle  
**Sinh viên thực hiện:** Nguyễn Thị Kỳ Duyên (MSSV: `0023410647` — Lớp: `ĐHCNTT23B-CS`)  
**Giảng viên hướng dẫn:** TS. Lương Thái Ngọc  
**Cơ sở đào tạo:** Trường Đại học Đồng Tháp (DTHU) — Khoa Công nghệ và Kỹ thuật

---

## 1. Mục đích thư mục

Thư mục `ke-hoach/` quản lý toàn bộ các bản báo cáo tiến độ thực hiện đề tài gửi GVHD theo định kỳ từng tuần:
- Quản lý nhật ký công việc đã thực hiện, đối chiếu với đề cương được duyệt.
- Tự động hóa chuyển đổi báo cáo Markdown sang tệp PDF có định dạng học thuật đẹp mắt, kèm tiêu đề nhận diện DTHU và khung chữ ký sinh viên.

---

## 2. Quy trình viết và xuất PDF báo cáo tiến độ tuần

1. **Tạo file mới:** Tạo tệp Markdown trong thư mục `ke-hoach/new/` theo mẫu:
   ```text
   ke-hoach/new/Weekly at DD-MM-YYYY.md
   ```
2. **Xuất file PDF:** Sử dụng script menu trung tâm `.\tool.ps1` hoặc xuất trực tiếp:
   ```powershell
   cd ke-hoach
   powershell -ExecutionPolicy Bypass -File .\tool\export-pdf.ps1
   ```
