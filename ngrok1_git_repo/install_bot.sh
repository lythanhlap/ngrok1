#!/data/data/com.termux/files/usr/bin/bash

echo "[+] Đang cài gói cần thiết..."
pkg update -y
pkg install -y wget unzip curl jq python

echo "[+] Tải bot về..."
cd $HOME
mkdir -p .telebot && cd .telebot

wget https://raw.githubusercontent.com/zimz102/ngrok1/main/telebot.sh -O telebot.sh
chmod +x telebot.sh

echo "[+] Chạy bot Telegram..."
./telebot.sh
