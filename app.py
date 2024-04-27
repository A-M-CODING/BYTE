import streamlit as st
import base64

def main():
    st.title("APK File Downloader")
    
    # Provide download link to the APK file
    st.markdown("### Download APK")
    st.markdown(get_binary_file_downloader_html("app-release.apk", "Download APK"), unsafe_allow_html=True)

def get_binary_file_downloader_html(bin_file, file_label='File'):
    with open(bin_file, 'rb') as f:
        data = f.read()
    bin_str = base64.b64encode(data).decode()
    href = f'<a href="data:application/octet-stream;base64,{bin_str}" download="{bin_file}">{file_label}</a>'
    return href

if __name__ == "__main__":
    main()
