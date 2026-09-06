import json
import os

from dotenv import load_dotenv
from langchain_openai import ChatOpenAI
from langchain.tools import tool

from cube_client import query_cube
from schema import get_cube_schema, format_cube_schema
from prompts import SYSTEM_PROMPT

load_dotenv()

@tool
def query_cube_tool(query: dict) -> dict:
    """
    Query the Cube.dev Semantic Layer using measures,
    dimensions, and filters.
    """
    return query_cube(query)


def create_agent():
    """
    Create the MetricMind AI agent.
    """

    cube_metadata = get_cube_schema()
    cube_schema = format_cube_schema(cube_metadata)

    schema_text = json.dumps(cube_schema, indent=2)

    prompt = SYSTEM_PROMPT.format(
        cube_schema=schema_text
    )

    api_key = os.getenv("OPENAI_API_KEY")

    if not api_key:
        raise ValueError("OPENAI_API_KEY is not configured")

    llm = ChatOpenAI(
        model=os.getenv("OPENAI_MODEL", "gpt-4o-mini"),
        temperature=0,
        api_key=api_key,
    )

    llm_with_tools = llm.bind_tools([query_cube_tool])

    return llm_with_tools, prompt


def ask_agent(question: str) -> str:
    """
    Ask MetricMind a natural-language business question.
    """

    llm, system_prompt = create_agent()

    messages = [
        {
            "role": "system",
            "content": system_prompt,
        },
        {
            "role": "user",
            "content": question,
        },
    ]

    response = llm.invoke(messages)

    # If the model requests a Cube query, execute it.
    if response.tool_calls:

        tool_call = response.tool_calls[0]

        query = tool_call["args"]

        result = query_cube_tool.invoke(query)

        messages.append(response)

        messages.append(
            {
                "role": "tool",
                "content": json.dumps(result),
                "tool_call_id": tool_call["id"],
            }
        )

        final_response = llm.invoke(messages)

        return final_response.content

    return response.content
