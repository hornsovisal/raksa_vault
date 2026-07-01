# Raksa Vault (រក្សា Vault): Secure Mobile Vault for Sensitive Data

**Raksa Vault** is a Blue Team defensive mobile security application built with **Flutter**. The application focuses on protecting sensitive personal information through secure authentication and local storage. Users can unlock the app using email/password authentication, PIN, and biometric authentication. After successful authentication, users can safely store and manage sensitive text-based data such as passwords, bank account numbers, credit/debit card details, recovery codes, private notes, Wi-Fi passwords, software license keys, emergency contacts, and identity document details.

The application is designed as an educational mobile development project that demonstrates important Flutter concepts such as state management, navigation, forms, local database storage, authentication flow, and secure handling of sensitive user data.

## ✨ Key Features

* **Secure Authentication:** Users can log in using email/password and unlock the vault using a PIN or biometric authentication such as fingerprint or face unlock.
* **SQLite Local Storage:** Sensitive vault items are stored locally on the device using SQLite.
* **Sensitive Data Management:** Users can create, view, update, delete, and search sensitive records.
* **Category-Based Vault:** Stored data is organized into categories such as passwords, bank accounts, credit cards, recovery codes, private notes, Wi-Fi passwords, software licenses, emergency contacts, and identity document numbers.
* **Secure PIN Storage:** The user’s PIN is stored securely using `flutter_secure_storage`.
* **Layered Architecture:** The project follows a clean `models / data / ui` structure for better organization and maintainability.

## 🔐 Data Stored in the Vault

Raksa Vault focuses only on **text-based sensitive data**. It does not store document images or files.

Examples of stored data include:

* Passwords
* Bank account numbers
* Credit/debit card information
* Recovery codes
* Private notes
* Wi-Fi passwords
* Software license keys
* Emergency contacts
* Identity document details, such as ID number or passport number only

## ⚙️ Project Setup

### Prerequisites

* Flutter SDK and Dart SDK
* Android Studio or VS Code
* Android emulator or physical Android device
* SQLite package for local database storage
* `flutter_secure_storage` for storing sensitive authentication values
* `local_auth` for biometric authentication

### Installation

1. Clone the repository:

```bash
git clone https://github.com/hornsovisal/raksa_vault.git
cd raksa_vault
```

2. Install dependencies:

```bash
flutter pub get
```

3. Verify the setup:

```bash
flutter doctor
```

4. Run the app:

```bash
flutter run
```

## 🧩 Basic Usage

Once launched, the app opens on the **Authentication screen**. After the user logs in or unlocks the app, they are redirected to the main vault screen.

### 🔐 1. Login / Unlock

The user authenticates using email/password, PIN, or biometric authentication. This protects the vault from unauthorized access.

### 🗄️ 2. Vault Dashboard

The user can view all stored sensitive items. Each item displays its title, category, and last updated date.

### ➕ 3. Add / Edit Item

The user can create or update a sensitive record by entering a title, category, and secret content.

### 🔎 4. Search and Filter

The user can search for stored records and filter them by category.

### ⚙️ 5. Settings

The user can change PIN settings and enable or disable biometric authentication.

## 🧱 Project Structure

| Directory / File         | Purpose                      | Key Files / Notes                                       |
| ------------------------ | ---------------------------- | ------------------------------------------------------- |
| `lib/models/`            | Data models                  | `user.dart`, `vault_item.dart`, `app_settings.dart`     |
| `lib/data/database/`     | SQLite database              | database helper, vault item table                       |
| `lib/data/repositories/` | Data access logic            | `auth_repository.dart`, `vault_repository.dart`         |
| `lib/data/services/`     | Security and device services | PIN storage, biometric service                          |
| `lib/ui/screens/`        | App screens                  | login, unlock, vault dashboard, add/edit item, settings |
| `lib/ui/widgets/`        | Reusable widgets             | `vault_tile.dart`, `pin_pad.dart`, `category_chip.dart` |
| `lib/main.dart`          | App entry point              | starts the app                                          |
| `pubspec.yaml`           | Dependencies                 | Flutter packages                                        |

## 🗃️ SQLite Database Design

The application uses SQLite to store vault items locally on the device.

### Table: `vault_items`

| Field          | Type                | Description                                  |
| -------------- | ------------------- | -------------------------------------------- |
| `id`           | INTEGER PRIMARY KEY | Unique ID of the vault item                  |
| `title`        | TEXT                | Name of the stored item                      |
| `category`     | TEXT                | Type of sensitive data                       |
| `secret_value` | TEXT                | Sensitive content                            |
| `description`  | TEXT                | Optional note or description                 |
| `created_at`   | TEXT                | Date and time when the item was created      |
| `updated_at`   | TEXT                | Date and time when the item was last updated |

### Example Categories

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

## 🔒 Security Note

Raksa Vault is designed to store sensitive text-based data locally. The user’s PIN should not be stored as plain text. It should be stored securely using `flutter_secure_storage`, preferably as a hashed value. Sensitive vault data should also be protected carefully, and the app should require authentication before showing any stored records.

## 🤝 Contribution

**Prepared By:** Horn Sovisal; Kue ChanChessika

**Course:** Mobile Development in Cybersecurity

**Course Info:** This course covers building mobile applications with Flutter, focusing on authentication, local storage, UI navigation, data flow, and secure handling of sensitive information.

**Lecturer:** Mr. Ronan Ogor

**Department:** Telecom and Networking, Cyber Security, Cambodia Academy of Digital Technology (CADT)

## 📝 License

This project is open source and available under the MIT License.
