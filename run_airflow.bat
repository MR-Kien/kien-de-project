@echo off
echo Dang kiem tra trang thai Docker...
kubectl get nodes >nul 2>&1
if %errorlevel% neq 0 (
    echo [LOI] Docker hoac Cluster chua chay. Vui long mo Docker Desktop truoc!
    pause
    exit
)

echo Dang khoi tao Port Forward cho Airflow 3...
echo [INFO] Vui long khong tat cua so nay khi dang dùng Airflow.
echo [INFO] Truy cap: http://localhost:8080

kubectl port-forward svc/airflow-api-server 8080:8080 -n airflow
pause