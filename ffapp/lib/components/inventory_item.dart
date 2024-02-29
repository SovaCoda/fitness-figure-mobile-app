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
            photoPath,
            height: 170.0,
            width: 170.0,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () => onViewDetails(context),
              child: const Text("View Details")),
          const SizedBox(height: 5),
          equiped ? const GreyedEquipButton() : EquipButton(onEquip: onEquip),
          const SizedBox(height: 10,)
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
    return ElevatedButton(
        onPressed: () => onEquip(context),
        child: const Text("Train"));
  }
}

class GreyedEquipButton extends StatelessWidget {
  const GreyedEquipButton({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.inversePrimary),
      ),
      onPressed: () => {},
      child: const Text("Training"));
  }
}
