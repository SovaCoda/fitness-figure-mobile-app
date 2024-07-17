import 'package:flutter/material.dart';

class InventoryItem extends StatelessWidget {
  const InventoryItem(
      {super.key,
      required this.photoPath,
      required this.onViewDetails,
      required this.equiped,
      required this.onEquip});

  final String photoPath;
  final Function(BuildContext) onViewDetails;
  final bool equiped;
  final Function(BuildContext) onEquip;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 310,
      decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
            right: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
          ),
          color: Theme.of(context).colorScheme.primaryFixedDim),
      child: (Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 25),
          Image.asset(
            "lib/assets/$photoPath.gif",
            height: 170.0,
            width: 170.0,
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            padding: const EdgeInsets.all(1),
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).colorScheme.secondary.withAlpha(127),
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignInside),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: WidgetStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                  backgroundColor: WidgetStateProperty.all<Color>(
                      Theme.of(context).colorScheme.secondary)),
              child: Text("View Details",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryFixedDim)),
              onPressed: () => onViewDetails(context),
            ),
          ),
          equiped ? const GreyedEquipButton() : EquipButton(onEquip: onEquip),
        ],
      )),
    );
  }
}

class EquipButton extends StatelessWidget {
  const EquipButton({
    super.key,
    required this.onEquip,
  });

  final Function(BuildContext p1) onEquip;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      padding: const EdgeInsets.all(1),
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.secondary.withAlpha(127),
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
            shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
            backgroundColor: WidgetStateProperty.all<Color>(
                Theme.of(context).colorScheme.secondary)),
        child: Text("Train",
            style: TextStyle(
                color: Theme.of(context).colorScheme.primaryFixedDim)),
        onPressed: () => onEquip(context),
      ),
    );
  }
}

class GreyedEquipButton extends StatelessWidget {
  const GreyedEquipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
                style: ButtonStyle(
                    shape: WidgetStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0))),
                    backgroundColor: WidgetStateProperty.all<Color>(
                        Theme.of(context).colorScheme.secondary)),
                onPressed: () => {},
                child: Text("- Active - ",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primaryFixedDim))),
          ),
        ),
      ],
    );
  }
}
