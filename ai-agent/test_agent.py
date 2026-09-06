from agent import ask_agent


def test_european_sales():
    question = "Show me European sales"

    answer = ask_agent(question)

    assert answer
    print("\nQuestion:", question)
    print("Answer:", answer)


def test_profit_by_category():
    question = "Show profit by category"

    answer = ask_agent(question)

    assert answer
    print("\nQuestion:", question)
    print("Answer:", answer)


def test_total_profit():
    question = "What is total profit?"

    answer = ask_agent(question)

    assert answer
    print("\nQuestion:", question)
    print("Answer:", answer)


if __name__ == "__main__":
    test_european_sales()
    test_profit_by_category()
    test_total_profit()
