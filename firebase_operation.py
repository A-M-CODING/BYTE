# firebase_operation.py

import firebase_admin
from firebase_admin import credentials, firestore, auth 
import os

# Get the path to the Firebase admin SDK JSON file
current_dir = os.path.dirname(os.path.abspath(__file__))
json_file_path = os.path.join(current_dir, 'byte-e6f0c-firebase-adminsdk-ileby-166e4268f3.json')

# Initialize Firebase Admin
cred = credentials.Certificate(json_file_path)
firebase_admin.initialize_app(cred)
db = firestore.client()

def get_feedback_with_username():
    feedback_ref = db.collection(u'feedback')
    docs = feedback_ref.order_by('date', direction=firestore.Query.DESCENDING).stream()  # Sort by date in descending order
    feedback_list = []
    for doc in docs:
        user_id = doc.get('userId')
        user = auth.get_user(user_id)
        username = user.email.split('@')[0] if user.email else "Unknown"
        feedback = {'date': doc.get('date'), 'rating': doc.get('rating'), 'review': doc.get('review'), 'username': username}
        feedback_list.append(feedback)
    return feedback_list

def get_total_users_count():
    all_users_count = 0
    page = auth.list_users()  # Fetch the first page of users
    while page:
        all_users_count += len(page.users)
        page = page.get_next_page()  # Move to the next page if available
    return all_users_count
