# NỘI DUNG TỔNG HỢP VÀ CÔNG CỤ VẼ SƠ ĐỒ PIPELINE

**Đề tài:** Nghiên cứu kỹ thuật khai thác và phòng chống tấn công Man-in-the-Middle  
**Sinh viên thực hiện:** Nguyễn Thị Kỳ Duyên (MSSV: `0023410647` — Lớp: `ĐHCNTT23B-CS`)  
**Giảng viên hướng dẫn:** TS. Lương Thái Ngọc  
**Cơ sở đào tạo:** Trường Đại học Đồng Tháp (DTHU) — Khoa Công nghệ và Kỹ thuật

---

## 1. Mục đích thư mục

Thư mục `noi-dung-tong-hop/` có các nhiệm vụ chiến lược:
1. **Lưu trữ tài liệu nghiên cứu chuyên sâu:** Nghiên cứu tổng hợp chuyên đề về kỹ thuật khai thác và phòng chống Man-in-the-Middle theo chuẩn WHAT - WHY - HOW.
2. **Hệ thống hóa toàn bộ tài liệu kiến trúc:** Sơ đồ phòng thử nghiệm Testbed Lab 5 node, luồng tấn công ARP/DNS Spoofing, SSL Stripping và cơ chế phòng vệ Dynamic ARP Inspection & DHCP Snooping.
3. **Pipeline tự động hóa (Tool trong Tool):** Trích xuất tự động các khối sơ đồ Mermaid trong Markdown, xuất ảnh PNG độ phân giải cao và tạo ra file PDF tổng hợp hoàn chỉnh.

---

## 2. Cách thức khởi chạy

Sử dụng script menu trung tâm:
- Chạy `.\tool.ps1` ở thư mục gốc để biên dịch báo cáo LaTeX hoặc xem tài liệu Docsify trên trình duyệt.
- Hoặc xuất tài liệu tổng hợp trực tiếp:
```powershell
cd noi-dung-tong-hop
powershell -ExecutionPolicy Bypass -File .\tool\export-pdf.ps1 -DirectOnly
```
