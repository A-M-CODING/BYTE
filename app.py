import streamlit as st

def main():
    st.title("APK File Downloader")
    st.markdown("### Download APK 1")

    # The direct URL to the APK file in your GitHub repository
    apk_url = 'https://github.com/A-M-CODING/BYTE/raw/streamlit-flutter-apk/app-release.apk'
    st.markdown(f'[Download APK]({apk_url})', unsafe_allow_html=True)

if __name__ == "__main__":
    main()
