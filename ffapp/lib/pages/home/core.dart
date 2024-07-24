import 'dart:async';

import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Core extends StatefulWidget {
  const Core({super.key});

  @override
  State<Core> createState() => CoreState();
}

class CoreState extends State<Core> {
  late final FigureModel figure;
  late final CurrencyModel currency; 
  late final Timer currencyGenTimer;
  late int currencyIncrement;
  late final AuthService auth;

  void handleCurrencyUpdate () {
    currency.addToCurrency(currencyIncrement);
  }

  int getCurrencyIncrement (FigureModel figure) {
    int currencyIncrement = 0;
    currencyIncrement = figure.EVLevel + 1;
    return currencyIncrement;
  }

  void reactivateGenerationServer(){ // reactivates the generation of value by getting the last logged time of generation on the server and interpolating between then and now
    DateTime lastLoggedGeneration = auth.getCurrencyOfflineTracker();
    int secondDifference = DateTime.now() - lastLoggedGeneration;
    currency.addToCurrency(secondDifference * currencyIncrement);
  }


  void deactivateGenerationServer(){ // deactivates the generation of the value by updating the currency and then updating the offline tracker's datetime 
    auth.updateCurrency(int.parse(currency.currency)); // commit the current currency
    auth.updateCurrencyOfflineTracker(DateTime.now()); // commit the current datetime for offline generation
  }

  @override
  initState() {
    super.initState;
    figure = Provider.of<FigureModel>(context, listen: false);
    currency = Provider.of<CurrencyModel>(context, listen: false);
    currencyIncrement = getCurrencyIncrement(figure);
    reactivateGenerationServer();
    currencyGenTimer = Timer.periodic(const Duration(seconds: 1), (timer) {handleCurrencyUpdate();});
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
          Text('Evo Level ${figure.EVLevel} Generating $currencyIncrement/s', style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.primary),)
        ]));
    });
  }
  
}