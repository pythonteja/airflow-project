from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator
import logging

# Default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2025, 10, 20),
    'email': ['Suchithra.Ananthoju@advicehealthcare.com'],
    'email_on_failure': True,
    'email_on_success': True,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Initialize the DAG
dag = DAG(
    dag_id='test_email_functionality',
    default_args=default_args,
    description='Test DAG to verify email functionality',
    schedule_interval=None,
    catchup=False,
    tags=['test'],
)

def test_failure():
    """Test function that will fail to trigger email on failure"""
    logging.info("This task will fail intentionally")
    raise Exception("This is a test failure to verify email notifications")

def test_success():
    """Test function that will succeed to trigger email on success"""
    logging.info("This task will succeed to verify email notifications")
    return "Success"

# Define tasks
failure_task = PythonOperator(
    task_id='test_failure_task',
    python_callable=test_failure,
    dag=dag,
)

success_task = PythonOperator(
    task_id='test_success_task',
    python_callable=test_success,
    dag=dag,
)