

# AWS Setup
Note that all AWS was set up using Terraform for this project. The terraform code can be found on our [github.](https://github.com/CSUN-SeniorDesign/eat-infrastructure/tree/master/Project%201). This AWS services page will detail how our AWS services are set up.


## EC2 - Alex
### Nat and Bastion Instance - Alex
NAT / Bastion Jump instance creation
For this very important instance that acts as a secure entry point to our network, we chose Amazon’s NAT instance AMI. This AMI is configured to provide Network Address Translation and is less expensive and complicated than a NAT gateway, although less robust. This AMI must be searched for in the console, it does not appear when you select the launch an instance button.


#### Arguments
The arguments highlighted in yellow are important details required for proper automation of the AWS environment. I ensured that I allocated a public IP  with the associate_public _IP argument, and by specifying the subnet ID, our instance was placed in the desired subnet: public subnet 1. This is because we need this instance to be internet facing and we will assign an elastic IP to it later. With the vpc_security_groups argument, you can add one or more security groups that your instance will be tied to upon creation.  The same is true for the last highlighted argument, key_name, which specifies an authentication key for logging into the instance. The name “NAT” underlined in blue is very important. Whatever name you place here can be used as a variable when specifying this instance in other terraform code. Names specified under “tags” can be used by other software such as Ansible to automate configuration and deployment.


You should see the NAT /Bastion instance in the console with specified parameters if you execute the code successfully



### Blog Instances - Alex
### Terraform EC2 - Blog server instances
For our blog Servers, we chose Ubuntu Server as the operating system. This AMI is free-tier and one of the staple options found in the EC2 default instance creation wizard. Just like all terraform code we have written, things can be automated easily by specifying arguments for desired outcomes such as placing the instance in specific subnets and security groups. The designation “web2” in the first line of code is very important. Whatever name you place here can be used as a variable when specifying this instance in other terraform code.  Names specified under “tags” can be used by other software such as Ansible to automate configuration and deployment.


Our blog server instances were created with the following code:


As you can see by the highlighted arguments, we have specified a key pair, security group and subnet for the web servers to be associated with upon creation. The result of the above code in the console upon successful execution




## VPC
This section will go into detail about the VPC setup.


### Elastic IP - Alex
### Terraform VPC - Elastic IP allocation
Creating an elastic IP with Terraform is pretty easy and straightforward. You can specify an instance to associate with that elastic IP upon its creation with the code below. In this case we associated this elastic Ip with our NAT instance.


Successful execution should yield the desired results in the AWS console.




### Private and Public subnets- Erik
There are currently 6 subnets set up with Terraform, the same as in Project 0. 3 of these subnets are public, and 3 are private. Each of the public and the private subnets are linked to the VPCs main ID but they are located in different availability zones (us-west-2a, us-west-2b, us-west-2c). Tags are also used for easier access. The following template can be used to create a new subnet.

        resource "aws_subnet" "main" {
                 vpc_id     = "${aws_vpc.main.id}"
                 cidr_block = "10.0.1.0/24"

          tags {
                   Name = "Main"
                 }
        }


### Internet Gateway
The Internet Gateway is the component of the VPC that connects our instances to internet. This is how we declared our IG:

        resource "aws_internet_gateway" "gw" {
                Vpc_id = “${aws_vpc.main.id}”
        }






### Route Tables - Tyler
The route tables direct the route traffic flows through our subnets.


#### Private Route Table
The private route table's default route is to the NAT/Bastion Instance. This means that all traffic coming into and going out of our private subnets must enter through the NAT/Bastion Instance.


The private route table is connected to our 3 private subnets.


#### Public Route Table
The public route table's default route is to the internet gateway, this means that everything in the public subnets is accessible from the internet.


The public route table is connected to our 3 public subnets.


### Security Groups
Security groups allow us to specify incoming and outgoing traffic to instances. For this project, we created 2 security groups, one for our NAT instance, and one for our blog instances. Creation of a security group is pretty straightforward if you understand the principle of inbound and outbound networking rules. I created the NAT security group after referencing our network diagram and visualizing the connections between subnets and machines and what rules would need to be in place. Most important is to add a route for SSH via port 22. We want this rule to allow any source and destination IP  by entering 0.0.0.0/0 in the CIDR block arguments for both ingress and egress entries as seen in the code below. Also seen in the code below are rules for HTTP and HTTPs as well as ICMP for connectivity testing. We had to ensure that our instances both in the private and public subnets were reachable from the internet. The designation “NATSG” in the first line of code is used as a variable for other Terraform code. You can choose a description for your security group to appear with the description argument. Note that there is a description argument for rules as well.




#### NAT Security Group
The NAT security group allows ingress traffic on port 22, 80 and 443 from any IP. As our blog instances are routed to the NAT instance, it allows them to send and receive data from the internet using the nat instance.


This allows the blog instances to receive data from the NAT instance, from the internet.


The NAT security group allows outbound traffic to ports 80, 22, and 443 to any IP. This allows the blog instances


#### Blog Security Group
The blog instances allow SSH traffic to and from any IP, but only allow HTTP traffic to and from the subnet the NAT instance is being hosted on.


### Route 53 - Tyler
The route 53 for this project was a lot simpler than for last project. First, we routed traffic from Namecheap using a custom DNS pointing to our Route 53 NS records.


After that, we added A records for blog, www, and the apex domain using terraform. These records all pointed at the NAT instance's allocated elastic IP. From there we had to wait for Ansible to get set up to test if our route 53 was actually working.


## S3 and DynamoDB - Brian
### S3 - Brian
I created our s3 bucket by being able to do the default terraform setup. I ran into some issues at first since my team had already started working on their aws configurations. Once installed i kept me and my group members kept getting an error that 37 records needed to be added this was due to the fact that the backend had not been properly install. After destroying and reapplying the plan we were able to configure our things without getting state errors.
### DynamoDB - Brian
In order to makes sure that the state file would be working I had to set up the dynamodb table. This table was used so that if 2 people are working on the project if they apply changes they would not get any issues running it, on top of this as well the state file that is in the bucket is able to be updated in a remote way so that everyone’s changes could be remotely updated and the be made available to all of our organization.


## Certificates - Tyler
To start setting up certificates, we had to go on Namecheap and set up a custom DNS using the NS records we were provided in our Route 53 zone.


After that, we had to request a certificate through Terraform, then add CNAME records to our Route 53 zone using Terraform. After about an hour, the certificate would  automatically become issued.


## Application Load Balancer - Tyler
The application load balancer is hosted in all 3 us-west-2 availability zones, on the public subnets. There are two listeners set up on the ALB.


One redirects HTTP traffic to HTTPS and the other allows HTTPS traffic, and holds a security policy and SSL certificate, then it forwards the decrypted traffic to a "HTTP-Group" target group.


This "HTTP-Group" target group has two registered targets, our two blog servers.


## User keys and instances
In order for users to login to an instance, a key pair must be created and the public key must be distributed to each instance. Each user then logs into the instance with the corresponding private key which can be shared across multiple users.


Here we are creating an instance with the name “web” and specifying a key named “deployer”. This is the public key distribution method. The code near the bottom is the actual public key being coded into our terraform script.


#### Place key in NAT/Bastion jump Instance
In order to be able to ssh into the blog servers from our NAT/Bastion we must use the secure copy command to transfer the key to the instance and change the permissions on the key afterward.






## Ansible - Shahid, Erik, Brian
Ansible is an automation tool that can be deployed on multiple hosts at once. Running scripts on each host that needs tasks to be done is very slow and is not safe. Ansible intelligently checks to see if the task has already been performed. It then runs each task on all hosts requiring said tasks to be run. There’s a method to group hosts based on certain tasks that need to be completed.


Take for example:
```
[apache]
Host1 ansible_ssh_host=ubuntu@192.168.56.56
Host2 ansible_ssh_host=ubuntu@192.168.56.57
```


```
[nat]
Host3 ansible_ssh_host=ubuntu@192.168.56.58
```


Playbook example:
Touchapachehosts.yml
```
---
          - hosts: apache
            tasks:
              - name: run touch command
                command: /bin/touch /home/skarim/Desktop/hello.txt


                - name: Send files to target group
                - copy:
                    src: /home/myfile
                    dest: /home/myfile
```
Playbooks are a bunch of tasks separated into a format call yaml. Each task will be completed top to bottom then across each host in the group.


For this specific playbook all the hosts in the apache hosts will use the touch command to create a txt file called hello.txt onto the Desktop.


Tasks that need to be completed on the apache group will be seperate from tasks to be completed on the nat group.


### Playbook 1 - Shahid
webserverdeploy.yml
```
  ---
    - hosts: apache
      sudo: yes
      tasks:
        # Apache2 is required to host webpages
        - name: install apache2
          apt: name=apache2 update_cache=yes state=latest


        # Python-pip is required for hugo commands
        - name: install python-pip
          apt: name=python-pip update_cache=yes state=latest


        # Git is required for version control
        - name: install git
          apt: name=git update_cache=yes state=latest


        # A fresh install of apache2 leaves an index.html file in the
        # /var/www/html directory. This must be removed before placing
        # hugo files in the html directory
        - name: clear apache's html folder
          command: rm -rf html/*


        # An empty directory must be made for the tarball of the blog to
        # be unpacked into
        - name: create a directory for the tarball
          file:
            path: $HOME/eat-blog
            state: absent
            mode: 0755
```




### Playbook 2 - Erik, Brian
servicedeploy.yml
```
  ---
    - hosts: apache
      sudo: yes
      tasks:
        # The folder on the local machine containing the blog must be
        # archived into a tarball then sent to the blog servers
        - name: compress directory into a tarball
          archive:
            path: $HOME/eat-blog
            dest: $HOME/eat-blog.tar
            format: tar


        # The tarball containing the blog needs to be unarchived into
        # the directory
        - name: uncompress directory from tarball
          un archive:
            src: $HOME/eat-blog.tar
            dest: $HOME/eat-blog
```


In order to run both playbooks in one command type this into the terminal:
```
ansible-playbook webserverdeploy.yml servicedeploy.yml --ask-sudo-pass
```
