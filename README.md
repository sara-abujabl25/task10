# Task Manager App

## Project Overview

Task Manager is a Flutter application designed to help users organize and manage their daily tasks in a simple and convenient way. Users can add tasks, track their progress, mark tasks as completed, and delete them.

The application also includes an Explore section that retrieves online content through a REST API.

## Problem Statement

Managing daily tasks can become difficult without a simple way to organize and track them. This application provides users with an easy way to manage their tasks and keep their data saved in a cloud database.

## Target Audience

Individuals who want a simple and organized way to manage their daily tasks and track their progress.

## Features

- **User Authentication:** Sign in and account management using Supabase Authentication.
- **Task Management:** Add, view, complete, and delete personal tasks.
- **Cloud Database:** Store and manage tasks using Supabase Database.
- **Explore:** Retrieve online quotes through a REST API.
- **State Management:** Manage application states using Cubit.
- **Local Caching:** Store retrieved API data locally using SharedPreferences.
- **Loading and Error Handling:** Handle different data-fetching states.
- **Responsive UI:** Adapt the interface to different screen sizes.

## Application Screenshots

<p align="center">
  <img src="screenshot/login.png" width="200">
  <br><br>
  <img src="screenshot/register.png" width="200">
  <br><br>
  <img src="screenshot/home.png" width="200">
  <br><br>
  <img src="screenshot/explore.png" width="200">
  <br><br>
  <img src="screenshot/settings.png" width="200">
  <br><br>
  <img src="screenshot/supabase_database.png" width="200">
  <br><br>
  <img src="screenshot/responsive_design.png" width="200">
</p>

## Technologies Used

| Technology | Purpose |
|---|---|
| Flutter & Dart | Application development |
| Supabase | Authentication and cloud database |
| flutter_bloc | State management using Cubit |
| Dio | HTTP requests and API integration |
| SharedPreferences | Local data caching |
| DummyJSON API | External data source |
| Material 3 | User interface design |

## Project Structure

```text
lib/
├── main.dart
├── cubit/
│   ├── task_cubit.dart
│   ├── task_state.dart
│   ├── online_task_cubit.dart
│   └── online_task_state.dart
├── models/
│   └── online_task_model.dart
├── screens/
│   ├── home_page.dart
│   ├── explore_tasks_page.dart
│   ├── login_page.dart
│   ├── register_page.dart
│   └── settings_page.dart
└── services/
    ├── api_service.dart
    └── auth_service.dart
```

## Architecture & State Management

The application uses a structured project organization that separates screens, state management, data models, and services.

Cubit is used to manage application states and separate business logic from the user interface.

- `TaskCubit` manages personal task operations.
- `OnlineTaskCubit` handles online data and its different states.

## Database & Authentication

Supabase is used for user authentication and cloud data storage.

The `tasks` table stores task information, including:

- Task ID
- User ID
- Title
- Description
- Priority
- Completion status
- Creation date

Row Level Security (RLS) policies are enabled to ensure that authenticated users can access and manage only their own tasks.

## API Integration & Caching

The Explore section uses Dio to retrieve data from the DummyJSON API.

The retrieved JSON data is converted into model objects before being displayed in the application.

SharedPreferences is used to cache retrieved data locally. The application can use previously cached data when a new API request fails.

## Getting Started

### Requirements

- Flutter SDK
- Dart SDK
- A Supabase project

### Installation

1. Clone the repository:

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

2. Navigate to the project directory:

```bash
cd task9
```

3. Install dependencies:

```bash
flutter pub get
```

4. Configure your Supabase project URL and publishable key in the application configuration.

5. Run the application:

```bash
flutter run
```

## Challenges & Solutions

| Challenge | Solution |
|---|---|
| Managing application state | Used Cubit to organize state and business logic. |
| Handling API responses | Used Dio and data models to process JSON responses. |
| Handling network errors | Implemented loading, success, and error states. |
| Keeping retrieved data available | Used SharedPreferences for local caching. |
| Managing user task data securely | Used Supabase with Row Level Security policies. |
| Supporting different screen sizes | Applied responsive UI design. |



## Author

**Sarah Mousa Abu Jabal**  
 


---

Developed as a final project for the Flutter Training Camp.
