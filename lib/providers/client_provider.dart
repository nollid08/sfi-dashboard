import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/providers/clients_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'client_provider.g.dart';

@Riverpod(keepAlive: true)
class SingleClient extends _$SingleClient {
  @override
  Stream<Client> build(String clientId) {
    final db = FirebaseFirestore.instance;
    return db.collection('clients').doc(clientId).snapshots().map((doc) {
      return Client.fromJson(doc.data()!, doc.id);
    });
  }

  Future<void> updateClient(Client updatedClient) async {
    final db = FirebaseFirestore.instance;
    await db
        .collection('clients')
        .doc(updatedClient.id)
        .update(updatedClient.toFBJson());
    return;
  }
}
