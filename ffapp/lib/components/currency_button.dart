import 'package:flutter/material.dart';

class CurrencyButton extends StatelessWidget {
  const CurrencyButton({super.key});

  void clickCurrency() {

  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add_alert),
      tooltip: 'Show Snackbar',
      onPressed: clickCurrency
    );
  }
}