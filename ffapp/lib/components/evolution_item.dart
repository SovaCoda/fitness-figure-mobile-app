import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EvolutionItem extends StatelessWidget {
  final String title;
  final List<String> upgrades;
  final bool isUnlocked;

  const EvolutionItem({
    Key? key,
    required this.title,
    required this.upgrades,
    this.isUnlocked = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: isUnlocked ? Border.all(color: Theme.of(context).colorScheme.secondary, width: 2) : null
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 140,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(127),
                  width: 2,
                ),
              ),
            ),
            margin: const EdgeInsets.only(top: 10, bottom: 3),
            child: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 20,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: upgrades.map((benefit) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "- ",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      Expanded(
                        child: Text(
                          benefit,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          if (!isUnlocked)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Icon(Icons.lock, color: Colors.white, size: 16),
            ),
        ],
      ),
    );
  }
}
