import boto3

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

    getFile(bucket_name,filename,filename)

def getFile(bucket, filename, filepath):
    filepath = "/tmp/"+filepath

    s3client = boto3.client('s3')
    s3client.download_file(bucket, filename, filepath)

    txt_file = open(filepath, "r")
    tag = txt_file.readline()
    txt_file.close()

    print(tag)
