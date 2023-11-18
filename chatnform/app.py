from form import show_health_info_form
from chat import show_chat
import streamlit as st
import cohere 
from altProds import get_links
from vision import detect_text
from dotenv import load_dotenv
import os
load_dotenv()  # loads variables from .env

cohereAPIKey = os.getenv("COHERE_API_KEY")
co = cohere.Client(cohereAPIKey)

# Main app configuration
st.set_page_config(page_title="BYTE", layout="wide")

# Define your pages here
pages = {
    "Health Information Form": show_health_info_form,
    "Chat": show_chat
}

# Sidebar for page navigation
st.sidebar.title("Navigation")
selection = st.sidebar.radio("Go to", list(pages.keys()))

# Display the selected page
page = pages[selection]
page()
