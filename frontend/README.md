# WorkNomads Frontend

A Flutter mobile application built with modern architecture patterns, featuring authentication, data management, and reactive state management using the BLoC pattern.

## Project Overview

WorkNomads Frontend is a cross-platform mobile application developed with Flutter 3.35.2. The app implements **Clean Architecture** principles with a layered approach, comprehensive state management, authentication flows, and data persistence capabilities.

### Key Features

- **Authentication System** - JWT-based login/logout with automatic token refresh
- **Responsive UI** - Cross-platform mobile interface with pull-to-refresh functionality
- **Data Persistence** - Local storage with SharedPreferences integration
- **HTTP Client** - Dio-based networking with automatic authentication handling
- **State Management** - BLoC pattern with reactive programming
- **Navigation** - Declarative routing with authentication-based access control
- **Monitoring** - Comprehensive logging and debugging capabilities

## Architecture

The application follows **Clean Architecture** principles with a **layered architecture** pattern, ensuring clear separation of concerns and maintainable code structure:

### Architecture Layers

```
┌─────────────────────┐
│   Feature Layer     │  ← Business Logic & UI
├─────────────────────┤
│ Infrastructure Layer│  ← Auth, Routing, Cross-cutting
├─────────────────────┤
│    Core Layer       │  ← Storage, HTTP, Foundation
└─────────────────────┘
```

### Core Components

- **Core Layer**
  - `LocalStorageBloc` - Persistent data management
  - `HttpBloc` - Network client configuration
  - `LayeredContext` - Cross-layer service access

- **Infrastructure Layer**
  - `UserBloc` - Authentication state management
  - `AppRouter` - Declarative routing with auth integration
  - `RouterCubit` - BLoC-wrapped navigation management

- **Feature Layer**
  - `HomePage` - Main content with media list
  - `LoginPage` - User authentication
  - `RegisterPage` - User registration

### Clean Architecture Benefits

This project implements **Clean Architecture** principles, providing:

- **Dependency Inversion** - Core layers don't depend on outer layers
- **Testability** - Business logic is independent of frameworks and UI
- **Maintainability** - Clear separation makes code easier to modify
- **Scalability** - Well-defined boundaries support growth
- **Single Responsibility** - Each layer has a focused purpose

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.35.2
- **Dart SDK**: Latest stable
- **IDE**: VS Code, Android Studio, or IntelliJ IDEA
- **Platform Tools**:
  - Android SDK (for Android development)
  - Xcode (for iOS development on macOS)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/hugoradiawan/worknomads-project.git
   cd worknomads-project/frontend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter setup**
   ```bash
   flutter doctor
   ```

4. **Run the application**
   ```bash
   # Development mode
   flutter run

   # Release mode
   flutter run --release

   # Specific platform
   flutter run -d android
   flutter run -d ios
   ```

## 📂 Project Structure

```
lib/
├── core/                                # Foundation layer
│   ├── blocs/                           # Core state management
│   │   ├── http_client/                 # HTTP client BLoC
│   │   ├── local_storage/               # Storage management BLoC
│   │   └── app_bloc_observer.dart       # Global BLoC monitoring
│   ├── router/                          # Navigation system
│   │   ├── app_router.dart              # Route configuration
│   │   └── router_cubit.dart            # Router state management
│   ├── widgets/                         # Core provider widgets
│   │   ├── core_provider.dart           # Core services provider
│   │   └── infrastructure_provider.dart # Infrastructure services
│   ├── layered_context.dart             # Cross-layer access utility
│   ├── typedef.dart                     # Common type definitions
│   └── usecase.dart                     # Use case abstractions
├── features/                            # Feature-specific modules
│   ├── home/                            # Home feature
│   │   └── presentation/                # UI components
│   └── login/                           # Authentication feature
│       └── presentation/                # Login/Register pages
├── shared/                              # Shared resources
│   ├── blocs/                           # Shared state management
│   ├── data/                            # Data models and repositories
│   └── domain/                          # Business entities
├── app.dart                             # Application widget
└── main.dart                            # Application entry point
```

### Clean Architecture Layers in Code

The project structure reflects **Clean Architecture** principles:

- **Presentation Layer** (`features/*/presentation/`) - UI components and state management
- **Domain Layer** (`shared/domain/`) - Business entities and use cases
- **Data Layer** (`shared/data/`) - Repositories, data sources, and models
- **Infrastructure** (`core/`) - External frameworks and cross-cutting concerns

## 🔧 Technology Stack

### Core Technologies
- **Flutter**: 3.35.2 - UI framework
- **Dart**: Latest stable - Programming language

### State Management
- **flutter_bloc**: BLoC pattern implementation
- **hydrated_bloc**: State persistence

### Networking
- **dio**: HTTP client

### Storage
- **shared_preferences**: Local storage

### Navigation
- **go_router**: Declarative routing
