# Task Manager App – Project Milestone 09

A Flutter-based Task Manager application that allows users to manage their daily tasks and explore inspirational quotes fetched from a REST API.

## Features

### Task Management
- Add, complete, and delete personal tasks.
- Organize daily tasks through a simple user interface.

### Daily Inspiration
- Fetch inspirational quotes from an external REST API.
- Display quotes along with their authors.
- Browse through the available quotes.

## REST API Integration

**API Name:** DummyJSON Quotes API

**API Endpoint:**
https://dummyjson.com/quotes?limit=5

The application uses Dio to send HTTP GET requests and retrieve five quotes from the API.

## Data Flow

The application follows this data flow:

1. **Flutter UI:** Displays the retrieved data and application states.
2. **Cubit / BLoC:** Manages Loading, Success, and Error states.
3. **Dio:** Handles HTTP requests and API communication.
4. **JSON Model:** Converts the API response into Dart objects.
5. **SharedPreferences:** Stores retrieved quotes locally for caching.

## Application States

- **Loading:** Displayed while fetching data from the API.
- **Success:** Displayed when the data is retrieved successfully.
- **Error:** Displayed when the request fails and no cached data is available.
- **Cached Data:** Previously stored quotes are displayed when the API request fails.

## Technologies Used

- Flutter
- Dart
- flutter_bloc
- Dio
- REST API
- JSON
- SharedPreferences

## Screenshots

### 1. Home Page

<img src="screenshots/home.png" width="250" alt="Task Manager Home Page">

### 2. Daily Inspiration (Explore)

<img src="screenshots/explore.png" width="250" alt="Daily Inspiration Page">

### 3. Loading State

<img src="screenshots/loading.png" width="250" alt="Loading State">

## Learning Outcomes

- Integrating REST APIs into Flutter applications.
- Sending HTTP GET requests using Dio.
- Converting JSON responses into Dart Models.
- Managing application states using Cubit.
- Implementing local data caching using SharedPreferences.
- Handling API requests and loading or error scenarios.

---

**Project Milestone 09 – REST API Integration, JSON Model, State Management, and Caching.**
