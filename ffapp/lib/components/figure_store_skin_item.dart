
import 'package:ffapp/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FigureStoreSkinItem extends StatefulWidget {
  final String photoPath;
  final String figureName;
  final int itemPrice;
  final String skinName;
  final Function(BuildContext, int, String?, String?, bool) onPurchaseSkin;
  final Function(BuildContext, String) onViewSkin;
  final Function(BuildContext, String, String) onEquipSkin;
  final bool owned;
  final bool equipped;

  const FigureStoreSkinItem(
      {super.key,
      required this.photoPath,
      required this.itemPrice,
      required this.onPurchaseSkin,
      required this.owned,
      required this.skinName,
      required this.figureName,
      required this.onViewSkin,
      required this.onEquipSkin,
      required this.equipped,});

  @override
  _FigureStoreSkinItemState createState() => _FigureStoreSkinItemState(stateowned: owned);
}

class _FigureStoreSkinItemState extends State<FigureStoreSkinItem> {
  bool stateowned;
  bool equipped = false;

  _FigureStoreSkinItemState({required this.stateowned});

  @override
  void initState() {
    super.initState();
    stateowned = widget.owned;
    equipped = widget.equipped;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            "lib/assets/${widget.photoPath}.gif",
            height: 170.0,
            width: 170.0,
          ),
          const SizedBox(height: 10),
          Text(
            'Price: ${widget.itemPrice}',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  widget.onViewSkin(context, widget.skinName);
                },
                child: const Text("View Skin"),
              ),
            ],
          ),
          equipped
              ? ElevatedButton(
                  onPressed: () {
                    widget.onEquipSkin(context, widget.figureName, widget.skinName);
                    setState(() {
                      equipped = true;
                    });
                  },
                  child: const Text("Equipped"),
                )
              : ElevatedButton(
                  onPressed: () {
                    widget.onEquipSkin(context, widget.figureName, widget.skinName);
                    setState(() {
                      equipped = true;
                    });
                  },
                  child: const Text("Equip"),
                ),
          Opacity(
            opacity: !stateowned ? 1.0 : 0.5,
            child: ElevatedButton(
              onPressed: () => {widget.onPurchaseSkin(context, widget.itemPrice, widget.skinName, widget.figureName, stateowned), setState(() {stateowned = true;})},
              child: !stateowned ? const Text("Buy Skin") : const Text("Owned"),
            ),
          ),
        ],
      ),
    );
  }
}