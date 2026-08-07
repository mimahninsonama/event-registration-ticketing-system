import json

# Common headers used by every API response
DEFAULT_HEADERS = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "Content-Type",
    "Access-Control-Allow-Methods": "GET,POST,DELETE,OPTIONS"
}


def success_response(data=None, message="Success", status_code=200):
    """
    Build a successful HTTP response.
    """

    body = {
        "success": True,
        "message": message,
        "data": data
    }

    return {
        "statusCode": status_code,
        "headers": DEFAULT_HEADERS,
        "body": json.dumps(body)
    }


def error_response(message="An error occurred", status_code=400, errors=None):
    """
    Build an error HTTP response.
    """

    body = {
        "success": False,
        "message": message
    }

    if errors:
        body["errors"] = errors

    return {
        "statusCode": status_code,
        "headers": DEFAULT_HEADERS,
        "body": json.dumps(body)
    }