## Terraform script to create bastion host at AWS

#### This repo has being created to bootstrap bastion host at AWS. It have external access to provide further installs like Red Hat OpenShift or any other software required.

---

#### How to get started with AWS access?

That repo do not provide instructions to setup AWS accout. We presume it's allready set for you.
So first step is to configure AWS access. 

Please issue first:

`aws configure`

provide:

``AWS_ACCESS_KEY_ID``
``AWS_SECRET_ACCESS_KEY``
``AWS_DEFAULT_REGION``

You can check of you've done afterwords:

`aws configure list`


Note: if your output sucks you can set:

`export AWS_PAGER=""`

---

#### If you are done with AWS access, create all required objects with Terraform.

It's simple three steps job.

`terraform init`

`terraform plan`

`terraform apply`

Once done, monitor your AWS instance and finally login to with SSH client.

Note: 

after terraform run you will find the file `bastion-key.pem` at your work directory.
that's your gateway to connect to bastion host just created

ssh login command that you can get to bastion host looks like that:

`ssh -i "bastion-key.pem" ec2-user@[PUBLIC_IP]`

after you successfull log in to the host, you may install additional, required packages
I provided some you can copy-paste at `install-tools.sh`

Have fun exploring!

---

