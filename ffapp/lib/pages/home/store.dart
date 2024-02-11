import 'package:flutter/material.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:logger/logger.dart';
import 'package:ffapp/services/auth.dart';

var logger = Logger();

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  //add a skin's image path and its price to render it in the store
  final listOfSkins = [
    ["lib/assets/icons/robot1_skin0_cropped.gif", 100],
    ["lib/assets/icons/robot1_skin1_cropped.gif", 350],
    ["lib/assets/icons/robot2_skin0_cropped.gif", 100],
    ["lib/assets/icons/robot2_skin1_cropped.gif", 350],
    ["lib/assets/icons/robot1_skin0_cropped.gif", 100],
    ["lib/assets/icons/robot1_skin1_cropped.gif", 350],
  ];

  late AuthService auth;

  Future<void> initAuthService() async {
    auth = await AuthService.instance;
    logger.i("AuthService initialized");
  }

  FlutterUser user = FlutterUser();
  late int currency = 0;

  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await initAuthService();
    await user.initAuthService();
    await user.checkUser();
    String stringCur = await user.getCurrency();
    currency = int.parse(stringCur);
    logger.i("Currency: $currency");
  }

  void subtractCurrency(BuildContext context, int subtractCurrency) async {
    int currentCurrency = await user.getCurrencyInt();
    logger.i(
        "Subtracting user's currency on purchase. Amount subtracted: $subtractCurrency");
    int updateCurrency = currentCurrency - subtractCurrency;
    if (updateCurrency < 0) {
      logger.i("Not enough currency to complete transaction.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Not enough currency to complete this purchase!")),
      );
      return;
    }
    await auth.updateCurrency((currentCurrency - subtractCurrency));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: (Column(
        children: [
           Text(
            "Figure Store",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              )
          ),
          const SizedBox(height: 10),
          Column(
            // generates the store as a bunch of rows with 2 elements each from the array above
            // TO DO: if there are an odd number of skins it wont render the last one rn
            children: 
                List.generate(
                (listOfSkins.length / 2).floor(),
                (index) => 
                    Column(
                      children: [
                        const SizedBox(height: 15),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 5),
                          StoreItem(
                              photoPath: listOfSkins[index * 2][0].toString(),
                              itemPrice:
                                  int.parse(listOfSkins[index * 2][1].toString()),
                              onBuySkin: (context, price) =>
                                  subtractCurrency(context, price)),
                          const SizedBox(width: 15),
                          StoreItem(
                              photoPath: listOfSkins[index * 2 + 1][0].toString(),
                              itemPrice: int.parse(
                                  listOfSkins[index * 2 + 1][1].toString()),
                              onBuySkin: (context, price) =>
                                  subtractCurrency(context, price)),
                          const SizedBox(width: 5),
                          ],
                        ),
                      ]
                    )
                ),
          ),
          const SizedBox(height: 30),
        ],
      )),
    );
  }
}

class StoreItem extends StatelessWidget {
  const StoreItem(
      {super.key,
      required this.photoPath,
      required this.itemPrice,
      required this.onBuySkin});

  final String photoPath;
  final int itemPrice;
  final Function(BuildContext, int) onBuySkin;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.secondaryContainer
      ),
      child: (Column(
        children: [
          const SizedBox(height: 25),
          Image.asset(
            photoPath,
            height: 170.0,
            width: 170.0,
          ),
          const SizedBox(height: 10),
          Text('Price: $itemPrice', 
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer
            )
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () => onBuySkin(context, itemPrice),
              child: const Text("Buy Skin")),
          const SizedBox(height: 5),
        ],
      )),
    );
  }
}
