# Poll App

A simple Flutter app for creating and participating in polls.

## Features

*   Create polls with multiple options.
*   Vote on existing polls.
*   View poll results in a chart.

## Dependencies

*   provider: For state management.
*   charts_flutter: For displaying charts.
*   sqflite: For local database storage.
*   path_provider: For getting the application documents directory.

## Folder Structure


lib/
├── main.dart
├── models/
│   └── poll.dart
├── screens/
│   ├── create_poll_screen.dart
│   ├── poll_details_screen.dart
│   └── poll_list_screen.dart
├── services/
│   └── database_service.dart
└── providers/
    └── poll_provider.dart
