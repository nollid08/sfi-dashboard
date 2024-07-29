import 'package:dashboard/models/client_types.dart';

class Client {
  final String id;
  final String name;
  final String eircode;
  final String rollNumber;
  final ClientType type;
  final String town;
  final String county;
  final bool isDeis;
  final int classrooms;
  final int students;

  Client({
    required this.id,
    required this.name,
    required this.eircode,
    required this.rollNumber,
    required this.type,
    required this.town,
    required this.county,
    required this.isDeis,
    required this.classrooms,
    required this.students,
  });

  factory Client.fromJson(Map<String, dynamic> json, String id) {
    final String name = json['name'] ?? 'N/A';
    final String town = json['addressLine1'] ?? 'N/A';
    final String county = json['addressLine2'] ?? 'N/A';
    final String eircode = json['eircode'] ?? 'N/A';
    final String rollNumber = json['rollNumber'] ?? 'N/A';
    final ClientType type = ClientType.fromString(json['type']['id'] ?? '');
    final bool isDeis = json['isDeis'] ?? false;
    final int classrooms = json['classrooms'] ?? 0;
    final int students = json['students'] ?? 0;
    return Client(
      id: id,
      name: name,
      eircode: eircode,
      rollNumber: rollNumber,
      type: type,
      town: town,
      county: county,
      isDeis: isDeis,
      classrooms: classrooms,
      students: students,
    );
  }

  factory Client.fromFBJson(Map<String, dynamic> json, String id) {
    final String name = json['name'] ?? 'N/A';
    final String town = json['town'] ?? 'N/A';
    final String county = json['county'] ?? 'N/A';

    final String eircode = json['eircode'] ?? 'N/A';
    final String rollNumber = json['rollNumber'] ?? 'N/A';
    final ClientType type = ClientType.fromString(json['type'] ?? '');
    final bool isDeis = json['isDeis'] ?? false;
    final int classrooms = json['classrooms'] ?? 0;
    final int students = json['students'] ?? 0;
    return Client(
      id: id,
      name: name,
      eircode: eircode,
      rollNumber: rollNumber,
      type: type,
      town: town,
      county: county,
      isDeis: isDeis,
      classrooms: classrooms,
      students: students,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'eircode': eircode,
      'rollNumber': rollNumber,
      'type': type.toJson(),
      'town': town,
      'county': county,
      'isDeis': isDeis,
      'classrooms': classrooms,
      'students': students,
    };
  }

  Map<String, dynamic> toFBJson() {
    return {
      'name': name,
      'eircode': eircode,
      'rollNumber': rollNumber,
      'type': type.id,
      'town': town,
      'county': county,
      'isDeis': isDeis,
      'classrooms': classrooms,
      'students': students,
    };
  }

  Client copyWith({
    String? id,
    String? name,
    String? eircode,
    String? rollNumber,
    ClientType? type,
    String? town,
    String? county,
    bool? isDeis,
    int? classrooms,
    int? students,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      eircode: eircode ?? this.eircode,
      rollNumber: rollNumber ?? this.rollNumber,
      type: type ?? this.type,
      town: town ?? this.town,
      county: county ?? this.county,
      isDeis: isDeis ?? this.isDeis,
      classrooms: classrooms ?? this.classrooms,
      students: students ?? this.students,
    );
  }
}
