import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../icons/fitness_icon.dart';
import '../main.dart';
import '../pages/home/store.dart';
import '../services/routes.pb.dart';
import 'animated_figure.dart';

class InventoryItem extends StatefulWidget {
  final bool equipped;
  final void Function(BuildContext) onEquip;
  final bool locked;
  final FigureInstance? figureInstance;
  final bool isSelected;
  final int index;
  final bool isWorkingOut;

  const InventoryItem({
    super.key,
    required this.equipped,
    required this.onEquip,
    required this.figureInstance,
    this.locked = false,
    this.isSelected = false,
    this.isWorkingOut = false,
    required this.index,
  });

  @override
  InventoryItemState createState() => InventoryItemState();
}

class InventoryItemState extends State<InventoryItem> {
  @override
  void initState() {
    super.initState();
  }

  // void _showSkinPage(BuildContext context) {
  //   Provider.of<HomeIndexProvider>(context, listen: false).setIndex(6);
  // }

  @override
  Widget build(BuildContext context) {
    return widget.locked
        ? Image.asset(
            "lib/assets/images/locked_figure.png",
            height: MediaQuery.of(context).size.height * 0.33,
          )
        : Consumer2<FigureModel, FigureInstancesProvider>(
            builder: (context, figureModel, figureInstances, _) {
              return Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final size = constraints.maxWidth < constraints.maxHeight
                          ? constraints.maxWidth
                          : constraints.maxHeight;
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // highlighted border over figure if selected
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.47,
                              height: MediaQuery.of(context).size.height * 0.34,
                              decoration: BoxDecoration(
                                border: widget.isSelected
                                    ? Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 3,
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          // FitnessIcon as the main container
                          Center(
                            child: FitnessIcon(
                              type: FitnessIconType.figure_full,
                              size: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.35,
                            ),
                          ),
                          // Original elements positioned over the FitnessIcon
                          if (widget.figureInstance != null)
                            // Positioned(
                            //   left: size * 0.05,
                            //   top: size * 0.05,
                            //   child: GestureDetector(
                            //     onTap: () {
                            //       if (!widget.isSelected) {
                            //         figureModel
                            //             .setFigure(widget.figureInstance!);
                            //         Provider.of<SelectedFigureProvider>(context,
                            //                 listen: false,)
                            //             .setSelectedFigureIndex(widget.index);
                            //         widget.onEquip(context);
                            //       }
                            //       _showSkinPage(context);
                            //     },
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(10),
                            //       child: FitnessIcon(
                            //       type: FitnessIconType.swap,
                            //       size: size * 0.15,
                            //     ),),
                            //   ),
                            // ),
                            Positioned(
                              left: size * 0.05,
                              bottom: size * 0.05,
                              child: _buildChargeBar(
                                  context,
                                  size,
                                  figureInstances
                                          .listOfFigureInstances.isNotEmpty
                                      ? figureInstances
                                          .listOfFigureInstances[widget.index]
                                      : widget.figureInstance!),
                            ),
                          Positioned(
                            right: size * 0.05,
                            bottom: size * 0.05,
                            child: _buildEvBar(
                                context,
                                size,
                                figureInstances.listOfFigureInstances.isNotEmpty
                                    ? figureInstances
                                        .listOfFigureInstances[widget.index]
                                    : widget.figureInstance!),
                          ),
                          Center(
                            child: _buildFigureImage(
                                context,
                                size,
                                figureInstances.listOfFigureInstances.isNotEmpty
                                    ? figureInstances
                                        .listOfFigureInstances[widget.index]
                                    : widget.figureInstance!),
                          ),
                          if (widget.isWorkingOut)
                            if (!widget.isSelected)
                              Center(
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.441,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3365,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.lock, size: 40),
                                            Text(
                                                'You cannot switch figures during a workout!',
                                                style: TextStyle(fontSize: 20),
                                                textAlign: TextAlign.center)
                                          ])))
                            else
                              Container()
                          else
                            Container(),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          );
  }

  Widget _buildChargeBar(
      BuildContext context, double size, FigureInstance figure) {
    if (widget.figureInstance != null) {
      return Padding(
        padding:
            EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.01),
        child: Row(
          children: [
            const FitnessIcon(
                type: FitnessIconType.charge, size: 17, height: 28),
            Text('${figure.charge}%',
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE18F4D))),
          ],
        ),
      );
    } else {
      return Text(
        '--',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      );
    }
  }

  Widget _buildEvBar(BuildContext context, double size, FigureInstance figure) {
    if (widget.figureInstance != null) {
      return Padding(
        padding:
            EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
        child: Row(
          children: [
            const FitnessIcon(type: FitnessIconType.evo, size: 17, height: 28),
            Text('${figure.evPoints}',
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00A7E1))),
          ],
        ),
      );
    } else {
      return Text(
        '--',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
      );
    }
  }

  Widget _buildFigureImage(
      BuildContext context, double size, FigureInstance figure) {
    if (widget.locked) {
      return Icon(
        Icons.lock,
        size: size * 0.5,
        color: Theme.of(context).colorScheme.onSurface,
      );
    } else {
      return Consumer<FigureInstancesProvider>(
        builder: (BuildContext context, FigureInstancesProvider value,
            Widget? child) {
          return AnimatedFigure(
            useEquippedFigure: false,
            figureLevel: figure.evLevel,
            figureName: figure.figureName,
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.height * 0.15,
          );
        },
      );
    }
  }
}
