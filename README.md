# Terraform Demo
Repository contains the necessary code for utilizing Terraform to create resources in AWS.

**Assumptions**
- Terraform is already installed on the deployment system (local laptop or server, etc...) 
- Starting a new environment with no current infrastructure (starting from scratch).
- S3 bucket created is NOT publicly accessible.
- S3 bucket is encrypted by default.
- EC2 instance has access to a single S3 bucket and cannot view/list/create/edit any other buckets.
- There are no ssh keys stored in AWS prior to deploying the infrastructure.
- Ansible is installed on the deployment system.
  - An single Ansible playbook will be run to provision an ssh key in AWS and the private key will be stored on the deployment system.
- Security group for the EC2 instance only allows a single IP address to SSH.

To run this demo: 
```bash
git clone <this repo>
cd tf-demo
```
At a minium, modify the `main.tf` file and change the value for `current-public-ip` in the `module ec2-instance`. Use your public IP address or choose a more open CIDR block, otherwise you will not be able to ssh to the box.

Also you must modify the `bucket-name` value passed to `module s3-bucket` and `module ec2-instance`. Bucket names must be unique across all of AWS.
Search for the following values in `main.tf`.
```
current-public-ip = "<your public ip>"
bucket-name = "<your bucket name>"
```
You can also modify any of the variables and names passed in to suit you. Perhaps you don't want use "tf-demo" as the key pair name, or you want to use a different region, CIDR block, etc... You should be able to customize the deployment to your needs.

_For our example the **"bucket-name"** is **"tf-demo-2020"** and our **"keypair-name"** is **"tf-demo".**_

Once you have made your modifications, you should be ready to deploy.
1. Run the ansible playbook to create a key pair for the EC2 instance.
2. Initialize Terraform
3. Review the plan
4. Run apply to deploy
5. ssh to the box 
6. Verify you can access the S3 bucket

Run the following:

```bash
ansible-playbook playbook.yml --extra-vars "@playbook.vars.yml"
terraform init
terraform plan
terraform apply --auto-approve
```
Take note of the outputs:
~~~
Outputs:

ec2-public-ip = <your ec2 instance IP>
~~~

Once deployment is finished:

ssh to the IP address printed in output from Terraform using the key pair stored in your home dir 

`ssh -i ~/tf-demo/tf-demo.pem ec2-user@<ec2-public-ip value from the Terraform output>`

Once you are logged into the EC2 instance (remember to change the bucket name to the bucket you created):

```bash
aws s3 ls s3://tf-demo-2020
touch filetest.txt
aws s3 cp filetest.txt s3://tf-demo-2020
aws s3 ls s3://tf-demo-2020
rm filetest.txt
aws s3 cp s3://tf-demo-2020/filetest.txt .
aws s3 rm s3://tf-demo-2020/filetest.txt
aws s3 ls s3://tf-demo-2020
```

Output should be similar to the following:
~~~
[ec2-user@ip-10-10-1-170 ~]$ aws s3 ls s3://tf-demo-2020
[ec2-user@ip-10-10-1-170 ~]$ touch filetest.txt
[ec2-user@ip-10-10-1-170 ~]$ aws s3 cp filetest.txt s3://tf-demo-2020
upload: ./filetest.txt to s3://tf-demo-2020/filetest.txt
[ec2-user@ip-10-10-1-170 ~]$ aws s3 ls s3://tf-demo-2020
2020-10-09 23:08:29          0 filetest.txt
[ec2-user@ip-10-10-1-170 ~]$ rm filetest.txt
[ec2-user@ip-10-10-1-170 ~]$ aws s3 cp s3://tf-demo-2020/filetest.txt .
download: s3://tf-demo-2020/filetest.txt to ./filetest.txt
[ec2-user@ip-10-10-1-170 ~]$ aws s3 rm s3://tf-demo-2020/filetest.txt
delete: s3://tf-demo-2020/filetest.txt
[ec2-user@ip-10-10-1-170 ~]$ aws s3 ls s3://tf-demo-2020
[ec2-user@ip-10-10-1-170 ~]$
~~~
