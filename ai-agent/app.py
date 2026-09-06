import streamlit as st

from agent import ask_agent


st.set_page_config(
    page_title="MetricMind",
    page_icon="📊",
)

st.title("📊 MetricMind")
st.write("Ask a business question about your data.")

question = st.text_input(
    "Your question",
    value="",
    placeholder="Show me European sales",
    key="user_question",
)

if st.button("Ask", type="primary"):

    question = st.session_state.user_question.strip()

    if not question:
        st.warning("Please enter a question.")
    else:
        with st.spinner("Analyzing your question..."):
            try:
                answer = ask_agent(question)

                st.subheader("Answer")
                st.write(answer)

            except Exception as e:
                st.error(f"Error: {e}")
