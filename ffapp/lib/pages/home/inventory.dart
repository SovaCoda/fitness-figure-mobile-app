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

  void equipNew(String newFigureName) {
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
        figureInstancesList
            .firstWhere((element) => element.figureName == newFigureName));
  }

  @override
  Widget build(BuildContext context) {
    double usableHeight = MediaQuery.of(context).size.height *
        0.75; // height of app bar and bottom nav bar (adjusted mediaquery for my device)
    return (Column(
      children: [
        Consumer<UserModel>(
          builder: (context, userModel, _) {
            return Column(
              children: [
                for (int i = 0; i <= 1; i++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: usableHeight / 2,
                          maxWidth: MediaQuery.of(context).size.width,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          margin: const EdgeInsets.all(4),
                          height: usableHeight / 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: i * 2 >= figureInstancesList.length
                                    ? InventoryItem(
                                        figureInstance: null,
                                        locked: true,
                                        photoPath: "null",
                                        equiped: false,
                                        onEquip: (context) => {})
                                    : Consumer<InventoryModel>(
                                        builder: (_, inventory, __) {
                                          return InventoryItem(
                                              figureInstance:
                                                  figureInstancesList[i * 2],
                                              photoPath:
                                                  ("${figureInstancesList[i * 2].figureName}/${figureInstancesList[i * 2].figureName}_skin${figureInstancesList[i * 2].curSkin}_evo${figureInstancesList[i * 2].evLevel}_cropped_happy"),
                                              equiped:
                                                  figureInstancesList[i * 2]
                                                          .figureName
                                                          .toString() ==
                                                      userModel.user?.curFigure,
                                              onEquip: (context) => {
                                                    equipNew(
                                                        figureInstancesList[
                                                                i * 2]
                                                            .figureName
                                                            .toString())
                                                  });
                                        },
                                      ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: i * 2 + 1 >= figureInstancesList.length
                                    ? InventoryItem(
                                        figureInstance: null,
                                        locked: true,
                                        photoPath: "null",
                                        equiped: false,
                                        onEquip: (context) => {})
                                    : InventoryItem(
                                        figureInstance:
                                            figureInstancesList[i * 2 + 1],
                                        photoPath:
                                            ("${figureInstancesList[i * 2 + 1].figureName}/${figureInstancesList[i * 2 + 1].figureName}_skin0_evo0_cropped_happy"),
                                        equiped: figureInstancesList[i * 2 + 1]
                                                .figureName
                                                .toString() ==
                                            userModel.user?.curFigure,
                                        onEquip: (context) => {
                                              equipNew(
                                                  figureInstancesList[i * 2 + 1]
                                                      .figureName
                                                      .toString())
                                            }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            );
          },
        )
      ],
    ));
  }
}
