import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/ff_app_button.dart';
import '../../components/inventory_item.dart';
import '../../main.dart';
import '../../services/auth.dart';
import '../../services/providers.dart';
import '../../services/routes.pb.dart' as routes;
import 'store.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  late AuthService auth;
  late int currency = 0;

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
  }

  Future<void> selectFigure(int index) async {
    if (index ==
        Provider.of<SelectedFigureProvider>(context, listen: false)
            .selectedFigureIndex) {
      return;
    }
    final List<routes.FigureInstance> figureInstancesList =
        Provider.of<FigureInstancesProvider>(context, listen: false)
            .listOfFigureInstances;
    Provider.of<FigureModel>(context, listen: false)
        .setFigure(figureInstancesList[index]);
    Provider.of<SelectedFigureProvider>(context, listen: false)
        .setSelectedFigureIndex(index);

    equipFigure(index, figureInstancesList);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Consumer2<SelectedFigureProvider, FigureInstancesProvider>(
      builder: (context, selectedFigureProvider, figureInstancesProvider, _) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Consumer<UserModel>(
              builder: (context, userModel, _) {
                const int totalSlots = 6; // 4 slots for now
                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
                  physics: const AlwaysScrollableScrollPhysics().applyTo(
                    const BouncingScrollPhysics(),
                  ),
                  // Add 1 to account for the bottom spacing
                  itemCount: ((totalSlots + 1) ~/ 2) + 1,
                  itemBuilder: (context, index) {
                    // Handle the bottom spacing
                    if (index == (totalSlots + 1) ~/ 2) {
                      return SizedBox(height: screenHeight * 0.1);
                    }

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: _buildInventorySlot(
                                context,
                                index * 2,
                                userModel,
                                figureInstancesProvider.listOfFigureInstances,
                                selectedFigureProvider.selectedFigureIndex,
                                totalSlots,
                              ),
                            ),
                            Expanded(
                              child: _buildInventorySlot(
                                context,
                                index * 2 + 1,
                                userModel,
                                figureInstancesProvider.listOfFigureInstances,
                                selectedFigureProvider.selectedFigureIndex,
                                totalSlots,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                      ],
                    );
                  },
                );
              },
            ),
            Positioned(
              bottom: screenHeight * 0.01,
              child: FFAppButton(
                text: 'GO TO STORE',
                size: screenWidth * 0.79389312977099236641221374045802,
                height: screenHeight * 0.08098591549295774647887323943662,
                fontSize: 20,
                isStore: true,
                onPressed: () =>
                    Provider.of<HomeIndexProvider>(context, listen: false)
                        .setIndex(6),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Builds an inventory slot Widget for robot in [figureInstancesList] at [index]
  ///
  /// Returns an inventory slot Widget if [index] < [totalSlots]
  /// Otherwise returns an empty SizedBox
  Widget _buildInventorySlot(
    BuildContext context,
    int index,
    UserModel userModel,
    List<routes.FigureInstance> figureInstancesList,
    int selectedFigureIndex,
    int totalSlots,
  ) {
    if (index < figureInstancesList.length) {
      return GestureDetector(
        onTap: () => !userModel.isWorkingOut ? selectFigure(index) : null,
        child: InventoryItem(
          figureInstance: figureInstancesList[index],
          equipped: figureInstancesList[index].figureName ==
              userModel.user?.curFigure,
          onEquip: (context) => equipFigure(index, figureInstancesList),
          isWorkingOut: userModel.isWorkingOut,
          isSelected: selectedFigureIndex == index,
          index: index,
        ),
      );
    } else if (index < totalSlots) {
      // Additional slots for future figures
      return InventoryItem(
        figureInstance: null,
        locked: true,
        equipped: false,
        onEquip: (context) => {},
        index: index,
      );
    } else {
      // Empty slot
      return const SizedBox();
    }
  }

  /// Equips a figure at index [figureIndex] in [figureInstancesList]
  void equipFigure(
      int figureIndex, List<routes.FigureInstance> figureInstancesList) {
    final routes.User user =
        Provider.of<UserModel>(context, listen: false).user!;
    user.curFigure = figureInstancesList[figureIndex].figureName;
    Provider.of<UserModel>(context, listen: false).setUser(user);

    auth.updateUserDBInfo(Provider.of<UserModel>(context, listen: false).user!);
    Provider.of<FigureModel>(context, listen: false)
        .setFigure(figureInstancesList[figureIndex]);
  }
}
