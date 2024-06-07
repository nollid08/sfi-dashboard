import 'package:dashboard/models/client_types.dart';

class Client {
  final String name;
  final String addressLineOne;
  final String addressLineTwo;
  final String eircode;
  final String rollNumber;
  final ClientType type;

  Client({
    required this.name,
    required this.addressLineOne,
    required this.addressLineTwo,
    required this.eircode,
    required this.rollNumber,
    required this.type,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      name: json['name'] ?? 'N/A',
      addressLineOne: json['addressLine1'] ?? 'N/A',
      addressLineTwo: json['addressLine2'] ?? 'N/A',
      eircode: json['eircode'] ?? 'N/A',
      rollNumber: json['rollNumber'] ?? 'N/A',
      type: ClientType.fromString(json['type'] ?? ''),
    );
  }

  Map<String, String> toJson() {
    return {
      'name': name,
      'addressLineOne': addressLineOne,
      'addressLineTwo': addressLineTwo,
      'postcode': eircode,
      'rollNumber': rollNumber,
      'type': type.id,
    };
  }
}
