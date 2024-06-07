class ClientType {
  final String id;
  final String name;

  ClientType({required this.id, required this.name});

  factory ClientType.fromString(String type) {
    if (type == 'primarySchool') {
      return ClientType(id: type, name: 'School');
    } else if (type == 'youth-project') {
      return ClientType(id: type, name: 'Youth Project');
    } else if (type == 'club') {
      return ClientType(id: type, name: 'Community Group');
    } else {
      return ClientType(id: type, name: 'Other');
    }
  }
}
