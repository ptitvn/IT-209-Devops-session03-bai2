#!/bin/bash
# Chạy bằng root: bash setup.sh
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"

apt update && apt install -y nginx
systemctl enable --now nginx

mkdir -p /var/www/my-web/html
cp "$DIR/404.html" /var/www/my-web/html/404.html
echo "<h1>Trang chu cua toi</h1>" > /var/www/my-web/html/index.html
chown -R www-data:www-data /var/www/my-web

cp "$DIR/my-web" /etc/nginx/sites-available/my-web
ln -sf /etc/nginx/sites-available/my-web /etc/nginx/sites-enabled/my-web
rm -f /etc/nginx/sites-enabled/default

# Cảnh báo nếu còn site khác trong sites-enabled (có thể trùng server_name "_")
OTHERS=$(ls /etc/nginx/sites-enabled | grep -v '^my-web$' || true)
if [ -n "$OTHERS" ]; then
  echo "[!] Con site khac dang bat: $OTHERS"
  echo "    Neu thay canh bao 'conflicting server name', go bang: rm /etc/nginx/sites-enabled/<ten-site>"
fi

nginx -t
systemctl reload nginx

# Mở firewall nếu ufw đang bật
if command -v ufw >/dev/null && ufw status | grep -q "Status: active"; then
  ufw allow 80/tcp
fi

echo
echo "===== KIEM TRA ====="
echo "--- /invalid-path-demo ---"
curl -I http://localhost/invalid-path-demo
echo "--- noi dung trang loi ---"
curl -s http://localhost/invalid-path-demo | head -n 8
echo "--- /404.html (truy cap truc tiep) ---"
curl -I http://localhost/404.html
