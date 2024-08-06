import 'package:dashboard/models/screen_item.dart';
import 'package:dashboard/providers/navigation/screens_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'indexed_screens_provider.g.dart';

@riverpod
class IndexedScreens extends _$IndexedScreens {
  @override
  List<ScreenItem> build() {
    final screens = ref.read(screensProvider);
    List<ScreenItem> indexedScreens = [];
    for (ScreenItem screen in screens) {
      indexedScreens.add(screen);
      if (screen.children != null) {
        indexedScreens.addAll(screen.children!);
      }
    }
    return indexedScreens;
  }

  int getIndexFromRoute(String route) {
    //sort longest to shortest
    final List<ScreenItem> sortedScreenItems = [...state]
      ..sort((a, b) => b.route.length.compareTo(a.route.length));
    for (ScreenItem screenItem in sortedScreenItems) {
      if (screenItem.isActive(route)) {
        return state.indexOf(screenItem);
      }
    }
    return 0;
  }
}
