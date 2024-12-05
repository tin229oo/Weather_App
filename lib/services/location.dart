import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

class Location {
  double? latitude;
  double? longitude;
  String? city;

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

        latitude = position.latitude;
        longitude = position.longitude;

        Uri reverseGeocodeUrl = Uri.parse(
            'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json');
        Response reverseResponse = await get(reverseGeocodeUrl);

        if (reverseResponse.statusCode == 200) {
          var reverseData = jsonDecode(reverseResponse.body);
          city = reverseData['address']['city'] ??
              reverseData['address']['town'] ??
              reverseData['address']['village'] ??
              'Unknown';
        } else {
          city = 'Unknown';
          print('Failed to get city name: ${reverseResponse.body}');
        }
      } else {
        print('Location permissions are denied.');
        city = 'Unknown';
      }
    } catch (e) {
      print('Error in getCurrentLocation: $e');
    }
  }
}
