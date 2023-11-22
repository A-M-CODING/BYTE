import streamlit as st
import re  # Import regular expressions library
from utils import hash_password, create_new_tenant, verify_tenant

def is_valid_username(username):
    """Check if the username is valid according to the specified rules."""
    return re.match(r'^[a-zA-Z0-9_-]{1,64}$', username) is not None

def show_signup():
    st.subheader("Personalize 🍏")
    st.markdown("In case you encounter an error: Please click the signup button again or refresh the page")
    
    # Instructions for username
    st.markdown("Your username should only contain alphanumeric characters (a-z, A-Z, 0-9), underscore (_), and hyphen (-), and must be 1 to 64 characters long.")
    
    username = st.text_input("Username")
    password = st.text_input("Password", type='password')
    
    if st.button("SignUp"):
        if is_valid_username(username):
            hashed_password = hash_password(password)
            tenant_name = f"{username}_{hashed_password}"[:64]
            
            if verify_tenant(tenant_name):
                st.session_state['user'] = username
                st.session_state['tenant_name'] = tenant_name  # Store tenant name
                st.success("Logged in successfully! Let's chat!")
            else:
                create_new_tenant(tenant_name)
                st.session_state['user'] = username
                st.session_state['tenant_name'] = tenant_name  # Store tenant name

                # Create new tenant logic..
                st.success("Signup successful! Let's get to know you then chat!")
        else:
            st.error("Invalid username. Please make sure it only contains alphanumeric characters, underscore, or hyphen and is between 1 and 64 characters long.")

# Display the signup page
show_signup()

