import 'package:flutter/material.dart';

class Store extends StatelessWidget {
  Store({super.key});

  //add a skin's image path and its price to render it in the store
  final listOfSkins = [
    ["lib/assets/icons/robot1_skin0_cropped.gif", 100],
    ["lib/assets/icons/robot1_skin1_cropped.gif", 350],
    ["lib/assets/icons/robot2_skin0_cropped.gif", 100],
    ["lib/assets/icons/robot2_skin1_cropped.gif", 350]
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: (
        Column(
          children: [
            const Text(
              "Figure Store",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),

            Column(
            // generates the store as a bunch of rows with 2 elements each from the array above
            // TO DO: if there are an odd number of skins it wont render the last one rn
              children: List.generate((listOfSkins.length / 2).floor(), (index) => 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StoreItem(photoPath: listOfSkins[index*2][0].toString(), itemPrice: int.parse(listOfSkins[index*2][1].toString())),
                    StoreItem(photoPath: listOfSkins[index*2 + 1][0].toString(), itemPrice: int.parse(listOfSkins[index*2 + 1][1].toString()))
                  ],
                )
              ),
            ),
          ],
        )
      ),
    );
  }
}

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