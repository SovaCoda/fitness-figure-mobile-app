import 'dart:async';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:ffapp/components/research_option.dart';
import 'package:ffapp/components/robot_line_painter.dart';

class Core extends StatefulWidget {
  const Core({super.key});

  @override
  State<Core> createState() => CoreState();
}

class CoreState extends State<Core> {
  late FigureModel figure = FigureModel();
  late final CurrencyModel currency;
  late final Timer currencyGenTimer;
  late final UserModel user;
  late int? currencyIncrement;
  late final AuthService auth;

  void handleCurrencyUpdate() {
    currency.addToCurrency(currencyIncrement!);
  }

  int getCurrencyIncrement(FigureModel figure) {
    int currencyIncrement = 0;
    currencyIncrement = figure.EVLevel + 1;
    return currencyIncrement;
  }

  void reactivateGenerationServer() async {
    // reactivates the generation of value by getting the last logged time of generation on the server and interpolating between then and now
    Routes.User? user = await auth.getUserDBInfo();
    currency.setCurrency(user!.currency.toString());
    Routes.OfflineDateTime lastLoggedGeneration = await auth
        .getOfflineDateTime(Routes.OfflineDateTime(email: user.email));
    DateTime parsedDateTime = DateTime.parse(lastLoggedGeneration.currency);
    Duration difference = DateTime.now().difference(parsedDateTime);
    if (difference.inSeconds < 0) {
      auth.updateCurrency(0);
    }
    else{
    currency.addToCurrency(difference.inSeconds * currencyIncrement!);
    auth.updateCurrency(int.parse(currency.currency));
    }
  }

  void deactivateGenerationServer() {
    // deactivates the generation of the value by updating the currency and then updating the offline tracker's datetime
    auth.updateCurrency(
        int.parse(currency.currency)); // commit the current currency
    auth.updateOfflineDateTime(Routes.OfflineDateTime(
        email: user.user!.email,
        currency: DateTime.now()
            .toString())); // commit the current datetime for offline generation
  }

  @override
  initState() {
    super.initState;
    currencyIncrement = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialize();
    });
  }

  void initialize() async {
    currency = Provider.of<CurrencyModel>(context, listen: false);
    currencyGenTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      handleCurrencyUpdate();
    });
    await Future.delayed(const Duration(
        milliseconds:
            500)); // allow time for figure instance to be filled out by dashboard
    auth = Provider.of<AuthService>(context, listen: false);
    user = Provider.of<UserModel>(context, listen: false);
    figure = Provider.of<FigureModel>(context, listen: false);
    currencyIncrement = getCurrencyIncrement(figure);
    reactivateGenerationServer();
    setState(() {
      currencyIncrement = currencyIncrement;
    });
  }

  @override
  void dispose() {
    super.dispose();
    currencyGenTimer.cancel();
    deactivateGenerationServer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width * 0.5,
                        MediaQuery.of(context).size.height * 0.3),
                    painter: RobotLinePainter(),
                  ),
                  RobotImageHolder(
                    url: (figure.figure != null)
                        ? ("${figure.figure!.figureName}/${figure.figure!.figureName}_skin${figure.figure!.curSkin}_evo${figure.EVLevel}_cropped_happy")
                        : "robot1/robot1_skin0_evo0_cropped_happy",
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10, top: 10, right: 30),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).colorScheme.primary),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                minRadius: 75,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: Column(
                  children: [
                    Text('EVO ${figure.EVLevel}',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                    Text('\$${getCurrencyIncrement(figure)}/sec',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface)),
                    Text(
                        '\$${Provider.of<CurrencyModel>(context, listen: true).currency}',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface)),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.465,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.02,
                    bottom: MediaQuery.of(context).size.height * 0.02,
                    right: MediaQuery.of(context).size.width * 0.02),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                            width: 1))),
                child: Text('Research',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 24)),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ResearchOption(
                        title: 'Optimize Processors',
                        chance: 34,
                        ev: 40,
                        duration: Duration(seconds: 30),
                      ),
                      ResearchOption(
                        title: 'Shine Tracks',
                        chance: 12,
                        ev: 200,
                        duration: Duration(minutes: 1),
                      ),
                      ResearchOption(
                        title: 'Upgrade Coolants',
                        chance: 4,
                        ev: 550,
                        duration: Duration(minutes: 2),
                      ),
                      // Add more ResearchOption widgets here as needed
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
