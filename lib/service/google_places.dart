import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

class Place {
  String long;
  String lat;

  Place({
    required this.long,
    required this.lat,
  });

  @override
  String toString() {
    return 'Place(streetNumber: $lat, street: $long)';
  }
}

class Suggestion {
  final String placeId;
  final String description;
  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = Client();

  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  static const String androidKey = 'AIzaSyCSRyd6_fhcAKO0-WocoGv_G7Wq0AJxBCc';
  static const String iosKey = 'AIzaSyCSRyd6_fhcAKO0-WocoGv_G7Wq0AJxBCc';
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Future<List<Suggestion>> fetchSuggestions(String input) async {
    Uri request =
        Uri.https("maps.googleapis.com", "maps/api/place/autocomplete/json", {
      "input": input,
      "type": "geocode",
      "language": "es-Es",
      // "components": "country:ch",
      "key": apiKey,
      "sessiontoken": sessionToken
    });
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<String> getCurrentLocation(String lat, String long) async {
    Uri request = Uri.https("maps.googleapis.com", "maps/api/geocode/json", {
      "latlng": lat + "," + long,
      "key": apiKey,
      "language": "es-Es",
      "sessiontoken": sessionToken
    });
    final response = await client.get(request);
    String loc = "";
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        loc = result['plus_code']["compound_code"];
        return loc;
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return "";
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    Uri request =
        Uri.https("maps.googleapis.com", "maps/api/place/details/json", {
      "place_id": placeId,
      "fields": "geometry",
      "key": apiKey,
      "language": "es-Es",
      "sessiontoken": sessionToken
    });
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final place = Place(
            lat: result['result']["geometry"]["location"]["lat"].toString(),
            long: result['result']["geometry"]["location"]["lng"].toString());

        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}
