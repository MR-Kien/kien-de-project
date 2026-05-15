# 🚀 Olist Data Engineering Pipeline (Airflow 3)

Dự án này triển khai một Data Pipeline hoàn chỉnh (End-to-End) để thu thập, lưu trữ và xử lý dữ liệu thương mại điện tử từ Kaggle (Olist Dataset). Sử dụng các công nghệ hiện đại nhất như **Airflow 3**, **Kubernetes**, **S3**, và **dbt**.

---

## 🏗️ Kiến trúc hệ thống (Architecture)

1.  **Data Source**: Tự động tải Brazilian E-Commerce Public Dataset từ **Kaggle**.
2.  **Orchestration**: Sử dụng **Apache Airflow 3.0.0** với tính năng **Data Assets (AIP-63)** để quản lý luồng dữ liệu dựa trên sự thay đổi của vật thể (Asset-driven).
3.  **Storage**: Dữ liệu Raw được đẩy lên **Amazon S3** (`kien-data-lake-2026`).
4.  **Processing**: Tích hợp **Databricks** để xử lý dữ liệu lớn.
5.  **Transformation**: Sử dụng **dbt** (Data Build Tool) để chuyển đổi và xây dựng mô hình dữ liệu (Data Modeling).
6.  **Infrastructure**: Toàn bộ hệ thống chạy trên **Kubernetes (Kind cluster)** và được quản lý bằng **Helm**.

---

## 📂 Cấu trúc thư mục (Project Structure)

```text
kien-de-project/
├── dags/                # Chứa các Airflow DAGs (Workflow định nghĩa luồng dữ liệu)
├── dbt_project/         # Dự án dbt để transform dữ liệu
├── databricks/          # Các scripts/notebooks chạy trên Databricks
├── kubernetes/          # Cấu hình K8s (Manifests, ConfigMaps...)
├── Dockerfile           # Build custom image Airflow 3
├── docker-compose.yaml  # Cấu hình chạy local (dành cho dev/test)
├── deploy.bat           # Script tự động build image và cập nhật lên K8s Cluster
└── run_airflow.bat      # Script mở port-forward để truy cập UI Airflow
```

---

## 🛠️ Yêu cầu hệ thống (Prerequisites)

*   **Docker Desktop** (Đã bật Kubernetes).
*   **Kind** (Kubernetes in Docker).
*   **Helm** (Để quản lý Airflow Chart).
*   **Kubectl** (Để điều khiển cluster).
*   **AWS CLI & Kaggle API Key** (Cấu hình credentials).

---

## 🚀 Hướng dẫn triển khai (Deployment)

### 1. Triển khai lên Kubernetes
Chạy file script sau để tự động Build image và Push vào Kind cluster:
```powershell
.\deploy.bat
```
*Script này sẽ thực hiện: Build Docker Image v5.7 -> Load vào Kind Cluster -> Cập nhật Airflow qua Helm.*

### 2. Truy cập Airflow UI
Sau khi deploy thành công, chạy script sau để mở cổng kết nối:
```powershell
.\run_airflow.bat
```
Sau đó truy cập: [http://localhost:8080](http://localhost:8080)

---

## ⚙️ Cấu hình (Configuration)

Các biến môi trường và kết nối cần thiết trong Airflow:
*   `aws_conn`: Kết nối tới AWS S3.
*   `databricks_default`: Kết nối tới Databricks Workspace.
*   `S3_BUCKET`: `kien-data-lake-2026`.

---

## 📝 Ghi chú về Airflow 3
Dự án này tiên phong sử dụng các tính năng mới của **Airflow 3**:
*   **Assets**: Thay thế cho Dataset truyền thống, cho phép định nghĩa các vật thể dữ liệu (`Asset`) và quản lý luồng Producer/Consumer hiệu quả hơn.
*   **Task Decorators**: Sử dụng `@task` triệt để giúp code sạch và dễ bảo trì hơn.

