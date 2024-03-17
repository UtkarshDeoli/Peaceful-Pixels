# What is Peaceful Pixels ?
- Peaceful pixels is a IoT project that was created by me when i was preparing for JEE
- i had no phone so communacation with friends happned through this device.
- it was janky project it used firebase RTDB but now i am bulding it from ground up using MQTT
- This Repo will have a Flutter App for Android
- And Code for the ESP01 As the Message Reciever.
---
  
## Technologies Used
- Flutter
- MQTT
- Arduino
---

## Features
- Receive and display messages through MQTT.
- Cross-platform Flutter app for Android.
  
---
## How to setup ?

### Flutter App
1. Clone this repository to your local machine.
2. Navigate to the `cd peaceful_pixels` directory.
3. Run `flutter pub get` to install dependencies.
4. Connect your Android device or start an emulator.
5. Run `flutter run` to launch the app on your device/emulator.

### ESP01 Code
1. Connect your ESP01 to your development environment.
2. Upload the provided code (`esp01_receiver.ino`) to your ESP01.
3. Ensure your ESP01 is connected to the MQTT broker and configured to receive messages.

## Contributing
Contributions are welcome! Please feel free to fork this repository and submit pull requests to contribute new features, enhancements, or bug fixes.

## License
[Insert your license information here.]
