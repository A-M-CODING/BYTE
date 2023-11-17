import streamlit as st
import hashlib
import weaviate
import os
import cohere
import chat
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Retrieve API keys and endpoint from environment variables
WEAVIATE_ENDPOINT = os.getenv("WEAVIATE_ENDPOINT")
WEAVIATE_API_KEY = os.getenv("WEAVIATE_API_KEY")
COHERE_API_KEY = os.getenv("COHERE_API_KEY")

# Initialize Weaviate client with the API key and endpoint
client = weaviate.Client(
    url=WEAVIATE_ENDPOINT,  
    auth_client_secret=weaviate.AuthApiKey(api_key=WEAVIATE_API_KEY),  
    additional_headers={
        "X-Cohere-Api-Key": COHERE_API_KEY,
    }
)

# Initialize Cohere client with the API key
co = cohere.Client(COHERE_API_KEY)

# Helper function to hash password
def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()
# Function to create a new tenant in Weaviate
def create_new_tenant(username, password):
    tenant_name = f"{username}_{hash_password(password)}"[:64]
    client.schema.add_class_tenants(
        class_name='User', 
        tenants=[weaviate.Tenant(name=tenant_name)]
    )

# Function to verify if a tenant exists in Weaviate
def verify_tenant(username, hashed_password):
    tenant_name = f"{username}_{hashed_password}"[:64]
    tenants = client.schema.get_class_tenants(class_name='User')
    print(tenants)
    return tenant_name in [t.name for t in tenants]

# Placeholder function for document upload logic
def upload_document(user_id, document):
    pass

# Main function to run the Streamlit app
def main():
    st.title("BYTE - Medical Document Management")

    # Initialize session state for navigation
    if 'current_screen' not in st.session_state:
        st.session_state['current_screen'] = 'home'
        st.session_state['uploaded_files'] = []

    # Home screen
    if st.session_state['current_screen'] == 'home':
        show_home_screen()

    # Authentication screen
    elif st.session_state['current_screen'] == 'auth':
        show_auth_screen()

    # Chat screen
    elif st.session_state['current_screen'] == 'chat':
        show_chat_screen()

    # Document upload screen
    elif st.session_state['current_screen'] == 'upload':
        show_upload_screen()

# Function to display home screen
def show_home_screen():
    st.subheader("Your Gateway to Organized Medical Documents")
    if st.button("START"):
        st.session_state['current_screen'] = 'auth'

# Function to display authentication screen
def show_auth_screen():
    col1, col2 = st.columns(2)

    # Login column
    with col1:
        st.subheader("Login")
        login_username = st.text_input("Login Username")
        login_password = st.text_input("Login Password", type='password')
        if st.button("Login"):
            # Login logic
            hashed_password = hash_password(login_password)
            if verify_tenant(login_username, hashed_password):
                st.session_state['user'] = login_username
                st.session_state['current_screen'] = 'chat'
            else:
                st.error("Incorrect Username/Password")

    # Signup column
    with col2:
        st.subheader("SignUp")
        signup_username = st.text_input("Signup Username")
        signup_password = st.text_input("Signup Password", type='password')
        if st.button("SignUp"):
            # SignUp logic
            hashed_password = hash_password(signup_password)
            if verify_tenant(signup_username, hashed_password):
                st.error("User already exists")
                return
            create_new_tenant(signup_username, hashed_password)
            st.session_state['user'] = signup_username
            st.session_state['current_screen'] = 'upload'

        if st.button("Back"):
            st.session_state['current_screen'] = 'home'

# Function to display chat screen
def show_chat_screen():
    st.subheader("Chat with BYTE")
    # Placeholder for chat  this is just to give an idea but the connectors is the part where i intend to connect the server
    chat.run_chatbot()


# Function to display document upload screen
def show_upload_screen():
    st.subheader("Upload Your Medical Documents")
    uploaded_file = st.file_uploader("Choose a file", type=['pdf', 'docx', 'txt', 'png', 'jpg', 'jpeg'])
    if uploaded_file is not None:
        upload_document(st.session_state['user'], uploaded_file)
        st.success("File uploaded successfully!")

# Run the Streamlit app
if __name__ == '__main__':
    main()