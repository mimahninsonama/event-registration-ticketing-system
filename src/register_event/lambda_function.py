import os

import boto3
from boto3.dynamodb.conditions import Key
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
    convert_decimals,
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

        # --------------------------------
        # Parse request body
        # --------------------------------

        body, error = parse_request_body(event)

        if error:
            return error_response(
                message=error,
                status_code=400
            )

        # --------------------------------
        # Validate required fields
        # --------------------------------

        errors = validate_required_fields(
            body,
            [
                "event_id",
                "full_name",
                "email"
            ]
        )

        if errors:
            return error_response(
                message="Validation failed.",
                status_code=400,
                errors=errors
            )

        # --------------------------------
        # Validate email
        # --------------------------------

        if not validate_email(body["email"]):
            return error_response(
                message="Invalid email address.",
                status_code=400
            )

        # --------------------------------
        # Verify event exists
        # --------------------------------

        response = events_table.get_item(
            Key={
                "event_id": body["event_id"]
            }
        )

        event_item = convert_decimals(
            response.get("Item")
        )

        if not event_item:
            return error_response(
                message="Event not found.",
                status_code=404
            )

        # --------------------------------
        # Generate Registration ID
        # --------------------------------

        registration_id = generate_registration_id()

        # --------------------------------
        # Generate Ticket ID
        # --------------------------------

        ticket_id = generate_ticket_id()

        # --------------------------------
        # Build Registration Record
        # --------------------------------

        registration = build_registration_item(
            registration_id=registration_id,
            ticket_id=ticket_id,
            event_id=body["event_id"],
            full_name=body["full_name"],
            email=body["email"]
        )

        # --------------------------------
        # Check Duplicate Registration
        # --------------------------------

        response = registrations_table.query(
            IndexName="email-index",
            KeyConditionExpression=Key("email").eq(body["email"])
        )

        existing = response.get("Items", [])

        for item in existing:
            if item["event_id"] == body["event_id"]:
                return error_response(
                    message="You are already registered for this event.",
                    status_code=409
                )

        # --------------------------------
        # Save Registration
        # --------------------------------

        registrations_table.put_item(
            Item=registration
        )

        logger.info(
            f"Registration created successfully: {registration_id}"
        )

        # --------------------------------
        # Success Response
        # --------------------------------

        return success_response(
            message="Registration successful.",
            data={
                "registration_id": registration_id,
                "ticket_id": ticket_id,
                "event_id": body["event_id"],
                "status": "CONFIRMED"
            }
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