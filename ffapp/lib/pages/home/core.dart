import 'dart:async';

import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;



class Core extends StatefulWidget {
  const Core({super.key});

  @override
  State<Core> createState() => CoreState();
}

class CoreState extends State<Core> {
  late final FigureModel figure;
  late final CurrencyModel currency; 
  late final Timer currencyGenTimer;
  late final UserModel user;
  late int? currencyIncrement;
  late final AuthService auth;

  void handleCurrencyUpdate () {
    currency.addToCurrency(currencyIncrement!);
  }

  int getCurrencyIncrement (FigureModel figure) {
    int currencyIncrement = 0;
    currencyIncrement = figure.EVLevel + 1;
    return currencyIncrement;
  }

  void reactivateGenerationServer() async { // reactivates the generation of value by getting the last logged time of generation on the server and interpolating between then and now
    Routes.User? user = await auth.getUserDBInfo();
    currency.setCurrency(user!.currency.toString());
    Routes.OfflineDateTime lastLoggedGeneration = await auth.getOfflineDateTime(Routes.OfflineDateTime(email: user.email));
    DateTime parsedDateTime = DateTime.parse(lastLoggedGeneration.currency);
    Duration difference = DateTime.now().difference(parsedDateTime);
    currency.addToCurrency(difference.inSeconds * currencyIncrement!);
    auth.updateCurrency(int.parse(currency.currency));
  }


  void deactivateGenerationServer(){ // deactivates the generation of the value by updating the currency and then updating the offline tracker's datetime 
    auth.updateCurrency(int.parse(currency.currency)); // commit the current currency
    auth.updateOfflineDateTime(Routes.OfflineDateTime(email: user.user!.email, currency: DateTime.now().toString())); // commit the current datetime for offline generation
  }

  @override
  initState() {
    super.initState;
    currencyIncrement = 0;
    WidgetsBinding.instance!.addPostFrameCallback((_) { initialize();});
  }

  void initialize () async {
    currency = Provider.of<CurrencyModel>(context, listen: false);
    currencyGenTimer = Timer.periodic(const Duration(seconds: 1), (timer) {handleCurrencyUpdate();});
    await Future.delayed(Duration(milliseconds: 200)); // allow time for figure instance to be filled out by dashboard
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
    
    return Consumer<FigureModel>(builder: 
    (context, figure, child) {
        return Center(child: Column(children: [
          Text('Evo Level ${figure.EVLevel} Generating ${currencyIncrement ?? 0}/s', style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.primary),)
        ]));
    });
  }
  
}