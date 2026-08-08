import os

import boto3
from botocore.exceptions import ClientError

from common.logger import logger
from common.responses import success_response, error_response

dynamodb = boto3.resource("dynamodb")

registrations_table = dynamodb.Table(
    os.environ["REGISTRATIONS_TABLE_NAME"]
)


def lambda_handler(event, context):

    logger.info("DELETE /registration invoked")

    try:

        registration_id = event.get(
            "pathParameters",
            {}
        ).get("id")

        if not registration_id:
            return error_response(
                message="Registration ID is required.",
                status_code=400
            )

        response = registrations_table.get_item(
            Key={
                "registration_id": registration_id
            }
        )

        if "Item" not in response:
            return error_response(
                message="Registration not found.",
                status_code=404
            )

        registrations_table.delete_item(
            Key={
                "registration_id": registration_id
            }
        )

        logger.info(
            f"Deleted registration {registration_id}"
        )

        return success_response(
            message="Registration cancelled successfully."
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