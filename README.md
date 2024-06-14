## Farmlog
As part of my college project, I've developed an enhanced version of Farmlog, an application built with Flutter and Firebase, aimed at empowering the agriculture community.
Farmlog version 2 is designed to be an indispensable tool for farmers, event organizers, and agriculture enthusiasts, enhancing their ability to share knowledge, stay informed, and connect with the community.

## Tech stack
1. Flutter
2. Firebase

## Screenshots
![enter image description here](https://media.licdn.com/dms/image/D4D22AQFs4nOrHCIPdQ/feedshare-shrink_2048_1536/0/1718353500631?e=1721260800&v=beta&t=dKV7PJqBjn0u8K1THsx4N4mBZcsc5NEvxgLf7wWb4uU)

![enter image description here](https://media.licdn.com/dms/image/D4D22AQGbTNUARoFbAQ/feedshare-shrink_2048_1536/0/1718353498021?e=1721260800&v=beta&t=acvzmJLrItBOlBQhHF_Sw96vLWIcxf9Y8xrkupbQjKs)

## Installation
**[CLICK HERE TO DOWNLOAD APK](https://drive.google.com/file/d/1E5Nm4UsAglsHv8zzTC_ektdWgWw_-8NA/view?usp=sharing)**


## Features
-   **Blog Management**: Users can create, read, update, and delete blogs to share knowledge and experiences.
-   **Commenting**: Users can comment on blogs, with authors having the exclusive ability to reply.
-   **Blog Sharing**: Share insightful blogs with others to spread valuable information.
-   **Feedback**: Users can send feedback to the developer to improve the application continuously.
-   **Account Management**: Create accounts and login for a personalized experience.
-   **Chatbot Support**: Get answers related to the agriculture field with the integrated chatbot.
-   **Comment Control**: Authors can enable or disable the comment section on their blogs.
-   **AI Content Filtering**: Ensures that only agriculture-related content is published, maintaining relevance and quality.
-    **Multilingual Support**: Now available in Hindi, Marathi, and English to cater to a broader audience.
-   **Event Management**: Users with event organizer roles can create, update, read, and delete events, making it easier to manage agricultural events.
-   **Community Tab**: A dedicated space for users to ask and answer questions, fostering community engagement.
-   **Search Functionality**: Easily search for blogs, questions, and events with the new search button.





## How to setup



1. Clone this repo.
2. Set up firebase and add following two services 
2.1.Firebase storage
2.2.Firestore(create following empty collections : 
    - [ ] Blog
   - [ ] Answer
   - [ ] Comment
   - [ ] Event
   - [ ] Feedback
   - [ ] Question
   - [ ] Users)
3. Add openai api key to lib/chatbot/chatbotapi.dart and Done 👍.
