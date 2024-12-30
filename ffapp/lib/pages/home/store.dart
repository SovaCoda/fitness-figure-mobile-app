import 'package:ffapp/components/animated_button.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart' as routes;
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

var logger = Logger();

class FigureInstancesProvider extends ChangeNotifier {
  late List<routes.FigureInstance> listOfFigureInstances;
  void initializeListOfFigureInstances(
    List<routes.FigureInstance> listOfFigureInstances,
  ) {
    this.listOfFigureInstances = listOfFigureInstances;
  }

  void setFigureInstanceCurSkin(
    String figureName,
    String curSkin,
    int selectedFigureIndex,
  ) {
    listOfFigureInstances[selectedFigureIndex].curSkin = curSkin.substring(4);
    notifyListeners();
  }

  void setFigureInstanceCharge(int selectedFigureIndex, int charge) {
    listOfFigureInstances[selectedFigureIndex].charge = charge;
    notifyListeners();
  }

  void setFigureInstanceEV(int selectedFigureIndex, int evPoints) {
    listOfFigureInstances[selectedFigureIndex].evPoints = evPoints;
    notifyListeners();
  }
}

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  late List<routes.Figure> listOfFigures = List.empty();
  late List<routes.FigureInstance> listOfFigureInstances = List.empty();
  late AuthService auth;
  late int currency = 0;
  int currentFigureIndex = 0;

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
    initialize();
  }

  Future<void> initialize() async {
    final routes.User? databaseUser = await auth.getUserDBInfo();

    listOfFigures = await auth.getFigures().then((value) => value.figures);
    listOfFigureInstances = await auth
        .getFigureInstances(databaseUser!)
        .then((value) => value.figureInstances);

    final String stringCur = databaseUser.currency.toString();
    currency = int.parse(stringCur);
    logger.i("Currency: $currency");

    if (mounted) {
      setState(() {});
    }
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

  void nextFigure() {
    setState(() {
      currentFigureIndex = (currentFigureIndex + 1) % listOfFigures.length;
    });
  }

  void previousFigure() {
    setState(() {
      currentFigureIndex = (currentFigureIndex - 1 + listOfFigures.length) %
          listOfFigures.length;
    });
  }

  Future<void> purchaseFigure(
      BuildContext context, int price, String figureName) async {
    if (listOfFigureInstances.length > 4) {
      showOverlayAlert(context, "Maximum figures reached!", Colors.red, 90);
      return;
    }

    final routes.User user =
        Provider.of<UserModel>(context, listen: false).user!;
    final int currentCurrency = user.currency.toInt();

    if (currentCurrency >= price) {
      // Update currency
      user.currency = Int64(currentCurrency - price);
      await auth.updateUserDBInfo(user);

      // Create figure instance
      await auth.createFigureInstance(
        routes.FigureInstance(
          figureName: figureName,
          curSkin: "0",
          userEmail: user.email,
          lastReset: "2001-09-04 19:21:00",
          evPoints: 0,
          charge: 70,
        ),
      );

      // Update state
      setState(() {
        listOfFigureInstances.add(
          routes.FigureInstance(
            figureName: figureName,
            curSkin: "0",
            userEmail: user.email,
          ),
        );
      });

      // Update currency in provider
      if (context.mounted) {
        Provider.of<CurrencyModel>(context, listen: false)
            .setCurrency((currentCurrency - price).toString());

        showOverlayAlert(context, "Figure purchased!", Colors.green, 73);
      }
    } else {
      showOverlayAlert(context, "Not enough currency!", Colors.red, 90);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Text(
          "Figure Store",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.39,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                child: RobotImageHolder(
                  url:
                      "${listOfFigures.isNotEmpty ? listOfFigures[currentFigureIndex].figureName : "robot1"}/${listOfFigures.isNotEmpty ? listOfFigures[currentFigureIndex].figureName : "robot1"}_skin0_evo0_cropped_happy",
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              ),
              Positioned(
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: previousFigure,
                ),
              ),
              Positioned(
                right: 10,
                child: IconButton(
                  icon:
                      const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: nextFigure,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding:
              const EdgeInsets.only(left: 40, top: 12, bottom: 12, right: 40),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.295,
          decoration: const BoxDecoration(
            border:
                Border(top: BorderSide(color: Color.fromRGBO(51, 133, 162, 1))),
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(28, 109, 189, 0.29),
                Color.fromRGBO(0, 164, 123, 0.29),
              ],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Text(
                    listOfFigures.isNotEmpty
                        ? listOfFigures[currentFigureIndex].figureName ==
                                "robot1"
                            ? 'The original figure - a classic design that combines style and functionality. Perfect for beginners and veterans alike.'
                            : 'A more advanced companion for those seeking an extra challenge. Unlock new possibilities with this sophisticated model.'
                        : 'The original figure - a classic design that combines style and functionality. Perfect for beginners and veterans alike.',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Text(
                '\$${listOfFigures.isNotEmpty ? listOfFigures[currentFigureIndex].price : "0"}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              FFAppButton(
                text: listOfFigureInstances.any(
                  (instance) =>
                      instance.figureName ==
                      listOfFigures[currentFigureIndex].figureName,
                )
                    ? 'Owned'
                    : 'Purchase',
                size: MediaQuery.of(context).size.width * 0.79,
                height: MediaQuery.of(context).size.height * 0.08,
                onPressed: () => listOfFigureInstances.any(
                  (instance) =>
                      instance.figureName ==
                      listOfFigures[currentFigureIndex].figureName,
                )
                    ? null
                    : purchaseFigure(
                        context,
                        int.parse(
                            listOfFigures[currentFigureIndex].price.toString()),
                        listOfFigures[currentFigureIndex].figureName,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
