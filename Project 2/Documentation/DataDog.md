##### DataDog
1.  DataDog installation and setup needs to be done with Ansible.
2.  AWS Policy and Role needs to be done using Terraform.
3.

##### Datadog AWS Integration (needs to be terraformed?)

DatadogAWSIntegrationRole
Linked to DatadogAWSIntegrationPolicy

DatadogAWSIntegrationPolicy
{
	"Version": "2012-10-17",
	"Statement": [
    	{
        	"Action": [
            	"cloudwatch:Get*",
            	"cloudwatch:List*",
            	"ec2:Describe*",
            	"support:*",
            	"tag:GetResources",
            	"tag:GetTagKeys",
            	"tag:GetTagValues"
        	],
        	"Effect": "Allow",
        	"Resource": "*"
    	}
	]
}



##### HipChat - Allows us to create rooms and chat inside datadog.
##### Pagerduty - Phone and SMS monitoring tool

##### Install DataDog Agent (Ansible instructions coming soon)
1.	Login to your DataDog Dashboard and select Integrations > Agent

2.	Select which OS you want to install the agent on and copy the command line installation code. (I tested on Amazon Linux).
3.	ssh into your your Amazon Linux (NAT) instance and paste code to install. Once, installed you should see something similar to the picture below.
 4. You are now done! You can start and stop the datadog agent with the following commands:
	sudo stop datadog-agent
	Sudo start datadog-agent
