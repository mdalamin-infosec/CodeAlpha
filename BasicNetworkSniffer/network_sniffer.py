from scapy.all import sniff, IP, TCP, UDP, ICMP, Raw
from datetime import datetime

packet_count = 0

def analyze_packet(packet):
    global packet_count
    packet_count += 1

    print("\n" + "=" * 65)
    print(f"Packet Number : {packet_count}")
    print(f"Time          : {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"Packet Length : {len(packet)} bytes")

    if packet.haslayer(IP):
        print(f"Source IP     : {packet[IP].src}")
        print(f"Destination IP: {packet[IP].dst}")

        if packet.haslayer(TCP):
            print("Protocol      : TCP")
            print(f"Source Port   : {packet[TCP].sport}")
            print(f"Destination Port: {packet[TCP].dport}")

        elif packet.haslayer(UDP):
            print("Protocol      : UDP")
            print(f"Source Port   : {packet[UDP].sport}")
            print(f"Destination Port: {packet[UDP].dport}")

        elif packet.haslayer(ICMP):
            print("Protocol      : ICMP")

        else:
            print(f"Protocol      : IP Protocol {packet[IP].proto}")

        if packet.haslayer(Raw):
            print(f"Payload       : {bytes(packet[Raw].load)[:150]}")
        else:
            print("Payload       : No Payload")

    print(f"Summary       : {packet.summary()}")
    print("=" * 65)


print("""
========================================
     CodeAlpha Basic Network Sniffer
========================================
Interface: eth1
Press CTRL+C to stop
""")

sniff(
    iface="eth1",
    prn=analyze_packet,
    store=False
)

