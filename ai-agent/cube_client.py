import os
import requests
from dotenv import load_dotenv

load_dotenv()

CUBE_API_URL = os.getenv("CUBE_API_URL")
CUBE_API_TOKEN = os.getenv("CUBE_API_TOKEN")


def query_cube(query: dict):
    """
    Execute a query against the Cube.dev Semantic Layer.

    The query must use Cube measures, dimensions, and filters.
    Raw SQL is not accepted.
    """

    if not CUBE_API_URL:
        raise ValueError("CUBE_API_URL is not configured")

    if not CUBE_API_TOKEN:
        raise ValueError("CUBE_API_TOKEN is not configured")

    headers = {
        "Authorization": f"Bearer {CUBE_API_TOKEN}",
        "Content-Type": "application/json",
    }

    response = requests.post(
        CUBE_API_URL,
        headers=headers,
        json=query,
        timeout=60,
    )

    response.raise_for_status()

    return response.json()
