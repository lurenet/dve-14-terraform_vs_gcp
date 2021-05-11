Follow this simple instruction

Clone this project: git clone https://github.com/lurenet/dve-14-terraform_vs_gcp.git

Setup settings for your GCP project in variables.tf like credentials, nexus params, etc

Try this with terraform:
  terraform init
  terraform plan
  terraform apply

For cancel use:
  terraform destroy

tomcat_server_ip will be shown in output. Use it!

Run this URL: http://${tomcat_server_ip}/hello-1.0/

