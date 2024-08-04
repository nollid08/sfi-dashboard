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
  final DateTime? joinDate;
  final List<String> previousBookingIds;
  final bool? hasHall;
  final bool? hasParking;
  final int? largestClassSize;
  final bool? hasMats;
  final String? contactName;
  final String? contactEmail;
  final String? contactPhone;
  final String? principalName;
  final String? principalEmail;
  final String? notes;

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
    this.joinDate,
    this.previousBookingIds = const [],
    this.hasHall,
    this.hasParking,
    this.largestClassSize,
    this.hasMats,
    this.contactName,
    this.contactEmail,
    this.contactPhone,
    this.principalName,
    this.principalEmail,
    this.notes,
  });

  factory Client.fromFBJson(Map<String, dynamic> json, String id) {
    final String eircode = json['eircode'] ?? 'N/A';
    final String rollNumber = json['rollNumber'] ?? 'N/A';
    final ClientType type = ClientType.fromString(json['type']['id'] ?? '');
    final bool isDeis = json['isDeis'] ?? false;
    final int classrooms = json['classrooms'] ?? 0;
    final int students = json['students'] ?? 0;
    final String name = json['name'] ?? 'N/A';
    final String town = json['town'] ?? 'N/A';
    final String county = json['county'] ?? 'N/A';
    final bool? hasHall = json['hasHall'];
    final bool? hasParking = json['hasParking'];
    final int? largestClassSize = json['largestClassSize'];
    final bool? hasMats = json['hasMats'];
    final String? contactName = json['contactName'];
    final String? contactEmail = json['contactEmail'];
    final String? contactPhone = json['contactPhone'];
    final String? principalName = json['principalName'];
    final String? principalEmail = json['principalEmail'];
    final String? notes = json['notes'];
    final DateTime? joinDate = json['joinDate'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['joinDate'])
        : null;
    return Client(
      id: id,
      name: name,
      eircode: eircode,
      rollNumber: rollNumber,
      type: type,
      town: town,
      county: county,
      isDeis: isDeis,
      joinDate: joinDate,
      classrooms: classrooms,
      students: students,
      hasHall: hasHall,
      hasParking: hasParking,
      largestClassSize: largestClassSize,
      hasMats: hasMats,
      contactName: contactName,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
      principalName: principalName,
      principalEmail: principalEmail,
      notes: notes,
    );
  }

  factory Client.fromJson(Map<String, dynamic> json, String id) {
    final String eircode = json['eircode'] ?? 'N/A';
    final String rollNumber = json['rollNumber'] ?? 'N/A';
    final ClientType type = ClientType.fromString(json['type'] ?? '');
    final bool isDeis = json['isDeis'] ?? false;
    final int classrooms = json['classrooms'] ?? 0;
    final int students = json['students'] ?? 0;
    final String name = json['name'] ?? 'N/A';
    final String town = json['town'] ?? 'N/A';
    final String county = json['county'] ?? 'N/A';
    final bool? hasHall = json['hasHall'];
    final bool? hasParking = json['hasParking'];
    final int? largestClassSize = json['largestClassSize'];
    final bool? hasMats = json['hasMats'];
    final String? contactName = json['contactName'];
    final String? contactEmail = json['contactEmail'];
    final String? contactPhone = json['contactPhone'];
    final String? principalName = json['principalName'];
    final String? principalEmail = json['principalEmail'];
    final String? notes = json['notes'];
    final DateTime? joinDate = json['joinDate'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['joinDate'])
        : null;
    return Client(
      id: id,
      name: name,
      eircode: eircode,
      rollNumber: rollNumber,
      type: type,
      town: town,
      county: county,
      isDeis: isDeis,
      joinDate: joinDate,
      classrooms: classrooms,
      students: students,
      hasHall: hasHall,
      hasParking: hasParking,
      largestClassSize: largestClassSize,
      hasMats: hasMats,
      contactName: contactName,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
      principalName: principalName,
      principalEmail: principalEmail,
      notes: notes,
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
      'joinDate': joinDate?.millisecondsSinceEpoch,
      'previousBookingIds': previousBookingIds,
      'hasHall': hasHall,
      'hasParking': hasParking,
      'largestClassSize': largestClassSize,
      'hasMats': hasMats,
      'contactName': contactName,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'principalName': principalName,
      'principalEmail': principalEmail,
      'notes': notes,
    };
  }

  Map<String, dynamic> toFBJson() {
    return {
      'name': name,
      'eircode': eircode,
      'rollNumber': rollNumber,
      'type': type.toJson(),
      'town': town,
      'county': county,
      'isDeis': isDeis,
      'classrooms': classrooms,
      'students': students,
      'hasHall': hasHall,
      'hasParking': hasParking,
      'largestClassSize': largestClassSize,
      'hasMats': hasMats,
      'contactName': contactName,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'principalName': principalName,
      'principalEmail': principalEmail,
      'notes': notes,
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
    DateTime? joinDate,
    List<String>? previousBookingIds,
    bool? hasHall,
    bool? hasParking,
    int? largestClassSize,
    bool? hasMats,
    String? contactName,
    String? contactEmail,
    String? contactPhone,
    String? principalName,
    String? principalEmail,
    String? notes,
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
      joinDate: joinDate ?? this.joinDate,
      previousBookingIds: previousBookingIds ?? this.previousBookingIds,
      hasHall: hasHall ?? this.hasHall,
      hasParking: hasParking ?? this.hasParking,
      largestClassSize: largestClassSize ?? this.largestClassSize,
      hasMats: hasMats ?? this.hasMats,
      contactName: contactName ?? this.contactName,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      principalName: principalName ?? this.principalName,
      principalEmail: principalEmail ?? this.principalEmail,
      notes: notes ?? this.notes,
    );
  }
}
