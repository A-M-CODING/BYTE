# app.py

import streamlit as st

from firebase_operation import get_feedback_with_username, get_total_users_count

def main():
    st.title("APK File Downloader")
    st.markdown("BYTE - nutritionist in your pocket.Get immediate nutrition advice, alternate food recommendations and connect with like-minded people!")
    
    # APK Download Link
    apk_url = 'https://github.com/A-M-CODING/BYTE/raw/streamlit-flutter-apk/app-release.apk'
    st.markdown(f'[Download APK]({apk_url})', unsafe_allow_html=True)

    # Display Active Users
    st.title('Active Users')
    active_users_count =  get_total_users_count()
    st.write(f"Number of Active Users: {active_users_count}")

    # Display Feedback Data
    st.title('User Feedback')
    feedback = get_feedback_with_username()
    for item in feedback:
        # Create a horizontal layout with the username on the left and the date on the right
        col1, col2 = st.columns([2, 1])
        col1.write(f"Username: {item['username']}")
        col2.write(item['date'].date().strftime('%Y-%m-%d'))  # Display date on the right
        st.write("\nRating: ", item['rating'])
        st.write("Review:\n", item['review'], "\n")  # Display review on a new line
        st.write("---")  # Add a horizontal line between reviews

if __name__ == "__main__":
    main()
