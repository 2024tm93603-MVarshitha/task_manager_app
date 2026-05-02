# 📋 Task Manager App

A Flutter-based Task Manager Application using **Firebase** as a Backend-as-a-Service (BaaS). Built as part of the Cross Platform Application Development assignment at **BITS Pilani WILP**.

---

## 📱 App Screenshots

> Register → Login → Add Tasks → Edit → Delete → Logout

---

## 🚀 Project Overview

This app allows users to:
- Register and login securely using **Firebase Authentication**
- Create, Read, Update, and Delete tasks stored in **Cloud Firestore**
- Set **due dates** for tasks with overdue highlighting
- Mark tasks as **completed** with a strikethrough effect
- All data syncs in **real-time** with the Firebase backend

---

## 🛠️ Technology Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter (Dart) |
| Authentication | Firebase Auth |
| Database | Cloud Firestore |
| Backend | Firebase (BaaS) |
| Version Control | GitHub |
| Development | Android Studio + Emulator |

> **Note:** Firebase (Google's BaaS) was used instead of Back4App due to network restrictions in our environment. Firebase provides identical BaaS capabilities — Authentication, real-time cloud database, and scalable backend — fully meeting all assignment requirements.

---

## ✨ Key Features

- ✅ **User Registration & Login** — Email/password auth via Firebase
- ✅ **Create Tasks** — Add title, description and due date
- ✅ **Read Tasks** — Real-time task list with Firestore StreamBuilder
- ✅ **Update Tasks** — Edit any task inline
- ✅ **Delete Tasks** — Delete with confirmation dialog
- ✅ **Mark Complete** — Checkbox with strikethrough effect
- ✅ **Due Date** — Calendar picker, overdue dates shown in red
- ✅ **Secure Logout** — Invalidates session completely
- ✅ **Real-Time Sync** — All changes reflect instantly via Firestore

---

## 📁 Project Structure

```
lib/
├── main.dart                  # App entry point + Firebase init
├── firebase_options.dart      # Firebase configuration
├── screens/
│   ├── login_screen.dart      # Login UI
│   ├── register_screen.dart   # Registration UI
│   └── task_list_screen.dart  # Task CRUD UI
└── services/
    └── firebase_service.dart  # Firebase Auth + Firestore operations
```

---

## 🔥 Firebase Structure

```
Firestore Database:
users/
  └── {userUID}/
        └── tasks/
              └── {taskID}
                    ├── title: string
                    ├── description: string
                    ├── dueDate: timestamp
                    ├── isCompleted: boolean
                    └── createdAt: timestamp
```

---

## ⚙️ Setup Instructions

### Prerequisites
- Flutter SDK installed
- Android Studio with emulator
- Firebase project created at [console.firebase.google.com](https://console.firebase.google.com)

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/2024tm93603-MVarshitha/task_manager_app.git
   cd task_manager_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project
   - Enable Email/Password Authentication
   - Create a Firestore database
   - Download `google-services.json` and place in `android/app/`
   - Update `firebase_options.dart` with your project config

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.1.0
  firebase_auth: ^5.1.0
  cloud_firestore: ^5.1.0
  cupertino_icons: ^1.0.8
```

---

## 🎥 Demo Video

https://youtu.be/IBX3NNwu-tA(#) ← *(Add your YouTube link here)*

---

## 📊 Assignment Deliverables

| Deliverable | Status |
|-------------|--------|
| Flutter App with CRUD | ✅ Done |
| Firebase BaaS Integration | ✅ Done |
| User Authentication | ✅ Done |
| Real-Time Database Sync | ✅ Done |
| GitHub Repository | ✅ Done |
| YouTube Demo Video | ✅ Done |
| PPT Presentation | ✅ Done |

---

## 👩‍💻 Developer

**M. Varshitha**  
Roll No: 2024TM93603  
BITS Pilani WILP — Cross Platform Application Development  
Semester 3
