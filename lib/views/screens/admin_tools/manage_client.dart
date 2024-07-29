import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageClient extends ConsumerWidget {
  const ManageClient(this.clientId, {super.key});
  final clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(child: Text(clientId)),
    );
  }
}
