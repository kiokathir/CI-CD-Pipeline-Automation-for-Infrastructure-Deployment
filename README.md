# CI-CD-Pipeline-Automation-for-Infrastructure-Deployment
 Problem Statement:
Manually creating and updating infrastructure each time is time-consuming, and inefficient.
This is where Infrastructure as Code (IaC) with Terraform becomes useful. Terraform allows you to define and automate your AWS infrastructure (through code.
However, manually running Terraform every time isn't scalable either. To solve this:
 
 Solution:
We introduce CI/CD automation using Jenkins and GitHub:
•	Terraform code is stored and version-controlled in GitHub.
•	A GitHub webhook is integrated with Jenkins to trigger pipeline jobs automatically when changes are pushed to the repo.
•	Jenkins runs the pipeline, which executes terraform init, plan, and apply commands.
•	This process automatically provisions EC2 instances (or any AWS resources) here we deployed entire infra without manual intervention. Summary:
“Using Terraform, GitHub, and Jenkins, we automate the provisioning of infrastructure on AWS. Every time new Terraform code is pushed to GitHub, Jenkins gets triggered and deploys the infrastructure automatically—ensuring consistent, fast, and repeatable infrastructure delivery.”

"for ouptut refer attached pdf"
