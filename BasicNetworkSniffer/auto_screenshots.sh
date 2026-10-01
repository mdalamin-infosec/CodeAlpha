#!/bin/bash

set -e

PROJECT_DIR="$HOME/CodeAlpha_BasicNetworkSniffer"
SCREENSHOT_DIR="$PROJECT_DIR/screenshots"

KALI_IP="192.168.56.103"
UBUNTU_IP="192.168.56.102"
UBUNTU_USER="mrnobody"

mkdir -p "$SCREENSHOT_DIR"

echo "============================================"
echo " CodeAlpha Screenshot Automation"
echo "============================================"

echo
echo "[1] Network setup screenshot"
clear
echo "KALI:"
ip -br addr
echo
echo "UBUNTU:"
ssh "$UBUNTU_USER@$UBUNTU_IP" "ip -br addr"
sleep 3
gnome-screenshot -f "$SCREENSHOT_DIR/01-network-setup.png"

echo
echo "[2] Sniffer running screenshot"
cd "$PROJECT_DIR"
sudo timeout 8 python3 network_sniffer.py &
sleep 3
gnome-screenshot -f "$SCREENSHOT_DIR/02-sniffer-running.png"
wait || true

echo
echo "[3] ICMP capture screenshot"

ICMP_LOG="/tmp/icmp_capture.txt"
rm -f "$ICMP_LOG"

sudo timeout 8 python3 network_sniffer.py > "$ICMP_LOG" 2>&1 &
sleep 2

ssh "$UBUNTU_USER@$UBUNTU_IP" "ping -c 4 $KALI_IP" >/dev/null 2>&1

sleep 2
clear
grep -A 10 -B 2 "Protocol          : ICMP" "$ICMP_LOG" | head -30

sleep 3
gnome-screenshot -f "$SCREENSHOT_DIR/03-icmp-capture.png"

echo
echo "[4] TCP payload screenshot"

TCP_LOG="/tmp/tcp_capture.txt"
rm -f "$TCP_LOG"

ssh "$UBUNTU_USER@$UBUNTU_IP" \
"pkill -f 'nc -l.*4444' 2>/dev/null || true; nohup nc -lvnp 4444 >/tmp/nc.log 2>&1 &"

sleep 2

sudo timeout 10 python3 network_sniffer.py > "$TCP_LOG" 2>&1 &
sleep 2

echo "Hello CodeAlpha Network Sniffer" | nc -w 2 "$UBUNTU_IP" 4444 || true

sleep 3
clear

grep -A 12 -B 4 "Hello CodeAlpha Network Sniffer" "$TCP_LOG" | head -40 || \
grep -A 12 -B 4 "Destination Port  : 4444" "$TCP_LOG" | head -40

sleep 3
gnome-screenshot -f "$SCREENSHOT_DIR/04-tcp-payload-capture.png"

echo
echo "============================================"
echo " Screenshots completed"
echo "============================================"
ls -lh "$SCREENSHOT_DIR"
