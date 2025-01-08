import 'package:ffapp/components/ff_app_button.dart';
import 'package:ffapp/components/inventory_item.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/pages/home/store.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/providers.dart';
import 'package:ffapp/services/routes.pb.dart' as routes;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/pages/home/store.dart' as store;

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  //add a skin's image path and its price to render it in the store
  final listOfSkins = [
    ["robot1_skin0_cropped", true],
    ["robot2_skin0_cropped", false],
  ];

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
    List<routes.FigureInstance> figureInstancesList = Provider.of<FigureInstancesProvider>(context, listen: false).listOfFigureInstances;
    Provider.of<FigureModel>(context, listen: false)
        .setFigure(figureInstancesList[index]);
    Provider.of<SelectedFigureProvider>(context, listen: false)
        .setSelectedFigureIndex(index);

    equipNew(figureInstancesList[index].figureName, index, figureInstancesList);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SelectedFigureProvider, FigureInstancesProvider>(
      builder: (context, selectedFigureProvider, figureInstancesProvider, _) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Consumer<UserModel>(
                    builder: (context, userModel, _) {
                      const int totalSlots = 6; // 4 slots for now
                      return Column(
                        children: [
                          for (int i = 0; i < (totalSlots + 1) ~/ 2; i++) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: _buildInventorySlot(
                                    context,
                                    i * 2,
                                    userModel,
                                    figureInstancesProvider.listOfFigureInstances,
                                    selectedFigureProvider,
                                    totalSlots,
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.001),
                                Expanded(
                                  child: _buildInventorySlot(
                                    context,
                                    i * 2 + 1,
                                    userModel,
                                    figureInstancesProvider.listOfFigureInstances,
                                    selectedFigureProvider,
                                    totalSlots,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                          ],
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1),
                        ],
                      );
                    },
                  ),
                  // SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () => context.goNamed('SkinStore'),
                  //   child: Text('Go to Store'),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Theme.of(context).colorScheme.primary,
                  //     foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  //   ),
                  // ),
                ],
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.01,
              child: FFAppButton(
                text: "GO TO STORE",
                size: MediaQuery.of(context).size.width *
                    0.79389312977099236641221374045802,
                height: MediaQuery.of(context).size.height *
                    0.08098591549295774647887323943662,
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

  Widget _buildInventorySlot(
    BuildContext context,
    int index,
    UserModel userModel,
    List<routes.FigureInstance> figureInstancesList,
    SelectedFigureProvider selectedFigureProvider,
    int totalSlots,
  ) {
    if (index < figureInstancesList.length) {
      return GestureDetector(
        onTap: () => selectFigure(index),
        child: InventoryItem(
          figureInstance: figureInstancesList[index],
          equipped: figureInstancesList[index].figureName ==
              userModel.user?.curFigure,
          onEquip: (context) => equipNew(
            figureInstancesList[index].figureName,
            index,
            figureInstancesList
          ),
          isSelected: selectedFigureProvider.selectedFigureIndex == index,
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

  void equipNew(String newFigureName, int figureIndex, List<routes.FigureInstance> figureInstancesList) {
    final routes.User user =
        Provider.of<UserModel>(context, listen: false).user!;
    user.curFigure = newFigureName;
    Provider.of<UserModel>(context, listen: false).setUser(user);

    auth.updateUserDBInfo(Provider.of<UserModel>(context, listen: false).user!);
    Provider.of<FigureModel>(context, listen: false)
        .setFigure(figureInstancesList[figureIndex]);
  }
}
