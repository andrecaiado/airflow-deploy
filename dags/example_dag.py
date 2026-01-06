"""
Example DAG for Apache Airflow
This is a simple DAG to demonstrate basic Airflow functionality.
"""
from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator


def print_hello():
    """Simple Python function to print hello"""
    print("Hello from Airflow!")
    return "Hello World"


# Default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2026, 1, 6, 12, 15, 0),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(seconds=30),
}

# Define the DAG
with DAG(
    'example_dag',
    default_args=default_args,
    description='A simple example DAG',
    schedule_interval=timedelta(minutes=5),
    catchup=False,
    tags=['example'],
) as dag:

    # Task 1: Bash operator
    t1 = BashOperator(
        task_id='print_date',
        bash_command='date',
    )

    # Task 2: Python operator
    t2 = PythonOperator(
        task_id='print_hello',
        python_callable=print_hello,
    )

    # Task 3: Another Bash operator
    t3 = BashOperator(
        task_id='sleep',
        bash_command='sleep 5',
    )

    # Set task dependencies
    t1 >> t2 >> t3
