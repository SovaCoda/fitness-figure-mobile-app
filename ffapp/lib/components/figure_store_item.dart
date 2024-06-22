import 'package:flutter/material.dart';

class FigureStoreItem extends StatelessWidget {

  FigureStoreItem(
      {super.key,
      required this.photoPath,
      required this.itemPrice,
      required this.onOpenSkin,
      required this.owned,
      required this.skinName,
      required this.figureName,
      required this.onViewSkin});

  final String photoPath;
  final String figureName;
  final int itemPrice;
  final String skinName;
  final Function(BuildContext, int, String?) onOpenSkin;
  final Function(BuildContext, String) onViewSkin;
  bool owned;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: owned ? 0.5 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        child: Column(
          children: [
            const SizedBox(height: 25),
            Image.asset(
              "lib/assets/$photoPath.gif",
              height: 170.0,
              width: 170.0,
            ),
            const SizedBox(height: 10),
            Text(
              'Price: $itemPrice',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(height: 10),
            owned
                ? Column(
                  children: [
                    Text(
                    'Owned',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    ),
                    ElevatedButton(
                    onPressed: () {
                      onViewSkin(context, skinName);
                    },
                    child: const Text("View Skins"),
                    ),
                  ],
                  )
                : ElevatedButton(
                    onPressed: () => onOpenSkin(context, itemPrice, null),
                    child: const Text("Buy Skin"),
                  ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
    }
}