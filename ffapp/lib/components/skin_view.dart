import 'package:ffapp/components/figure_store_skin_item.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/pages/home/store.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/components/robot_image_holder.dart';

class SkinViewer extends StatefulWidget {
  final List<Routes.Skin> listOfSkins;
  final List<Routes.FigureInstance> listOfFigureInstances;
  final List<Routes.SkinInstance> listOfSkinInstances;
  final String figureName;

  const SkinViewer({
    Key? key,
    required this.listOfSkins,
    required this.listOfSkinInstances,
    required this.figureName,
    required this.listOfFigureInstances,
  }) : super(key: key);

  @override
  _SkinViewerState createState() => _SkinViewerState();
}

class _SkinViewerState extends State<SkinViewer> {
  late AuthService auth;
  late UserModel userModel;
  int currentSkinIndex = 0;
  late String figureName;
  late int selectedFigureIndex;

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
    userModel = Provider.of<UserModel>(context, listen: false);
    selectedFigureIndex =
        Provider.of<SelectedFigureProvider>(context, listen: false)
            .selectedFigureIndex;
    figureName = widget.listOfFigureInstances[selectedFigureIndex].figureName;
    print("SkinViewer initialized with figureName: ${widget.figureName}");
    print("listOfSkins: ${widget.listOfSkins}");
    print("listOfFigureInstances: ${widget.listOfFigureInstances}");
  }

  void showOverlayAlert(
      BuildContext context, String message, MaterialColor color, int offset) {
    OverlayEntry overlayEntry = OverlayEntry(
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
  print("Equipping skin: $skinName for figure: $figureName");
  int selectedIndex = Provider.of<SelectedFigureProvider>(context, listen: false).selectedFigureIndex;
  
  // Update the FigureInstancesProvider
  Provider.of<FigureInstancesProvider>(context, listen: false)
    .setFigureInstanceCurSkin(figureName, skinName, selectedIndex);
  
  // Update the SelectedFigureProvider
  Provider.of<FigureModel>(context, listen: false)
    .setFigureSkin(skinName.substring(4));

  // Update the backend
  auth.updateFigureInstance(Routes.FigureInstance(
    figureName: figureName,
    curSkin: skinName.substring(4),
    userEmail: userModel.user?.email,
  )).then((_) {
    print("Figure instance updated in backend for $figureName");
    
    // Force a rebuild of the entire inventory
    Provider.of<SelectedFigureProvider>(context, listen: false).notifyListeners();
  });
}

  void purchaseSkin(BuildContext context, int price, String skinSkinName,
      String figureSkinName, bool owned) async {
    String currency =
        Provider.of<CurrencyModel>(context, listen: false).currency;
    double curCurrency = double.parse(currency);
    if (curCurrency >= price && owned == false) {
      Provider.of<CurrencyModel>(context, listen: false)
          .setCurrency((curCurrency - price).toString());
      await auth.createSkinInstance(Routes.SkinInstance(
          userEmail: userModel.user?.email,
          skinName: skinSkinName,
          figureName: figureSkinName));
      Provider.of<UserModel>(context, listen: false).user?.currency =
          Int64((curCurrency - price).toInt());
      await auth.updateUserDBInfo(userModel.user!);

      // Update the local list of skin instances
      setState(() {
        widget.listOfSkinInstances.add(Routes.SkinInstance(
            userEmail: userModel.user?.email,
            skinName: skinSkinName,
            figureName: figureSkinName));
      });

      showOverlayAlert(context, "Skin purchased!", Colors.green, 73);

      // Automatically equip the newly purchased skin
      equipSkin(context, figureSkinName, skinSkinName);
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
      currentSkinIndex = (currentSkinIndex - 1 + widget.listOfSkins.length) % 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FigureInstancesProvider>(
      builder: (context, equippedSkin, _) {
        Provider.of<FigureInstancesProvider>(context, listen: true)
            .initializeListOfFigureInstances(widget.listOfFigureInstances);

        Routes.Skin skin = widget.listOfSkins[currentSkinIndex];
        bool owned = widget.listOfSkinInstances
            .any((element) => element.skinName == skin.skinName);

        return Container(
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 1,
                  child: currentSkinIndex == 1
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            // Left robot (green)
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Opacity(
                                opacity: 0.3,
                                child: RobotImageHolder(
                                  url:
                                      '$figureName/${figureName}_skin0_evo0_cropped_happy',
                                  height:
                                      MediaQuery.of(context).size.height * 0.50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                ),
                              ),
                            ),

                            Positioned(
                              top: 0,
                              right: 0,
                              child: Opacity(
                                opacity: 0.3,
                                child: RobotImageHolder(
                                  url:
                                      '$figureName/${figureName}_skin0_evo0_cropped_happy',
                                  height:
                                      MediaQuery.of(context).size.height * 0.50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                ),
                              ),
                            ),
                            Positioned(
                              // Center robot
                              top: 0,
                              child: RobotImageHolder(
                                url:
                                    '$figureName/${figureName}_skin1_evo0_cropped_happy',
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: MediaQuery.of(context).size.width * 0.5,
                              ),
                              // Right robot (green)
                            ),
                            // Left arrow
                            Positioned(
                              left: 10,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back_ios,
                                    color: Colors.white),
                                onPressed: previousSkin,
                              ),
                            ),
                            // Right arrow
                            Positioned(
                              right: 10,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_forward_ios,
                                    color: Colors.white),
                                onPressed: nextSkin,
                              ),
                            ),
                          ],
                        )
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            // Left robot (green)
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Opacity(
                                opacity: 0.3,
                                child: RobotImageHolder(
                                  url:
                                      '$figureName/${figureName}_skin1_evo0_cropped_happy',
                                  height:
                                      MediaQuery.of(context).size.height * 0.50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                ),
                              ),
                            ),

                            Positioned(
                              top: 0,
                              right: 0,
                              child: Opacity(
                                opacity: 0.3,
                                child: RobotImageHolder(
                                  url:
                                      '$figureName/${figureName}_skin1_evo0_cropped_happy',
                                  height:
                                      MediaQuery.of(context).size.height * 0.50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                ),
                              ),
                            ),
                            Positioned(
                              // Center robot
                              top: 0,
                              child: RobotImageHolder(
                                url:
                                    '$figureName/${figureName}_skin0_evo0_cropped_happy',
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: MediaQuery.of(context).size.width * 0.5,
                              ),
                              // Right robot (green)
                            ),
                            // Left arrow
                            Positioned(
                              left: 10,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back_ios,
                                    color: Colors.white),
                                onPressed: previousSkin,
                              ),
                            ),
                            // Right arrow
                            Positioned(
                              right: 10,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_forward_ios,
                                    color: Colors.white),
                                onPressed: nextSkin,
                              ),
                            ),
                          ],
                        )),
              Container(
                width: MediaQuery.of(context).size.width * 0.65,
                height: MediaQuery.of(context).size.height * 0.22,
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.white, width: 0.5))),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  // There is no skin.description text to use, so I did this approach, but I suggest adding a place to define these elsewhere
                  child: Text(
                    figureName == "robot1" && currentSkinIndex == 0
                        ? 'The original skin with the original figure. You really can\'t go wrong with the classics and this one comes with the default green theme.'
                        : figureName == "robot1" && currentSkinIndex == 1
                            ? 'For those who believe in pretty in pink, this figure and theme combo does not disappoint!'
                            : figureName == "robot2" && currentSkinIndex == 0
                                ? 'Text for robot 2 default skin description'
                                : 'Text for robot 2 skin 1 description',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.primary.withAlpha(100),
                      blurRadius: 10.0,
                      spreadRadius: 1.0,
                      offset: const Offset(
                        0.0,
                        0.0,
                      ),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => !owned
                      ? purchaseSkin(
                          context,
                          skin.price,
                          skin.skinName,
                          figureName,
                          owned,
                        )
                      : equipSkin(context, figureName, skin.skinName),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.6,
                      MediaQuery.of(context).size.height * 0.07,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  child: Text(
                    owned
                        ? (equippedSkin
                                        .listOfFigureInstances[
                                            Provider.of<SelectedFigureProvider>(
                                                    context,
                                                    listen: false)
                                                .selectedFigureIndex]
                                        .curSkin ==
                                    skin.skinName.substring(4) &&
                                equippedSkin
                                        .listOfFigureInstances[
                                            Provider.of<SelectedFigureProvider>(
                                                    context,
                                                    listen: false)
                                                .selectedFigureIndex]
                                        .figureName ==
                                    figureName)
                            ? 'Equipped'
                            : 'Equip'
                        : 'Purchase',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            ],
          ),
        );
      },
    );
  }
}
