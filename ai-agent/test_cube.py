from cube_client import query_cube

query = {
    "measures": ["sales.revenue"]
}

result = query_cube(query)
print(result)
