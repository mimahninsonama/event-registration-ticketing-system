import os

import boto3
from botocore.exceptions import ClientError
from common.utils import convert_decimals

from common.logger import logger
from common.responses import success_response, error_response

dynamodb = boto3.resource("dynamodb")

EVENTS_TABLE = os.environ["EVENTS_TABLE_NAME"]

events_table = dynamodb.Table(EVENTS_TABLE)


def lambda_handler(event, context):

    logger.info("GET /events invoked")

    try:

        response = events_table.scan()

        events = convert_decimals(
           response.get("Items", [])
)

        logger.info(f"Retrieved {len(events)} events.")

        return success_response(
            data=events,
            message="Events retrieved successfully."
        )

    except ClientError as e:

        logger.error(e)

        return error_response(
            message="Failed to retrieve events.",
            status_code=500
        )

    except Exception as e:

        logger.exception(e)

        return error_response(
            message="Unexpected server error.",
            status_code=500
        )