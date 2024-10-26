class ClientType {
  final String id;
  final String name;

  ClientType({required this.id, required this.name});

  factory ClientType.fromString(String type) {
    if (type == 'national.mainstream') {
      return ClientType(id: type, name: 'Primary Mainstream');
    } else if (type == 'national.special') {
      return ClientType(id: type, name: 'Special Mainstream');
    } else if (type == 'secondary.mainstream') {
      return ClientType(id: type, name: 'Secondary Mainstream');
    } else {
      return ClientType(id: type, name: 'Other');
    }
  }

  Map<String, String> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
