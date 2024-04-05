import 'package:ffapp/components/ev_bar.dart';
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
  const Inventory({Key? key}) : super(key: key);

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

  late List<Routes.FigureInstance>  figureInstancesList = List.empty();
  late List<Routes.Figure> figureList = List.empty();

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
        weekComplete: Provider.of<UserModel>(context, listen: false).user?.weekComplete,
        curFigure: newFigureName,
    ));
    auth.updateUserDBInfo(Provider.of<UserModel>(context, listen: false).user!);
    Provider.of<FigureModel>(context, listen: false).setFigure(figureInstancesList.firstWhere((element) => element.figureName == newFigureName));
  }

  Map<String, int> displayEVPointsAndMax(int eVPoints, List<int> eVCutoffs) {
    int displayPoints = eVPoints;
    int maxPoints = eVCutoffs[0];
    int level = 1;

    for (int i = 0; i < eVCutoffs.length; i++) {
      if (displayPoints > eVCutoffs[i]) {
        displayPoints -= eVCutoffs[i];
        maxPoints = eVCutoffs[i];
        level++;
      } else {
        break;
      }
    }

    return {
      'displayPoints': displayPoints,
      'maxPoints': maxPoints,
      'level': level
    };
  }

  void showFigureDetailsDialog(BuildContext context, String? figureName) {
    List<int> eVCutoffs = [];
    Figure figure = figureList.firstWhere((x) => x.figureName == figureName);
    eVCutoffs.add(figure.stage1EvCutoff); // why did we decide to repersent this in the database this way it leads to a lot of code duplication
    eVCutoffs.add(figure.stage2EvCutoff);
    eVCutoffs.add(figure.stage3EvCutoff);
    eVCutoffs.add(figure.stage4EvCutoff);
    eVCutoffs.add(figure.stage5EvCutoff);// this is a lot of code duplication
    eVCutoffs.add(figure.stage6EvCutoff); 
    eVCutoffs.add(figure.stage7EvCutoff); // we could have just made a list of the stage ev cutoffs
    eVCutoffs.add(figure.stage8EvCutoff);
    eVCutoffs.add(figure.stage9EvCutoff); // and then looped through them to get the max points
    eVCutoffs.add(figure.stage10EvCutoff); // this would have been a lot cleaner
    // :(
    Map<String, int> displayPointsAndMax = displayEVPointsAndMax(figureInstancesList.firstWhere((x) => x.figureName == figureName).evPoints, eVCutoffs);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: 300,
            height: 500,
            child: Consumer<FigureModel>(
              builder: (context, figureModel, _) {
                return Column(
                  children: [
                    const SizedBox(height: 10,),
                    RobotImageHolder(url: (figureName! + "_skin0_cropped"), height: 300, width: 300),
                    const SizedBox(height: 10,),
                    EvBar(currentXp: displayPointsAndMax['displayPoints'] ?? 0 , maxXp: displayPointsAndMax['maxPoints'] ?? 0, currentLvl: displayPointsAndMax['level'] ?? 1, fillColor: Theme.of(context).colorScheme.tertiary, barWidth: 200),
                    const SizedBox(height: 40,),
                    ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: (Column(
        children: [
          Text("Figure Inventory",
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  )),
          const SizedBox(height: 10),
          Column(
            // generates the store as a bunch of rows with 2 elements each from the array above
            // TO DO: if there are an odd number of skins it wont render the last one rn
            children: List.generate(
                (figureInstancesList.length / 2).ceil(),
                (index) => Column(children: [
                      const SizedBox(height: 15),
                      Consumer<UserModel>(
                        builder: (context, userModel, _) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 5),
                              InventoryItem(
                                photoPath: (figureInstancesList[index * 2].figureName.toString() + "_skin0_cropped"),
                                onViewDetails: (context) => {showFigureDetailsDialog(context, (figureInstancesList[index * 2].figureName.toString()))},
                                equiped: figureInstancesList[index * 2].figureName.toString() == userModel.user?.curFigure,
                                onEquip: (context) => {equipNew(figureInstancesList[index * 2].figureName.toString())}
                              ),
                              const SizedBox(width: 15),
                              index * 2 + 1 >= figureInstancesList.length ? Container() : //Conditional to check if we have a last skin to render
                              InventoryItem(
                                photoPath: (figureInstancesList[index * 2 + 1].figureName.toString() + "_skin0_cropped"),
                                onViewDetails: (context) => {showFigureDetailsDialog(context, (figureInstancesList[index * 2 + 1].figureName.toString()))},
                                equiped: figureInstancesList[index * 2 + 1].figureName.toString() == userModel.user?.curFigure,
                                onEquip: (context) => {equipNew(figureInstancesList[index * 2 + 1].figureName.toString())},
                              ),
                              const SizedBox(width: 5),
                            ],
                          );
                        },
                      ),
            ])),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
              onPressed: () => context.goNamed('SkinStore'),
              child: const Text("Buy More")),
        ],
      )),
    );
  }
}