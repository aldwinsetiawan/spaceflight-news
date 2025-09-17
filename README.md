# Flutter Android Project

A simple Flutter project targeting Android devices.

## Features

- Built with Flutter
- Runs on Android
- Get data from [Spaceflight news API](https://api.spaceflightnewsapi.net/v4/docs/)
- Can save bookmarks locally
- Open original link in browser

## Getting Started

### Prerequisites

Make sure you have the following installed:

- [Flutter SDK at least 3.35.3](https://flutter.dev/docs/get-started/install)
- Android Studio or VS Code
- Android device or emulator

### Installation

1. Clone this repository:

```bash
git clone https://github.com/aldwinsetiawan/spaceflight-news.git
cd spaceflight-news
```

2. Get Flutter dependencies:


```bash
flutter pub get
```


3. Run the app on an Android device or emulator:


```bash
flutter run
```


### Building APK


To generate an APK for Android:


```bash
flutter build apk --release
