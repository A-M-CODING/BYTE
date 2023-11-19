# BYTE 🍏:
BYTE - Nutritionist in your pocket

## Overview
BYTE is an innovative health and nutrition-focused application, combining the power of AI and multi-tenancy architecture for a personalized user experience. Utilizing Streamlit for the frontend, Cohere's language models, Weaviate vector database, Flask backend, and the integration of Retrieval-Augmented Generation (RAG), BYTE stands at the forefront of health and nutrition AI applications.

## Link to BYTE:
https://byte-nutrition.streamlit.app

## Functional Aspects
- Personalized User Experience: Utilizes multi-tenancy for data privacy and personalized user interactions.
- Health Information Form: Collects user-specific data to tailor recommendations.
- Document Upload and Processing: Supports uploading and processing of medical documents in various formats.
- AI-Powered Chatbot with RAG: Cohere-powered chatbot enhanced with RAG, delivering accurate and context-aware responses.
- Connectors to Internet and User Data: Employs connectors to access real-time internet data and user-uploaded documents for comprehensive responses.
- Hybrid Search: Leverages Weaviate’s hybrid search capability, prioritizing vector search over keyword search for more relevant results.

## Technical Aspects
- Streamlit for UI: Provides a dynamic and interactive user interface.
- Weaviate Vector Database: Manages data storage and efficient querying with multi-tenancy support.
- Cohere for NLP: Generates nuanced responses using large language models.
- RAG for Enhanced Responses: Combines retrieval from external sources and generative AI for comprehensive answers.
- Flask Backend: Handles specific backend operations and connects with Cohere's API.
- Document Processing: Utilizes the unstructured library for effective information extraction.
- Hybrid Vector and Keyword Search: Integrates Weaviate’s search capabilities for precise query responses.

## Key Features
- User Signup and Data Isolation: Supports user profiles with secure multi-tenancy.
- Detailed Health Data Collection: Comprehensive forms for capturing health metrics.
- Document Upload and AI Extraction: Processes various document formats for health data extraction.
- RAG-Enhanced AI Chatbot: Provides personalized and accurate health advice.
- Connectors for Extensive Data Access: Integrates real-time internet data and user documents for enriched responses.
- Prioritized Vector Search: Employs hybrid search with a focus on vector search for relevant results.
- Responsive and Intuitive UI: Crafted with Streamlit for a seamless user experience.
- Backend Operations with Flask: Manages backend processes and integrates AI functionalities.

## Technologies Used
- Streamlit: Frontend interface development.
- Weaviate: Vector database for data storage and searching.
- Cohere: Natural language understanding and processing.
- Flask: Backend server management.
- Unstructured Library, Google Cloud Vision API: Document processing and text extraction.
- Python: Primary programming language.
- Various Python Libraries: Including langchain, cohere, and weaviate_client.

## Getting Started
### Installation Requirements:
- Python 3.x
- Streamlit, Flask, Cohere SDK, Weaviate Client, etc. (refer to requirements.txt)
- Cohere API key, Weaviate API key, Google Vision API key, etc., for accessing various services.

### Running the Application:
- Clone the repository and navigate to the project directory.
- Install dependencies: pip install -r requirements.txt.
- Set up necessary API keys and environment variables.
- Start the Streamlit app: streamlit run App.py.
- Run the Flask server for backend functionalities.

## Detailed Features
### 1. Landing Page

![image](https://github.com/A-M-CODING/BYTE/assets/86928073/443c3db8-5456-42e8-87d5-25c71445a1d0)

The BYTE app's main page is a straightforward spot where you find out what the app does and where to go next. It utilises Streamlit's multi-page application feature, which lets us have a neat sidebar that lists all the other pages like SignUp, Form, Upload, and Chat. This page is your starting point and shows you the way to all the app's tools for health and nutrition.

### 2. Sign Up/Log In Page

![image](https://github.com/A-M-CODING/BYTE/assets/86928073/ed8f598f-a063-496a-8922-5cfd102487e6)
The SignUp page of the BYTE app doubles as the gateway for new users to create an account and for existing users to log in. Utilizing Weaviate's multi-tenancy feature, this page plays a crucial role in maintaining user privacy and security. Multi-tenancy in Weaviate allows BYTE to isolate each user's data within the app. This means that when a user signs up or logs in, their information is stored and managed in a separate 'tenant', effectively creating a private space for their session within the database.

Each time a user enters their username and password, BYTE uses this information to generate a unique ID, a process that involves hashing the password for additional security. This unique ID is key to creating and managing a session state exclusive to that user, ensuring that their interactions with the app remain private and secure. The session state keeps track of the user's activity during their time on the app, preserving the state across different pages without mixing it with other users' sessions.

Weaviate's multi-tenancy is central to providing a personalized and secure experience for each BYTE user. It ensures that each user's data, from dietary preferences to health records, remains accessible only to them, thanks to the distinct and isolated tenants created for every individual within the database.

#### Signing up as a new user
![image](https://github.com/A-M-CODING/BYTE/assets/86928073/9444de1b-cdb7-4aff-8a57-0b528b174eb9)
On the BYTE app's SignUp page, both new and existing users manage their access. New users sign up here, and Weaviate's multi-tenancy comes into play by creating a unique ID for each new account. This ID is crafted from their username and a hashed version of their password, ensuring their data stays private.

#### Logging in as an existing user
![image](https://github.com/A-M-CODING/BYTE/assets/86928073/003a079e-6bf8-4d19-9501-229efc167cbe)
For returning users, this page serves as a login portal where they can access their account using the unique ID generated during their initial signup. This process ensures that each user's experience and session are kept separate, thanks to Weaviate's multi-tenancy feature. By providing each user with a dedicated data 'tenant,' their information and session state remain isolated and secure, guaranteeing privacy and a personalized experience within the BYTE app.

### 3. Form Page

![image](https://github.com/A-M-CODING/BYTE/assets/86928073/5d4169d7-4260-48a7-9245-682759013f9d)
![image](https://github.com/A-M-CODING/BYTE/assets/86928073/b3a1914d-c174-4670-87a6-4e3284efde43)
The Form page on the BYTE app is where users input their personal health goals, activity level, dietary preferences, and reasons for using the app. When a user submits this form, the data is directed into the database and linked to their unique tenant ID, thanks to Weaviate's multi-tenancy feature. This ensures the information is stored in the user's private data space.

Behind the scenes, submitting the form triggers the creation of an object ID for this new set of data, which is then added to the database under the user's isolated tenant. This object ID, along with the user's ID stored in the session state, is later used to fetch this personalized information. When the user interacts with the chatbot, this data is retrieved and used to provide context, ensuring the chatbot's advice and responses are customized to each user's specific health profile and needs.

#### Filling and submitting the form
![image](https://github.com/A-M-CODING/BYTE/assets/86928073/160a57a7-99e5-456f-8421-a3fea10bf02c)
![image](https://github.com/A-M-CODING/BYTE/assets/86928073/2e958f7e-0da7-4dfd-97e7-a0ce06bf97d3)

### 4. File Upload Page

![image](https://github.com/A-M-CODING/BYTE/assets/86928073/e85cf490-9f2e-40c9-907e-791cfef67a62)
![image](https://github.com/A-M-CODING/BYTE/assets/86928073/efd7867d-b187-4349-a632-b03d5d9ca8e5)
The Upload Documents page in the BYTE app is designed for users to upload various types of medical documents, which can be PDFs, DOCX files, TXT files, and even images like PNGs or JPEGs. This flexibility allows users to even snap a picture of their documents and upload them directly. Once a document is uploaded, the unstructured.io API kicks in to extract content from these files. 

After extraction, this information is stored in the user's dedicated database space within Weaviate using their unique tenant ID, similar to how form data is stored. Each document's contents are then linked to an object ID, which is crucial for retrieval.

To leverage this stored information, a RAG connector is incorporated into Cohere's co.chat endpoint. This connector enables the chatbot to pull contextually relevant information from the user's documents during conversations. The app emphasizes vector search over keyword search, allowing for more nuanced and context-aware interactions. The hybrid search functionality ensures that even implicit details in the user documents can significantly influence the chatbot's advice and responses, making the user experience seamlessly personalized. This powerful hybrid search is sophisticated enough to infer details like dietary preferences, for example, identifying a user as vegan from the content of their medical reports without them having to explicitly state it.

### 5. Chat Page

#### Asking generic questions about food and nutrition/health management

![image](https://github.com/A-M-CODING/BYTE/assets/86928073/10af31bf-7adf-4e80-85fa-16275b7cf1f5)
![image](https://github.com/A-M-CODING/BYTE/assets/86928073/59c9b1bb-5673-4467-9785-b43e72f454e6)
![image](https://github.com/A-M-CODING/BYTE/assets/86928073/a25219be-91a9-4a71-8777-a005a18dd0fe)
The chatbot in the Byte Nutrition application serves as an intelligent and context-aware assistant for users, leveraging multiple advanced technologies to provide personalized nutrition advice and product recommendations.

When a user interacts with the chatbot, it first constructs a preamble using the user's data, such as dietary preferences and health goals, extracted from their form submissions. This information is stored in the database via Weaviate's multi-tenancy feature, which assigns a unique tenant ID to each user. For existing users, the system retrieves their data using their ID from the session state. New users have a new ID generated upon signup. Weaviate creates an object ID for the form data when adding it to the database, and this ID, along with the user's session ID, is later used to fetch context-relevant information to assist the chatbot in generating responses.

The application utilizes the unstructured.io API to extract content from uploaded medical documents, which are then stored in the database associated with the user's tenant ID. This extracted data enriches the context for the chatbot, enabling it to understand the user's health condition without explicit input during the conversation.

To enhance the chatbot's responses with information from the user's documents, a RAG (Retrieval-Augmented Generation) connector is added to Cohere's co.chat endpoint. The system performs a hybrid search, prioritizing vector search over keyword search. This allows the chatbot to deduce information like dietary restrictions, for example, identifying a user as vegan based on their medical documents, without the user having to state this explicitly.

The chatbot also provides citations within its responses, linking back to the source documents or external content it referenced, thereby giving users the opportunity to explore the information in more depth.

#### Uploading nutrition label of food product

![image](https://github.com/A-M-CODING/BYTE/assets/86928073/55e6276e-fcea-4bdd-b42a-fc6158c84805)
![image](https://github.com/A-M-CODING/BYTE/assets/86928073/28e86662-5a1a-41c2-83ae-8ae1ae0dd641)
![image](https://github.com/A-M-CODING/BYTE/assets/86928073/0d2da1f5-e791-4820-8aa5-0775e0315a49)
If a user uploads an image of a nutrition label, the application employs the Google Vision API to extract text from the image, providing the chatbot with additional nutritional data to consider in its responses.

Moreover, Cohere's co.chat endpoint's search query generator mode is utilized to suggest healthier product alternatives based on the user's profile. It generates a search query that is passed to the Google Search API, which fetches links to alternative products. These links are displayed in the application's sidebar, allowing users to easily click through to purchase the products from the respective websites.

#### Healthier Alternate Product Links
![image](https://github.com/A-M-CODING/BYTE/assets/86928073/abf245f1-6269-4c5c-b14b-b4172ea7b45c)

## Contributing
Contributions to enhance BYTE or introduce new features are welcome. Please fork the repository, make your changes, and submit a pull request for review.
