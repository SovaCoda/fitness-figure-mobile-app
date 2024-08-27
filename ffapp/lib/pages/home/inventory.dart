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
    Provider.of<SelectedFigureProvider>(context, listen: false).setSelectedFigureIndex(index);
    Provider.of<FigureModel>(context, listen: false).setFigure(figureInstancesList[index]);
    equipNew(figureInstancesList[index].figureName.toString(), index);
  }

@override
Widget build(BuildContext context) {
  return Consumer<SelectedFigureProvider>(
    builder: (context, selectedFigureProvider, _) {
      return Column(
        children: [
          Consumer<UserModel>(
            builder: (context, userModel, _) {
              return Column(
                children: [
                  for (int i = 0; i < (figureInstancesList.length + 1) ~/ 2; i++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: i * 2 < figureInstancesList.length
                              ? GestureDetector(
                                  onTap: () => selectFigure(i * 2),
                                  child: InventoryItem(
                                    figureInstance: figureInstancesList[i * 2],
                                    photoPath: ("${figureInstancesList[i * 2].figureName}/${figureInstancesList[i * 2].figureName}_skin${figureInstancesList[i * 2].curSkin}_evo${figureInstancesList[i * 2].evLevel}_cropped_happy"),
                                    equiped: figureInstancesList[i * 2].figureName.toString() == userModel.user?.curFigure,
                                    onEquip: (context) => equipNew(figureInstancesList[i * 2].figureName.toString(), i * 2),
                                    isSelected: selectedFigureProvider.selectedFigureIndex == i * 2,
                                  ),
                                )
                              : InventoryItem(
                                  figureInstance: null,
                                  locked: true,
                                  photoPath: "null",
                                  equiped: false,
                                  onEquip: (context) => {},
                                ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: i * 2 + 1 < figureInstancesList.length
                              ? GestureDetector(
                                  onTap: () => selectFigure(i * 2 + 1),
                                  child: InventoryItem(
                                    figureInstance: figureInstancesList[i * 2 + 1],
                                    photoPath: ("${figureInstancesList[i * 2 + 1].figureName}/${figureInstancesList[i * 2 + 1].figureName}_skin${figureInstancesList[i * 2 + 1].curSkin}_evo${figureInstancesList[i * 2 + 1].evLevel}_cropped_happy"),
                                    equiped: figureInstancesList[i * 2 + 1].figureName.toString() == userModel.user?.curFigure,
                                    onEquip: (context) => equipNew(figureInstancesList[i * 2 + 1].figureName.toString(), i * 2 + 1),
                                    isSelected: selectedFigureProvider.selectedFigureIndex == i * 2 + 1,
                                  ),
                                )
                              : InventoryItem(
                                  figureInstance: null,
                                  locked: true,
                                  photoPath: "null",
                                  equiped: false,
                                  onEquip: (context) => {},
                                ),
                        ),
                      ],
                    ),
                ],
              );
            },
          )
        ],
      );
    },
  );
}
  void equipNew(String newFigureName, int figureIndex) {
  Provider.of<UserModel>(context, listen: false).setUser(Routes.User(
    email: Provider.of<UserModel>(context, listen: false).user?.email,
    currency: Provider.of<UserModel>(context, listen: false).user?.currency,
    weekGoal: Provider.of<UserModel>(context, listen: false).user?.weekGoal,
    weekComplete:
        Provider.of<UserModel>(context, listen: false).user?.weekComplete,
    curFigure: newFigureName,
  ));
  auth.updateUserDBInfo(Provider.of<UserModel>(context, listen: false).user!);
  Provider.of<FigureModel>(context, listen: false).setFigure(
      figureInstancesList[figureIndex]);
}
  
  }
