# Script tao Slide PowerPoint (.pptx)
$outputDir = "d:\Nien-Luan-MNT&AN\thesis-2026-cn01-man-in-the-middle-dthu\slide"
if (!(Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }
$pptxPath = Join-Path $outputDir "Slide_Bao_cao_0023410647_NguyenThiKyDuyen.pptx"

Write-Host "Dang khoi tao Microsoft PowerPoint..." -ForegroundColor Cyan
$pptApp = New-Object -ComObject PowerPoint.Application
$pptApp.DisplayAlerts = 1

try {
    $presentation = $pptApp.Presentations.Add(0)
    $presentation.PageSetup.SlideWidth = 960
    $presentation.PageSetup.SlideHeight = 540

    # Slide 1: BIA
    $slide1 = $presentation.Slides.Add(1, 1)
    $slide1.Shapes.Title.TextFrame.TextRange.Text = "NGHIÊN CỨU KỸ THUẬT KHAI THÁC VÀ PHÒNG CHỐNG TẤN CÔNG MAN-IN-THE-MIDDLE"
    $slide1.Shapes.Title.TextFrame.TextRange.Font.Size = 22
    $slide1.Shapes.Title.TextFrame.TextRange.Font.Bold = 1
    $slide1.Shapes.Title.TextFrame.TextRange.Font.Name = "Times New Roman"

    $slide1.Shapes.Placeholders.Item(2).TextFrame.TextRange.Text = @"
TRƯỜNG ĐẠI HỌC ĐỒNG THÁP - KHOA CÔNG NGHỆ VÀ KỸ THUẬT
BÁO CÁO BẢO VỆ NIÊN LUẬN CHUYÊN NGÀNH MẠNG MÁY TÍNH VÀ AN NINH

Sinh viên thực hiện: NGUYỄN THỊ KỲ DUYÊN (MSSV: 0023410647)
Lớp: ĐHCNTT23B-CS | Niên khóa: 2023 - 2027
Giảng viên hướng dẫn: ThS. TRỊNH LÊ HOÀNG TUẤN
Thời gian thực hiện: 19/10/2026 - 19/12/2026 | Báo cáo: Tháng 12/2026
"@
    $slide1.Shapes.Placeholders.Item(2).TextFrame.TextRange.Font.Size = 14
    $slide1.Shapes.Placeholders.Item(2).TextFrame.TextRange.Font.Name = "Times New Roman"

    # Slide 2: TONG QUAN
    $slide2 = $presentation.Slides.Add(2, 2)
    $slide2.Shapes.Title.TextFrame.TextRange.Text = "1. TÍNH CẤP THIẾT VÀ MỤC TIÊU NGHIÊN CỨU"
    $slide2.Shapes.Title.TextFrame.TextRange.Font.Size = 22
    $slide2.Shapes.Title.TextFrame.TextRange.Font.Bold = 1
    $slide2.Shapes.Placeholders.Item(2).TextFrame.TextRange.Text = @"
1. Tính cấp thiết:
   - Các giao thức mạng cổ điển (ARP, DNS, DHCP, HTTP) thiếu cơ chế xác thực nguồn gốc và kiểm tra toàn vẹn gói tin.
   - Kẻ tấn công Man-in-the-Middle (MitM) có thể nghe lén mật khẩu, đánh cắp cookie phiên, sửa đổi nội dung và tiêm mã độc.

2. Mục tiêu nghiên cứu:
   - Phân tích chuyên sâu 6 kỹ thuật dẫn đường: ARP Spoofing, DNS Spoofing, DHCP Spoofing, ICMP Redirect, Rogue AP, SSL Stripping.
   - Nghiên cứu cơ chế tấn công vào phiên và dữ liệu: Session Hijacking, đánh cắp Cookie, làm giả nội dung (Tampering).
   - Thiết lập mô hình phòng thử nghiệm (Testbed Lab) 5 node: Kali Linux, 02 máy nạn nhân, Gateway, Web Server Nginx.
   - Triển khai giải pháp phòng vệ đa tầng: HTTPS/HSTS, Dynamic ARP Inspection (DAI), DHCP Snooping, VPN WireGuard, Giám sát ARP.
   - Chạy lại các đợt tấn công để kiểm chứng vô hiệu hóa mối đe dọa.
"@
    $slide2.Shapes.Placeholders.Item(2).TextFrame.TextRange.Font.Size = 13
    $slide2.Shapes.Placeholders.Item(2).TextFrame.TextRange.Font.Name = "Times New Roman"

    # Slide 3: KY THUAT KHAI THAC
    $slide3 = $presentation.Slides.Add(3, 2)
    $slide3.Shapes.Title.TextFrame.TextRange.Text = "2. CÁC KỸ THUẬT KHAI THÁC VÀ DẪN ĐƯỜNG LƯU LƯỢNG"
    $slide3.Shapes.Title.TextFrame.TextRange.Font.Size = 22
    $slide3.Shapes.Title.TextFrame.TextRange.Font.Bold = 1
    $slide3.Shapes.Placeholders.Item(2).TextFrame.TextRange.Text = @"
1. Các kỹ thuật dẫn đường lưu lượng:
   - ARP Cache Poisoning (RFC 826): Gửi gói tin ARP Reply giả mạo để chiếm vị trí trung gian giữa Gateway và Nạn nhân.
   - DNS Spoofing: Đón bắt truy vấn UDP 53, trả về IP máy chủ độc hại của Attacker.
   - DHCP Spoofing & Starvation: Chiếm cạn kiệt tài nguyên IP và thiết lập Gateway/DNS giả mạo.
   - SSL Stripping (Moxie Marlinspike): Đánh chặn liên kết và bóc tách kết nối HTTPS xuống HTTP bản rõ.

2. Các kiểu tấn công vào phiên và dữ liệu:
   - Session Hijacking: Thu thập Cookie xác thực phiên người dùng thiếu cờ bảo vệ (Secure, HttpOnly).
   - Content Tampering: Sửa đổi mã HTML/JavaScript trong luồng truyền HTTP bản rõ để đánh cắp thông tin nhạy cảm.
"@
    $slide3.Shapes.Placeholders.Item(2).TextFrame.TextRange.Font.Size = 13
    $slide3.Shapes.Placeholders.Item(2).TextFrame.TextRange.Font.Name = "Times New Roman"

    # Slide 4: TESTBED LAB
    $slide4 = $presentation.Slides.Add(4, 2)
    $slide4.Shapes.Title.TextFrame.TextRange.Text = "3. MÔ HÌNH PHÒNG THỬ NGHIỆM (TESTBED LAB)"
    $slide4.Shapes.Title.TextFrame.TextRange.Font.Size = 22
    $slide4.Shapes.Title.TextFrame.TextRange.Font.Bold = 1
    $slide4.Shapes.Placeholders.Item(2).TextFrame.TextRange.Text = @"
1. Cấu trúc mô hình mạng thử nghiệm (Subnet 192.168.10.0/24 - VLAN 10):
   - Máy kẻ tấn công (Kali Linux 2024): IP 192.168.10.50 (MAC: 08:00:27:11:22:33) - arpspoof, scapy, bettercap.
   - Máy nạn nhân 01 (Windows 10/11 Client): IP 192.168.10.10 (MAC: 00:0C:29:AA:BB:CC) - Trình duyệt Edge/Chrome.
   - Máy nạn nhân 02 (Ubuntu Desktop): IP 192.168.10.20 (MAC: 00:0C:29:DD:EE:FF) - Trình duyệt Firefox.
   - Gateway / Switch: IP 192.168.10.1 (MAC: 00:50:56:EA:01:01) - Cấu hình DHCP Snooping và DAI.
   - Web Server Nginx nội bộ: IP 192.168.10.100 - Hỗ trợ dịch vụ HTTP và HTTPS/TLS 1.3.

2. Công cụ kiểm thử và thu thập:
   - Wireshark, tcpdump, Docker Compose, Python Scapy, Dnsmasq, OpenSSL PKI.
"@
    $slide4.Shapes.Placeholders.Item(2).TextFrame.TextRange.Font.Size = 13
    $slide4.Shapes.Placeholders.Item(2).TextFrame.TextRange.Font.Name = "Times New Roman"

    # Slide 5: GIAI PHAP PHONG THU
    $slide5 = $presentation.Slides.Add(5, 2)
    $slide5.Shapes.Title.TextFrame.TextRange.Text = "4. TRIỂN KHAI CÁC GIẢI PHÁP PHÒNG CHỐNG ĐA LỚP"
    $slide5.Shapes.Title.TextFrame.TextRange.Font.Size = 22
    $slide5.Shapes.Title.TextFrame.TextRange.Font.Bold = 1
    $slide5.Shapes.Placeholders.Item(2).TextFrame.TextRange.Text = @"
1. Tầng liên kết dữ liệu (Data Link - Lớp 2):
   - DHCP Snooping: Phân định Trusted/Untrusted ports, tự động tạo DHCP Binding Database.
   - Dynamic ARP Inspection (DAI): Đối soát từng gói ARP với Binding Database, hủy bỏ toàn bộ gói tin giả mạo.

2. Tầng ứng dụng (Application - Lớp 7):
   - HTTPS & HSTS (RFC 6797): max-age=31536000; includeSubDomains; preload triệt tiêu SSL Stripping.
   - Bảo mật Cookie: Bắt buộc cờ Secure, HttpOnly và thuộc tính SameSite=Strict.

3. Tầng mạng & Giám sát thời gian thực:
   - Mạng riêng ảo VPN (WireGuard/IPsec): Mã hóa toàn vẹn lưu lượng giữa Client và Server.
   - Công cụ giám sát ARP thời gian thực: Quét liên tục bảng ARP và kích hoạt cảnh báo khi phát hiện trùng lặp MAC/IP.
"@
    $slide5.Shapes.Placeholders.Item(2).TextFrame.TextRange.Font.Size = 13
    $slide5.Shapes.Placeholders.Item(2).TextFrame.TextRange.Font.Name = "Times New Roman"

    # Slide 6: KET QUA DOI SANH
    $slide6 = $presentation.Slides.Add(6, 2)
    $slide6.Shapes.Title.TextFrame.TextRange.Text = "5. KẾT QUẢ THỰC NGHIỆM ĐỐI SÁNH TRƯỚC VÀ SAU PHÒNG THỦ"
    $slide6.Shapes.Title.TextFrame.TextRange.Font.Size = 22
    $slide6.Shapes.Title.TextFrame.TextRange.Font.Bold = 1
    $slide6.Shapes.Placeholders.Item(2).TextFrame.TextRange.Text = @"
1. Tấn công ARP Spoofing / Poisoning:
   - Trước phòng thủ: 10/10 lần thành công, bảng ARP nạn nhân bị đầu độc trong 1.2s.
   - Sau khi bật DAI: 0/10 lần thành công, 100% gói tin ARP giả mạo bị Switch Drop và ghi log cảnh báo.

2. Tấn công SSL Stripping & Đánh cắp Cookie:
   - Trước phòng thủ: 10/10 lần thành công, toàn bộ Cookie và mật khẩu bản rõ bị kẻ tấn công chụp lại.
   - Sau khi bật HSTS: 0/10 lần thành công, trình duyệt tự động nâng cấp HTTPS, từ chối kết nối HTTP.

3. Tấn công Rogue DHCP Server:
   - Trước phòng thủ: Nạn nhân bị gán Gateway giả mạo trong vòng 0.8s.
   - Sau khi bật DHCP Snooping: Gói DHCP Reply độc hại bị chặn lập tức tại cổng Untrusted.
"@
    $slide6.Shapes.Placeholders.Item(2).TextFrame.TextRange.Font.Size = 13
    $slide6.Shapes.Placeholders.Item(2).TextFrame.TextRange.Font.Name = "Times New Roman"

    # Slide 7: KET LUAN
    $slide7 = $presentation.Slides.Add(7, 2)
    $slide7.Shapes.Title.TextFrame.TextRange.Text = "6. KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN"
    $slide7.Shapes.Title.TextFrame.TextRange.Font.Size = 22
    $slide7.Shapes.Title.TextFrame.TextRange.Font.Bold = 1
    $slide7.Shapes.Placeholders.Item(2).TextFrame.TextRange.Text = @"
1. Kết quả đạt được:
   - Hoàn thành đầy đủ các mục tiêu nghiên cứu dưới sự hướng dẫn của ThS. Trịnh Lê Hoàng Tuấn.
   - Xây dựng thành công mô hình thử nghiệm 5 node và bộ kịch bản thực nghiệm tấn công/phòng thủ thực tế.
   - Đạt kết quả phòng thủ 100% trước các kỹ thuật ARP Spoofing, DNS Spoofing, DHCP Spoofing và SSL Stripping.
   - Hoàn thiện trọn bộ hồ sơ bản in và gói số hóa nộp niên luận đúng hạn quy định.

2. Hướng phát triển trong tương lai:
   - Nghiên cứu phòng chống MitM trên giao thức IPv6 (NDP Spoofing / RA Guard).
   - Ứng dụng trí tuệ nhân tạo (Machine Learning) để nhận diện bất thường lưu lượng trên mạng định nghĩa bằng phần mềm (SDN).

KÍNH CHÚC QUÝ THẦY CÔ SỨC KHỎE VÀ THÀNH CÔNG!
XIN TRÂN TRỌNG CẢM ƠN!
"@
    $slide7.Shapes.Placeholders.Item(2).TextFrame.TextRange.Font.Size = 13
    $slide7.Shapes.Placeholders.Item(2).TextFrame.TextRange.Font.Name = "Times New Roman"

    # Luu file
    $presentation.SaveAs($pptxPath)
    $presentation.Close()
    Write-Host "Da tao thanh cong Slide PowerPoint: $pptxPath" -ForegroundColor Green
}
finally {
    $pptApp.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($pptApp) | Out-Null
}
