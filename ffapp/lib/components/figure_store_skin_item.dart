import 'package:ffapp/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FigureStoreSkinItem extends StatefulWidget {
  final String photoPath;
  final String figureName;
  final int itemPrice;
  final String skinName;
  final Function(BuildContext, int, String?, String?, bool) onPurchaseSkin;
  final Function(BuildContext, String) onViewSkin;
  final Function(BuildContext, String, String) onEquipSkin;
  final bool initialOwned;  // Changed from 'owned' to 'initialOwned'
  final bool initialEquipped;  // Changed from 'equipped' to 'initialEquipped'

  const FigureStoreSkinItem({  // Added const constructor
    super.key,
    required this.photoPath,
    required this.itemPrice,
    required this.onPurchaseSkin,
    required this.initialOwned,
    required this.skinName,
    required this.figureName,
    required this.onViewSkin,
    required this.onEquipSkin,
    required this.initialEquipped,
  });

  @override
  FigureStoreSkinItemState createState() => FigureStoreSkinItemState();
}

class FigureStoreSkinItemState extends State<FigureStoreSkinItem> {
  late bool equipped;
  late bool owned;  // Moved the owned state here

  @override
  void initState() {
    super.initState();
    equipped = widget.initialEquipped;
    owned = widget.initialOwned;  // Initialize owned from widget's initial value
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.8,
      height: 900,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            "lib/assets/${widget.photoPath}.gif",
            height: 380.0,
            width: 380.0,
          ),
          Text(
            'Price: ${widget.itemPrice}',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
          ),
          if (owned)
            equipped
                ? ElevatedButton(
                    onPressed: () {
                      widget.onEquipSkin(
                        context,
                        widget.figureName,
                        widget.skinName,
                      );
                      setState(() {
                        equipped = true;
                      });
                    },
                    child: const Text("Equipped"),
                  )
                : ElevatedButton(
                    onPressed: () {
                      widget.onEquipSkin(
                        context,
                        widget.figureName,
                        widget.skinName,
                      );
                      setState(() {
                        equipped = true;
                      });
                      context.goNamed('Home');
                    },
                    child: const Text("Equip"),
                  )
          else
            ElevatedButton(
              onPressed: () {},
              child: const Text("Not Owned"),
            ),
          Opacity(
            opacity: !owned ? 1.0 : 0.5,
            child: ElevatedButton(
              onPressed: () {
                widget.onPurchaseSkin(
                  context,
                  widget.itemPrice,
                  widget.skinName,
                  widget.figureName,
                  owned,
                );
                setState(() {
                  if (Provider.of<UserModel>(context, listen: false)
                          .user!
                          .currency
                          .toInt() >=
                      widget.itemPrice) {
                    owned = true;
                  }
                });
              },
              child: !owned ? const Text("Buy Skin") : const Text("Owned"),
            ),
          ),
        ],
      ),
    );
  }
}