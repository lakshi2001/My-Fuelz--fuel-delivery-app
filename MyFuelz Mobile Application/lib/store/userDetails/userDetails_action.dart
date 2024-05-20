class UserDetails {
  final String phoneNumber;
  final String name;
  final String email;
  final String role;
  final String userID;

  UserDetails(
      {required this.phoneNumber,
      required this.email,
      required this.role,
      required this.name,
      required this.userID});
}

class TankerDetails {
  final String phoneNumber;
  final String name;
  final String email;
  final String role;
  final String userID;

  TankerDetails(
      {required this.phoneNumber,
      required this.email,
      required this.role,
      required this.name,
      required this.userID});
}

class FuelDetails {
  final String address;
  final String fuelLit;
  final String stationName;
  final String desc;
  final String statID;

  FuelDetails({
    required this.address,
    required this.fuelLit,
    required this.stationName,
    required this.desc,
    required this.statID,
  });
}

class AssignToken {
  final List<dynamic> token;

  AssignToken({
    required this.token,
  });
}

class FuelStations {
  final List<Map<String, dynamic>> stations;

  FuelStations({
    required this.stations,
  });
}
