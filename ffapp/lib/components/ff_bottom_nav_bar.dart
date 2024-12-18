import 'package:ffapp/icons/fitness_icon.dart';
import 'package:ffapp/services/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// Weird callback fix I had to do
// ignore: must_be_immutable
class FfBottomNavBar extends StatelessWidget {
  int selectedIndex;
  FfBottomNavBar({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 110,
      child: OverflowBox(
        alignment: Alignment.center,
        minHeight: 200,
        minWidth: 200,
        maxHeight: 200,
        maxWidth: MediaQuery.sizeOf(context).width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
                offset: Offset(0, -MediaQuery.of(context).size.height * 0.04),
                child: SvgPicture.asset(
                  'lib/assets/art/panel_bottom_bg.svg',
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                )),
            Theme(
                data: Theme.of(context).copyWith(
                  canvasColor:
                      Theme.of(context).colorScheme.surface.withAlpha(0),
                ),
                child: Transform.translate(
                    offset:
                        Offset(0, MediaQuery.of(context).size.height * 0.02),
                    child: BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        selectedItemColor: Colors.white,
                        unselectedItemColor: Colors.white70,
                        showSelectedLabels: true,
                        showUnselectedLabels: true,
                        selectedLabelStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.white),
                        unselectedLabelStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.white),
                        // selectedIconTheme: IconThemeData(size: 40, shadows: [
                        //   BoxShadow(
                        //       color: Theme.of(context).colorScheme.primary,
                        //       offset: Offset(0, 0),
                        //       blurRadius: 20)
                        // ]),
                        items: <BottomNavigationBarItem>[
                          // for some reason icons don't keep their glow when extracting a svg from the figma
                          // so we have to use images for the active icons
                          BottomNavigationBarItem(
                            icon: const FitnessIcon(
                              type: FitnessIconType.home,
                              size: 39,
                              height: 34,
                            ),
                            label: 'Dashboard',
                            tooltip: "Dashboard",
                            activeIcon: Image.asset(
                                'lib/assets/images/home_active.png',
                                width: 50),
                          ),
                          BottomNavigationBarItem(
                            icon: const FitnessIcon(
                                type: FitnessIconType.inventory,
                                size: 39,
                                height: 35),
                            label: 'Inventory',
                            activeIcon: Image.asset(
                                'lib/assets/images/inventory_active.png',
                                width: 50),
                          ),
                          BottomNavigationBarItem(
                            icon: Image.asset('lib/assets/images/plus.png',
                                width: 50),
                            label: 'Add Workout',
                            activeIcon: Image.asset(
                                'lib/assets/images/plus_active.png',
                                width: 50),
                          ),
                          BottomNavigationBarItem(
                            icon: const FitnessIcon(
                                type: FitnessIconType.history,
                                size: 36,
                                height: 34),
                            label: 'Profile',
                            activeIcon: Image.asset(
                                'lib/assets/images/profile_active.png',
                                width: 50),
                          ),
                          BottomNavigationBarItem(
                            icon: const FitnessIcon(
                                type: FitnessIconType.map, size: 34),
                            label: 'Research',
                            activeIcon: const FitnessIcon(
                                type: FitnessIconType.map_active, size: 50),
                          ),
                        ],
                        currentIndex: selectedIndex ?? 0,
                        onTap: Provider.of<HomeIndexProvider>(context,
                                listen: false)
                            .setIndex)) // Provider.of<HomeIndexProvider>(context, listen: false).setIndex)
                )
          ],
        ),
      ),
    );
  }
}
