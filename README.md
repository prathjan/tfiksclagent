# Enabling AppDynamics Business Insights for a legacy Java/Tomcat Multi Service Application with Cisco Intersight Service for Terraform 
## Contents
        Use Case

        Pre-requisites

        Step 1: Intersight Target configuration for AppDynamics and on prem entities

        Step 2: Setting up TFCB Workspaces

        Step 3: Share variables with a Global Workspace

        Step 4: Prepping infrastructure & platform for application deployment

        Step 5: Database Server Deployment

        Interfacing with AppDynamics Controller API for Provisioning

            Step 6: Use RBAC script to create AppDynamics User and license rule

            Step 7: Retrieve and install AppDynamics Zero Agent using AppDynamics Controller ZFI API's 

        Step 8: Deploying App Services in a multi instance Tomcat Platform

        Step 9: Generate Application Load

        View Application Insights in AppDynamics and Intersight

        Interfacing with AppDynamics Controller API for De-provisioning
        
            Use RBAC script to remove AppDynamics User and license rule

            Uninstall AppDynamics Zero Agent

        Undeploy applications and deprovision infrastructure


### Use Case

* As a DevOps and App developer, use IST (Intersight Service for Terraform) to enable existing Java/Tomcat Micro services for AppDynamics Insights

* As DevOps and App Developer, use Intersight and AppDynamics to get app and infrastructure insights for Full Stack Observability

![alt text](https://github.com/prathjan/images/blob/main/tomflow.png?raw=true)

### Pre-requisites

1. The VM template that you provision in Step 5 below will have a user "root/Cisco123" provisioned with sudo privileges. Terraform scripts will use this user credentials to remotely run installation scripts in the VM.

2. Sign up for a user account on Intersight.com. You will need Premier license as well as IWO license to complete this use case. 

3. Sign up for a TFCB (Terraform for Cloud Business) at https://app.terraform.io/. Log in and generate the User API Key. You will need this when you create the TF Cloud Target in Intersight.

4. You will need access to a vSphere infrastructure with backend compute and storage provisioned

5. You will also need an account in AppDynamics SAAS Controller and should have the API Client ID and Client Secret.

### Step 1: Intersight Target configuration for AppDynamics and on prem entities

You will log into your Intersight account and create the following targets. Please refer to Intersight docs for details on how to create these Targets:

    Assist

    vSphere

    AppDynamics

    TFC Cloud

    TFC Cloud Agent - When you claim the TF Cloud Agent, please make sure you have the following added to your Managed Hosts. This is in addition to other local subnets you may have that hosts your kubernetes cluster like the IPPool that you may configure for your k8s addressing:
    NO_PROXY URL's listed:

            github-releases.githubusercontent.com

            github.com

            app.terraform.io

            registry.terraform.io

            releases.hashicorp.com

            archivist.terraform.io

### Step 2: Setting up TFCB Workspaces

1. 

You will set up the following workspaces in TFCB and link to the VCS repos specified. 

    AppdGlobal -> https://github.com/prathjan/SvcAppdGlobal.git

    AppdDb -> https://github.com/prathjan/SvcAppdDb.git 

    AppdInfra -> https://github.com/prathjan/SvcAppdInfra.git 

    AppdSaas -> https://github.com/prathjan/SvcAppdSaas.git 

    AppdRbac -> https://github.com/prathjan/SvcAppdRbac.git

    AppdApp -> https://github.com/prathjan/SvcAppdApp.git

    AppdLoad -> https://github.com/prathjan/SvcAppdLoad.git 

    AppdRemove -> https://github.com/prathjan/SvcAppdLoad.git 


2. 

You will set up the AppdGlobal workspace here. Add all the variables defined here as your TFCB workspace variables: https://github.com/prathjan/SvcAppdGlobal/blob/main/terraform.auto.tfvars

In addition, you will define the following. These are not included in the terraform.auto.tfvars file since its specific to your setup and has sensitive info:

root_password - Root password to access your VM's

vsphere_password - vSphere administrator password

mysql_pass - MySql admin password (use root/root)

Please also set this workspace to share its data with other workspaces in the organization by enabling Settings->General Settings->Share State Globally.

3. 

You will set up the AppdDb workspace here
Set Execution Mode as Agent and select the TF Cloud Agent that you have provisioned.Please also set this workspace to share its data with other workspaces in the organization by enabling Settings->General Settings->Share State Globally.

You will set the following variables:

globalwsname - AppdGlobal

org - TFCB organization like "CiscoDevNet" or "Lab14"

4. 

You will set up the AppdInfra workspace here.

Set Execution Mode as Agent and select the TF Cloud Agent that you have provisioned.Please also set this workspace to share its data with other workspaces in the organization by enabling Settings->General Settings->Share State Globally.

You will set the following variables:

globalwsname - AppdGlobal	

dbvmwsname - AppdDb

org - TFCB organization like "CiscoDevNet" or "Lab14"

5. 

You will set up the AppdSaas workspace here.

Set Execution Mode as Remote.Please also set this workspace to share its data with other workspaces in the organization by enabling Settings->General Settings->Share State Globally.

You will set the following variables:

appname - ChaiStore, for example

javaver - java version like 21.5.0.32605	

clientid - AppDynamics API Client ID	

clientsecret - AppDynamics API Client Secret	

zerover - AppDynamics Zero Agent version like "21.6.0.232"	

infraver - AppDynamics Infra Agent version like 21.5.0.1784	

machinever - AppDynamics Machine Agent version like 21.6.0.3155	

ibmver - AppDynamics IBM Java Agent version 21.6.0.32801	

url - AppDynamics Controller URL https://devnet.saas.appdynamics.com	


6. 

You will set up the AppdRbac workspace here.

Set Execution Mode as Agent and select the TF Cloud Agent that you have provisioned.

You will set the following variables:

appvmwsname - AppdInfra	

saaswsname - AppdSaas	

globalwsname - AppdGlobal

org - TFCB organization like "CiscoDevNet" or "Lab14"

7.

You will set up the AppdApp workspace here.

Set Execution Mode as Agent and select the TF Cloud Agent that you have provisioned.Please also set this workspace to share its data with other workspaces in the organization by enabling Settings->General Settings->Share State Globally.

You will set the following variables:

globalwsname - AppdGlobal

dbvmwsname - AppdDb	

appvmwsname - AppdInfra

org - TFCB organization like "CiscoDevNet" or "Lab14"

8. 

You will set up the AppdLoad workspace here.

Set Execution Mode as Agent and select the TF Cloud Agent that you have provisioned.Please also set this workspace to share its data with other workspaces in the organization by enabling Settings->General Settings->Share State Globally.

You will set the following variables:

globalwsname - AppdGlobal	

appvmwsname - AppdInfra

org - TFCB organization like "CiscoDevNet" or "Lab14"

trigcount - trigger count, set to sone random number

9.

You will set up the AppdRemove workspace here.

Set Execution Mode as Agent and select the TF Cloud Agent that you have provisioned.Please also set this workspace to share its data with other workspaces in the organization by enabling Settings->General Settings->Share State Globally.

You will set the following variables:

globalwsname - AppdGlobal	

appvmwsname - AppdInfra

org - TFCB organization like "CiscoDevNet" or "Lab14"

trigcount - trigger count, set to sone random number


### Step 3: Share variables with a Global Workspace

Execute the AppDGlobal TFCB workspace to setup the global variables for other workspaces. Check for a sucessful Run before progressing to the next step.
        
### Step 4: Prepping infrastructure & platform for application deployment

Execute the AppdInfra TFCB workspace to set up the VM infrastructure for app hosting. Check for a sucessful Run before progressing to the next step.

### Step 5: Database Server Deployment

Execute the AppdDb TFCB workspace to set up the mysql database for the microservices. Check for a sucessful Run before progressing to the next step.

### Step 6: Interfacing with AppDynamics Controller API for Provisioning - Retrieve and install AppDynamics Zero Agent using AppDynamics Controller ZFI API's 

Execute the AppdSaas TFCB workspace to retrieve ZFI download and install commands for Zero agent. Check for a sucessful Run before progressing to the next step.


### Step 7: Interfacing with AppDynamics Controller API for Provisioning - Use RBAC script to create AppDynamics User/Role/license rule and retrieve accesskey

Execute the AppdRbac TFCB workspace to set up the AppDynamics Zero Agent on the infrastructure provisioned. Check for a sucessful Run before progressing to the next step.

### Step 8: Deploying App Services in a multi instance Tomcat Platform

Execute the AppdApp TFCB workspace to set up multiple instances of Tomcat Application server with each hosting a single microservice. Retrieve the VM IP from the AppdInfra workspace Outputs. 

View the application deployment status at:

http://<vm_infra_ip>:8085/tools.descartes.teastore.webui/status

![alt text](https://github.com/prathjan/images/blob/main/teastatus.png?raw=true)

View the application at:

http://<vm_infra_ip>:8085/tools.descartes.teastore.webui/

![alt text](https://github.com/prathjan/images/blob/main/tea.png?raw=true)


### Step 9: Generate Application Load

Execute the AppdLoad workspace to generate load for the apps deployed

### View Application Insights in AppDynamics 

Checkout the application insights in AppDynamics:

![alt text](https://github.com/prathjan/images/blob/main/appd.png?raw=true)

### View Application Insights in Intersight

Checkout the infrastructure insights in Intersight:

![alt text](https://github.com/prathjan/images/blob/main/optimize.png?raw=true)

### Interfacing with AppDynamics Controller API for De-provisioning - Use RBAC script to remove AppDynamics User and license rule

Execute the AppdRemove workspace to remove all the entities created in AppDynamics.

Due to a known error, you will have to manually delete the SuperChaiStore application from AppDynamics to complete the cleanup:

![alt text](https://github.com/prathjan/images/blob/main/appddel.png?raw=true)
            
### Undeploy applications and deprovision infrastructure

Destroy the TFCB workspaces in this order:

AppdLoad

AppdRemove

AppdRbac

AppdSaas

AppdInfra

AppdDb
