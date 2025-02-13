# Flutter GPIO Control App
This is a Flutter application for controlling GPIO pins. The application implements clean architecture and uses the `flutter_bloc` package for state management. The application provides a user interface to interact with GPIO pins.

## Features
    - Add new GPIO pins (input or output)
    - Toggle output pins
    - Monitor input pins
    - Visual feedback for pin states

## Usage
- Click the `+` button to add a new pin
- Fill in the basic information (pin number and label)
- Toggle `Show Advanced Configuration` to see additional options
- Select the desired configuration options
- Click `Add` to create the pin with the selected configuration
- The UI will now show the configuration details in the expanded view of each pin.

## Screenshots
- TODO: Add screenshots

## Platform Support
| Android |  iOS  | MacOS |  Web  | Linux | Windows |
| :-----: | :---: | :---: | :---: | :---: | :-----: |
|   ❌   |   ❌   |   ❌   |   ❌ |   ✅    |    ❌   |

## Dependencies
- [flutter_bloc](https://pub.dev/packages/flutter_bloc): State management library for Flutter applications.
- [dart_periphery](https://pub.dev/packages/dart_periphery): Dart package for controlling GPIO pins.

## Hardware Requirements
- A Linux machine with GPIO pins (e.g., Raspberry Pi 4B, 5)
- Jumper wires for connecting to GPIO pins
- External devices to control or monitor (e.g., LEDs, buttons, sensors)

## Getting Started

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK: Included with Flutter
- CMake: Required for building the Linux application

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/IoT-gamer/flutter_gpio_control_app.git
   cd flutter_gpio_control_app
   ```

2. Install dependencies:
   ```sh
   flutter pub get
   ```

### Running the Application

To run the application on Linux, use the following command:
```sh
flutter run -d linux
```

### Project Structure

- [main.dart](lib/main.dart): Entry point of the application.
- [gpio_control](lib/features/gpio_control): Contains the main features of the application.
  - `device/`: Hardware interaction layer (GPIO Pins) including repositories.
  - `domain/`: Domain layer including use cases.
  - `presentation/`: Presentation layer including UI and state management.

### Building for Linux

The Linux build configuration is managed using CMake. The build process is defined in the [build.ninja](build/linux/x64/debug/build.ninja) file.

