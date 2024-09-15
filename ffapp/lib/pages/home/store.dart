import 'package:ffapp/components/figure_store_item.dart';
import 'package:ffapp/main.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ffapp/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:fixnum/fixnum.dart';
import 'package:go_router/go_router.dart';
import 'package:ffapp/components/skin_view.dart';

var logger = Logger();

class FigureInstancesProvider extends ChangeNotifier {
  late List<Routes.FigureInstance> listOfFigureInstances;
  void initializeListOfFigureInstances(
      List<Routes.FigureInstance> listOfFigureInstances) {
    this.listOfFigureInstances = listOfFigureInstances;
  }

  void setFigureInstanceCurSkin(
      String figureName, String curSkin, int selectedFigureIndex) {
    listOfFigureInstances[selectedFigureIndex].curSkin = curSkin.substring(4);
    notifyListeners();
  }
}

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  //add a skin's image path and its price to render it in the store
  late List<Routes.Skin> listOfSkin = List.empty();
  late List<Routes.Figure> listOfFigures = List.empty();
  late List<Routes.FigureInstance> listOfFigureInstances = List.empty();
  late List<Routes.SkinInstance> listOfSkinInstances = List.empty();

  late AuthService auth;
  late int currency = 0;
  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
    initialize();
  }

  void initialize() async {
    Routes.User? databaseUser = await auth.getUserDBInfo();

    listOfSkin = await auth.getSkins().then((value) => value.skins);
    listOfFigures = await auth.getFigures().then((value) => value.figures);
    listOfFigureInstances = await auth
        .getFigureInstances(databaseUser!)
        .then((value) => value.figureInstances);
    listOfSkinInstances = await auth
        .getSkinInstances(databaseUser)
        .then((value) => value.skinInstances);

    String stringCur = databaseUser.currency.toString();
    currency = int.parse(stringCur);
    logger.i("Currency: $currency");
    // Check to see if mounted to prevent crash from exiting menu too fast
    if (mounted) {
      setState(() {
        listOfFigures = listOfFigures;
      });
    }
  }

  void showSkinView(String figureName) {
    print("Showing skin view for figure: $figureName");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Colors.grey[900],
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height *
                  0.8, // Set the height to 80% of the screen height
              child: ChangeNotifierProvider(
                  create: (context) => FigureInstancesProvider(),
                  child: SkinViewer(
                      listOfSkins: listOfSkin,
                      listOfSkinInstances: listOfSkinInstances,
                      figureName: figureName,
                      listOfFigureInstances: listOfFigureInstances)),
            ));
      },
    );
  }

  void addSkinInstance(
      BuildContext context, Routes.SkinInstance skinInstance) async {
    await auth.createSkinInstance(skinInstance);
    logger.i("Added skin instance to user's inventory.");
  }

  void subtractCurrency(BuildContext context, int subtractCurrency) async {
    Routes.User databaseUser = Provider.of<UserModel>(context, listen: false)
        .user!; // Changed to use provider
    int currentCurrency = databaseUser.currency.toInt();
    logger.i(
        "Subtracting user's currency on purchase. Amount subtracted: $subtractCurrency");
    int updateCurrency = currentCurrency - subtractCurrency;
    if (updateCurrency < 0) {
      logger.i("Not enough currency to complete transaction.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Not enough currency to complete this purchase!")),
        );
        return;
      }
    }
    databaseUser.currency = Int64(updateCurrency);
    await auth.updateUserDBInfo(databaseUser);
    if (mounted) {
      Provider.of<CurrencyModel>(context, listen: false)
          .setCurrency(updateCurrency.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      //permanent top bar if we want it
      appBar: AppBar(
        title: InkWell(
          onTap: () => context.goNamed("Home"),
          child: Text(
            'FF',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              onTap: () => context.goNamed('SkinStore'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<CurrencyModel>(
                    builder: (context, currencyModel, child) {
                      return Text(currencyModel.currency,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ));
                    },
                  ),
                  const SizedBox(width: 10.0),
                  Icon(
                    Icons.currency_exchange,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
            ),
          ),

          //question mark area that displays an alert on tap
          InkWell(
              onTap: () => {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Questions?"),
                            content: const Text(
                                '''Fitness figure is a gamified fitness motivation app that aims to combat inactivity and health problems every where. If you have any questions feel free to reach out to us at our email: \n\n\t\t\t\t\t\t\t\tfitnessfigure@gmail.com'''),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Get Fit")),
                            ],
                          );
                        })
                  },
              child: Row(
                children: [
                  const SizedBox(width: 10.0),
                  Icon(Icons.question_mark,
                      color: Theme.of(context).colorScheme.onSurface),
                  const SizedBox(width: 4.0),
                ],
              ))
        ],
      ),

      body: SingleChildScrollView(
        child: (Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Text("Figure Store",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
            const SizedBox(height: 10),
            Column(
              // generates the store as a bunch of rows with 2 elements each from the array above
              children: List.generate(
                  (listOfFigures.length / 2).floor(),
                  (index) => Column(children: [
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 5),
                            Consumer<UserModel>(
                              builder: (context, userModel, child) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Robot 1
                                        FigureStoreItem(
                                          owned: listOfFigureInstances.any(
                                              (instance) =>
                                                  instance.figureName ==
                                                  listOfFigures[index * 2]
                                                      .figureName),
                                          photoPath:
                                              "${listOfFigures[index * 2].figureName}/${listOfFigures[index * 2].figureName}_skin0_evo0_cropped_happy",
                                          itemPrice: int.parse(
                                              listOfFigures[index * 2]
                                                  .price
                                                  .toString()),
                                          onOpenSkin:
                                              (context, price, skinSkinName) {
                                            subtractCurrency(context, price);
                                            if (userModel.user!.currency >=
                                                price) {
                                              auth.createFigureInstance(
                                                  Routes.FigureInstance(
                                                figureName:
                                                    listOfFigures[index * 2]
                                                        .figureName,
                                                curSkin: "0",
                                                userEmail:
                                                    userModel.user?.email,
                                                lastReset:
                                                    "2001-09-04 19:21:00",
                                                evPoints: 0,
                                                charge: 70,
                                              ));
                                            }
                                          },
                                          onViewSkin: null,
                                          // onViewSkin: (context, figureName) {
                                          //   print("Viewing skin for figure: $figureName");
                                          //   showSkinView(
                                          //       listOfFigures[index * 2]
                                          //           .figureName);
                                          // },
                                          skinName: "",
                                          figureName: listOfFigures[index * 2]
                                              .figureName,
                                        ),
                                        const SizedBox(width: 15),
                                        // Robot 2
                                        FigureStoreItem(
                                          skinName: "",
                                          owned: listOfFigureInstances.any(
                                              (instance) =>
                                                  instance.figureName ==
                                                  listOfFigures[index * 2 + 1]
                                                      .figureName),
                                          photoPath:
                                              "${listOfFigures[index * 2 + 1].figureName}/${listOfFigures[index * 2 + 1].figureName}_skin0_evo0_cropped_happy",
                                          itemPrice: int.parse(
                                              listOfFigures[index * 2 + 1]
                                                  .price
                                                  .toString()),
                                          isLocked:
                                              false, //Provider.of<FigureModel>(context, listen: false).figure!.evLevel < 5 ? true : false,
                                          onOpenSkin:
                                              (context, price, skinSkinName) {
                                            subtractCurrency(context, price);
                                            if (userModel.user!.currency >=
                                                price) {
                                              auth.createFigureInstance(
                                                  Routes.FigureInstance(
                                                figureName:
                                                    listOfFigures[index * 2 + 1]
                                                        .figureName,
                                                curSkin: "0",
                                                userEmail:
                                                    userModel.user?.email,
                                                lastReset:
                                                    "2001-09-04 19:21:00",
                                                evPoints: 0,
                                                charge: 70,
                                              ));
                                            }
                                          },
                                          onViewSkin: (context, skinName) {
                                            
                                            showSkinView(
                                                listOfFigures[index * 2 + 1]
                                                    .figureName);
                                          },
                                          figureName:
                                              listOfFigures[index * 2 + 1]
                                                  .figureName,
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                      ])),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () => context.goNamed('Home'),
                child: const Text("Go Home")),
            const SizedBox(
              height: 40,
            )
          ],
        )),
      ),
    );
  }
}
