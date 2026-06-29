/// Device location. Matches: Location in native SDK.
class Location {
  final double latitude;
  final double longitude;

  const Location({required this.latitude, required this.longitude});

  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}
