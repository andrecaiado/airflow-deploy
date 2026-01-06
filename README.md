# Airflow deployment in Kubernetes

This repository contains configuration files and scripts to deploy Apache Airflow in a Kubernetes cluster using Helm charts.

## Prerequisites

- A running Kubernetes cluster (version 1.30+)
- Helm 3.10+ installed
- kubectl configured to interact with your Kubernetes cluster

## Project Structure

- `dags/` - Contains all Airflow DAGs (Directed Acyclic Graphs)
- `values/` - Helm chart configuration files for different environments
- `secrets/` - Sensitive configuration (gitignored)
- `scripts/` - Deployment and utility scripts

## Deployment Steps

1. **Clone the repository:**

   ```bash
   git clone https://github.com/andrecaido/airflow-deploy.git
   cd airflow-deploy
   ```

2. **Add the Helm repository for Airflow:**

   ```bash
   helm repo add apache-airflow https://airflow.apache.org
   helm repo update
   ```

2. **Customize configuration files:**

   Modify the values files located in the `values` directory to suit your deployment needs. You can create separate files for different environments (e.g., `local`, `staging`, `production`).

   There is also a [base.yaml](./values/base.yaml) file that contains common configurations applied across all environments.

   Sensitive information, such as passwords and secret keys, should be stored in the `secrets` directory in a separate file corresponding to each environment (e.g., `local.yaml`, `staging.yaml`, `production.yaml`). The [local.yaml.template](./secrets/local.yaml.template) template file can be copied and updated for this purpose.

   Refer to the [official Helm chart documentation](https://airflow.apache.org/docs/helm-chart/stable/index.html) for a complete list of configurable options.

3. **Run the deployment script:**

   The `deploy.sh` script will create a namespace for Airflow and install the Helm chart in the specified environment and with the configurations for the chosen environment.

   ```bash
   chmod +x scripts/deploy.sh
   DRY_RUN=<true|false> ./scripts/deploy.sh <environment>
   ```

   Choose `true` for `DRY_RUN` to simulate the deployment without making any changes, or `false` to perform the actual deployment. This is optional and defaults to `false` if not set.

   Replace `<environment>` with the desired environment. The environments must match the names of the configuration files in the `values` directory (e.g., `local`, `staging`, `production`). This is optional and defaults to `local` if not provided.

4. **Monitor the deployment:**

    You can monitor the deployment process using:
  
    ```bash
    kubectl get pods -n airflow -w
    ```
    
    Ensure all pods are in the `Running` state before proceeding.

5. **Access the Airflow web UI:**

    Forward the port to access the Airflow web server:
  
    ```bash
    kubectl port-forward svc/airflow-webserver 8081:8080 -n airflow
    ```
  
    Open your browser and navigate to `http://localhost:8081`. Use the credentials specified in your secrets file to log in.

    Unpause paused DAGs from the UI to start scheduling tasks.

## Adding DAGs

All DAGs are stored in the `dags/` directory. To add a new DAG:

1. Create a new Python file in the `dags/` directory
2. Define your DAG following Airflow's conventions
3. Commit and push your changes to the repository
4. Git-sync will automatically sync the DAGs to your Airflow deployment within a few minutes

See [dags/example_dag.py](./dags/example_dag.py) for a sample DAG structure.

## Cleanup

To uninstall Airflow and clean up the resources, run the following command:

```bash
helm uninstall airflow --namespace airflow && kubectl delete namespace airflow
```

