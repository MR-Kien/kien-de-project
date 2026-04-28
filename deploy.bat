@echo off
:: Định nghĩa các biến môi trường
set VERSION=v5.2
set CHART_PATH="C:\Users\MSIPRO\Downloads\airflow-1.20.0.tgz"
set NAMESPACE=airflow
:: Key này giúp các thành phần AF3 nói chuyện được với nhau (Dùng chuỗi hex cố định)
set WEBSERVER_KEY=8b72e177698544e3939634586d34b3e8
set API_SECRET_KEY=a69db978d5c7fcb56d57c6f58856564f

echo --- Step 1: Building Base Image (Thanh phan & Thu vien) ---
:: Dung --no-cache de dam bao requirements.txt luon moi nhat
docker build --no-cache -t my-airflow-dag:%VERSION% .

echo --- Step 2: Loading Image to Kind Cluster ---
kind load docker-image my-airflow-dag:%VERSION% --name desktop

echo --- Step 3: Upgrading Airflow 3.1.8 with Professional Config ---
:: Luu y: Dung dau ^ de viet cau lenh Helm tren nhieu dong cho de nhin
helm upgrade airflow %CHART_PATH% ^
  --namespace %NAMESPACE% ^
  --set images.airflow.repository=my-airflow-dag ^
  --set images.airflow.tag=%VERSION% ^
  --set images.airflow.pullPolicy=Never ^
  --set webserver.secretKey=%WEBSERVER_KEY% ^
  --set auth.apiSecretKey=%API_SECRET_KEY% ^
  --set executor=KubernetesExecutor ^
  --set dags.gitSync.enabled=true ^
  --set dags.gitSync.repo=https://github.com/MR-Kien/kien-de-project.git ^
  --set dags.gitSync.branch=main ^
  --set dags.gitSync.subPath=dag ^
  --set dags.gitSync.recommendedProbeSetting=true

echo --- Step 4: System is Syncing ---
echo Git-sync sidecar se tu dong cap nhat DAG moi sau moi 60 giay.
echo Ban khong can xoa Pod thu cong nua.

echo --- DONE! ---
pause