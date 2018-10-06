# AWS Services
## ASG
The Autoscaling Group was a new challenge for this project. This was set up completely by the beginning of the second week. The ASG requires Launch Configurations, which includes an AMI (Provided by packer), an Instance Profile (discussed in AWS Setup), a key name to ssh into the boxes, and an instance type.

The ASG itself is created based off the launch configuration we created. The ASG is linked to the HTTP-Group target group, so instances created will have traffic go thorugh the load balancer. We can set the minimum, maximum, and desired servers to whatever we choose. The ASG is hosted in us-west-2. All instances are created in the private-1 subnet, whos default route is through the NAT instance.

## Route 53
Route 53 has been updated with 3 new domains, staging.fa480.club, www.staging.fa480.club and blog.staging.fa480.club. These were set up also using apache-2 sites, to have separate directories for the staging and main sites.
