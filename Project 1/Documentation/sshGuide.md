##### How to connect to AWS instances using SSH (Mac & Linux users)

###### Setup and configure AWS Command Line Interface (CLI)
1. Open your terminal and run "pip install awscli" and wait for it to install. You should
get a message similar to the one below when it is finished.

		Successfully installed PyYAML-3.13 awscli-1.16.18 botocore-1.12.8 ....

2. You can verify that aws cli was installed with "aws --version".

		$ aws --version
		aws-cli/1.16.10 Python/2.7.10 Darwin/17.7.0 botocore/1.12.0

3. We need to create the Access key now and we can do that by:
	1. Login to your aws console
	2. Click on your user name on the right top corner then "My Security Credentials"
	3. Click "Users" on the left side and then click on your user name. You should
	   now see a summary of that user.
	4. Click "Security credentials" and then "Create access key"
	5. You can either download and store the .csv in a secure place or just write them
	   down somewhere else, but remember that you cannot recover or view your secret
	   access key if you lose it.


4. You can now open your terminal again and run "aws configure" where it will ask for
	your Access key you just created.

			$ aws configure
			AWS Access Key ID [None]: YOUR ACCESS KEY
			AWS Secret Access Key [None]: YOUR SECRET ACCESS KEY
			Default region name [None]: YOUR REGION
			Default output format [None]: YOUR FORMAT

###### Connect to your instance with a public network.
1. Open your terminal again and cd into the folder where you have your privatekey.pem
file stored and run "chmod 400 privatekey.pem" to change the permissions of the key.
2. Most Mac & Linux machines have SSH preinstalled but you can check by running "ssh" in your terminal. Check out http://www.openssh.com if the terminal does not recognize the command.
3. We should now be able to successfully connect through SSH by running: "ssh -A /path_to_key/privatekey.pem username@public_dns_name"
 (Amazon Linux uses ec2-user as username and -A enables agent forwarding).

			$ ssh -A privatekey.pem ec2-user@34.213.12.211
			Last login: Fri Sep 21 23:26:43 2018 from 76-221-172-215.lightspeed.irvnca.sbcglobal.net

            __|  __|_  )
            _|  (     /   Amazon Linux AMI
            __\___|___|

			https://aws.amazon.com/amazon-linux-ami/2018.03-release-notes/
			13 package(s) needed for security, out of 24 available
			Run "sudo yum update" to apply all updates.

###### Connect to your instance with a private network.
1. You are now able to SSH into your instance with a private ip by running "ssh username@private-ip". (Ubuntu uses ubuntu as username)

		$ ssh ubuntu@PrivateIP-1
		Welcome to Ubuntu 16.04.5 LTS (GNU/Linux 4.4.0-1065-aws x86_64)

		 * Documentation:  https://help.ubuntu.com
		 * Management:     https://landscape.canonical.com
		 * Support:        https://ubuntu.com/advantage

		  Get cloud support with Ubuntu Advantage Cloud Guest:
		    http://www.ubuntu.com/business/services/cloud

		0 packages can be updated.
		0 updates are security updates.

		The programs included with the Ubuntu system are free software;
		the exact distribution terms for each program are described in the
		individual files in /usr/share/doc/*/copyright.

		Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
		applicable law.

		To run a command as administrator (user "root"), use "sudo <command>".
		See "man sudo_root" for details.

		ubuntu@PrivateIP-1:~$

##### How to connect to AWS instances using SSH (Windows)
###### PuTTY
1. Download and Install PuTTY (https://www.putty.org/)
2. Open PuTTY and enter ec2-user@34.213.12.211
3. Click "Connection > SSH > Auth"
4. Tick the box "Allow agent forwarding" and "Browse" and locate your .ppk file.
5. Open Pageant, Right click on the tiny icon of a computer that appeared in the right corner.
6. Select "Add keys" and select your .ppk file.
7. It's not time to SSH into one of our blog instances with "ssh ubuntu@private-ip"
				$ ssh ubuntu@172.31.60.174
Welcome to Ubuntu 16.04.5 LTS (GNU/Linux 4.4.0-1065-aws x86_64)
8. You are now signed into your blog server which has a private ip.
