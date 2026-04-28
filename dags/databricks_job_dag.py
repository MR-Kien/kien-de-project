from airflow.models.dag import DAG
from airflow.providers.databricks.operators.databricks import DatabricksRunNowOperator
from datetime import datetime
# Import list assets và function từ file produce_data_assets
from produce_data_assets import order_assets, produce_kaggle_assets

# DAG 1: Producer - Chạy hàng ngày để cập nhật S3
with DAG(
    dag_id="producer_kaggle_to_s3",
    schedule="@daily",
    start_date=datetime(2026, 1, 1),
    catchup=False,
) as dag1:
    produce_kaggle_assets()

# DAG 2: Consumer - Chạy khi Assets sẵn sàng
with DAG(
    dag_id="consumer_databricks_job",
    schedule=order_assets, # Lắng nghe danh sách Asset (Dataset)
    start_date=datetime(2026, 1, 1),
    catchup=False,
) as dag2:

    run_databricks = DatabricksRunNowOperator(
        task_id="run_medallion_job",
        databricks_conn_id="databricks_default",
        job_id=12345678, # Thay bằng Job ID thực tế của bạn
    )