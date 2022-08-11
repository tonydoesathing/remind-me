<p align="center">
    <img src="assets/logo_rounded_rect.png"
        height="130">
</p>

# RemindMe 
<a href="https://www.flutter.org/" alt="Flutter"><img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" /></a> 
<a href="https://www.figma.com/file/ClVd12IfJiBPj1tKsO5OCh/Remind-me?node-id=0%3A1" alt="Figma"><img src="https://img.shields.io/badge/figma-%23F24E1E.svg?style=for-the-badge&logo=figma&logoColor=white" /></a>
<a href="https://github.com/tonydoesathing/remind-me/releases" alt="Figma"><img src="https://img.shields.io/github/v/release/tonydoesathing/remind-me" /></a>
<a href="https://github.com/tonydoesathing/remind-me" alt="Figma"><img src="https://img.shields.io/github/last-commit/tonydoesathing/remind-me" /></a>

A simple Flutter app to schedule reminder notifications with custom callbacks.

<p align="center">
    <img src="assets/readme/reminder_example.gif" height=500>
</p>

## Features
* Open a URL on tapping notification
* Schedule a notification to go off at a specified time
* Repeat notification schedules daily, weekly, monthly, or yearly
* All simple CRUD operations
* Dynamic Material 3 color theming, including dark/light modes


## Running
Pull the repo and then run `flutter pub get` in the directory.
To run the app, run `flutter run ./lib/main.dart` in the directory.
Finally, build with `flutter build`.


## Libraries and Tools
Android icons generated with [Icons Launcher](https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html) and other icons generated with [Flutter Launcher Icons](https://pub.dev/packages/flutter_launcher_icons). Makes heavy use of the [Awesome Notifications](https://pub.dev/packages/awesome_notifications) package for notifications and [bloc](https://bloclibrary.dev/#/) for state management.
