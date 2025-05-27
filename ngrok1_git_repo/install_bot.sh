#!/data/data/com.termux/files/usr/bin/bash

echo "[+] Đang cài gói cần thiết..."
pkg update -y
pkg install -y wget unzip curl jq python

echo "[+] Tải bot về..."
cd $HOME
mkdir -p .telebot && cd .telebot

wget https://raw.githubusercontent.com/lythanhlap/ngrok1/blob/7e5ede31a58dd4279b1401dcfb60af04d687ff80/ngrok1_git_repo/telebot.sh -O telebot.sh
chmod +x telebot.sh

echo "[+] Chạy bot Telegram..."
./telebot.sh
