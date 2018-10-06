# Packer - Build AWS AMIs

![HashiCorp Packer Logo](https://skeltonthatcher.com/wp-content/uploads/2017/09/blog-packer-list.png)

## 1. Download & Install
HashiCorp Packer is an amazing tool that allows you to create base images from one single source configuration. You can download Packer using the following link: https://www.packer.io/downloads.html
Or if you want to install it straight from the command line you can do so by the following:
- OS X:
`$ brew install packer`
- Windows:
`choco install packer`

Once it has installed you can confirm it by running the following command: `packer --version`.

Here are all the available commands for packer:

- `build` - build image(s) from template
- `fix` - fixes templates from old versions of packer
- `inspect` - see components of a template
- `validate` - check that a template is valid
- `version` - Prints the Packer version

## 2. AWS User & Policy
Once you have Packer installed you need to **create an IAM user** that you can use with it and you also need to **create a policy** that gives the packer_user minimal permissions needed.
### Create user & policy
1. This should be done using Terraform but we are testing it manually first. Login to your EC2 console and click on your username in the top right corner and click `My Security Credentials`.
2. Click `Users` and then `Add user`
3. Enter `packer_user` as username and tick the box saying `Programmatic access` under access type.
4. Click `Next: Permissions`
5. Click `Attach existing policies directly` and then `Create Policy` and select `JSON` on the next page.
6. Copy and Paste the following and then `Review Policy` and then Save it:
````
{
  "Version": "2012-10-17",
  "Statement": [{
      "Effect": "Allow",
      "Action" : [
        "ec2:AttachVolume",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CopyImage",
        "ec2:CreateImage",
        "ec2:CreateKeypair",
        "ec2:CreateSecurityGroup",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteKeyPair",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteSnapshot",
        "ec2:DeleteVolume",
        "ec2:DeregisterImage",
        "ec2:DescribeImageAttribute",
        "ec2:DescribeImages",
        "ec2:DescribeInstances",
        "ec2:DescribeRegions",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSnapshots",
        "ec2:DescribeSubnets",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume",
        "ec2:GetPasswordData",
        "ec2:ModifyImageAttribute",
        "ec2:ModifyInstanceAttribute",
        "ec2:ModifySnapshotAttribute",
        "ec2:RegisterImage",
        "ec2:RunInstances",
        "ec2:StopInstances",
        "ec2:TerminateInstances"
      ],
      "Resource" : "*"
  }]
}
````

## 3. Build your AMI
### Builders and Provisioners
Packer uses builders and provisioners to handle your code. Provisioners handle the base settings for your image, such as which OS, what region etc. Provisioners can import scripts onto the instance to install specific things needed.

### Example.JSON
1. Copy and paste the following template and save it as example.json in the folder where you installed packer.
2. Edit the variables to your preference, such as region and OS.
3. run `packer validate example.json`
````
{
  "variables": {
    "aws_access_key": "",
    "aws_secret_key": ""
  },
  "builders": [{
    "type": "amazon-ebs",
    "access_key": "{{user `aws_access_key`}}",
    "secret_key": "{{user `aws_secret_key`}}",
    "region": "us-east-1",
    "source_ami_filter": {
      "filters": {
      "virtualization-type": "hvm",
      "name": "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*",
      "root-device-type": "ebs"
      },
      "owners": ["099720109477"],
      "most_recent": true
    },
    "instance_type": "t2.micro",
    "ssh_username": "ubuntu",
    "ami_name": "packer-example {{timestamp}}"
  }]
}
````
4. Run `aws configure` and insert the access keys for your packer_user that you created.
5. Run `packer build -debug example.json` to check each step for errors.
6. When you have pressed enter enough of times and it completed, it should terminate the instance that you just created and a new AMI can be found under `Images -> AMIs` on your EC2 console.

### Manage your AMIs
Remember to deregister old AMIs that are not being used anymore since Amazon charges $0.01/month for each AMI. It is very cheap but the images can add up quickly if you test enough of times. To De-register an image you just right click and click `Deregister`.

Enjoy!
