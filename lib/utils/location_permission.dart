import 'package:geolocator/geolocator.dart';

import 'custom_log.dart';


class MyPermission {
  static Future<bool> askPermissions() async {
    LocationPermission permission = await Geolocator.requestPermission();

    CustomLog.actionLog(value: "Permission Status => $permission");
    if (permission == LocationPermission.denied) {
      return false;

      ///
    } else if (permission == LocationPermission.deniedForever) {
      return false;

      ///
    } else {
      return true;
    }
  }

  static Future<bool> checkPermissions() async {
    await askPermissions().then((value) {
      if (value) {
        return true;
      }
    });
    return false;
  }
}

//
// Future<bool> getLocationPermission() async {
//   LocationPermission permission;
//   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   CustomLog.actionLog(value:"PERMISSION serviceEnabled => $serviceEnabled");
//
//   if (!serviceEnabled) {
//     await Geolocator.openLocationSettings();
//     return false;
//   }
//
//   permission = await Geolocator.checkPermission();
//
//   if (permission == LocationPermission.denied ||
//       permission == LocationPermission.deniedForever) {
//     return false;
//   }
//   ///
//   else {
//     return true;
//   }
// }

class MyLocation {
  lat() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
    return position.latitude.toString();
  }

  long() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
    return position.longitude.toString();
  }
}
