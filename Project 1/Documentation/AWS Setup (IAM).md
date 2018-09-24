
# AWS Setup
Note that all AWS was set up using Terraform for this project. The terraform code can be found on our [github.](https://github.com/CSUN-SeniorDesign/eat-infrastructure/tree/master/Project%201). This AWS setup page will detail how our AWS was setup (not including services).


Most of our documentation will be located in the AWS Services page, as that is where the bulk of this project is contained.




## IAM
This section will go into detail about how our IAM users, groups and policies are set up.


### IAM Users
IAM users are created using Terraform, one for each member of our team. These users aren't accessible to begin with. First they must be given a default password and console access manually.


The users are given a default password, then must change it the first time they log in. After that, they can create an access key for use in the AWS CLI. At this point, the users are set up.


### IAM Groups
There is currently one IAM group set up, called "EAT-Team" that gives all members Administrator access. All IAM users are added to this group when they are created.


Note that a password must be set manually, and console access is disabled until one is set, so there is no risk of compromising an account though.


The administrator access is given through an attached built-in policy "AdministratorAccess."


### IAM Organization
The IAM organization is exactly the same as the one from Project 0. Since Shahid joined our group, he had to be added to the organization, and needed an IAM account.


At this point, the AWS is set up, and able to be accessed by every group member. From here, the rest of our AWS will be covered in the "AWS Services.md" file.
