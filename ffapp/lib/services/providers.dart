import 'package:flutter/foundation.dart';
import 'package:spine_flutter/spine_flutter.dart';

// Provider that allows access to changing the page index of home from any widget in home.
class HomeIndexProvider with ChangeNotifier {
  Map<int, String> pageNames = {
    0: 'Dashboard',
    1: 'Inventory',
    2: 'Workout Adder',
    3: 'Profile',
    4: 'Core',
    5: 'Evolution'
  };

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

class FigureSkeletonProvider with ChangeNotifier {
  List<SkeletonDrawable> drawables = [];
  Map<String, Atlas> atlases = {};
  Map<String, SkeletonData> skeletons = {};
  Map<String, SpineWidgetController> controllers = {};

  void initialize() async {
    for (int j = 1; j <= 2; j++) {
      for (int i = 1; i <= 3; i++) {
        final atlas = await Atlas.fromAsset(
          "lib/assets/figures/Character_0${j}_lvl$i/export/st_$i.atlas",
        );
        final skeletonData = await SkeletonData.fromAsset(atlas,
            "lib/assets/figures/Character_0${j}_lvl$i/export/st_$i.json");
        atlases["$j$i"] = atlas;
        skeletons["$j$i"] = skeletonData;
        final controller = SpineWidgetController(onInitialized: (controller) {
          controller.animationState.setAnimationByName(0, "idle", true);
          controller.animationState.addAnimationByName(0, "idle", true, 0);
        });

        controllers["$j$i"] = controller;
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
