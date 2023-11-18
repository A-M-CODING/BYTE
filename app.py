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
