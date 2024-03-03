import 'package:flutter/material.dart';

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
          color: Theme.of(context).colorScheme.secondaryContainer),
      child: (Column(
        children: [
          const SizedBox(height: 25),
          Image.asset(
            "lib/assets/icons/" + photoPath + ".gif",
            height: 170.0,
            width: 170.0,
          ),
          const SizedBox(height: 10),
          Text('Price: $itemPrice',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer)),
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
