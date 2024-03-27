import 'package:ffapp/components/ev_bar.dart';
import 'package:ffapp/components/inventory_item.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
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

  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
    initialize();
  }

  void showFigureDetailsDialog(BuildContext context, String? figureUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          width: 300,
          height: 500,
          child: Column(
            children: [
              SizedBox(height: 10,),
              RobotImageHolder(url: figureUrl!, height: 300, width: 300),
              SizedBox(height: 10,),
              EvBar(currentXp: 10, maxXp: 45, currentLvl: 1, fillColor: Theme.of(context).colorScheme.tertiary, barWidth: 200),
              SizedBox(height: 40,),
              ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("Close"))
            ],
          ),
        ),
      );
    },
  );}

  void initialize() async {
    Routes.User? databaseUser = await auth.getUserDBInfo();
    String stringCur = databaseUser?.currency.toString() ?? "0";
    currency = int.parse(stringCur);
    await auth.getFigureInstances(databaseUser!).then((value) => setState(() {
      figureInstancesList = value.figureInstances;
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
                                photoPath: figureInstancesList[index * 2].figureName.toString(),
                                onViewDetails: (context) => {showFigureDetailsDialog(context, figureInstancesList[index * 2].figureName.toString())},
                                equiped: figureInstancesList[index * 2].figureName.toString() == userModel.user?.curFigure,
                                onEquip: (context) => {equipNew(figureInstancesList[index * 2].figureName.toString())}
                              ),
                              const SizedBox(width: 15),
                              index * 2 + 1 >= figureInstancesList.length ? Container() : //Conditional to check if we have a last skin to render
                              InventoryItem(
                                photoPath: figureInstancesList[index * 2 + 1].figureName.toString(),
                                onViewDetails: (context) => {showFigureDetailsDialog(context, figureInstancesList[index * 2 + 1].figureName.toString())},
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