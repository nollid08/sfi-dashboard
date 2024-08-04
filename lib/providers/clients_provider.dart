import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clients_provider.g.dart';

@Riverpod(keepAlive: true)
class Clients extends _$Clients {
  @override
  Stream<List<Client>> build() {
    final db = FirebaseFirestore.instance;
    return db.collection('clients').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Client.fromJson(doc.data(), doc.id);
      }).toList();
    });
  }
}
