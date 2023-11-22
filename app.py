import streamlit as st

# Page configuration
st.set_page_config(
    page_title="BYTE - Health & Nutrition",
    page_icon="🍏",
    layout="wide"
)

# Main header
st.title("Welcome to BYTE 🍏")
st.markdown("### Your Gateway to Personalized Health and Nutrition")

# Instructions for New Users
st.markdown("## Getting Started Guide for New Users")
st.markdown("""
Please Follow these steps to get the best experience:
1. **Sign Up**: Visit the Signup Page. If you encounter any errors, please try clicking the 'Sign Up' button again, or refresh the page and attempt to sign up once more.
2. **Fill Out the Form**: After signing up, move to the form page to complete the Health Information Form with your details.
3. **Optional - Upload Medical Documents**: You have the option to upload any relevant medical documents for a more personalized experience.
4. **Explore the Chat**: Once registered, you can move to the chat page and  start chatting. Feel free to attach pictures in the chat for a more interactive experience.
5. **View Alternative Products**: After viewing the generated response in the chat, you can click on the sidebar to explore alternative products.
6. **Chat Normally**: Continue to use the chat as normal and remove pictures if needed.
""")

# Using columns to create a more dynamic layout
col1, col2 = st.columns([2, 1])

with col1:
    st.markdown("""
        **Discover a Healthier You!**
        
        At BYTE, we're passionate about helping you achieve your health and fitness goals.
        - 🥗 **Personalized Diet Plans**
        - 🏋️ **Fitness Tracking**
        - 📊 **Health Monitoring**
        - 🍎 **Nutrition Advice**
        
        Get started by filling out our Health Information Form and let us tailor a plan just for you!
    """)

with col2:
    st.image("https://source.unsplash.com/weekly?health", caption="Embark on your health journey with us!")

# Footer
st.markdown("---")
st.markdown("### Hope you like it!")
