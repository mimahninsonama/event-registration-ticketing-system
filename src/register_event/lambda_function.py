import os

import boto3
from botocore.exceptions import ClientError

from common.logger import logger
from common.responses import success_response, error_response
from common.validation import (
    parse_request_body,
    validate_required_fields,
    validate_email,
)
from common.ticket import (
    generate_registration_id,
    generate_ticket_id,
)
from common.utils import (
    build_registration_item,
)

dynamodb = boto3.resource("dynamodb")

events_table = dynamodb.Table(
    os.environ["EVENTS_TABLE_NAME"]
)

registrations_table = dynamodb.Table(
    os.environ["REGISTRATIONS_TABLE_NAME"]
)


def lambda_handler(event, context):

    logger.info("POST /register invoked")

    try:

        # -------------------------------
        # Parse the request body
        # -------------------------------

        body, error = parse_request_body(event)

        if error:
            return error_response(
                message=error,
                status_code=400
            )

        # -------------------------------
        # Validate required fields
        # -------------------------------

        errors = validate_required_fields(
            body,
            [
                "event_id",
                "full_name",
                "email",
            ]
        )

        if errors:
            return error_response(
                message="Validation failed.",
                status_code=400,
                errors=errors
            )

        # -------------------------------
        # Validate email
        # -------------------------------

        if not validate_email(body["email"]):
            return error_response(
                message="Invalid email address.",
                status_code=400
            )

        # Placeholder until we implement
        # the remaining registration logic

        return success_response(
            message="Validation successful.",
            data=body
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