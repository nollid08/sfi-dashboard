import 'package:dashboard/providers/navigation/indexed_screens_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_screen_index_provider.g.dart';

@riverpod
class SelectedScreenIndex extends _$SelectedScreenIndex {
  @override
  int build() {
    return 0;
  }

  void updateIndexBasedOnRouteName(String currentRoute) {
    final screenItemsNotifier = ref.watch(indexedScreensProvider.notifier);
    final int index = screenItemsNotifier.getIndexFromRoute(currentRoute);
    state = index;
  }

  void updateIndex(int index) {
    state = index;
  }
}
