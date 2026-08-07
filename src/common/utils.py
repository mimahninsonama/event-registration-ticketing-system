from datetime import datetime, timezone


def current_timestamp():
    """
    Return the current UTC timestamp.
    """

    return datetime.now(timezone.utc).isoformat()


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
        "registered_at": timestamp
    }