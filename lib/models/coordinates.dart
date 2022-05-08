/*
Coordinates model to store latitude and longitude
*/

import 'dart:convert';

List<Coordinates> coordinatesFromJson(String str) => List<Coordinates>.from(
    json.decode(str).map((x) => Coordinates.fromJson(x)));

String coordinatesToJson(List<Coordinates> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Coordinates {
  Coordinates({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
  });

  final String? name;
  final double? lat;
  final double? lon;
  final String? country;

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        name: json["name"],
        lat: json["lat"].toDouble(),
        lon: json["lon"].toDouble(),
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "lat": lat,
        "lon": lon,
        "country": country,
      };
}
