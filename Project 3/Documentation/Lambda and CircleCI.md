 
# CircleCI
The CircleCI has been completely changed from the last project, and it has a completely different function.

First, the CircleCI gets the docker using checkout, then it will build two docker images, one layered on the other.

```
            
            # Build 1
            docker build --rm=true -t fa480.club-base .
            cd ..
            cd production-site-dockerfile/
            
            # Build 2
            docker build --rm=true -t finalbuild .
            

```
After this, the docker images are tagged with the SHA of the current commit.

```
 # Tagging
            docker tag finalbuild:latest 507963158957.dkr.ecr.us-west-2.amazonaws.com/beats_repo:$CIRCLE_SHA1
            cd ..
```
Next, the ProductionSite.txt and StagingSite.txt are uploaded to S3.

```
 command: |
            # This uploads the ProductionSite.txt to s3.
            sudo pip install awscli        
            aws s3 cp /home/circleci/project/ProductionSite.txt s3://csuneat-project-2/
            sudo rm /home/circleci/project/ProductionSite.txt
      - run:   
          command: |
            # Adding Staging Site to s3.
            touch StagingSite.txt
            echo $CIRCLE_SHA1 > StagingSite.txt
            aws s3 cp StagingSite.txt s3://csuneat-project-2
```

These files are one line, and contain the SHA of the commit to use (which is linked to the image). They are both used by lambda later.

Finally, the images are uploaded to ECR using the following.

```
      - run:
         command: |
           # Upload image to ECR here.
           sudo $(aws ecr get-login --no-include-email --region us-west-2)
           sudo docker push 507963158957.dkr.ecr.us-west-2.amazonaws.com/beats_repo
```

# Lambda
Lambda took much longer than CircleCI. I started working on it the first week, and eventually finished it Tuesday of the second week.

The first part of setting up lambda was giving it permissions for ECS/ECR, CloudWatch and S3, as I covered in my last week's blog.

The lambda uses a simple cloudwatch log that allows us to see the output of the python function that gets ran. This was just set up using the console, as it is only temporary to find more information about the function, and it doesn't need to be preserved if anything happens to the rest of the infrastructure.

The lambda requires a handler, which will basically link the function to other parts of the AWS infrastructure. A single function can have inputs/outputs from multiple AWS services.

After the logs were set up, I received a simple event from s3 and attempted to "decode" it.

```
    '''
    Example event recieved from S3:

    event = {'Records': [{
            'eventVersion': '2.0',
            'eventSource': 'aws:s3',
            'awsRegion': 'us-west-2',
            'eventTime': '2018-10-11T19:08:26.592Z',
            'eventName': 'ObjectCreated:Put',
            'userIdentity':
                    {'principalId': 'AWS:ID HERE'},
            'requestParameters':
                {'sourceIPAddress': 'IP ADDRESS HERE'},
            'responseElements':
                {'x-amz-request-id': 'AMZ REQUEST ID HERE',
                'x-amz-id-2': 'ID 2 HERE (LONGER)'},
            's3':
                {'s3SchemaVersion': '1.0',
                'configurationId': 'LAMBDA TF CONFIGURATION ID',
                'bucket':
                    {'name': 'NAME OF BUCKET',
                    'ownerIdentity':{'principalId': 'ID OF OWNER'},
                    'arn': 'ARN OF BUCKET'},
                'object':
                    {'key': 'FILENAME', 'size': 48, 'eTag': 'ETAG HERE', 'sequencer': 'SEQUENCER NUMBER HERE'}}}]}
    '''
```

After this, we have the event handler. This gets ran everytime the function gets called from another AWS service.

```
    def my_handler(event, context):
        bucket = event.get("Records")[0].get("s3").get("bucket")
        bucket_arn = bucket.get("arn")
        bucket_name = bucket.get("name")

        the_object = event.get("Records")[0].get("s3").get("object")
        filename = the_object.get("key")

        tag = getFile(bucket_name,filename,filename)
        containername = ""

        if filename == "ProductionSite.txt":
            containername = "beats-production"
        elif filename=="StagingSite.txt":
            containername = "beats-staging"

        print(tag)


        update(tag,containername,tag)
```

We are assuming that the event is from a bucket. There will be an error otherwise. We are getting the name and ARN of the bucket. Then we get the key of the object that was uploaded. After this, we run the "getFile" function.

```
    def getFile(bucket, filename, filepath):
        filepath = "/tmp/"+filepath

        s3client = boto3.client('s3')
        s3client.download_file(bucket, filename, filepath)

        txt_file = open(filepath, "r")
        tag = txt_file.readline()
        txt_file.close()

        return tag
```

This function downloads the s3 object that was updated (the StagingSite or ProductionSite.txt file), then will read the first line, and return that first line after closing the file. From here we return back to the handler function.

```
        containername = ""

        if filename == "ProductionSite.txt":
            containername = "beats-production"
        elif filename=="StagingSite.txt":
            containername = "beats-staging"

        print(tag)


        update(tag,containername,tag)
```

Based on the filename (aka: the tag), we will change the container to beats-production or beats-staging. Note that this containername will be used to reference the task definition and service (as they are both called beats-staging/beats-production). This is to simplify the service and remove an argument.

Finally, we update the ECS records.

```
    imagename = "507963158957.dkr.ecr.us-west-2.amazonaws.com/beats_repo:"+imagename
    imagename = imagename.rstrip()
```

These lines specify the imagename (from ECR), then strip the newline character. After this we print the imagename, then setup the task definition.

```
print("Image name is:##" +imagename +"##.")
    response = client.register_task_definition(
        family=containername,
        #taskRoleArn='string',
        networkMode='bridge',
        containerDefinitions=[
            {
                'name': containername,
                'image': imagename,
            #'cpu': 123,
                'memory': 300,
            #'memoryReservation': 123,
            #'links': [
            #    'string',
                'portMappings': [
                    {
                        'containerPort': 80,
                        'hostPort': 80,
                        'protocol': 'tcp'
                    },
                    {
                        'containerPort': 443,
                        'hostPort': 443,
                        'protocol': 'tcp'
                    }
                ],
                'essential': True,
            },
        ],
    )
```

The only important attributes being updated here are the memory, task-definition image, and port mappings. The family and name both refer to the current task-defintion in ECS (either beats-staging or beats-production). Note that both images, staging and production, use the same cluster. This cluster has two container instances, one for staging and one for production.

Finally, we update the container and task definition with our new values.

```
    pprint.pprint(response['taskDefinition']['revision'])
#Update service
    taskDefinitionRev = response['taskDefinition']['family'] + ':' + str(response['taskDefinition']['revision'])
#print taskDefinition
    response = client.update_service(
        cluster='beats-cluster',
        service=containername,
        desiredCount=1,
        taskDefinition=taskDefinitionRev,
        deploymentConfiguration={
            'maximumPercent': 100,
            'minimumHealthyPercent': 40
        }
    )
```





 



