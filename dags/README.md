# DAGs Directory

This directory contains all Apache Airflow DAGs (Directed Acyclic Graphs) for this deployment.

## Adding New DAGs

1. Create a new Python file in this directory (e.g., `my_dag.py`)
2. Define your DAG using Airflow's DAG syntax
3. Commit and push your changes to the repository
4. Git-sync will automatically sync the DAGs to your Airflow deployment

## DAG Structure

Each DAG file should:
- Import necessary Airflow modules
- Define default arguments
- Create a DAG instance
- Define tasks and their dependencies

## Example

See [example_dag.py](./example_dag.py) for a basic DAG structure.

## Best Practices

- Use meaningful DAG IDs
- Add appropriate tags for organization
- Set `catchup=False` for most use cases
- Include proper documentation in docstrings
- Test DAGs locally before deploying
- Use descriptive task IDs

## Resources

- [Airflow DAG Documentation](https://airflow.apache.org/docs/apache-airflow/stable/concepts/dags.html)
- [Airflow Operators](https://airflow.apache.org/docs/apache-airflow/stable/operators-and-hooks-ref.html)
