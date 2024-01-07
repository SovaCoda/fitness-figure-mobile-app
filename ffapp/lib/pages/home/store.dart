
import 'package:ffapp/components/store_item.dart';
import 'package:flutter/material.dart';

class Store extends StatelessWidget {
  const Store({super.key});

  @override
  Widget build(BuildContext context) {
    return(
      const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StoreItem(
                photoPath: "lib/assets/icons/robot1_skin0_cropped.gif",
                itemPrice: 100),
              StoreItem(
                photoPath: "lib/assets/icons/robot1_skin1_cropped.gif", 
                itemPrice: 350)
            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StoreItem(
                photoPath: "lib/assets/icons/robot2_skin0_cropped.gif",
                itemPrice: 100),
              StoreItem(
                photoPath: "lib/assets/icons/robot2_skin1_cropped.gif", 
                itemPrice: 350)
            ]
          ),
        ],
      )
    );
  }
}