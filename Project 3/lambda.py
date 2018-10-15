import boto3
import pprint
import os

region = "us-west-2"
client = boto3.client('ecs', region_name=region)

def my_handler(event, context):
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

    bucket = event.get("Records")[0].get("s3").get("bucket")
    bucket_arn = bucket.get("arn")
    bucket_name = bucket.get("name")

    the_object = event.get("Records")[0].get("s3").get("object")
    filename = the_object.get("key")

    tag = getFile(bucket_name,filename,filename)
    containername

    if filename == "ProductionSite.txt":
        containername = "production"
    elif filename=="StagingSite.txt":
        contianername = "staging"

    update(tag,containername)

    getFile(bucket_name,filename,filename)

def getFile(bucket, filename, filepath):
    filepath = "/tmp/"+filepath

    s3client = boto3.client('s3')
    s3client.download_file(bucket, filename, filepath)

    txt_file = open(filepath, "r")
    tag = txt_file.readline()
    txt_file.close()

    return tag


response = client.list_task_definitions(familyPrefix= 'demotask', status='ACTIVE')

#pprint.pprint(response['taskDefinitionArns'][3])
def update(tag,containername):
    imagename = "507963158957.dkr.ecr.us-west-2.amazonaws.com/beats_repo"+tag
    response = client.register_task_definition(
        family='demotask',
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
                        'containerPort': 80,
                        'hostPort': 80,
                        'protocol': 'tcp'
                    }
                ],
                'essential': True,
            },
        ],
    )
    pprint.pprint(response['taskDefinition']['revision'])
#Update service
    taskDefinitionRev = response['taskDefinition']['family'] + ':' + str(response['taskDefinition']['revision'])
#print taskDefinition
    response = client.update_service(
        cluster='clusterdemo',
        service='servicedemo',
        desiredCount=1,
        taskDefinition=taskDefinitionRev,
        deploymentConfiguration={
            'maximumPercent': 100,
            'minimumHealthyPercent': 40
        }
    )
    #pprint.pprint(response)
print("service updated")
