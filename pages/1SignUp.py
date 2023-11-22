import streamlit as st
from utils import hash_password, create_new_tenant, verify_tenant

def show_signup():
    st.subheader("Personalize 🍏")
    st.write("In case you encounter an error: Please click the signup button again or refresh the page")
    username = st.text_input("Username")
    password = st.text_input("Password", type='password')
    if st.button("SignUp"):
        hashed_password = hash_password(password)
        tenant_name = f"{username}_{hashed_password}"[:64]
        if verify_tenant(tenant_name):
            st.session_state['user'] = username
            st.session_state['tenant_name'] = tenant_name  # Store tenant name
            st.success("Logged in successfully! Lets chat!")
        else:
            create_new_tenant(tenant_name)
            st.session_state['user'] = username
            st.session_state['tenant_name'] = tenant_name  # Store tenant name

            # Create new tenant logic..
            st.success("Signup successful! Lets get to know you then chat!")

# Display the signup page
show_signup()
