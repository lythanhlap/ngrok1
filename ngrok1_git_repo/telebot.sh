#!/data/data/com.termux/files/usr/bin/bash

# Token và Chat ID của bạn
BOT_TOKEN="7701715072:AAE8sqGrQpJeP7R60vP1sdGTJAOoTUdWtzQ"
CHAT_ID="7914691499"

echo "[+] Bắt đầu lắng nghe Telegram bot..."
LAST_UPDATE_ID=0

while true; do
    RESPONSE=$(curl -s "https://api.telegram.org/bot$BOT_TOKEN/getUpdates?offset=$((LAST_UPDATE_ID+1))")
    MESSAGE=$(echo $RESPONSE | jq -r '.result[0].message.text')
    UPDATE_ID=$(echo $RESPONSE | jq -r '.result[0].update_id')

    if [ "$UPDATE_ID" != "null" ]; then
        echo "[+] Nhận lệnh: $MESSAGE"
        LAST_UPDATE_ID=$UPDATE_ID

        if [ "$MESSAGE" == "/startport" ]; then
            pkill -f "python3 -m http.server" 2>/dev/null
            nohup python3 -m http.server 8080 >/dev/null 2>&1 &
            pkill -f "./ngrok http" 2>/dev/null
            nohup ./ngrok http 8080 > ngrok.log 2>&1 &
            sleep 5
            NGROK_URL=$(grep -o 'https://[0-9a-z]*\.ngrok.io' ngrok.log | head -n1)
            curl -s -X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="✅ Port đã mở tại: $NGROK_URL"

        elif [ "$MESSAGE" == "/stopport" ]; then
            pkill -f "python3 -m http.server"
            pkill -f "./ngrok http"
            curl -s -X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="🛑 Đã tắt HTTP server và ngrok"

        elif [ "$MESSAGE" == "/status" ]; then
            HTTP_STATUS=$(pgrep -f "python3 -m http.server" > /dev/null && echo "Đang chạy" || echo "Tắt")
            NGROK_STATUS=$(pgrep -f "./ngrok http" > /dev/null && echo "Đang chạy" || echo "Tắt")
            NGROK_URL=$(grep -o 'https://[0-9a-z]*\.ngrok.io' ngrok.log | head -n1)
            STATUS_MSG="📊 Trạng thái hệ thống:
- HTTP server: $HTTP_STATUS
- Ngrok: $NGROK_STATUS
- Link: $NGROK_URL"
            curl -s -X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="$STATUS_MSG"
        fi
    fi
    sleep 2
done
