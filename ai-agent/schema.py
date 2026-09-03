import os
import requests
from dotenv import load_dotenv

load_dotenv()

CUBE_API_URL = os.getenv("CUBE_API_URL")
CUBE_API_TOKEN = os.getenv("CUBE_API_TOKEN")

def get_cube_schema():
    """
    Get the semantic layer schema from Cube.dev.
    """

    meta_url = CUBE_API_URL.replace(
        "/cubejs-api/v1/load",
        "/cubejs-api/v1/meta"
    )

    headers = {
        "Authorization": f"Bearer {CUBE_API_TOKEN}",
        "Content-Type": "application/json"
    }

    response = requests.get(
        meta_url,
        headers=headers,
        timeout=30
    )

    response.raise_for_status()

    return response.json()

def format_cube_schema(metadata):
    """
    Convert Cube metadata into a simple structure
    for the AI agent.
    """
    
    schema = {}

    for cube in metadata.get("cubes", []):
        cube_name = cube.get("name")

        if not cube_name:
            continue

        schema[cube_name] = {
            "measures": [
                measure["name"]
                for measure in cube.get("measures", [])
                if measure.get("name")
            ],
            "dimensions": [
                dimension["name"]
                for dimension in cube.get("dimensions", [])
                if dimension.get("name")
            ]
        }

    return schema
