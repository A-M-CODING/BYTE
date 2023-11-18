import streamlit as st
from utils import upload_document, show_user_documents_screen ,batch_import_documents

def show_upload_screen():
    st.subheader("Upload Your Medical Documents")
    uploaded_file = st.file_uploader("Choose a file", type=['pdf', 'docx', 'txt', 'png', 'jpg', 'jpeg'])

    # Check if 'tenant_name' is in session_state, if not, set a default value
    user_id = st.session_state.get('tenant_name', None)

    if uploaded_file is not None:
        if user_id:
            with st.spinner("Processing document..."):
                try:
                    data_objects = upload_document(uploaded_file, user_id)
                    batch_import_documents(data_objects, user_id)
                    st.success("File uploaded and processed successfully!")
                    st.write("Here are your documents:")
                    show_user_documents_screen(user_id)

                except Exception as e:
                    st.error(f"An error occurred: {e}")
        else:
            st.error("Tenant ID is not set. Please login first.")

            
show_upload_screen()
