
# Smarn Mobile App

## Overview
Smarn is a Flutter-based mobile application designed for scholars. The app features three user roles: **Admin**, **Teacher**, and **Student**, each with specific functionalities. It integrates with Firebase Firestore and Firebase Functions to manage data and backend logic efficiently.

## Features
### Admin Features
- Manage teachers, classes, subjects, activities, space,  constarints.
- Create and manage timetables manually.
- Generate timetables automatically based on activities and constraints.
- Oversee all activities and ensure compliance with defined constraints.

### Teacher Features
- View assigned subjects and timetables.
- Access detailed activity schedules.
- Submit complaints and add requests.


### Student Features
- View class timetables and schedules.
- Stay updated on activities and class information.

## Tech Stack
- **Frontend**: Flutter
- **Database**: Firestore
- **Backend Functions**: Firebase Functions

## Installation
### Prerequisites
- Flutter SDK installed.
- Node.js installed for Firebase Functions.

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/MAY55A/SMARN-FET.git
   cd SMARN-FET
   ```

2. Install dependencies for the mobile app:
   ```bash
   flutter pub get
   ```

3. Navigate to the `functions` directory and install dependencies for Firebase Functions:
   ```bash
   cd functions
   npm install
   ```

4. Serve Firebase Functions locally (optional):
   ```bash
   npm run serve
   ```

5. Run the app:
   ```bash
   flutter run
   ```

## Firebase Setup
1. Set up a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
2. Add an Android/iOS app to the Firebase project.
3. Download the `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) file and place it in the respective directories of the Flutter project.
4. Enable Firestore and set up necessary collections for users, activities, timetables, etc.
5. Deploy Firebase Functions if required for production:
   ```bash
   firebase deploy --only functions
   ```

## Folder Structure
```
smarn/
├── lib/
│   ├── main.dart  # Entry point of the app
│   ├── models/    # Data models like Activity, Teacher, etc.
│   ├── pages/   # Screens for Admin, Teacher, and Student views
│   └── services/  # Firebase interaction and business logic
├── functions/        # Firebase Functions
├── pubspec.yaml      # Flutter dependencies
└── README.md         # Project documentation
```

## Running the Project Locally
1. Ensure the Firebase CLI is installed and authenticated:
   ```bash
   firebase login
   ```
2. Start Firebase Functions in a local emulator:
   ```bash
   cd functions
   npm run serve
   ```
3. Run the Flutter app on an emulator or a connected device:
   ```bash
   flutter run
   ```

## Notes
- Ensure the Firestore rules are appropriately set up to secure the data.
- Update the Firebase configuration in `main.dart` if necessary.

## Future Enhancements
- Add notifications for schedule updates.
- Implement a more detailed constraint management system for timetable generation.
- Introduce offline support for timetable access.

---
Developed with Flutter and Firebase for seamless scholar management.

