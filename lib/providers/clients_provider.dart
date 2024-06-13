import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clients_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<List<Client>> clients(ClientsRef ref) {
  final db = FirebaseFirestore.instance;
  return db.collection('clients').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return Client.fromJson(doc.data(), doc.id);
    }).toList();
  });
}
