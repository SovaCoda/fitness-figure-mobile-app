
import 'package:flutter/material.dart';

class StoreItem extends StatelessWidget {
  const StoreItem({
    super.key,
    required this.photoPath,
    required this.itemPrice
  });

  final String photoPath;
  final int itemPrice;

  void buySkin() {
    //TO DO ADD BUYING SKIN LOGIC
  }

  @override
  Widget build(BuildContext context) {
    return(
        Column(
          children: [
            const SizedBox(height: 25),
            Image.asset(
              photoPath,
              height: 180.0,
              width: 180.0,
            ),
            const SizedBox(height: 10),
            Text(
              'Price: $itemPrice',
              style: const TextStyle(color: Colors.grey)
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: buySkin, child: const Text("Buy Skin"))
          ]
      ,)
    );
  }
}