# English Fun - Complete Flutter App

A production-ready Flutter frontend application for English language learners. This app features interactive learning tools including daily practice exercises, vocabulary lessons, flashcard mode, and quizzes.

## Project Overview

**App Name:** English Fun  
**Target Users:** Beginner to Intermediate English Learners  
**Platform:** Flutter (iOS and Android)  
**State Management:** Riverpod  
**Navigation:** GoRouter  
**Design System:** Material 3 with Custom Theme  

## Features

### ✨ Implemented Screens

1. **Splash Screen** - Welcome screen with loading animation
2. **Onboarding** - 3-page PageView for app introduction
3. **Login Screen** - Email/Password authentication UI
4. **Home Dashboard** - Main hub with greeting, streak, XP, and quick actions
5. **Daily Practice** - Interactive exercises with feedback
6. **Vocabulary Module** - Full vocabulary system with details
7. **Flashcard Mode** - Swipeable interactive flashcards
8. **Quiz System** - Score-based multiple choice quizzes
9. **Profile Screen** - User statistics and achievements

### 🎨 Design System

- **Primary Color:** Deep Blue (#0D47A1)
- **Accent Color:** Soft Yellow (#FBC02D)
- **Background:** Off White (#F5F7FA)
- **Card Radius:** 20px

## Installation & Setup

### Prerequisites

- Flutter SDK 3.0.0 or higher
- Dart 3.0 or higher

### Quick Start

```bash
cd englishfun
flutter clean
flutter pub get
flutter run
```

## Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (Google Play)
```bash
flutter build appbundle --release
```

## Technology Stack

- **flutter_riverpod** - State management
- **go_router** - Navigation & routing
- **animations** - Smooth transitions
- **Material 3** - Modern design system

## Project Structure

```
lib/
├── main.dart              # Entry point
├── app.dart              # App configuration
├── core/                 # Core functionality
├── features/             # Feature screens
├── models/              # Data models
├── data/                # Mock data
└── navigation/          # Route configuration
```

## Key Routes

- `/` - Splash Screen
- `/onboarding` - Onboarding
- `/login` - Login
- `/home` - Home Dashboard
- `/practice` - Daily Practice
- `/vocabulary` - Vocabulary List
- `/flashcard` - Flashcard Mode
- `/quiz` - Quiz
- `/profile` - Profile

## Code Quality

- ✅ Full null safety
- ✅ No compilation errors
- ✅ Clean architecture
- ✅ Responsive design
- ✅ Reusable components

Verify with:
```bash
flutter analyze
```

## Testing

```bash
flutter test
```
## 📱 Screenshots
<img width="493" height="912" alt="1" src="https://github.com/user-attachments/assets/f53a64e4-8ca6-4077-9b63-98546b328f5c" /></br>
<img width="496" height="913" alt="2" src="https://github.com/user-attachments/assets/64363269-9838-46fb-9341-974728b6b3a2" /></br>
<img width="491" height="912" alt="3" src="https://github.com/user-attachments/assets/ae40c36b-0964-4782-aac6-92e2d6f4408c" /></br>
<img width="494" height="909" alt="4" src="https://github.com/user-attachments/assets/78d214fa-d721-44e3-b283-dac268afd878" /></br>
<img width="494" height="909" alt="5" src="https://github.com/user-attachments/assets/e32817af-01da-401c-b26f-43fb8df1094e" /></br>
<img width="494" height="908" alt="6" src="https://github.com/user-attachments/assets/2ac7a881-bbfc-47f7-ae33-1b90dc39ce94" /></br>
<img width="496" height="910" alt="7" src="https://github.com/user-attachments/assets/33dbcbb4-1a75-45e2-835d-23551005746c" /></br>
<img width="494" height="905" alt="8" src="https://github.com/user-attachments/assets/074aff9d-d1fb-415f-bb4e-b30870f31da2" /></br>
<img width="494" height="906" alt="9" src="https://github.com/user-attachments/assets/6e3d4031-fa8c-4c2d-a940-d51a1c847975" /></br>

## Documentation

See the complete documentation in the app for:
- Mock data structure
- Component usage
- Navigation patterns
- Responsive design helpers

---

**Status:** ✅ Production Ready  
**Last Updated:** March 2, 2026
