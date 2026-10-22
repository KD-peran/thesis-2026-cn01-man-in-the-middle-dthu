#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Hệ thống Giám sát & Phát hiện Bất thường ARP Spoofing Thời Gian Thực
Tác giả: Nguyễn Thị Kỳ Duyên (MSSV: 0023410647 - Lớp: ĐHCNTT23B-CS)
Đề tài: Nghiên cứu kỹ thuật khai thác và phòng chống tấn công Man-in-the-Middle

Cách dùng:
    sudo python3 arp_monitor_detector.py -i eth0 -g 192.168.10.1
"""

import argparse
import datetime
import os
import sys
from scapy.all import ARP, sniff

# Bảng lưu vết ánh xạ IP -> MAC trong mạng
ip_mac_table = {}

def log_alert(message):
    """Ghi cảnh báo ra màn hình và tệp nhật ký an ninh"""
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    formatted_msg = f"[{timestamp}] [CẢNH BÁO AN NINH MITM] {message}"
    print(f"\033[91m{formatted_msg}\033[0m")
    with open("arp_security_alerts.log", "a", encoding="utf-8") as f:
        f.write(formatted_msg + "\n")

def analyze_arp_packet(pkt, monitored_gateway):
    """Phân tích từng gói tin ARP để phát hiện xung đột MAC-IP (MAC Flapping)"""
    if pkt.haslayer(ARP) and pkt[ARP].op == 2:  # Chỉ kiểm tra gói ARP Reply
        src_ip = pkt[ARP].psrc
        src_mac = pkt[ARP].hwsrc.lower()

        # Kiểm tra nếu IP đã tồn tại trong bảng theo dõi
        if src_ip in ip_mac_table:
            old_mac = ip_mac_table[src_ip].lower()
            if old_mac != src_mac:
                # Phát hiện địa chỉ MAC bị thay đổi đột ngột!
                if src_ip == monitored_gateway:
                    log_alert(f"PHÁT HIỆN ARP SPOOFING CHÍ MẠNG VÀO GATEWAY {src_ip}!\n"
                              f"    -> MAC Hợp Pháp Cũ: {old_mac}\n"
                              f"    -> MAC Giả Mạo Mới: {src_mac} (Attacker đang đầu độc mạng!)")
                else:
                    log_alert(f"Phát hiện xung đột IP-MAC cho {src_ip}!\n"
                              f"    -> MAC Cũ: {old_mac} | MAC Mới: {src_mac}")
                # Cập nhật để theo dõi tiếp
                ip_mac_table[src_ip] = src_mac
        else:
            # Ghi nhận lần đầu thiết bị xuất hiện
            ip_mac_table[src_ip] = src_mac
            print(f"[*] Ghi nhận thiết bị mới: IP {src_ip} <-> MAC {src_mac}")

def main():
    parser = argparse.ArgumentParser(description="Công cụ giám sát và phát hiện tấn công ARP Spoofing thời gian thực")
    parser.add_argument("-i", "--interface", default="eth0", help="Giao diện mạng giám sát (Mặc định: eth0)")
    parser.add_argument("-g", "--gateway", default="192.168.10.1", help="Địa chỉ IP của Gateway cần bảo vệ đặc biệt")
    args = parser.parse_args()

    iface = args.interface
    gateway_ip = args.gateway

    print("=" * 65)
    print("   HỆ THỐNG GIÁM SÁT & PHÁT HIỆN BẤT THƯỜNG ARP SPOOFING (IDS)       ")
    print("   Đề tài: Nghiên cứu kỹ thuật khai thác & phòng chống MitM         ")
    print("=" * 65)
    print(f"[*] Giao diện mạng giám sát: {iface}")
    print(f"[*] Địa chỉ Gateway trọng yếu: {gateway_ip}")
    print("[*] Đang chủ động lắng nghe các bản tin ARP... Nhấn Ctrl+C để thoát.")

    try:
        sniff(filter="arp", iface=iface,
              prn=lambda pkt: analyze_arp_packet(pkt, gateway_ip), store=0)
    except KeyboardInterrupt:
        print("\n[+] Đã dừng hệ thống giám sát ARP an toàn.")

if __name__ == "__main__":
    main()
