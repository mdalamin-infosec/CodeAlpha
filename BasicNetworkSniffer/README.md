# Python Network Packet Sniffer

A Python-based network packet sniffer built with Scapy.

Developed as part of the CodeAlpha Cyber Security Internship.

## Features

- Captures live network packets
- Displays source and destination IP addresses
- Detects TCP, UDP and ICMP traffic
- Displays source and destination ports
- Displays packet length
- Displays packet payload
- Shows packet summary

## Lab Environment

- Kali Linux: 192.168.56.103
- Ubuntu Server: 192.168.56.102
- VirtualBox lab network

## Installation

sudo apt install python3-scapy -y

## Run

sudo python3 network_sniffer.py

## ICMP Test

From Ubuntu Server:

ping -c 4 192.168.56.103

## TCP Payload Test

Ubuntu Server:

nc -lvnp 4444

Kali Linux:

echo "Hello CodeAlpha Network Sniffer" | nc 192.168.56.102 4444

## Ethical Use

For educational use and authorized network environments only.
