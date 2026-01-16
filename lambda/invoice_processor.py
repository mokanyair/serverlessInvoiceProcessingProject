import json
import boto3
import os

s3 = boto3.client("s3")
sns = boto3.client("sns")

PROCESSED_BUCKET = os.environ["PROCESSED_BUCKET"]
SNS_TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]

def lambda_handler(event, context):
    for record in event["Records"]:
        bucket = record["s3"]["bucket"]["name"]
        key = record["s3"]["object"]["key"]

        response = s3.get_object(Bucket=bucket, Key=key)
        data = response["Body"].read().decode("utf-8")

        processed_data = data.upper()

        s3.put_object(
            Bucket=PROCESSED_BUCKET,
            Key=key,
            Body=processed_data
        )

        sns.publish(
            TopicArn=SNS_TOPIC_ARN,
            Message=f"Invoice {key} processed successfully"
        )

    return {"status": "success"}
