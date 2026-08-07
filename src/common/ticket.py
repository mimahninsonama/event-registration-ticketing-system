import uuid


def generate_registration_id():
    """
    Generate a unique registration ID.
    Example:
    REG-6A91C4D8
    """

    return f"REG-{uuid.uuid4().hex[:8].upper()}"


def generate_ticket_id():
    """
    Generate a ticket number.
    Example:
    TKT-8F3D19A4
    """

    return f"TKT-{uuid.uuid4().hex[:8].upper()}"