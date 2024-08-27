import 'package:ffapp/assets/data/figure_ev_data.dart';
import 'package:ffapp/components/charge_bar.dart';
import 'package:ffapp/components/ev_bar.dart';
import 'package:ffapp/components/resuables/gradiented_container.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/main.dart';

class InventoryItem extends StatelessWidget {
  final String photoPath;
  final bool equiped;
  final Function(BuildContext) onEquip;
  final bool locked;
  final FigureInstance? figureInstance;
  final bool isSelected;

  const InventoryItem({
    super.key,
    required this.photoPath,
    required this.equiped,
    required this.onEquip,
    required this.figureInstance,
    this.locked = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FigureModel>(
      builder: (context, figureModel, _) {
        return GradientedContainer(
          borderColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          radius: 1.3,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (figureInstance != null)
                Positioned(
                  left: 10,
                  top: 10,
                  child: GestureDetector(
                    onTap: () => {context.goNamed('SkinStore')},
                    child: Icon(Icons.swap_horiz,
                        size: 40, color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              Positioned(
                left: 10,
                bottom: 10,
                child: (figureInstance != null)
                    ? ChargeBar(
                        showDashedLines: false,
                        currentCharge: figureInstance!.charge,
                        fillColor: Theme.of(context).colorScheme.primary,
                        barHeight: 10,
                        barWidth: 50)
                    : Text("--",
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary)),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: (figureInstance != null)
                    ? EvBar(
                        currentXp: figureInstance!.evPoints,
                        maxXp: figure1.EvCutoffs[figureInstance!.evLevel],
                        fillColor: Theme.of(context).colorScheme.secondary,
                        barHeight: 10,
                        barWidth: 50)
                    : Text("--",
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary)),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  locked
                      ? Icon(
                          size: MediaQuery.of(context).size.width / 4,
                          Icons.lock,
                          color: Theme.of(context).colorScheme.onSurface,
                        )
                      : RobotImageHolder(
                          url: photoPath,
                          height: MediaQuery.of(context).size.height / 3.5,
                          width: 200),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}