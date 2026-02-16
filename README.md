# Expense Tracker Mini-App

A clean, Flutter application built for the **Softnet Limited Developer Assessment**.  
The project demonstrates strong architectural structure, efficient state management, and native mobile UX best practices.

---

## 🚀 Overview

The Expense Tracker enables users to:

- View a structured list of transactions
- Filter by category
- Search by merchant name
- View transaction details
- Add new transactions via a mobile-optimized form

The application prioritizes performance, scalability, and clean separation of concerns.

---

### Key Features
-   **Transaction Dashboard:** View a comprehensive list of expenses with merchant details and status.
-   **Intelligent Filtering:** Instantly filter by category (Groceries, Dining, etc.) and search by merchant name.
-   **Seamless Navigation:** Smooth transitions between list and detail views using a declarative router.
-   **Native Data Entry:** A form optimized for mobile with numeric keypads, category pickers, and date validation.
---

### 🛠 Tech Stack & Architecture

-   **Language:** Dart
-   **Framework:** [Flutter](https://flutter.dev/)
-   **State Management:** [Bloc](https://pub.dev/packages/flutter_bloc)
-   **Navigation:** [GoRouter](https://pub.dev/packages/go_router)
-   **Dependency Injection:** [GetIt](https://pub.dev/packages/get_it)
---

## 📂 Architecture
modular structure:
```
assets/                 # for app assets. contains the mock data
lib/
├── core/
|   ├──data_state       # define wrapper for data and errors
│   ├── di/             # Service locator (GetIt) setup
│   ├── router/         # GoRouter configuration
│   └── util/          # utility functions and extentions
|   ├── domain/     # Entities & Repository interfaces
|   ├── data/       # data sources & Repository implementation
|   ├── presentation/
|   │   ├── bloc/ # State management logic
|   │   ├── pages/   # UI Screens (List, Detail, Add)
|   │   └── widgets/   # Reusable UI components
└── main.dart           # Application entry point
```

This structure ensures:

- Clear separation of concerns  
- Easy scalability  
- Maintainable code organizationz

> **NOTE:** This will be changed to a feature based structure on a more robust app.

---

## 🎯 Engineering Highlights

- Native numeric keyboard using `KeyboardType.number`
- Category & date selection via `ModalBottomSheet | Dropdown` and `showDatePicker`
- Form validation with controlled state updates
- Efficient rendering using `ListView.builder`

---

## 📝 Mock Data
The app comes pre-loaded with ~20 transactions covering various categories: Groceries, Transportation, Dining, Entertainment, Healthcare, Shopping, and Utilities.

## 📋 Prerequisites

-   Flutter SDK: `^3.11.0`
-   A mobile emulator (iOS/Android) or a physical device.

## ⚙️ Installation & Setup

### 0. Install Flutter SDK

Before proceeding, ensure you have the Flutter SDK installed:  
- **Official Guide:** [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)  
- **Windows Tutorial:** ▶️ [YouTube Tutorial](https://www.youtube.com/watch?v=iPToBKhSDlA)  
- **macOS Tutorial:** ▶️ [YouTube Tutorial](https://www.youtube.com/watch?v=QG9bw4rWqrg)


### 1. Clone the Repository

#### SSH

```bash
git clone git@github.com:Danto1606/expense_tracker.git
```

#### HTTPS

```bash
git clone https://github.com/Danto1606/expense_tracker.git
```
### 2. Navigate to the Project
```bash
cd expense_tracker
```
### 3. Install Dependencies
```bash
flutter pub get
```
### 4. Run the Application
```bash
flutter run
```
### 5. Optional: Build Release Version

#### Android
```bash
flutter build apk --release
```
#### IOS
```bash
flutter build ios --release
```
---
## 📎 Repository
### [GitHub](https://github.com/Danto1606/expense_tracker)
---

## ✅ Summary
This project demonstrates:
- Clean, modular Flutter architecture
- Scalable state management with Bloc
- Production-conscious UX decisions
- Performance-optimized UI rendering