import streamlit as st
from utils import get_responses, import_responses

def show_health_info_form():
    st.title("Health Information Form")
    st.write("Please enter your health details to personalize your experience.")
    create_health_info_form()

def create_health_info_form():
    with st.form(key='health_info_form'):
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
            form_responses = {
                "Age": str(age),
                "Gender": str(gender),
                "Weight": str(weight),
                "Height": str(height),
                "Allergies": allergies + ([allergies_other] if allergies_other else []),
                "Diseases": diseases + ([diseases_other] if diseases_other else []),
                "Health Goals": health_goals + ([health_goals_other] if health_goals_other else []),
                "Activity Level": activity_level,
                "Dietary Preferences": dietary_preferences + ([dietary_preferences_other] if dietary_preferences_other else []),
                "Purpose of Using App": app_purpose + ([app_purpose_other] if app_purpose_other else [])
            }
            
            # Construct the responses_string
            responses_string = ", ".join(f"{key}: '{value}'" if isinstance(value, str) else f"{key}: {value}"
                                         for key, value in form_responses.items())

            user_id = st.session_state.tenant_name
            if user_id:
                with st.spinner("Processing form..."):
                    data_object = {
                        "user_form": responses_string,
                        "source": "User's Form",
                        "tenant": user_id
                    }
                    object_id = import_responses(data_object, user_id)
                    if object_id:
                        st.success("Form processed and saved successfully!")
                        # Store the object_id in session state for later retrieval
                        st.session_state["form_object_id"] = object_id
                    else:
                        st.error("Failed to process the form.")
            else:
                st.error("Tenant ID is not set. Please login first.")

show_health_info_form()
            
            
            
