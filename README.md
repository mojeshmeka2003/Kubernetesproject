# Kubernetesproject

Steps:

Steps to Run the Terraform 
1)terraform init
2)terraform apply
3)terraform plan
4)terraform destroy
• Rename my-machine-0 as Jenkins and 1 as Ansible and 2 as VMController


Jenkin Server Setup


• Connect Jenkins as EC2 Instance connect as root user.
• Set Password for root user.
• Command: passwd root
• Add a TCP port of 8080 to work on Jenkins
• Install Java command is yum install java
• wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhatstable/jenkins.repo
• rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
• Install Jenkins by yum install jenkins
• To install Git command is yum install git
• To start the Jenkins command is systemctl start jenkins
• To Know the Jenkins status command is systemctl status jenkins

Ansible Server Setup
• Connect to Ansible server from EC2-Connect as root user
• Set password to the root user.
• Install ansible and docker
• Command for ansible yum install ansible. & amazon-linux-extras install ansible2
• Command for Docker yum install docker.
• Login with docker credentials command as docker login.
• Create an ansible.yml file in opt directory.


Then restart the systemctl restart sshd.
• Steps to Install Kubectl
-----------------------------------------------------------
• curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s 
https://storage.googleapis.com/kubernetesrelease/release/stable.txt)/bin/linux/amd64/kubectl
• chmod +x ./kubectl
• sudo mv ./kubectl /bin/kubectl
• Create an IAM role with Route53, EC2, IAM and S3, VPC full access
• Attach IAM role to EC2 instance of VMController. To Attach A role click on 
security Modify an Role and then attach.


Steps to Install kops
----------------------
• curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name 
| cut -d '"' -f 4)/kops-linux-amd64
• chmod +x kops-linux-amd64
• sudo mv kops-linux-amd64 /bin/kops
• Create a Route53 private hosted zone

create an S3 bucket : aws s3 mb s3://clusters.project.com
Expose environment variable:
export  KOPS_STATE_STORE=s3://clusters.project.com
• Create sshkeys before creating cluster: ssh-keygen
• Create kubernetes cluster definitions on S3 bucket: kops create cluster --cloud=aws --zones=us-east-1b --name=clusters.project.com --dns-zone=project.com --dns private
• Create kubernetes cluster: kops update cluster clusters.project.com --yes –admin
• Validate your cluster: kops validate cluster --wait 10m
• To list nodes: kubectl get nodes.

Establish Keyless communication between jenkin server to ansible and ansible to controllerVM (Kubernetes Server)
• From jenkin server to Ansible:
• in jenkin Server
• Generate key: ssh-keygen
• Open a Vim /.ssh/id_rsa
• Copy that key from that file and paste it in the authorized_keys file in ansible server
• The same process should be repeated for ansible server, ControllerVM.

Continuous Integration with Jenkins

• Create following files:[deployment.ymal &service.yml]
• Create a docker file and push into the git repository

Edit a file in /etc/ansible/hosts in ansible server
• Add lines
[docks]
Private ip of controllerVM
• In the opt directory create a ansible.yml file.
• Create deployment and service file in /opt directory of VMController.


Jenkins Configurations:
Go to Manage Jenkins then Manage Plugins and then install Publish over ssh 
Plugin.
• Configure ssh server.
• Set ansible and jenkin server hosts with their respective private ips and give correct credentials
Then Once check the server configurations success or not.
• Create a new Job name as CICD and select Free Style Project.
• Source Code management configurations.
• Pulling sourcecode from my git repository

Create webhook b/w jenkins and git.

Configuring ansible server to create a docker image and push into my docker 
repository

Add build Configurations: Configuring jenkin server to copy Dockerfile to /opt 
directory in ansible from jenkins.


Add post build Configurations Run ansible playbook to deploy my application in 
kubernetes cluster.

Then click on Build Now 












Reference Link https://www.youtube.com/watch?v=LjXW-K7n5fk&t=10s
