# AWS Services

## VPC
The current setup that we have for our virtual private cloud (VPC) is that we have a total of 6 subnets. We split them up into by turning 3 of the subnets into public ones and the other 3 into private subnets. To do this we had to setup a route table that would specify that the public subnets would be the main ones that the route table used. Another route table was as well added for the private subnets. To top off the VPC settings we had to designate an internet gateway that would be attached to our main routing table which uses the public subnets

## EC2
After we had set up our VPC we went ahead and launched an Ubuntu instance with 3 availability zones available. We then went ahead and made sure that our instance had an elastic IP address so that we would be able to connect remotely into it. The second thing that we did is that we used a key pair to try and ssh into our Ubuntu instance. One of the challenges that we faced is that when using putty on windows you have to convert the .pem key to .ppk so that we were able to connect through putty. For this conversion we went ahead and used puttygen for the conversion then with the .ppk key we ssh into the instance. Once inside we were able to install apache as our web server. After setting this portion up one of our team members accidentally terminated the instance instead of stopping it so we just went ahead and redid our instance but we kept our same pairing key so that we wouldn’t have to create another one.

## Route 53
We used route 53 in order to host 2 zones one of the zones contains 6 subnets while the other one contains 3 subnets. For fa480club we configure the DNS records by setting the address to the elastic ip address. The name of the server will be using the domain of fa480 club and below these records we have set up the blog.fa480.club which will end up displaying or static web blog. 
We received two TLS certificates from certbot we used one for the fa480club and the other one for the blog.fa480club and configured the route so that even connecting through port 80 it will redirect to port 443.
