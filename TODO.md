# Todo

## Scope for lakehouse demo project


### Deployment Environment
Create deployment pipeline:
* One dev environment
* One test environment
* One prod environment

For each environment Azure ressources:
* Resource group
* Databricks workspace (+clusters)
* Storage account for sample data

In the repo, place simple .csv/.json files.

### Deployment Databricks
Repo:
* Environment folder
 * Databases
  * .sql files with bronze, silver and gold definitions (use spetlr config ids) 
 * tablenames
   * .yml files with configurator info    

* Three folders
  * Bronze
    * Orchestrator (w. simple E-T-L steps)
  * Silver
    * Orchestrator (w. simple E-T-L steps)
  * Gold
    * Orchestrator (w. simple E-T-L steps)
* Test folder
  * Local
    * One transformer test
    * One TestHandle example
  * Cluster
    * Integration test using Configurator

* Job folder
  * dbx configured jobs
