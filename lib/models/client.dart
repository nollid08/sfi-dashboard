import 'package:dashboard/models/client_types.dart';

class Client {
  final String id;
  final String name;
  final String addressLineOne;
  final String addressLineTwo;
  final String eircode;
  final String rollNumber;
  final ClientType type;

  Client({
    required this.id,
    required this.name,
    required this.addressLineOne,
    required this.addressLineTwo,
    required this.eircode,
    required this.rollNumber,
    required this.type,
  });

  factory Client.fromJson(Map<String, dynamic> json, String id) {
    final String name = json['name'] ?? 'N/A';
    final String addressLineOne = json['addressLine1'] ?? 'N/A';
    final String addressLineTwo = json['addressLine2'] ?? 'N/A';
    final String eircode = json['eircode'] ?? 'N/A';
    final String rollNumber = json['rollNumber'] ?? 'N/A';
    final ClientType type = ClientType.fromString(json['type']['id'] ?? '');
    return Client(
      id: id,
      name: name,
      addressLineOne: addressLineOne,
      addressLineTwo: addressLineTwo,
      eircode: eircode,
      rollNumber: rollNumber,
      type: type,
    );
  }

  factory Client.fromFBJson(Map<String, dynamic> json, String id) {
    final String name = json['name'] ?? 'N/A';
    final String addressLineOne = json['addressLine1'] ?? 'N/A';
    final String addressLineTwo = json['addressLine2'] ?? 'N/A';
    final String eircode = json['eircode'] ?? 'N/A';
    final String rollNumber = json['rollNumber'] ?? 'N/A';
    final ClientType type = ClientType.fromString(json['type'] ?? '');
    return Client(
      id: id,
      name: name,
      addressLineOne: addressLineOne,
      addressLineTwo: addressLineTwo,
      eircode: eircode,
      rollNumber: rollNumber,
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'addressLineOne': addressLineOne,
      'addressLineTwo': addressLineTwo,
      'eircode': eircode,
      'rollNumber': rollNumber,
      'type': type.toJson(),
    };
  }
}
