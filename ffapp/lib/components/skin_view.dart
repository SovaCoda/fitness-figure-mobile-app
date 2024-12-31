import 'package:ffapp/components/ff_app_button.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/pages/home/store.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart' as routes;
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class SkinViewer extends StatefulWidget {
  // final List<Routes.Skin> listOfSkins;
  // final List<Routes.FigureInstance> listOfFigureInstances;
  // final List<Routes.SkinInstance> listOfSkinInstances;
  // final String figureName;

  const SkinViewer({
    super.key,
    // required this.listOfSkins,
    // required this.listOfSkinInstances,
    // required this.figureName,
    // required this.listOfFigureInstances,
  });

  @override
  SkinViewerState createState() => SkinViewerState();
}

class SkinViewerState extends State<SkinViewer> {
  late AuthService auth;
  late UserModel userModel;
  late List<routes.Skin> listOfSkins;
  late List<routes.FigureInstance> listOfFigureInstances;
  late List<routes.SkinInstance> listOfSkinInstances;
  int currentSkinIndex = 0;
  late String figureName;
  late int selectedFigureIndex = 0;
  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
    listOfFigureInstances = [];
    listOfSkinInstances = [];
    listOfSkins = [];
    figureName = "robot1";
    initialize();
  }

  Future<void> initialize() async {
    final routes.User? databaseUser = await auth.getUserDBInfo();
    listOfFigureInstances = await auth
        .getFigureInstances(databaseUser!)
        .then((value) => value.figureInstances);
    listOfSkins = await auth.getSkins().then((value) => value.skins);
    if (mounted) {
      userModel = Provider.of<UserModel>(context, listen: false);
      selectedFigureIndex =
          Provider.of<SelectedFigureProvider>(context, listen: false)
              .selectedFigureIndex;
    }

    final List<routes.SkinInstance>? skinInstances;
    if (mounted) {
      skinInstances = await auth
          .getSkinInstances(
            userModel.user!,
          )
          .then((value) => value.skinInstances);
    } else {
      skinInstances = null;
    }

    figureName = listOfFigureInstances[selectedFigureIndex].figureName;
    listOfSkinInstances = skinInstances ?? [];
    logger.i("SkinViewer initialized with figureName: $figureName");
    logger.i("listOfSkins: $listOfSkins");
    logger.i("listOfFigureInstances: $listOfFigureInstances");
  }

  void showOverlayAlert(
    BuildContext context,
    String message,
    MaterialColor color,
    int offset,
  ) {
    final OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 30,
        left: MediaQuery.sizeOf(context).width / 2 - offset,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2))
        .then((_) => overlayEntry.remove());
  }

  void equipSkin(BuildContext context, String figureName, String skinName) {
    logger.i("Equipping skin: $skinName for figure: $figureName");
    final int selectedIndex =
        Provider.of<SelectedFigureProvider>(context, listen: false)
            .selectedFigureIndex;

    // Update the FigureInstancesProvider
    Provider.of<FigureInstancesProvider>(context, listen: false)
        .setFigureInstanceCurSkin(figureName, skinName, selectedIndex);

    // Update the SelectedFigureProvider
    Provider.of<FigureModel>(context, listen: false)
        .setFigureSkin(skinName.substring(4));

    // Update the backend
    auth
        .updateFigureInstance(
      routes.FigureInstance(
        figureName: figureName,
        curSkin: skinName.substring(4),
        userEmail: userModel.user?.email,
      ),
    )
        .then((_) {
      logger.i("Figure instance updated in backend for $figureName");

      // Force a rebuild of the entire inventory
      Provider.of<SelectedFigureProvider>(context, listen: false);
    });
  }

  Future<void> purchaseSkin(
    BuildContext context,
    int price,
    String skinSkinName,
    String figureSkinName,
    bool owned,
  ) async {
    final String currency =
        Provider.of<CurrencyModel>(context, listen: false).currency;
    final double curCurrency = double.parse(currency);
    if (curCurrency >= price && owned == false) {
      Provider.of<CurrencyModel>(context, listen: false)
          .setCurrency((curCurrency - price).toString());
      await auth.createSkinInstance(
        routes.SkinInstance(
          userEmail: userModel.user?.email,
          skinName: skinSkinName,
          figureName: figureSkinName,
        ),
      );
      if (context.mounted) {
        Provider.of<UserModel>(context, listen: false).user?.currency =
            Int64((curCurrency - price).toInt());
      }
      await auth.updateUserDBInfo(userModel.user!);

      // Update the local list of skin instances
      setState(() {
        listOfSkinInstances.add(
          routes.SkinInstance(
            userEmail: userModel.user?.email,
            skinName: skinSkinName,
            figureName: figureSkinName,
          ),
        );
      });
      if (context.mounted) {
        showOverlayAlert(context, "Skin purchased!", Colors.green, 73);

        // Automatically equip the newly purchased skin
        equipSkin(context, figureSkinName, skinSkinName);
      }
    } else if (owned == true) {
      showOverlayAlert(context, "Skin already owned!", Colors.red, 90);
    } else {
      showOverlayAlert(context, "Not enough currency!", Colors.red, 90);
    }
  }

  void nextSkin() {
    setState(() {
      currentSkinIndex = (currentSkinIndex + 1) % 2;
    });
  }

  void previousSkin() {
    setState(() {
      currentSkinIndex = (currentSkinIndex - 1 + listOfSkins.length) % 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    // a raise of hands if you knew this consumer existed
    return Consumer2<SelectedFigureProvider, FigureInstancesProvider>(
      builder: (context, selectedFigureProvider, equippedSkin, _) {
        // Re-initialize when selected figure changes
        if (selectedFigureIndex != selectedFigureProvider.selectedFigureIndex) {
          selectedFigureIndex = selectedFigureProvider.selectedFigureIndex;
          if (listOfFigureInstances.isNotEmpty) {
            figureName = listOfFigureInstances[selectedFigureIndex].figureName;
          }
          // Reset current skin index when figure changes
          currentSkinIndex = 0;
        }

        equippedSkin.initializeListOfFigureInstances(listOfFigureInstances);

        final routes.Skin skin = listOfSkins.isNotEmpty
            ? listOfSkins[currentSkinIndex]
            : routes.Skin();
        final bool owned = listOfSkinInstances
            .any((element) => element.skinName == skin.skinName);

        return Container(
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.473,
                width: MediaQuery.of(context).size.width * 1,
                child: currentSkinIndex == 1
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          // Left robot (green)
                          // Positioned(
                          //   left: 0,
                          //   top: 0,
                          //   child: Opacity(
                          //     opacity: 0.3,
                          //     child: RobotImageHolder(
                          //       url:
                          //           '$figureName/${figureName}_skin0_evo0_cropped_happy',
                          //       height:
                          //           MediaQuery.of(context).size.height * 0.50,
                          //       width:
                          //           MediaQuery.of(context).size.width * 0.35,
                          //     ),
                          //   ),
                          // ),
                          // right robot
                          // Positioned(
                          //   top: 0,
                          //   right: 0,
                          //   child: Opacity(
                          //     opacity: 0.3,
                          //     child: RobotImageHolder(
                          //       url:
                          //           '$figureName/${figureName}_skin0_evo0_cropped_happy',
                          //       height:
                          //           MediaQuery.of(context).size.height * 0.50,
                          //       width:
                          //           MediaQuery.of(context).size.width * 0.35,
                          //     ),
                          //   ),
                          // ),
                          Positioned(
                            // Center robot
                            top: 0,
                            child: RobotImageHolder(
                              url:
                                  '$figureName/${figureName}_skin0_evo0_cropped_happy', // would be skin1, but we have no skins
                              height: MediaQuery.of(context).size.height * 0.5,
                              width: MediaQuery.of(context).size.width * 0.5,
                            ),
                            // Right robot (green)
                          ),
                          // Left arrow
                          Positioned(
                            left: 10,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: previousSkin,
                            ),
                          ),
                          // Right arrow
                          Positioned(
                            right: 10,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                              onPressed: nextSkin,
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          // Left robot (green)
                          // Positioned(
                          //   left: 0,
                          //   top: 0,
                          //   child: Opacity(
                          //     opacity: 0.3,
                          //     child: RobotImageHolder(
                          //       url:
                          //           '$figureName/${figureName}_skin1_evo0_cropped_happy',
                          //       height:
                          //           MediaQuery.of(context).size.height * 0.50,
                          //       width:
                          //           MediaQuery.of(context).size.width * 0.35,
                          //     ),
                          //   ),
                          // ),
                          // right robot
                          // Positioned(
                          //   top: 0,
                          //   right: 0,
                          //   child: Opacity(
                          //     opacity: 0.3,
                          //     child: RobotImageHolder(
                          //       url:
                          //           '$figureName/${figureName}_skin1_evo0_cropped_happy',
                          //       height:
                          //           MediaQuery.of(context).size.height * 0.50,
                          //       width:
                          //           MediaQuery.of(context).size.width * 0.35,
                          //     ),
                          //   ),
                          // ),
                          Positioned(
                            // Center robot
                            top: 0,
                            child: RobotImageHolder(
                              url:
                                  '$figureName/${figureName}_skin0_evo0_cropped_happy',
                              height: MediaQuery.of(context).size.height * 0.5,
                              width: MediaQuery.of(context).size.width * 0.5,
                            ),
                            // Right robot (green)
                          ),
                          // Left arrow
                          Positioned(
                            left: 10,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: previousSkin,
                            ),
                          ),
                          // Right arrow
                          Positioned(
                            right: 10,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                              onPressed: nextSkin,
                            ),
                          ),
                        ],
                      ),
              ),
              // gradient container part
              Container(
                padding: const EdgeInsets.only(
                    left: 40, top: 12, bottom: 12, right: 40),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Color.fromRGBO(51, 133, 162, 1))),
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(28, 109, 189, 0.29),
                    Color.fromRGBO(0, 164, 123, 0.29)
                  ]),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      // There is no skin.description text to use, so I did this approach, but I suggest adding a place to define these elsewhere
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Text(
                          figureName == "robot1" && currentSkinIndex == 0
                              ? "The original skin with the original figure. You really can't go wrong with the classics and this one comes with the default green theme."
                              : figureName == "robot1" && currentSkinIndex == 1
                                  ? 'For those who believe in pretty in pink, this figure and theme combo does not disappoint!'
                                  : figureName == "robot2" &&
                                          currentSkinIndex == 0
                                      ? 'Text for robot 2 default skin description'
                                      : 'Text for robot 2 skin 1 description',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Text(
                      owned ? "Purchased" : '\$${skin.price}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    FFAppButton(
                      text: owned
                          ? (equippedSkin
                                          .listOfFigureInstances[Provider.of<
                                              SelectedFigureProvider>(
                                        context,
                                        listen: false,
                                      ).selectedFigureIndex]
                                          .curSkin ==
                                      skin.skinName.substring(4) &&
                                  equippedSkin
                                          .listOfFigureInstances[Provider.of<
                                              SelectedFigureProvider>(
                                        context,
                                        listen: false,
                                      ).selectedFigureIndex]
                                          .figureName ==
                                      figureName)
                              ? 'Equipped'
                              : 'Equip'
                          : 'Purchase',
                      size: MediaQuery.of(context).size.width *
                          0.79389312977099236641221374045802,
                      height: MediaQuery.of(context).size.height *
                          0.08098591549295774647887323943662,
                      onPressed: () => !owned
                          ? purchaseSkin(
                              context,
                              skin.price,
                              skin.skinName,
                              figureName,
                              owned,
                            )
                          : equipSkin(context, figureName, skin.skinName),
                      // child: Text(
                      //   owned
                      //       ? (equippedSkin
                      //                       .listOfFigureInstances[
                      //                           Provider.of<SelectedFigureProvider>(
                      //                                   context,
                      //                                   listen: false)
                      //                               .selectedFigureIndex]
                      //                       .curSkin ==
                      //                   skin.skinName.substring(4) &&
                      //               equippedSkin
                      //                       .listOfFigureInstances[
                      //                           Provider.of<SelectedFigureProvider>(
                      //                                   context,
                      //                                   listen: false)
                      //                               .selectedFigureIndex]
                      //                       .figureName ==
                      //                   figureName)
                      //           ? 'Equipped'
                      //           : 'Equip'
                      //       : 'Purchase',
                      //   style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      //         color: Theme.of(context).colorScheme.onPrimary,
                      //       ),
                      // ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
