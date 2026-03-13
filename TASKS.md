# English Vocabulary App Implementation Tasks

### Android Configuration
To allow the app to access the Internet on real devices, the following permission must be added to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

### File Structure & Components
- [x] Project Setup & Dependencies
  - [x] Initialize `vocabulary_app` Flutter project.
  - [x] Add dependencies (`http`, `audioplayers`, `flutter_tts`).
- [x] Data Layer
  - [x] Create models for Word data (Word, Phonetic, Meaning, Definition).
  - [x] Implement API service to fetch data from Free Dictionary API.
- [x] Audio Service
  - [x] Implement service to play audio from URL (`audioplayers`).
  - [x] Implement fallback TTS service (`flutter_tts`).
- [x] UI Layer
  - [x] Create Home/Search Screen with search bar.
  - [x] Create Word Detail Screen to display definitions, part of speech, and pronunciations.
  - [x] Integrate Audio Service into UI play buttons.
- [x] Polish & Verification
  - [x] Handle error states (e.g., word not found in API).
  - [x] Ensure clean, responsive UI (Material 3).
  - [x] Fix: Added Android Internet permissions for real device connectivity.

- [x] Quiz Feature
  - [x] Add `shared_preferences` dependency.
  - [x] Create `StorageService` to track searched words and test results.
  - [x] Implement `QuizModel` and question generation logic.
  - [x] Create `QuizScreen` UI.
  - [x] Create `QuizHistoryScreen` UI.
  - [x] Update Home Screen to navigate to Quiz.
- [x] Random Quiz (跳痛 QUIZ) Extension
  - [x] Update `DictionaryApiService` to fetch random words and their definitions.
  - [x] Update `QuizScreen` to support "Random Mode".
  - [x] Add "Random Quiz" launch button to Home Screen drawer.
