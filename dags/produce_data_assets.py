import os
import logging
import kagglehub
from datetime import datetime

from airflow.sdk import Asset
from airflow.decorators import task # Sử dụng task decorator
from airflow.providers.amazon.aws.hooks.s3 import S3Hook

# 1. Định nghĩa các Assets (vật thể dữ liệu)
s3_bucket = "kien-data-lake-2026"
raw_prefix = "raw"

# Định nghĩa danh sách các Asset riêng lẻ
orders_csv = Asset(f"s3://{s3_bucket}/{raw_prefix}/olist_orders_dataset.csv")
items_csv = Asset(f"s3://{s3_bucket}/{raw_prefix}/olist_order_items_dataset.csv")
customers_csv = Asset(f"s3://{s3_bucket}/{raw_prefix}/olist_customers_dataset.csv")
products_csv = Asset(f"s3://{s3_bucket}/{raw_prefix}/olist_products_dataset.csv")

order_assets = [orders_csv, items_csv, customers_csv, products_csv]

# 2. Task Producer
# Trong AF3, để cập nhật nhiều Assets từ một function, ta dùng @task với outlets
@task(outlets=order_assets)
def produce_kaggle_assets():
    logging.info("Đang tải dữ liệu từ Kaggle...")
    # Lưu ý: kagglehub sẽ tải về thư mục cache của user airflow
    path = kagglehub.dataset_download("olistbr/brazilian-ecommerce")
    
    s3_hook = S3Hook(aws_conn_id="aws_conn")
    
    target_files = [
        "olist_orders_dataset.csv",
        "olist_order_items_dataset.csv",
        "olist_customers_dataset.csv",
        "olist_products_dataset.csv"
    ]

    for filename in target_files:
        local_file_path = os.path.join(path, filename)
        if os.path.exists(local_file_path):
            logging.info(f"Đang đẩy {filename} lên S3 Asset...")
            s3_hook.load_file(
                filename=local_file_path,
                key=f"{raw_prefix}/{filename}",
                bucket_name=s3_bucket,
                replace=True
            )
        else:
            logging.warning(f"Cảnh báo: Không tìm thấy file {filename}!")