import 'package:ffapp/components/inventory_item.dart';
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

  void initialize() async {
    Routes.User? databaseUser = await auth.getUserDBInfo();
    String stringCur = databaseUser?.currency.toString() ?? "0";
    currency = int.parse(stringCur);
    await auth.getFigureInstances(databaseUser!).then((value) => setState(() {
      figureInstancesList = value.figureInstances;
    }));


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
                (figureInstancesList.length / 2).floor(),
                (index) => Column(children: [
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 5),
                          Consumer<UserModel>(
                            builder: (context, userModel, _) {
                              return InventoryItem(
                                photoPath: figureInstancesList[index * 2].figureName.toString(),
                                onViewDetails: (context) => {context.goNamed("FigureDetails", pathParameters: {'figureUrl': figureInstancesList[index * 2].figureName.toString()})},
                                equiped: figureInstancesList[index * 2].figureName.toString() == userModel.user?.curFigure ? true : false,
                                onEquip: (context) => {}
                              );
                            },
                          ),
                          const SizedBox(width: 15),
                          InventoryItem(
                              photoPath: listOfSkins[index * 2 + 1][0].toString(),
                              onViewDetails: (context) => {context.goNamed("FigureDetails", pathParameters: {'figureUrl': listOfSkins[index * 2 + 1][0].toString()})},
                              equiped: listOfSkins[index * 2 + 1][1].toString() == "true" ? true : false,
                              onEquip: (context) => {},
                          ),
                          const SizedBox(width: 5),
                        ],
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