# Sử dụng image chính thức của Airflow làm base
FROM apache/airflow:2.7.2-python3.9

USER root
# Cài đặt git để phục vụ GitSync nếu cần và các thư viện hệ thống
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER airflow

# Cài đặt các provider để kết nối AWS, Databricks và Kubernetes
RUN pip install --no-cache-dir \
    apache-airflow-providers-amazon \
    apache-airflow-providers-databricks \
    apache-airflow-providers-cncf-kubernetes \
    dbt-databricks \
    pydantic