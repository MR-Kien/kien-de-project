FROM apache/airflow:3.0.0

# Chuyển sang root để xử lý file hệ thống nếu cần
USER root

# Copy requirements trước để install (tận dụng cache)
COPY ./requirements.txt /requirements.txt

USER airflow

# Cài đặt các thư viện cần thiết
RUN pip install --no-cache-dir -r /requirements.txt

# Copy DAGs vào sau cùng
COPY --chown=airflow:0 ./dags/ /opt/airflow/dags/