import logging

logger = logging.getLogger()

# Configure only once
if not logger.handlers:
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s | %(levelname)s | %(message)s"
    )

logger.setLevel(logging.INFO)