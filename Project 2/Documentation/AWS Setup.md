# AWS Setup

## IAM
The IAM is very similar to how it was in Project 1. There is still a user for each person, but now there is also a CircleCI userm and a new role and 2 new policies.

### CircleCI User
The CircleCI user is used for CircleCI, to upload onto S3. This is required because whenever we push onto the server, a test will be ran with CircleCI that will upload the blog (assuming all code is correct) to the S3 bucket we created. In order to do that, CircleCI requires permissions, which it takes in the form of a user Access key and Secret Key. This user is placed into a bot group, with a PO_Policy. This policy is what allows the user to write to S3.

### IR_Role and IO_Policy
The IR_Role is used to fetch from S3, and also read from S3 (as per the IO_Policy). This role is attached to our ASG and set up as an IAM Instance Profile in our Launch Configurations. This permission is passed down to all EC2 instances created by the ASG, and allows them to fetch and read from S3 without requiring "aws configure" to be ran.
