# Session 03 – Bài 2: Custom Error Page 404 (Nginx)

## Mục tiêu
Cấu hình Nginx phục vụ trang lỗi 404 tùy biến và chặn truy cập trực tiếp `/404.html` bằng chỉ thị `internal`.

## Nội dung thư mục
| File | Mô tả |
|------|-------|
| `404.html` | Trang lỗi 404 tùy biến, đặt tại `/var/www/my-web/html/` |
| `my-web` | Server Block Nginx (`/etc/nginx/sites-available/my-web`) |
| `setup.sh` | Script cài đặt và kiểm tra tự động trên Ubuntu |
| `screenshots/` | Ảnh minh chứng |

## Cấu hình chính
```nginx
error_page 404 /404.html;

location = /404.html {
    root /var/www/my-web/html;
    internal;
}
```

## Các bước thực hiện
1. Cài Nginx, tạo thư mục `/var/www/my-web/html/`.
2. Tạo `404.html` và `index.html`.
3. Tạo Server Block `my-web`, liên kết vào `sites-enabled`, gỡ site `default` và `ptit-web` cũ (tránh trùng `server_name _`).
4. `sudo nginx -t` → `sudo systemctl reload nginx`.
5. Kiểm tra bằng `curl -I`.

## Kết quả kiểm tra (VPS: 160.187.229.76)
| Lệnh | Kết quả |
|------|---------|
| `curl -I http://160.187.229.76/invalid-path-demo` | `HTTP/1.1 404 Not Found`, `Content-Length: 823` (trang tùy biến) |
| `curl -I http://160.187.229.76/404.html` | `HTTP/1.1 404 Not Found` (bị `internal` chặn truy cập trực tiếp) |

## Ảnh minh chứng
1. `01_ssh_vao_vps_va_chay_setup.png` – SSH vào VPS Ubuntu 22.04
2. `02_ket_qua_kiem_tra_tren_vps.png` – Kết quả `setup.sh` và kiểm tra `curl` trên VPS
3. `03_nginx_t_sach_va_curl_localhost.png` – `nginx -t` không còn cảnh báo, `curl` đều trả về 404
4. `04_curl_tu_may_ngoai_toi_IP_VPS.png` – `curl` từ máy cá nhân tới IP công khai của VPS
5. `05_trang_404_tuy_bien.png` – Giao diện trang `404.html` (ảnh render từ file)
6. `06_git_push_len_github.png` – Đẩy bài lên GitHub
