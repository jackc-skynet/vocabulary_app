# Implementation Plan: English Vocabulary App

## Goal Description
Build a Flutter application that allows users to search for English words, view their meanings, phonetics, and hear pronunciations, as defined in the Product Requirements Document (PRD).

The app will fetch real-time dictionary data from the public `Free Dictionary API` and will fall back to local Text-to-Speech (TTS) if no exact pronunciation audio URL is provided by the API.

## Proposed Changes

I will generate a new Flutter project named `vocabulary_app` inside your project directory (`/Users/jack/Desktop/test_pm/vocabulary_app`). 

### Core Dependencies to Add (`pubspec.yaml`)
- `http`: For making network requests to the Free Dictionary API.
- `audioplayers`: To play the MP3 audio URLs provided by the API for pronunciations.
- `flutter_tts`: To provide a fallback Text-to-Speech engine in case the API does not return an audio file for a specific word.
- `shared_preferences`: To store quiz results and a history of searched words for the quiz source.

### File Structure & Components

#### [NEW] `lib/models/word_model.dart`
Data classes to deserialize the JSON response from `https://api.dictionaryapi.dev/api/v2/entries/en/<word>`. It will include structures for Phonetics, Meanings, and Definitions.

#### [NEW] `lib/services/dictionary_api_service.dart`
Service class responsible for sending HTTP GET requests to the API and returning parsed `WordModel` objects. Will handle `404 Not Found` responses gracefully when words don't exist in the dictionary.

#### [NEW] `lib/services/audio_service.dart`
A wrapper service that attempts to play the primary audio URL using `audioplayers`. If none exists or it fails, it will fall back to reading the word text aloud using `flutter_tts`.

#### [NEW] `lib/screens/home_screen.dart`
The main entry point. It will feature:
- A prominent Search Bar at the top.
- An area to display search results or a message prompting the user to search.

#### [NEW] `lib/screens/word_detail_screen.dart`
A detailed view for a single word, displaying:
- The word text and its phonetic spelling (e.g., `/həˈloʊ/`).
- A floating action button or inline button to trigger the audio pronunciation.
- A grouped list of meanings categorised by Part of Speech (Noun, Verb, etc.), showing definitions and example sentences.

#### [NEW] `lib/models/quiz_model.dart`
Data structures for a `QuizQuestion` (word and four options) and `QuizResult` (score and date).

#### [NEW] `lib/services/storage_service.dart`
Service to manage saving and loading quiz history and searched word history using `shared_preferences`.

#### [NEW] `lib/screens/quiz_screen.dart`
A quiz interface that iterates through 10 questions. For each question, it shows a definition or word and asks the user to pick the correct meaning from 4 choices.

#### [NEW] `lib/screens/quiz_history_screen.dart`
A screen listing past quiz results, showing scores and timestamps.

## Verification Plan

### Automated Tests
- Flutter's static analysis will pass (`flutter analyze`).
- The project will build successfully without compile-time errors.

### Manual Verification
- We will run the app locally (either on a connected Android/iOS simulator or the built-in macOS desktop target for rapid testing) to verify:
  1. Searching for valid words returns detailed results.
  2. Searching for invalid words shows a friendly error message.
  3. Clicking the play button successfully outputs audio.
