import json
import re

EMAIL_REGEX = r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"


def parse_request_body(event):
    """
    Parse the JSON body sent through API Gateway.
    """

    try:
        body = event.get("body")

        if body is None:
            return None, "Request body is required."

        if isinstance(body, str):
            body = json.loads(body)

        return body, None

    except json.JSONDecodeError:
        return None, "Request body must be valid JSON."


def validate_required_fields(data, required_fields):
    """
    Check that all required fields exist and are not empty.
    """

    errors = []

    for field in required_fields:

        value = data.get(field)

        if value is None:
            errors.append(f"{field} is required.")

        elif isinstance(value, str) and value.strip() == "":
            errors.append(f"{field} cannot be empty.")

    return errors


def validate_email(email):
    """
    Validate email format.
    """

    if not re.match(EMAIL_REGEX, email):
        return False

    return True