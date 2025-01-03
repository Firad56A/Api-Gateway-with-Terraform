import json
import boto3
import os

# Initialize the S3 client
s3_client = boto3.client('s3')

# Get the bucket name from environment variables
BUCKET_NAME = os.environ['BUCKET_NAME']

def lambda_handler(event, context):
    # Get the HTTP method (POST, GET, DELETE, etc.)
    http_method = event.get('httpMethod', '')

    # Route the request based on the method
    if http_method == 'POST':
        return handle_post(event)
    elif http_method == 'GET':
        if event.get('queryStringParameters') and 'name' in event['queryStringParameters']:
            return handle_get(event)
        else:
            return handle_get_all()
    elif http_method == 'DELETE':
        return handle_delete(event)
    else:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'Unsupported HTTP method'})
        }

def handle_post(event):
    """Handles POST requests to upload data to S3."""
    try:
        # Parse the request body
        body = json.loads(event['body'])
        file_name = body['name']
        file_content = body['content']

        # Upload the data to S3
        s3_client.put_object(
            Bucket=BUCKET_NAME,
            Key=file_name,
            Body=file_content
        )

        return {
            'statusCode': 200,
            'body': json.dumps({'message': f'File {file_name} uploaded successfully'})
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }

def handle_get(event):
    """Handles GET requests to retrieve a specific file from S3."""
    try:
        file_name = event['queryStringParameters']['name']

        # Retrieve the file from S3
        response = s3_client.get_object(Bucket=BUCKET_NAME, Key=file_name)
        file_content = response['Body'].read().decode('utf-8')

        return {
            'statusCode': 200,
            'body': json.dumps({'name': file_name, 'content': file_content})
        }

    except Exception as e:
        return {
            'statusCode': 404,
            'body': json.dumps({'error': str(e)})
        }

def handle_delete(event):
    """Handles DELETE requests to remove a file from S3."""
    try:
        file_name = event['queryStringParameters']['name']

        # Delete the file from S3
        s3_client.delete_object(Bucket=BUCKET_NAME, Key=file_name)

        return {
            'statusCode': 200,
            'body': json.dumps({'message': f'File {file_name} deleted successfully'})
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }

def handle_get_all():
    """Handles GET ALL requests to list all files in S3."""
    try:
        # List all objects in the bucket
        response = s3_client.list_objects_v2(Bucket=BUCKET_NAME)

        # Extract the file names
        files = [obj['Key'] for obj in response.get('Contents', [])]

        return {
            'statusCode': 200,
            'body': json.dumps({'files': files})
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }