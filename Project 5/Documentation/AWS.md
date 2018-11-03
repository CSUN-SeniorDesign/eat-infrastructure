
# Site Bucket
Our site bucket is set to public-read, with principal of * in the "PublicReadGetObject." This allows anyone to read objects from the bucket (aka, view the site). We set the bucket as a website by assigning the index.html as the index and error documents. We enable versioning as well.

# Services
We are using two regions, us-east-1 and us-west-2. Us-east-1 is only used for the ACM certificate, as that is what's required for CloudFront to properly work. We use the same validation methods as in previous assignments.

## Route 53
For Route 53, we remove all of the previous records and just add two Alias A records, one for *.fa480.club and one for fa480.club. The alias points to the cloudfront distribution domain name, and hosted zone ID in both cases.

## IAM
The IAM is the same as the previous assignments, although most uses can be removed (such as the bot users).

# CloudFront
We ended up getting cloudfront working after some troubles.

First, we create a https certificate in the us-east-1 region.  We set our bucket's website_endpoint as the domain_name in Terraform. We set the default_root_object to the index.html page. Then, we set two aliases, fa480.club and *.fa480.club. We turn on compression, and set allowed methods to GET, HEAD and OPTIONS. We are only using PriceClass_100, and are only hosting in US and CA, although that europe is also an option for this price tier. Note that the bucket must be named "fa480.club" in order for the cloudfront to work correctly.  
