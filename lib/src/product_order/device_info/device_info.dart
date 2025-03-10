
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DeviceTypeChecker {
  static Future<bool> isPOSDevice() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

        final String manufacturer = androidInfo.manufacturer.toLowerCase();
        final String model = androidInfo.model.toLowerCase();

        if (manufacturer.contains('sunmi') || model.contains('pos')) {
          return true; // Likely a POS device
        }
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        // Check iOS-specific details
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

        // POS devices are unlikely on iOS, but you could add checks if needed
        return false;
      }
    } catch (e) {
      print('Error checking device type: $e');
    }

    return false; // Default to not a POS device
  }

  static bool isAndroid() {
    return defaultTargetPlatform == TargetPlatform.android;
  }

  static bool isIOS() {
    return defaultTargetPlatform == TargetPlatform.iOS;
  }
}