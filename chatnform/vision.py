from google.cloud import vision
import io
import os
from dotenv import load_dotenv
import json
from google.oauth2 import service_account

load_dotenv()  # load environment variables from .env

# Retrieve the credentials JSON string
credentials_json = os.getenv("GOOGLE_CREDENTIALS_JSON")

# Convert the string back to a JSON object
credentials_dict = json.loads(credentials_json)

# Construct a credentials object from the dictionary
credentials = service_account.Credentials.from_service_account_info(credentials_dict)

def detect_text(uploaded_file):
    """Detects text in the uploaded file."""
    client = vision.ImageAnnotatorClient(credentials=credentials)

    # Read content directly from the uploaded file-like object
    content = uploaded_file.getvalue()

    image = vision.Image(content=content)

    response = client.text_detection(image=image)
    texts = response.text_annotations

    if texts:
        # Extract the entire block of text
        full_text = texts[0].description
        print('Extracted Text:\n')
        print(full_text)
        return full_text
    else:
        print('No text found')
        return None