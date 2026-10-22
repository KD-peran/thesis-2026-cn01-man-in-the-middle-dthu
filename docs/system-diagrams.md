# Tổng Hợp Sơ Đồ Kiến Trúc Hệ Thống & Luồng Tấn Công (Mermaid Diagrams)

> **Mục đích:** Tập hợp toàn bộ các sơ đồ thiết kế kiến trúc kỹ thuật của hệ thống phòng thử nghiệm, luồng tấn công Man-in-the-Middle và các cơ chế phòng thủ chuyên sâu dưới dạng mã nguồn mở Mermaid trực quan, có thể dựng hình động ngay trên trình duyệt và xuất ra tài liệu báo cáo.

---

## 1. Sơ Đồ Topo Phòng Thử Nghiệm 5 Thành Phần (Testbed Lab Topology)

```mermaid
graph TD
    subgraph SWITCH_ZONE ["SWITCH QUẢN LÝ TẦNG 2 (CISCO CATALYST 3750)"]
        SW["Cisco Catalyst 3750 Switch (VLAN 10)<br/>Định cấu hình: DHCP Snooping & Dynamic ARP Inspection"]
    end

    subgraph TRUSTED_ZONE ["VÙNG MẠNG TIN CẬY (TRUSTED PORTS)"]
        GW["Gateway / Router (VyOS / pfSense)<br/>IP: 192.168.10.1<br/>MAC: 00:50:79:66:68:01<br/>Cổng: Gi1/0/1 (Trusted)"]
        WEB["Web Server (Nginx + DVWA Target)<br/>IP: 192.168.10.100<br/>MAC: 00:50:79:66:68:10<br/>Cổng: Gi1/0/2 (Trusted)"]
    end

    subgraph UNTRUSTED_ZONE ["VÙNG TRUY CẬP NGƯỜI DÙNG & TẤN CÔNG (UNTRUSTED PORTS)"]
        VIC1["Victim 1 (Windows 10 Client)<br/>IP: 192.168.10.10<br/>MAC: 00:0C:29:AA:BB:10<br/>Cổng: Fa1/0/1 (Untrusted)"]
        KALI["Attacker (Kali Linux 2024)<br/>IP: 192.168.10.50<br/>MAC: 00:0C:29:CC:DD:50<br/>Cổng: Fa1/0/2 (Untrusted)"]
        VIC2["Victim 2 (Ubuntu 22.04 Client)<br/>IP: 192.168.10.20<br/>MAC: 00:0C:29:EE:FF:20<br/>Cổng: Fa1/0/3 (Untrusted)"]
    end

    GW ---|Gi1/0/1 Trusted| SW
    WEB ---|Gi1/0/2 Trusted| SW
    SW ---|Fa1/0/1 Untrusted| VIC1
    SW ---|Fa1/0/2 Untrusted| KALI
    SW ---|Fa1/0/3 Untrusted| VIC2

    style SW fill:#e0f2fe,stroke:#0284c7,stroke-width:2px;
    style KALI fill:#fee2e2,stroke:#ef4444,stroke-width:2px;
    style GW fill:#dcfce7,stroke:#22c55e,stroke-width:2px;
    style WEB fill:#dcfce7,stroke:#22c55e,stroke-width:2px;
```

---

## 2. Sơ Đồ Cơ Chế Đầu Độc Hai Chiều (Bidirectional ARP Poisoning)

```mermaid
sequenceDiagram
    autonumber
    actor Victim as Nạn nhân (Victim 1)<br/>192.168.10.10
    actor Attacker as Kẻ tấn công (Kali)<br/>192.168.10.50
    actor Gateway as Cổng mặc định (Gateway)<br/>192.168.10.1

    Note over Attacker: Kích hoạt IP Forwarding = 1
    
    Attacker->>Victim: Gói ARP Reply giả: 192.168.10.1 is at [MAC_Kali]
    Note over Victim: Bảng ARP Cache của Victim bị nhiễm độc!<br/>Nghĩ rằng Kali chính là Gateway.

    Attacker->>Gateway: Gói ARP Reply giả: 192.168.10.10 is at [MAC_Kali]
    Note over Gateway: Bảng ARP Cache của Gateway bị nhiễm độc!<br/>Nghĩ rằng Kali chính là Victim.

    Victim->>Attacker: Gói tin gửi ra ngoài (HTTP POST: User/Pass)
    Note over Attacker: Nghe lén, trích xuất mật khẩu & Cookie!
    Attacker->>Gateway: Chuyển tiếp gói tin đến Gateway hợp pháp

    Gateway->>Attacker: Gói tin phản hồi từ Internet
    Attacker->>Victim: Chuyển tiếp dữ liệu về cho Victim
```

---

## 3. Sơ Đồ Tấn Công Bóc Tách SSL (SSL Stripping)

```mermaid
sequenceDiagram
    autonumber
    actor Browser as Trình duyệt Nạn nhân
    actor Attacker as Bettercap (SSL Strip Proxy)
    actor Server as Web Server Ngân hàng (HTTPS)

    Browser->>Attacker: Yêu cầu HTTP: http://portal.dthu.edu.vn (Cổng 80)
    Note over Attacker: Bắt gói HTTP, thiết lập kết nối HTTPS với Server thật
    Attacker->>Server: Kết nối HTTPS an toàn (TLS 1.3 - Cổng 443)
    Server-->>Attacker: Phản hồi trang HTML đăng nhập qua HTTPS
    
    Note over Attacker: Quét mã HTML, thay thế:<br/>https:// -> http://<br/>Xóa biểu tượng ổ khóa
    Attacker-->>Browser: Trả về trang HTML đăng nhập qua HTTP bản rõ
    
    Browser->>Attacker: Gửi form đăng nhập HTTP (User/Pass dạng Cleartext)
    Note over Attacker: Đọc trọn vẹn thông tin đăng nhập!
    Attacker->>Server: Chuyển tiếp User/Pass qua kết nối HTTPS thật
```

---

## 4. Sơ Đồ Cơ Chế Phòng Vệ Tầng 2: Dynamic ARP Inspection & DHCP Snooping

```mermaid
flowchart TD
    Start["Gói tin ARP đi vào cổng Switch"] --> CheckPort{"Cổng này có phải là Trusted Port không?"}
    
    CheckPort -- "CÓ (Nối với Gateway)" --> Forward["CHUYỂN TIẾP GÓI TIN HỢP LỆ"]
    
    CheckPort -- "KHÔNG (Cổng Untrusted nối với Client/Attacker)" --> Inspect["Trích xuất (Sender MAC, Sender IP)<br/>Đối chiếu với DHCP Snooping Binding Table"]
    
    Inspect --> Valid{"Cặp (MAC, IP) có khớp với bản ghi DHCP không?"}
    
    Valid -- "TRÙNG KHỚP" --> RateCheck{"Tốc độ gói tin có vượt quá 15 pps không?"}
    RateCheck -- "DƯỚI NGƯỠNG" --> Forward
    RateCheck -- "VƯỢT NGƯỠNG" --> ErrDisable["Khóa cổng (err-disabled)<br/>Ghi log vi phạm DoS Switch"]
    
    Valid -- "SAI LỆCH (GIẢ MẠO)" --> Drop["TIÊU HỦY GÓI TIN NGAY (DROP)"]
    Drop --> LogMsg["Ghi nhật ký hệ thống: %SW_DAI-4-DHCP_SNOOPING_DENY<br/>Tăng bộ đếm ARP vi phạm"]

    style Forward fill:#dcfce7,stroke:#22c55e,stroke-width:2px;
    style Drop fill:#fee2e2,stroke:#ef4444,stroke-width:2px;
    style ErrDisable fill:#fef3c7,stroke:#f59e0b,stroke-width:2px;
```

---

## 5. Sơ Đồ Cơ Chế Bảo Vệ Tầng Ứng Dụng: HSTS & Đường Hầm VPN

```mermaid
graph LR
    subgraph CLIENT_ZONE ["MÁY KHÁCH (VICTIM CLIENT)"]
        Browser["Trình duyệt Web<br/>Bộ nhớ HSTS Preload Cache"]
        VpnClient["WireGuard VPN Client<br/>Giao diện mạng ảo wg0"]
    end

    subgraph INTERMEDIATE_ZONE ["KÊNH TRUYỀN MẠNG LAN (CÓ KALI MITM)"]
        LanWire["Đường truyền vật lý LAN<br/>(Kẻ tấn công sniffing chỉ thấy UDP mã hóa)"]
    end

    subgraph SERVER_ZONE ["HẠ TẦNG MÁY CHỦ BẢO VỆ"]
        VpnServer["WireGuard VPN Server"]
        WebServer["Web Server Nginx<br/>Bật TLS 1.3 & HSTS RFC 6797"]
    end

    Browser -->|Tự động nâng cấp HTTPS nội bộ| VpnClient
    VpnClient -->|Đóng gói mã hóa ChaCha20-Poly1305| LanWire
    LanWire -->|Đường hầm an toàn| VpnServer
    VpnServer -->|Lưu lượng an toàn| WebServer

    style Browser fill:#e0f2fe,stroke:#0284c7,stroke-width:1px;
    style VpnClient fill:#dcfce7,stroke:#22c55e,stroke-width:2px;
    style LanWire fill:#fee2e2,stroke:#ef4444,stroke-width:2px;
    style WebServer fill:#dcfce7,stroke:#22c55e,stroke-width:2px;
```
