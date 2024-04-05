import 'package:flutter/material.dart';

class StoreItem extends StatelessWidget {

  const StoreItem(
      {super.key,
      required this.photoPath,
      required this.itemPrice,
      required this.onBuySkin,
      required this.owned});

  final String photoPath;
  final int itemPrice;
  final Function(BuildContext, int) onBuySkin;
  final bool owned;

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
        ),
        child: Column(
          children: [
            const SizedBox(height: 25),
            Image.asset(
              "lib/assets/icons/" + photoPath + ".gif",
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
                ? Text('Owned',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ))
                : ElevatedButton(
                    onPressed: () => onBuySkin(context, itemPrice),
                    child: const Text("Buy Skin"),
                  ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
    }
}