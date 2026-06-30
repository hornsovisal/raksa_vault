# Raksa Vault (រក្សា Vault): Secure Mobile Vault & Intrusion Detection

**Raksa Vault** is a Blue Team defensive mobile security application built with **Flutter**. It protects a user's sensitive data — passwords, private notes, and documents — behind login, PIN, and biometric authentication. Beyond simply locking data away, it actively *detects* intrusions: after repeated failed unlock attempts, it silently captures an intruder photo, records the time and location, and preserves the evidence both on the device and in the cloud. The app is designed as an educational project demonstrating core mobile development concepts (state, navigation, local storage, REST/Firebase, and device features) through a real cybersecurity use case.

## ✨ Key Features

- **Secure Authentication:** Email/password login, a 4-digit PIN, and biometric (fingerprint / face).
- **Encrypted Vault:** Stores notes, passwords, and files locally in an encrypted SQLite database (`drift`). Sensitive tokens and the PIN are kept in `flutter_secure_storage`.
- **Intrusion Detection:** After a configurable number of failed unlock attempts, the front camera silently captures an "intruder selfie."
- **Forensic Logging:** Each unauthorized attempt is recorded with a photo, timestamp, and GPS location in a tamper-evident Break-In Log.
- **Offline-First with Cloud Sync:** Works fully offline; when connected, data backs up to **Firebase** so evidence survives even if the device is wiped.
- **Layered Architecture:** Built with a clean `models / data / ui` separation for easy testing and future expansion.

## ⚙️ Project Setup

### Prerequisites

- **Flutter SDK** (3.x or higher recommended) and the **Dart SDK**
- **Android Studio** (for the Android emulator) and/or **VS Code** with the Flutter & Dart extensions
- An Android device or emulator (camera, GPS, and biometric features are best tested on a real device)
- A **Firebase project** (required for cloud sync and authentication)

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/hornsovisal/raksa_vault.git
   cd raksa_vault
   ```

2. **Install dependencies:** All required packages are listed in `pubspec.yaml`.

   ```bash
   flutter pub get
   ```

3. **Configure Firebase:** Connect the app to your own Firebase project using the FlutterFire CLI (follow the current official FlutterFire docs for exact steps):

   ```bash
   flutterfire configure
   ```

   > This generates `lib/firebase_options.dart` and platform config files. These contain your project keys — they are listed in `.gitignore` and must **never** be committed.

4. **Verify the setup:**

   ```bash
   flutter doctor
   ```

5. **Run the app:**

   ```bash
   flutter run
   ```

## 🧩 Basic Usage

Once launched, the app opens on the **Unlock screen**. After authenticating, you reach the main vault with bottom navigation:

### 🔐 1. Login / Unlock
Sign in with email and password, or unlock an existing session with your PIN or biometrics. Repeated wrong PIN entries silently trigger intrusion capture.

### 🗄️ 2. Vault Dashboard
Browse, search, and manage your stored items (passwords, notes, documents). Each item shows its category, last update, and sync status.

### ➕ 3. Add / Edit Item
A form to create or update a vault entry — title, category, secret content, and an optional "sync to cloud" toggle.

### 🚨 4. Break-In Log
Review every unauthorized access attempt, each with the captured intruder photo, date/time, GPS coordinates, and number of failed attempts.

### ⚙️ 5. Settings
Configure the failed-attempt threshold and toggle camera and GPS capture on or off.

## 🧱 Project Structure

The project follows a layered architecture that separates data, models, and UI.

| Directory / File | Purpose | Key Files / Notes |
| --- | --- | --- |
| 📁 `lib/models/` | **Data models** — plain Dart classes | `user.dart`, `vault_item.dart`, `intruder_log.dart`, `app_settings.dart` |
| 📁 `lib/data/repositories/` | **Repositories** — coordinate data sources | `auth_repository.dart`, `local_vault_repository.dart`, `cloud_sync_repository.dart` |
| 📁 `lib/data/services/` | **Services** — device & backend access | database, Firebase, biometric, camera, location services |
| 📁 `lib/ui/screens/` | **Screens** — full pages | login, vault, add item, break-in log, settings |
| 📁 `lib/ui/widget/` | **Reusable widgets** | `vault_tile.dart`, `intruder_card.dart`, `pin_pad.dart` |
| 📄 `lib/main.dart` | **Entry point** — app bootstrap & routing | starts the app |
| 📄 `pubspec.yaml` | **Dependencies** | list of all Flutter/Dart packages |

## 🤝 Contribution

**Prepared By:** Horn Sovisal; Kue ChanChessika
**Course:** Mobile Development in Cybersecurity

**Course Info:** This course covers building mobile applications with Flutter, focusing on how data flows through an app — UI, network, local storage, and device features — and where security issues can arise.

**Lecturer:** Mr. Ronan. Ogor

**Department:** Telecom and Networking, Cyber Security, Cambodia Academy of Digital Technology (CADT)

## 📝 License

This project is open source and available under the [MIT License](LICENSE).
