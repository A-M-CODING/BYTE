import streamlit as st
import cohere 
from altProds import get_links
from vision import detect_text
from dotenv import load_dotenv
import os
load_dotenv()  # loads variables from .env


cohereAPIKey = os.getenv("COHERE_API_KEY")
co = cohere.Client(cohereAPIKey)

def show_health_info_form():
    st.title("Health Information Form")
    st.write("Please enter your health details to personalize your experience.")
    create_health_info_form()

def create_health_info_form():
    with st.form(key='health_info_form'):
        st.title("Health Information Form")
        st.write("Please enter your health details to personalize your experience.")
        # Personal details
        age = st.number_input("Age", min_value=0, max_value=120, step=1)
        gender = st.selectbox("Gender", ["Male", "Female", "Prefer not to say"])
        weight = st.number_input("Weight (kg)", min_value=20, max_value=200, step=1)
        height = st.number_input("Height (cm)", min_value=100, max_value=250, step=1)

        # Health details
        allergies = st.multiselect("Allergies", ["Nuts", "Dairy", "Gluten", "Seafood", "Pollen", "Latex", "No known allergies"], default=[])
        allergies_other = st.text_input("Other Allergies")

        diseases = st.multiselect("Diseases", ["Diabetes", "Hypertension", "Heart Disease", "Asthma", "Thyroid Disorder", "None"], default=[])
        diseases_other = st.text_input("Other Diseases")

        health_goals = st.multiselect("Health Goals", ["Gain Weight", "Maintain Weight", "Lose Weight", "Improve Muscle Tone", "Increase Stamina/Endurance", "Improve Overall Health"], default=[])
        health_goals_other = st.text_input("Other Health Goals")

        activity_level = st.selectbox("Activity Level", ["Sedentary (little or no exercise)", "Lightly Active (light exercise or sports 1-3 days a week)", "Moderately Active (moderate exercise or sports 3-5 days a week)", "Very Active (hard exercise or sports 6-7 days a week)", "Extra Active (very hard exercise, physical job or training twice a day)"])

        dietary_preferences = st.multiselect("Dietary Preferences", ["Vegetarian", "Vegan", "Pescatarian", "Omnivore", "Keto", "Paleo", "None"], default=[])
        dietary_preferences_other = st.text_input("Other Dietary Preferences")

        app_purpose = st.multiselect("Purpose of Using Our App", ["Fitness Tracking", "Health Monitoring", "Diet/Nutrition Planning", "Weight Management", "Medical Condition Management", "Physical Activity Motivation", "Research Purposes"], default=[])
        app_purpose_other = st.text_input("Other Purpose of Using App")

        submit_button = st.form_submit_button(label='Submit')

        if submit_button:
            # Encapsulating responses in a dictionary
            st.session_state['form_responses'] = {
                "Age": age,
                "Gender": gender,
                "Weight": weight,
                "Height": height,
                "Allergies": allergies + ([allergies_other] if allergies_other else []),
                "Diseases": diseases + ([diseases_other] if diseases_other else []),
                "Health Goals": health_goals + ([health_goals_other] if health_goals_other else []),
                "Activity Level": activity_level,
                "Dietary Preferences": dietary_preferences + ([dietary_preferences_other] if dietary_preferences_other else []),
                "Purpose of Using App": app_purpose + ([app_purpose_other] if app_purpose_other else [])
            }

            st.session_state['current_screen'] = 'chat'

def show_chat():
    st.title("BYTE Chatbot (Using cohere chat endpoint & RAG) ")
    st.write("This is a chatbot")

    form_responses = st.session_state.get('form_responses', {})


    def display_links(links):
        # Sidebar for product links
        with st.sidebar:
            # Create a container
            add_container = st.container()
            # Use the container as a context manager to add content
            with add_container:
                st.subheader('Products recommended just for you', divider='rainbow')
                for link in links:
                    st.markdown(f"* [{link}]({link})", unsafe_allow_html=True)


    # applying styles.css
    def load_css():
        with open("static/styles.css", "r")  as f:
            css = f"<style>{f.read()} </style>"
            st.markdown(css, unsafe_allow_html = True)

    def extract_links(documents):
        links = [doc['url'] for doc in documents if 'url' in doc]
        return ', '.join(links)

    def initialize_session_state() :
        
        # Initialize a session state to track whether the initial message has been sent
        if "initial_message_sent" not in st.session_state:
            st.session_state.initial_message_sent = False

        # Initialize a session state to store the input field value
        if "input_value" not in st.session_state:
            st.session_state.input_value = ""

        if "chat_history" not in st.session_state:
            st.session_state.chat_history = []
            
            prompt = f"""As an expert in food and nutrition, your task is to analyse my health-related information and then 
                        answer my questions related to food and nutrition keeping in mind my health specifications and goals. 
                        If I attached text extracted from my food item's nutrition label, analyse it according to my health data and
                        let me know in if it's good or bad for me, if I should or shouldn't eat it and if I 
                        can eat it, then specify the quantity to be consumed as well, all according to my
                        health information and goals as well as internet sources etc, in a brief and straightforward manner. 
                        Be concise and precise in your answers . Give clear, unambiguous answers. 
                        Your answers should be backed by verified sources from the internet. 
                        If I ask something unrelated to food and/or nutrition, politely decline. Here is my info: {form_responses}
                        """

            st.session_state.chat_history.append({"role": "User", "message": prompt})
            st.session_state.chat_history.append({"role": "Chatbot", "message": "Yes understood, I will act accordingly and follow your instructions fully. I will also use verified internet sources for all my responses."})

    def on_click_callback():

        load_css()
        customer_prompt = st.session_state.customer_prompt
        extracted_text = ""
        nutr_label = False

        # Check if an image has been uploaded
        uploaded_file = st.session_state.get("image_uploader")
        if uploaded_file is not None:
            with st.spinner('Processing image...'):
                # Directly pass the uploaded file to the detect_text function
                extracted_text = detect_text(uploaded_file)
                if extracted_text:
                    # Set the extracted text as the customer prompt
                    customer_prompt = extracted_text
                    nutr_label = True
                else:
                    st.error("No text could be extracted from the image.")

        if customer_prompt:
            
            st.session_state.input_value = ""
            st.session_state.initial_message_sent = True

            with st.spinner('Generating response...'):  

                llm_response = co.chat( 
                    message=customer_prompt,
                    connectors=[{"id": "web-search"}],
                    documents=[],
                    model='command',
                    temperature=0.5,
                    # return_prompt=True,
                    chat_history=st.session_state.chat_history,
                    prompt_truncation = 'auto',
                    #stream=True,
                ) 

            llm_response_documents = llm_response.documents 
            all_links = extract_links(llm_response_documents)
            formatted_response = f"{llm_response.text}\n\nCitations:\n{all_links}"     
            st.session_state.chat_history.append({"role": "User", "message": customer_prompt})
            st.session_state.chat_history.append({"role": "Chatbot", "message": formatted_response})
            if nutr_label:
                links = get_links(customer_prompt, form_responses)
                display_links(links)
            nutr_label = False
            uploaded_file = None

    def submain():

        initialize_session_state()
        chat_placeholder = st.container()
        prompt_placeholder = st.form("chat-form")

        with chat_placeholder:
            for chat in st.session_state.chat_history[2:]:
                if chat["role"] == "User":
                    msg = chat["message"]
                else:
                    msg = chat["message"]

                div = f"""
                <div class = "chatRow 
                {'' if chat["role"] == 'Chatbot' else 'rowReverse'}">
                    <img class="chatIcon" src = "app/static/{'logo.png' if chat["role"] == 'Chatbot' else 'admin.png'}" width=32 height=32>
                    <div class = "chatBubble {'adminBubble' if chat["role"] == 'Chatbot' else 'humanBubble'}">&#8203; {msg}</div>
                </div>"""
                st.markdown(div, unsafe_allow_html=True)
                
        
        with st.form(key="chat_form"):
            cols = st.columns((5, 1, 3))  # Add another column for the button
            
            # Display the initial message if it hasn't been sent yet
            if not st.session_state.initial_message_sent:
                cols[0].text_input(
                    "Chat",
                    placeholder="Hello, how can I assist you?",
                    label_visibility="collapsed",
                    key="customer_prompt",
                )  
            else:
                cols[0].text_input(
                    "Chat",
                    value=st.session_state.input_value,
                    label_visibility="collapsed",
                    key="customer_prompt",
                )

            cols[1].form_submit_button(
                "Ask",
                type="secondary",
                on_click=on_click_callback,
            )

            # File uploader for images
            uploaded_file = cols[2].file_uploader("Upload Image", type=['png', 'jpg', 'jpeg'], key="image_uploader")
   
    submain()


# Main function to manage navigation
def main():
    if 'current_screen' not in st.session_state:
        st.session_state['current_screen'] = 'form'

    if st.session_state['current_screen'] == 'form':
        create_health_info_form()  # This will display the form
    elif st.session_state['current_screen'] == 'chat':
        show_chat()  # This should start the chat function



