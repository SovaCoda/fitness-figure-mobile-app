import 'package:ffapp/components/button_themes.dart';
import 'package:ffapp/components/custom_button.dart';
import 'package:ffapp/components/inventory_item.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ffapp/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;

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
  late List<Routes.FigureInstance> figureInstancesList = List.empty();
  late List<Routes.Figure> figureList = List.empty();

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);

    initialize();
  }

  void initialize() async {
    Routes.User? databaseUser = await auth.getUserDBInfo();
    String stringCur = databaseUser?.currency.toString() ?? "0";
    currency = int.parse(stringCur);
    await auth.getFigureInstances(databaseUser!).then((value) => setState(() {
          figureInstancesList = value.figureInstances;
        }));
    await auth.getFigures().then((value) => setState(() {
          figureList = value.figures;
        }));
  }

  void selectFigure(int index) {
    if(index == Provider.of<SelectedFigureProvider>(context, listen: false).selectedFigureIndex) {
      return;
    }
    Provider.of<SelectedFigureProvider>(context, listen: false)
        .setSelectedFigureIndex(index);
    Provider.of<FigureModel>(context, listen: false)
        .setFigure(figureInstancesList[index]);
    equipNew(figureInstancesList[index].figureName.toString(), index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedFigureProvider>(
      builder: (context, selectedFigureProvider, _) {
        return Column(
          children: [
            SizedBox(height: 10),
            Consumer<UserModel>(
              builder: (context, userModel, _) {
                int totalSlots = figureInstancesList.length + 2;
                return Column(
                  children: [
                    for (int i = 0; i < (totalSlots + 1) ~/ 2; i++) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: _buildInventorySlot(context, i * 2,
                                userModel, selectedFigureProvider),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _buildInventorySlot(context, i * 2 + 1,
                                userModel, selectedFigureProvider),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ],
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.goNamed('SkinStore'),
              child: Text('Go to Store'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInventorySlot(BuildContext context, int index,
      UserModel userModel, SelectedFigureProvider selectedFigureProvider) {
    if (index < figureInstancesList.length) {
      return GestureDetector(
        onTap: () => selectFigure(index),
        child: InventoryItem(
          figureInstance: figureInstancesList[index],
          photoPath:
              ("${figureInstancesList[index].figureName}/${figureInstancesList[index].figureName}_skin${figureInstancesList[index].curSkin}_evo${figureInstancesList[index].evLevel}_cropped_happy"),
          equiped: figureInstancesList[index].figureName.toString() ==
              userModel.user?.curFigure,
          onEquip: (context) =>
              equipNew(figureInstancesList[index].figureName.toString(), index),
          isSelected: selectedFigureProvider.selectedFigureIndex == index,
          index: index
        ),
      );
    } else if (index < figureInstancesList.length + 2) {
      // Additional slots for future figures
      return InventoryItem(
        figureInstance: null,
        locked: true,
        photoPath: "null",
        equiped: false,
        onEquip: (context) => {},
        index: index
      );
    } else {
      // Empty slot
      return SizedBox();
    }
  }

  void equipNew(String newFigureName, int figureIndex) {
    Routes.User user = Provider.of<UserModel>(context, listen: false).user!;
    user.curFigure = newFigureName;
    Provider.of<UserModel>(context, listen: false).setUser(user);

    auth.updateUserDBInfo(Provider.of<UserModel>(context, listen: false).user!);
    Provider.of<FigureModel>(context, listen: false)
        .setFigure(figureInstancesList[figureIndex]);
  }
}
