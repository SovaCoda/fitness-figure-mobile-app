import 'package:flutter/foundation.dart';

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
