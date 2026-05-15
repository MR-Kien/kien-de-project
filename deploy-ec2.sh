#!/bin/bash
# Script để deploy Airflow bằng Docker Compose trên EC2

# Chuyển đến thư mục dự án (GitHub Actions sẽ clone code vào thư mục này)
cd "$(dirname "$0")"

echo "--- Bước 1: Khởi tạo thư mục và quyền ---"
mkdir -p ./dags ./logs ./plugins ./dbt_project
echo -e "AIRFLOW_UID=$(id -u)" > .env

echo "--- Bước 2: Dừng các container cũ (nếu có) ---"
sudo docker-compose down

echo "--- Bước 3: Build và khởi động lại Airflow ---"
sudo docker-compose up --build -d

echo "--- SUCCESS! ---"
echo "Airflow đang chạy trên EC2 bằng Docker Compose."
echo "Bạn có thể truy cập qua http://<EC2_PUBLIC_IP>:8080"
