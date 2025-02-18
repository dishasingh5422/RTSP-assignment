# RTSP Streaming App

This application allows you to stream RTSP video using the flutter_vlc_player package. The app provides a simple interface to enter an RTSP URL and control the video playback.
## Getting Started

****Setup and Run****
**Prerequisites**

1. Flutter SDK: Ensure you have Flutter installed. You can download it from flutter.dev.
2. Dart: Dart is included with Flutter.
3. A code editor like Visual Studio Code or Android Studio.

****Installation****
**Clone the repository:**
git clone <repository-url>
cd rtsp
**Install dependencies:**
flutter pub get
**Run the application:**
flutter run

****Usage:****
1. Enter RTSP URL:
Open the app on your device or emulator.
Enter a valid RTSP URL in the text field provided.
2.Control Playback:
Play: Starts streaming the video from the provided RTSP URL.
Pause: Pauses the video playback.
Stop: Stops the video playback and disposes of the player.

The main code for the application is in main.dart. Here is a brief overview of the key components:

**MyApp**: The root widget of the application.
**MyHomePage**: The main screen of the application where the user can enter the RTSP URL and control the video playback.
**_MyHomePageState**: The state class for MyHomePage that manages the VLC player and handles user interactions.


