# Project Blueprint

## Overview

This document outlines the plan for developing a Flutter application with QR code scanning functionality.

## Current Goal

Implement a QR code scanning feature that includes:
- A screen for scanning QR codes using the device's camera.
- A button to toggle the flashlight on and off.
- A screen to display the history of scanned codes.
- Local storage for the scan history.

## Plan

1.  **Add Dependencies:**
    - `mobile_scanner`: For the QR code scanning functionality.
    - `shared_preferences`: for local storage of the scan history.
    - `provider`: for state management.
    - `google_fonts`: for custom fonts.

2.  **File Structure:**
    - `lib/main.dart`: The main application entry point, including theme setup and navigation.
    - `lib/scanner_screen.dart`: The screen containing the camera view for scanning.
    - `lib/history_screen.dart`: The screen to display the list of scanned codes.

3.  **Implementation Steps:**
    - **main.dart:**
        - Set up a `ChangeNotifierProvider` for theme management.
        - Define light and dark themes using `ColorScheme.fromSeed` and `google_fonts`.
        - Create a home page with buttons to navigate to the scanner and history screens.
    - **scanner\_screen.dart:**
        - Use the `MobileScanner` widget to display the camera feed.
        - Add an `IconButton` to control the flashlight.
        - When a QR code is detected, save the code to `SharedPreferences` and show a confirmation dialog.
    - **history\_screen.dart:**
        - Load the scan history from `SharedPreferences`.
        - Display the history in a `ListView`.
        - Add a button to clear the scan history.

## Current Status

- **Fixed:** Correctly implemented the flashlight toggle functionality in `scanner_screen.dart` using `setState` after identifying the correct API usage for the `mobile_scanner: 5.2.3` package.
- **Completed:** All planned features for the QR scanner application are now implemented.
