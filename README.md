# azure
All things Azure, Infrastructure as Code, Containers and more.

All Terraform Code is compiled using a single main.tf file for ease of deployment in tutorials. This is not recommended for enterprise use where you should structure using modules, variables.tf, locals.tf and outputs.tf etc. Using a remote backend is recommended and you can add this to the main.tf for your deployment.
