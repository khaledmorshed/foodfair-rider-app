import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'global_instance_or_variable.dart';

class RiderLocation {

  getCurrentLocation() async {
    //by default permission stays denied. so it needs to send request to the usesr
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;
    //it will provide multiple location but exact location is in index[0]
    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    //to get exact location
    Placemark pMark = placeMarks![0];
    //to get complete address
    completeAddress =
        '${pMark.subThoroughfare} ${pMark.thoroughfare},${pMark.subLocality} ${pMark.locality},${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';
  }
}
