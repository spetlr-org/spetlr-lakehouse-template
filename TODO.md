# Todo

## Scope for lakehouse demo project


### Deployment Environment (mrmasterplan)
Create deployment pipeline:
* [ ] One dev environment
* [ ] One test environment
* [ ] One prod environment

For each environment Azure ressources:
* [ ] Resource group
* [ ] Databricks workspace (+clusters)
* [ ] Storage account for sample data

Other repo stuff:
* [ ]  In the repo, place simple .csv/.json files.

### Deployment Databricks (JeppeBlixen, farbo, LauJohansson)
Repo:
* [ ] Environment folder
 * [ ] Databases
  * .sql files with bronze, silver and gold definitions (use spetlr config ids) 
 * [ ] tablenames
   * .yml files with configurator info    

* [ ] Three folders
  * [ ] Bronze
    * [ ] Orchestrator (w. simple E-T-L steps)
  * [ ] Silver
    * [ ] Orchestrator (w. simple E-T-L steps)
  * [ ] Gold
    * [ ] Orchestrator (w. simple E-T-L steps)
* [ ] Test folder
  * [ ] Local
    * [ ] One transformer test
    * [ ] One TestHandle example
  * [ ] Cluster
    * [ ] Integration test using Configurator
* [ ] Job folder
  * Minimum one example of dbx configured jobs
     

### Presentation subjects (mrmasterplan, JeppeBlixen, farbo, LauJohansson)

10 min slidedeck
2 min per slide

Considerations: How do we get all attendees on board? (short intro to e.g. CICD)

* [ ] Presentation - SPETLR and the organization behind
* [ ] ONE SLIDE - our key take-homes
   * SPETLR can be used as an ETL framework
   * SPETLR enables reusing of code
   * SPETLR can be used for full unit and integration testing of ETL components
   * SPETLR can be used for CI/CD setup
   * Automated deployment
* [ ] ONE SLIDE - What and why CICD for Databricks Lakehouse platforms? 
* [ ] ONE SLIDE - We describe the three environments, but do not go into depth around azure deployments.
* [ ] ONE SLIDE - Orchestrator/ETL structure
* [ ] ONE SLIDE - Configurator 
* [ ] ONE SLIDE - Unit/Integration testing (remember to state why it is important)
* [ ] ONE SLIDE - CICD (spetlr configurator, PR process, deployment process)
