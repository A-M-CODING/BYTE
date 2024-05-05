# BYTE
_Nutritionist in your pocket_

Find more about BYTE, watch tutorial video and download APK here: https://byte-apk.streamlit.app/

Note: only available for Android devices currently

## Details About BYTE

### 1. Localization

![lang](https://github.com/A-M-CODING/BYTE/assets/86928073/a2e32f7a-d265-4040-a7f2-fd3abfaef68b)

BYTE's commitment to accessibility and inclusivity is exemplified through its localization capabilities, enabling the app to support six languages: English, Urdu, Hindi, Arabic, German, Korean, and Chinese. This feature is implemented using Flutter's robust localization framework, which not only enhances user experience but also reflects the app's dedication to serving a diverse global audience.

Flutter's localization framework utilizes the intl package to manage translations and format dates, numbers, and strings according to local conventions. This is crucial for providing a seamless and culturally relevant user interface, especially in contexts like dietary guidance where local terminology and units may vary significantly.


### 2. Authentication - Login and Sign Up Screens

![authentication](https://github.com/A-M-CODING/BYTE/assets/86928073/948782ab-ddf3-496a-a2f8-2cfa012da02f)

In BYTE, the authentication feature is implemented using Firebase Authentication to handle both traditional sign-up/login processes and to integrate Google sign-in for streamlined user access. This setup allows users to register and authenticate using their email addresses or directly via their Google accounts, leveraging OAuth 2.0 protocols for secure and convenient user authentication.

- **Firebase Authentication**: Manages user registration, login, and data security. Firebase's backend services provide robust, secure management of user authentication data, supporting a seamless integration with the app's frontend.
- **Google Sign-In**: Enhances ease of use by enabling users to log in with their existing Google accounts, reducing the barrier for new user registration and improving the overall user experience.

**Benefits**:
- **Security and Reliability**: Firebase Authentication provides a secure and reliable authentication infrastructure, which is crucial for maintaining user trust and data integrity.
- **Ease of Use**: By allowing users to sign in with Google, BYTE simplifies the login process, making it faster and more user-friendly, especially for users already logged into their Google accounts on their devices.
- **Scalability**: The use of Firebase ensures that the authentication system can scale effortlessly as the user base grows, without requiring additional setup for handling increased traffic or data.

This dual-method authentication approach not only enhances security but also caters to user convenience, making it an essential feature for the inclusive and user-focused design of BYTE.

### 3. Form Screen

![form](https://github.com/A-M-CODING/BYTE/assets/86928073/608ac29f-2783-43b6-b6af-c2c077093d87)

The form feature in BYTE serves as a vital component for collecting user-specific data to personalize dietary recommendations and ensure user anonymity. When users interact with BYTE, they are prompted to input essential information via a simple form. This data, including dietary restrictions, allergies, and food preferences, is then securely stored in Google Cloud Firestore. The use of Firestore ensures real-time data storage and retrieval, providing a dynamic and responsive user experience.

The design of the form prioritizes user privacy and minimal data collection. No unnecessary information, such as the user's name, is requested, maintaining the user's anonymity while still allowing for personalized interactions with the app. Additionally, users have the flexibility to update their information at any time, ensuring that their dietary recommendations remain accurate and relevant to their current needs.

This approach not only enhances the personalization of the service but also aligns with BYTE's commitment to privacy and user-centric design. The technology stack, including Google Cloud Firestore, supports this feature by offering robust, scalable, and secure data management, critical for handling sensitive user information efficiently.

### 4. Document Upload Feature

![doc](https://github.com/A-M-CODING/BYTE/assets/86928073/4fb25fc0-c515-485a-8cda-8cc9f15ede21)

The Document Upload feature in BYTE is a sophisticated component that enhances the app's ability to provide personalized dietary guidance. When users upload documents—such as medical reports or dietary plans—they are temporarily stored in cloud storage. Triggering a Google Cloud Function upon upload, the system captures the user's ID and document details. 

This function, hosted on Google Cloud Run, employs PDFPlumber to extract text, including formatted data like tables, from these documents efficiently. The extracted text is then processed by Cohere’s CoChat endpoint, which generates concise insights focusing on key information relevant to the user's dietary needs. These insights are subsequently chunked using LangChain and securely stored in the Weaviate vector database. Weaviate leverages multi-tenancy to ensure that each user’s data remains isolated in a separate vector space, enhancing privacy and data security.

This architecture supports Retrieval Augmented Generation (RAG), enabling BYTE’s chatbot to pull necessary information from stored insights to generate informed and precise responses to user queries. This functionality is integral to BYTE's mission of providing tailored dietary advice.

### 5. Profile Page

![prof](https://github.com/A-M-CODING/BYTE/assets/86928073/15deacdd-c78f-452c-84e7-1c2722e489ce)

The profile page in BYTE is designed as the central hub of the application, providing a seamless and intuitive navigation experience. From this main page, users can effortlessly access all the app's features with just one tap. Key functionalities available from the profile page include the scan feature for analyzing food labels, the interactive chat feature for dietary inquiries, and the community feature for engaging with other users who share similar dietary restrictions.

Additionally, the profile page includes a top icon that allows users to quickly navigate to the settings page, where they can adjust their preferences and account settings. For added convenience, a sliding panel at the bottom of the profile page displays users' recently favorited items. This panel includes an option to "see all favorites" making it simple for users to revisit their preferred food items and recipes. This thoughtful design makes the profile page not only the gateway to all essential features but also a personalized space where users can manage their dietary preferences efficiently.

### 6. Scan Feature

![scan](https://github.com/A-M-CODING/BYTE/assets/86928073/88704bb4-6587-4ec2-94b4-5164826f0cda)

BYTE's scan feature is a cutting-edge tool designed to support individuals with dietary restrictions by allowing them to quickly and effectively analyze food products on the go. Utilizing the smartphone camera, users can capture images of food labels or products, which are then processed using Gemini 1.5 Pro, a multi-modal AI model hosted on Google Cloud Functions. This model provides a detailed breakdown of the ingredients and nutritional content.

The information from the scanned image is combined with the user's health data and further analyzed by another cloud function utilizing Cohere's Command-R model. This comprehensive analysis takes into account both the visual data from the product and the user's specific health requirements to deliver personalized dietary advice. This advice includes a concise summary, presented in about 10 words at the top of the screen for quick reference, with the option to explore more detailed guidance if needed.

Sources are also provided along with the response so that users can be sure that the response is credible and view the provided sources for further knowledge and clarity. The users can then go on to either continue chatting about the item (or anything else) if they want or fetch alternative food products, or both, or simply go back.

This feature streamlines the dietary management process, making it simpler for users to make informed decisions about the foods they consume while shopping or dining out. The integration of advanced image recognition and personalized health analysis underscores BYTE's commitment to providing tailored dietary support, enhancing both convenience and the overall user experience.

### 7. Get Alternatives Feature

![alt](https://github.com/A-M-CODING/BYTE/assets/86928073/2e02c744-a618-422d-9354-885336ba76d0)

The Get Alternatives feature in BYTE is designed to seamlessly provide users with personalized alternative food product suggestions and relevant video content. This process begins when a Google Cloud Function retrieves image data processed by the Gemini 1.5 Pro model and user health details from Firestore. Using this data, a tailored search query is generated through Cohere's co.chat endpoint using Command-R model with the search query generation parameter set to true, ensuring that only search queries are produced.

Once the search query is generated, it triggers two parallel Google Cloud Functions: one uses Google Custom Search Engine to fetch alternative food product links from Amazon, and the other uses LangChain's YouTube search tool to find pertinent YouTube videos. The Amazon links are parsed to extract detailed information such as product name, image, ratings, and reviews. Concurrently, YouTube v3 data API is utilized to retrieve key video details like thumbnails and titles. The parallel invocation of these two functions ensures faster and more efficient responses.

These results are then displayed on the alternative products page in the form of interactive cards, offering users immediate visual and textual information about each alternative. Users have the option to save favorites by clicking a heart icon on these cards, with saved items being stored in the Firestore database linked to their user ID for easy access on the favorites page and profile favorites panel. This feature is designed to enhance user experience by providing immediate and personalized alternatives without the overhead of unnecessary data storage, aligning with BYTE's focus on efficiency and user-centric design.

### 8. Chat Feature

![chat](https://github.com/A-M-CODING/BYTE/assets/86928073/53ab0798-d32b-45b8-ac49-451d12e0b9fe)

BYTE's chat feature enhances user interaction by leveraging advanced cloud technologies and AI to deliver personalized dietary advice. Here's how it works:
1.	Query Processing: When users input a text query, it is sent to Cohere's Co.Chat endpoint using the Command-R model. This query includes the user's health information from Cloud Firestore, enabling personalized responses. Each response comes with sources for credibility verification.
2.	Image Analysis: If a query includes an image, the process mirrors the Scan feature. The image is analyzed by Gemini 1.5 Pro through a cloud function to understand the contents of the food product. This information, combined with the user's health data, is fed back into Cohere's Co.Chat endpoint to generate a detailed response on whether the product suits the user's dietary needs.
3.	Alternatives and Summaries: For queries involving images, there's an option to "Get Alternatives," providing similar food recommendations. This functions exactly the same as elaborated above.
4.	Multilingual Support: Despite generating responses in English due to model limitations in producing high-quality text in local languages, the chatbot initially accepts queries in multiple languages. Responses are then translated back to the user's language via Google Translate API, ensuring clarity and accessibility.
This chat feature represents a fusion of real-time data interaction, advanced natural language processing, and multilingual support, ensuring that all users, regardless of their dietary restrictions or language, receive accurate and personalized dietary guidance. This tool not only addresses individual dietary needs but also integrates seamlessly into the daily lives of its users, promoting healthier lifestyle choices effectively.

### 9. Community Feature

![comm](https://github.com/A-M-CODING/BYTE/assets/86928073/d84714bc-e361-4252-8a4d-c5e4bf3935b3)
![comm2](https://github.com/A-M-CODING/BYTE/assets/86928073/1d1adfb0-2964-4ec4-86f5-b5c97a0f866d)

The community feature is a dynamic platform within BYTE where users can actively engage through posts, comments, polls, and more. Designed to foster interaction and discussion, this feature enhances the overall user experience by providing a space for sharing information and opinions.
In BYTE, the community feature leverages Firebase Firestore to manage real-time interactions seamlessly. Users can enjoy a variety of interactive options that make staying connected and informed both easy and enjoyable.

**Key Functionalities**

1. **Post Creation and Management**
   - **Administrative Controls:** Only administrators have the ability to create posts, ensuring content quality and relevance.
   - **User Interaction:** Users can engage with posts by liking, commenting, and sharing.
   - **Categories:** Posts can be categorized for streamlined navigation and access.

2. **Comments and Replies**
   - **Engagement:** Users can comment on posts and reply to comments, supporting threaded conversations.
   - **Real-Time Updates:** Comments and replies are updated in real-time, providing a lively interaction experience.

3. **User Experience Enhancements**
   - **Pagination and Lazy Loading:** Efficient data loading improves responsiveness and user experience.
   - **Optimistic UI:** Immediate feedback on user interactions before database synchronization ensures a responsive interface.

**Benefits**

- **Community Engagement:** Encourages active participation and discussion among users, enhancing the social experience.
- **Scalability:** Leveraging Firestore, the feature scales smoothly as the user base grows, handling increased data and interaction without performance loss.
- **Security:** With Firebase's robust security measures, user data and interactions are securely managed, ensuring privacy and data integrity.

This community feature not only enriches the user experience but also fosters a sense of belonging and community within BYTE. It’s an essential part of our app that brings users together in meaningful ways.

### 10. Settings Screen

![settings](https://github.com/A-M-CODING/BYTE/assets/86928073/07e8a253-973d-44d3-b5b5-e90753f79645)

The settings feature in BYTE is designed to empower users with full control over their personal information and preferences, ensuring a tailored and secure experience. This feature facilitates various user-driven actions directly impacting how they interact with the app, enhancing both convenience and functionality.

Key functionalities within the settings include:

- Information Management: Users can update their personal information at any time. Changes are immediately reflected in the database, ensuring that all interactions with the chat and scan features are based on the most current data. This dynamic update system maintains the relevance and personalization of the app’s dietary recommendations.
- Document Upload: Similar to information updates, users can upload additional medical or dietary documents whenever necessary. These uploads are processed and stored securely, with the app using this updated data to enhance the accuracy of health and dietary advice provided.
- Password Management: For security purposes, users have the option to change their passwords, helping maintain the integrity and privacy of their accounts.
- Feedback and Ratings: BYTE encourages user engagement through a feedback system, where users can rate the app and provide insights into their experiences. This feedback is stored in the database and used to refine and improve the app.
- Logout Functionality: Users can securely log out through the settings page, which ensures that their information remains confidential, especially when using shared or public devices.






