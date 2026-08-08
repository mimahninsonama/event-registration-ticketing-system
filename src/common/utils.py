from datetime import datetime, timezone
from decimal import Decimal

def current_timestamp():
    """
    Return the current UTC timestamp.
    """

    return datetime.now(timezone.utc).isoformat()

def convert_decimals(obj):
    """
    Recursively convert DynamoDB Decimal values into
    Python int or float so they can be serialized to JSON.
    """

    if isinstance(obj, list):
        return [convert_decimals(item) for item in obj]

    if isinstance(obj, dict):
        return {
            key: convert_decimals(value)
            for key, value in obj.items()
        }

    if isinstance(obj, Decimal):

        if obj % 1 == 0:
            return int(obj)

        return float(obj)

    return obj

def build_registration_item(
    registration_id,
    ticket_id,
    event_id,
    full_name,
    email
):
    """
    Build a DynamoDB registration item.
    """

    timestamp = current_timestamp()

    return {
        "registration_id": registration_id,
        "ticket_id": ticket_id,
        "event_id": event_id,
        "full_name": full_name,
        "email": email,
        "status": "CONFIRMED",
        "checked_in": False,
        "registered_at": timestamp
    }