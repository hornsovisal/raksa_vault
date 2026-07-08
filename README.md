# Raksa Vault (រក្សា Vault) — Secure Mobile Vault

**Raksa Vault** is a Blue Team defensive mobile security application built with **Flutter**. The application is designed to protect users’ sensitive text-based information using secure authentication and local storage.

The app uses **Firebase Authentication** for first-time account registration and login. After logging in, users can unlock the vault using **biometric authentication** such as fingerprint or face recognition. If biometric authentication is unavailable or fails, the app provides a **4-digit PIN fallback**. Sensitive records are stored locally on the device using **SQLite/Drift**.

Raksa Vault is developed as an educational cybersecurity mobile project that demonstrates Flutter concepts such as stateful widgets, navigation, forms, authentication flow, local database storage, repository architecture, and secure handling of sensitive data.

---

## Project Direction

**Blue Team — Defensive Application**

Raksa Vault focuses on protecting sensitive user data locally on a mobile device. It is not an offensive security tool.

---

## Key Features

- **Firebase Register/Login**  
  Users can create an account and log in using email and password through Firebase Authentication.

- **Biometric Unlock**  
  Users can unlock the vault using fingerprint or face authentication, depending on the device.

- **PIN Fallback**  
  If biometric authentication is unavailable or fails, users can unlock the vault using a 4-digit PIN.

- **SQLite/Drift Local Storage**  
  Sensitive vault records are stored locally on the device using SQLite/Drift.

- **Sensitive Data Management**  
  Users can add, view, edit, delete, and search vault records.

- **Category-Based Vault**  
  Records are organized into categories such as passwords, bank accounts, credit cards, recovery codes, private notes, Wi-Fi passwords, software licenses, emergency contacts, and identity document numbers.

- **Secure PIN Storage**  
  The user’s PIN is stored securely using `flutter_secure_storage`, preferably as a hashed value.

- **Layered Architecture**  
  The project follows the course architecture using `models/`, `data/`, `repositories/`, `services/`, `ui/screens/`, and `ui/widgets/`.

---

## Data Stored in the Vault

Raksa Vault stores only **text-based sensitive data**. It does not store document images or uploaded files.

Examples of stored data include:

- Passwords
- Bank account numbers
- Credit/debit card information
- Recovery codes
- Private notes
- Wi-Fi passwords
- Software license keys
- Emergency contacts
- Identity document numbers

---

## Main Technologies

| Technology | Purpose |
|---|---|
| Flutter | Mobile application framework |
| Firebase Authentication | Email/password register and login |
| SQLite/Drift | Local database for vault records |
| `local_auth` | Biometric authentication |
| `flutter_secure_storage` | Secure PIN storage |
| Stateful Widgets | State management |
| Repository Pattern | Clean data access layer |

---

## Project Scope

### Included in Main Implementation

- Firebase email/password register and login
- Biometric unlock using fingerprint or face authentication
- PIN fallback unlock
- Local SQLite/Drift database
- Add, view, edit, delete vault records
- Search and category filter
- Settings screen
- Theme color system
- Layered Flutter architecture

### Not Included in Main Implementation

The following features are not included to keep the project realistic and focused:

- GPS location
- Camera
- Intruder selfie
- Document upload
- Firebase cloud database sync
- Corporate SSO
- Multi-device cloud backup

These features may be considered as future improvements.

---

## App Screens

### 1. Welcome Screen

Introduces Raksa Vault and allows users to go to login or account creation.

### 2. Register Screen

Allows first-time users to create an account using Firebase Authentication.

### 3. Login Screen

Allows existing users to log in using email and password.

### 4. Unlock Screen

Allows users to unlock the vault using biometric authentication or PIN fallback.

### 5. Vault Dashboard Screen

Displays saved vault records, total records, category count, and recent records.

### 6. Category Screen

Displays vault records grouped by category.

### 7. Add/Edit Record Screen

Provides a form to create or update a sensitive vault record.

### 8. Settings Screen

Allows users to manage biometric/PIN settings and logout.

---

## Basic User Flow

```txt
Open App
   ↓
Welcome Screen
   ↓
Register or Login with Firebase
   ↓
Create PIN for fallback unlock
   ↓
Unlock using Biometric or PIN
   ↓
Vault Dashboard
   ↓
Add / View / Edit / Delete / Search Records
   ↓
Data saved locally using SQLite/Drift
   ↓
Lock or Logout
````

---

## Project Structure

```txt
lib/
│
├── models/
│   ├── app_user.dart
│   ├── vault_item.dart
│   └── app_settings.dart
│
├── data/
│   ├── database/
│   │   ├── app_database.dart
│   │   └── app_database.g.dart
│   │
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── vault_repository.dart
│   │   └── settings_repository.dart
│   │
│   └── services/
│       ├── firebase_auth_service.dart
│       ├── biometric_service.dart
│       ├── pin_service.dart
│       └── secure_storage_service.dart
│
├── ui/
│   ├── screens/
│   │   ├── welcome_screen.dart
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── unlock_screen.dart
│   │   ├── vault_dashboard_screen.dart
│   │   ├── category_screen.dart
│   │   ├── add_edit_record_screen.dart
│   │   └── settings_screen.dart
│   │
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   ├── vault_tile.dart
│   │   ├── category_card.dart
│   │   └── pin_pad.dart
│   │
│   └── theme/
│       └── app_theme.dart
│
├── firebase_options.dart
└── main.dart
```

---

## Model Classes

The project includes at least three model classes, as required by the course.

### 1. `AppUser`

Represents the authenticated user.

```txt
uid
email
createdAt
```

### 2. `VaultItem`

Represents a sensitive record stored in the vault.

```txt
id
userId
title
category
secretValue
description
isFavorite
createdAt
updatedAt
```

### 3. `AppSettings`

Represents app security settings.

```txt
id
userId
biometricEnabled
pinEnabled
themeMode
```

---

## SQLite/Drift Database Design

The application uses SQLite/Drift for local data storage.

### Table: `vault_items`

| Field          | Type                | Description                |
| -------------- | ------------------- | -------------------------- |
| `id`           | INTEGER PRIMARY KEY | Unique record ID           |
| `user_id`      | TEXT                | Firebase user UID          |
| `title`        | TEXT                | Record title               |
| `category`     | TEXT                | Type of sensitive data     |
| `secret_value` | TEXT                | Sensitive information      |
| `description`  | TEXT                | Optional note              |
| `is_favorite`  | BOOLEAN             | Marks important records    |
| `created_at`   | DATETIME            | Date and time created      |
| `updated_at`   | DATETIME            | Last updated date and time |

### Table: `app_settings`

| Field               | Type                | Description              |
| ------------------- | ------------------- | ------------------------ |
| `id`                | INTEGER PRIMARY KEY | Unique settings ID       |
| `user_id`           | TEXT                | Firebase user UID        |
| `biometric_enabled` | BOOLEAN             | Enables biometric unlock |
| `pin_enabled`       | BOOLEAN             | Enables PIN fallback     |
| `theme_mode`        | TEXT                | App theme setting        |

---

## Example Categories

```txt
password
bank_account
credit_card
recovery_code
private_note
wifi_password
software_license
emergency_contact
identity_document
```

---

## Security Notes

Raksa Vault is designed to reduce the risk of unauthorized access to sensitive information.

Important security principles:

* The app does **not** store Firebase passwords locally.
* Firebase handles email/password authentication.
* The app does **not** store fingerprint or face data.
* Biometric verification is handled by the mobile operating system.
* The PIN is stored securely using `flutter_secure_storage`.
* Vault data is stored locally using SQLite/Drift.
* The app requires authentication before showing stored records.

---

## Project Setup

### Prerequisites

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Android emulator or physical Android device
* Firebase project
* Firebase CLI / FlutterFire CLI

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/hornsovisal/raksa_vault.git
cd raksa_vault
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

Create a Firebase project and enable **Email/Password Authentication**.

Then run:

```bash
flutterfire configure
```

This generates:

```txt
lib/firebase_options.dart
```

### 4. Generate Drift database files

```bash
dart run build_runner build
```

If needed:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. Verify Flutter setup

```bash
flutter doctor
```

### 6. Run the app

```bash
flutter run
```

---

## Required Packages

Main packages used in this project:

```yaml
firebase_core
firebase_auth
local_auth
flutter_secure_storage
drift
sqlite3_flutter_libs
path_provider
path
```

Development packages:

```yaml
drift_dev
build_runner
flutter_lints
```

---

## Git Workflow

Each member works on their own branch.

```txt
sovisal
chessika
```

Before working:

```bash
git pull
```

After finishing work:

```bash
git add .
git commit -m "Describe your update"
git push
```

---

## Future Improvements

The following features may be added in future versions:

* Firebase cloud backup and synchronization
* Email verification
* Password reset
* Stronger local encryption for vault records
* Camera-based security image
* GPS-based access log
* Multi-device recovery

---

## Contributors

**Prepared By:**

* Horn Sovisal
* Kue ChanChessika

**Course:** Mobile Development in Cybersecurity
**Lecturer:** Mr. Ronan Ogor
**Department:** Telecom and Networking, Cyber Security
**Institution:** Cambodia Academy of Digital Technology (CADT)

---

## License

This project is open source and available under the MIT License.

```
