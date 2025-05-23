# Next Stop 🌍

**NextStop** app allows users to **search**, **filter**, and **book** their favorite vacation destinations. 🏖️  
All hotel data is fetched dynamically through **RapidAPI**.  
> 🚧 *The app is still under development.*

---

##  Requirements 🛠

- [Xcode](https://developer.apple.com/xcode/) (latest version recommended)  
- macOS
- iOS 18

---

## Tech Stack 💻

| Layer       | Technology |
|-------------|------------|
| **UI**      | SwiftUI    |
| **Logic**   | Swift      |
| **Build**   | Xcode      |
| **Backend** | InteliJ    |

## Architecture & Tools 🧠

- **MVVM Pattern** for clear separation of UI and business logic  
-  **Unit Testing** of business logic
-  **Firebase** for backend services like authentication and data storage  
-  **RapidAPI** for accessing hotel and destination data  

---

## Backend Integration 🌐
As part of the app’s development, I also built a custom RESTful API using Java, Spring Boot, and JPA to simulate and test hotel data flows. This helped me better understand how to:
- Design and expose clean and consistent endpoints
- Use **JPA** for relational data modeling
- Handle common backend concerns like error handling, status codes, and entity validation
- Test services and controllers using **JUnit**
 The API was developed using **IntelliJ IDEA** and tested with **Postman**
---
## Lessons Learned & Challenges 📚

During the development of the NextStop app, I encountered several challenges and learned a lot through them:

- **Firebase Auth & Google Sign-In** – Implementing authentication with Firebase and Google accounts was a learning experience. Securing user sessions was crucial for the app’s integrity.
- **Dealing with inconsistent API responses** from RapidAPI – Data often didn't come in the expected format, requiring robust error handling and fallback mechanisms.
- **MVVM architecture** – Applying the MVVM pattern helped me separate the UI from the business logic, making the code more maintainable and testable.
-  **Unit Testing of Business Logic** – Writing unit tests for core features like filtering, booking flow, and user input validation helped me ensure the app runs smoothly.
-  **Working with Maps and Geolocation** – Syncing location input with UI updates and displaying data on maps using SwiftUI was challenging but rewarding.
-  **Managing State and Data Flow** – Learning how to effectively use `@StateObject`, `@Binding`, and `@EnvironmentObject` to manage app state and pass data between views was key to the app's functionality.

---

## Preview 📸

### Home & Search 🏠

<img src="https://github.com/user-attachments/assets/bef28ae3-e761-4c59-9ed2-bf3d133ef055" width="250"/>
<img src="https://github.com/user-attachments/assets/34e74fbf-fa95-4fd4-a02f-501a4505fa47" width="250"/>
<img src="https://github.com/user-attachments/assets/ec78b212-0c45-4671-b7a9-b1cce05d709e" width="250"/>
<img src="https://github.com/user-attachments/assets/a11207a6-af16-4391-836d-9cb120e06359" width="250"/>
<img src="https://github.com/user-attachments/assets/277338e8-5c5a-4545-add9-0dc1146db58f" width="250"/>

###  Listing Details 🏨

<img src="https://github.com/user-attachments/assets/abb1c79e-5f29-43d0-b572-2cf153ac254d" width="250"/>
<img src="https://github.com/user-attachments/assets/143736b2-f10d-4197-b03e-9162159c1c49" width="250"/>
<img src="https://github.com/user-attachments/assets/683f2f89-e8bd-459a-a487-1a0cc9d2ef24" width="250"/>
<img src="https://github.com/user-attachments/assets/dc040df1-a63e-4855-9c3f-413d6d0e5961" width="250"/>
<img src="https://github.com/user-attachments/assets/9281cf39-eaf8-4fe7-8ebe-dd9990ec4b28" width="250"/>

###  Map & Calendar 🗺

<img src="https://github.com/user-attachments/assets/b112889c-3294-455c-8cc1-5051b999032c" width="250"/>
<img src="https://github.com/user-attachments/assets/5abf6882-f8c3-4774-9de7-d23635ff1e25" width="250"/>
<img src="https://github.com/user-attachments/assets/c195768a-b322-4c1e-a770-4358e1920cd9" width="250"/>

### Authentication 🧑‍💼

<img src="https://github.com/user-attachments/assets/997458c8-c2bd-4d62-be48-5def449e64dc" width="250"/>
<img src="https://github.com/user-attachments/assets/b3777bfc-a0b7-4826-b855-c2f8c626c919" width="250"/>
<img src="https://github.com/user-attachments/assets/65fa954b-9c03-43b4-af7b-77150bf57c55" width="250"/>
<img src="https://github.com/user-attachments/assets/79eabf96-24ef-46fe-a0ff-48f3ecd40a08" width="250"/>

### Profile Editing ✏️

<img src="https://github.com/user-attachments/assets/339c5536-75a8-4603-bb67-67fb75aeb94f" width="250"/>
<img src="https://github.com/user-attachments/assets/96e4c77e-44be-4d53-b23f-c5a76a32fdd8" width="250"/>
<img src="https://github.com/user-attachments/assets/805c903e-4b78-46b3-a903-02227d4bea74" width="250"/>
<img src="https://github.com/user-attachments/assets/bc416665-95f4-4e64-8b24-afb8ed45a40c" width="250"/>
<img src="https://github.com/user-attachments/assets/1d470d24-35dd-406d-93cf-4e9ca47c9f95" width="250"/>
<img src="https://github.com/user-attachments/assets/2acadfa9-20ce-4c7e-8448-18927180c509" width="250"/>
<img src="https://github.com/user-attachments/assets/8af06dc1-ea05-44e4-ba90-da435b4c71cd" width="250"/>

### Wishlist ❤️

<img src="https://github.com/user-attachments/assets/d3659b1d-cc26-48b2-a349-93146815ac99" width="250"/>

---

## Unit Testing ✅

<img src="https://github.com/user-attachments/assets/80358844-c0e1-48f4-82cb-b57013a332a0" width="100%"/>




