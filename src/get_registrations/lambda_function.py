import os

import boto3
from boto3.dynamodb.conditions import Key
from botocore.exceptions import ClientError

from common.logger import logger
from common.responses import success_response, error_response
from common.utils import convert_decimals

dynamodb = boto3.resource("dynamodb")

registrations_table = dynamodb.Table(
    os.environ["REGISTRATIONS_TABLE_NAME"]
)


def lambda_handler(event, context):

    logger.info("GET /registrations invoked")

    try:

        email = event.get("pathParameters", {}).get("email")

        if not email:
            return error_response(
                message="Email is required.",
                status_code=400
            )

        response = registrations_table.query(
            IndexName="email-index",
            KeyConditionExpression=Key("email").eq(email)
        )

        registrations = convert_decimals(
            response.get("Items", [])
        )

        return success_response(
            message="Registrations retrieved successfully.",
            data=registrations
        )

    except ClientError as e:

        logger.exception(e)

        return error_response(
            message="Database operation failed.",
            status_code=500
        )

    except Exception as e:

        logger.exception(e)

        return error_response(
            message="Unexpected server error.",
            status_code=500
        )