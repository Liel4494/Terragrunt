# How to run terragrunt
### See [confluence page](https://rnd-hub.atlassian.net/wiki/spaces/DEVO/pages/2286452737/AWS+Provider)

##### First lets take a look in the folder structure:
1.The ``terraform-modules`` folder contains terraform modules of:
  * AWS ec2 instance.
  * Azure VM.

Each module has its own configuration based on the provider resource.

### directory Structure:
```directoryStructure
└── terraform-modules
    ├── aws
    │   └── ec2_instance
    │       ├── main.tf
    │       ├── outputs.tf
    │       └── variables.tf 
    └── azure
        └── vm
            └── main.tf
```

2.The ``environments`` folder contains three folders, one for each environment:
  * dev
  * prod
  * staging

  
Every environment folder contains a provider folder with ``terragrunt.hcl`` file:
  * aws.
  * azure.

The ``terragrunt.hcl`` files use the mudules in the ``terraform-modules`` folder and contains specific variables for each environment and provider. 

### directory Structure:
```directoryStructure
└── environment
    ├── dev
    │   ├── aws
    │   │   └── terragrunt.hcl //amazon_linux instance     
    │   └── azure
    │       └── terragrunt.hcl
    │       
    ├── prod
    │   ├── aws
    │   │   └── terragrunt.hcl //ubuntu22.04 instance      
    │   └── azure
    │       └── terragrunt.hcl
    │       
    └── staging
        ├── aws
        │   └── terragrunt.hcl //windowsServer2022 instance     
        └── azure
            └── terragrunt.hcl
```


---

### Terragrunt commands

Before running *terragrunt* commands, we need to make sure we have credentials for **all providers**.

In the ``tfe-base`` folder, run this command to apply all changes:
```commandline
terragrunt run-all apply 
```
To view only configuration changes run:
```commandline
terragrunt run-all plan
```
To destroy all configuration run:
```commandline
terragrunt run-all destroy
```





