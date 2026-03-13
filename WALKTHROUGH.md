# English Vocabulary App - Walkthrough

## Overview
The English Vocabulary App has been successfully implemented using **Flutter** and the **Free Dictionary API**. 

The application allows users to search for English words, view their comprehensive definitions categorized by parts of speech (including example sentences), see phonetic spellings, and listen to the word's pronunciation.

## What Was Implemented

1. **Project Setup**:
   - Initialized a new Flutter project (`vocabulary_app`).
   - Integrated essential packages: `http` (networking), `audioplayers` (audio from API URLs), and `flutter_tts` (offline Text-to-Speech fallback).

2. **Data Layer**:
   - Created robust Dart models (`WordModel`, `Phonetic`, `Meaning`, `Definition`) to parse the complex JSON structure returned by the Free Dictionary API.
   - Built a `DictionaryApiService` to handle network requests cleanly and safely catch `404 Not Found` errors when a word doesn't exist.

3. **Audio Service**:
   - Implemented an `AudioService` class that intelligently attempts to play the primary `.mp3` audio URL provided by the dictionary API.
   - **Fallback Mechanism**: If the API does not provide an audio file for a specific word, the app seamlessly falls back to the device's native Text-to-Speech engine (`flutter_tts`) to pronounce the word.

4. **Quiz Feature**:
   - **History Quiz**: 10-question multiple-choice quiz automatically generated from the words you've searched.
   - **Random Quiz (跳痛 QUIZ)**: A new exciting mode that fetches 10 random words from an external API, allowing you to learn completely new vocabulary through a quiz.
   - **Data Persistence**: Uses `shared_preferences` to remember searched words and save a history of all test scores with dates.
   - **Quiz History**: A dedicated screen to track your progress and review past scores.

5. **User Interface (UI)**:
   - **Home Screen Drawer**: Added a navigation drawer (side menu) to easily switch between the Dictionary search and the Quiz/History sections.
   - **Responsive Feedback**: Quiz screen provides immediate color feedback (Green/Red) upon answering.
   - **Loading States**: Includes state management to show loading spinners during API calls and friendly error messages for invalid words.

## How to Test and Run the App

Since you are running on a Mac, you can test the application using the macOS desktop target, an iOS simulator, or an attached Android device.

1. **Open the Project in your IDE**:
   You can open the `/Users/jack/Desktop/test_pm/vocabulary_app` folder in VS Code or Android Studio.

2. **Run via Terminal (macOS target)**:
   *Note: Running the macOS target requires Xcode development tools to be installed on your Mac (`xcode-select --install`).*
   ```bash
   cd /Users/jack/Desktop/test_pm/vocabulary_app
   flutter run -d macos
   ```

3. **Run via Terminal (Chrome / Web)**:
   If you don't have Xcode setup yet, the fastest way to see the UI layout is to run it on the Chrome web browser:
   ```bash
   cd /Users/jack/Desktop/test_pm/vocabulary_app
   flutter run -d chrome
   ```

## Validation Results
- Verified that static analysis (`flutter analyze`) passes with 0 issues after minor code cleanups.
- Verified that the widget tree structure correctly handles the asynchronous API responses.
- Verified that the Text-to-Speech fallback and AudioPlayer logic are wrapped in proper `try-catch` blocks to prevent app crashes.
