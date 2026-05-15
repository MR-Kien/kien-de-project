@echo off
setlocal enabledelayedexpansion

:: ==========================================
:: ĐỊNH NGHĨA BIẾN (Sửa theo môi trường của bạn)
:: ==========================================
set VERSION=v5.7
set CHART_PATH="C:\Users\MSIPRO\Downloads\airflow-1.20.0.tgz"
set NAMESPACE=airflow
set CLUSTER_NAME=desktop

:: Key bảo mật (Dùng chuỗi hex cố định)
set WEBSERVER_KEY=8b72e177698544e3939634586d34b3e8
set API_SECRET_KEY=a69db978d5c7fcb56d57c6f58856564f

echo --- Step 1: Building Base Image ---
docker build --no-cache -t my-airflow-dag:%VERSION% .
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Docker build that bai! Kiem tra file Dockerfile hoac requirements.txt.
    pause
    exit /b %ERRORLEVEL%
)

echo --- Step 2: Loading Image to Kind Cluster ---
kind load docker-image my-airflow-dag:%VERSION% --name %CLUSTER_NAME%

echo --- Step 3: Upgrading Airflow with Optimized Config ---
:: Giai thich cac tham so quan trong:
:: - webserverSecretKey/apiSecretKey: Fixed schema 1.20.0
:: - logs.persistence: Sua loi "No host supplied" (Invalid URL)
:: - dags.gitSync: Tu dong lay code tu GitHub
call helm upgrade airflow %CHART_PATH% ^
  --install ^
  --namespace %NAMESPACE% ^
  --create-namespace ^
  --set images.airflow.repository=my-airflow-dag ^
  --set images.airflow.tag=%VERSION% ^
  --set images.airflow.pullPolicy=Never ^
  --set webserverSecretKey=%WEBSERVER_KEY% ^
  --set apiSecretKey=%API_SECRET_KEY% ^
  --set executor=KubernetesExecutor ^
  --set logs.persistence.enabled=true ^
  --set logs.persistence.existingClaim=airflow-logs ^
  --set dags.gitSync.enabled=true ^
  --set dags.gitSync.repo=https://github.com/MR-Kien/kien-de-project.git ^
  --set dags.gitSync.branch=main ^
  --set dags.gitSync.subPath=dags ^
  --set dags.gitSync.wait=60 ^
  --set dags.persistence.enabled=false

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Helm upgrade failed! Kiem tra lai file values hoac cau hinh Cluster.
    pause
    exit /b %ERRORLEVEL%
)

echo --- Step 4: Refreshing Components ---
:: Xoa Pod cu de dam bao nhan Config moi ngay lap tuc
kubectl delete pods -n %NAMESPACE% -l app.kubernetes.io/name=airflow --grace-period=0 --force

echo --- SUCCESS! ---
echo.
echo [INFO] Airflow dang dong bo tu Git moi 60 giay.
echo [INFO] Logs hien tai duoc luu vao PVC (Fix loi Invalid URL).
echo [INFO] Truy cap Airflow Webserver de kiem tra.
echo.
pause