import 'package:ffapp/assets/data/figure_ev_data.dart';
import 'package:ffapp/components/legacy_charge_bar.dart';
import 'package:ffapp/components/legacy_ev_bar.dart';
import 'package:ffapp/components/resuables/gradiented_container.dart';
import 'package:ffapp/components/skin_view.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ffapp/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/icons/fitness_icon.dart';

class InventoryItem extends StatefulWidget {
  final String photoPath;
  final bool equiped;
  final Function(BuildContext) onEquip;
  final bool locked;
  final FigureInstance? figureInstance;
  final bool isSelected;
  final int index;

  const InventoryItem({
    Key? key,
    required this.photoPath,
    required this.equiped,
    required this.onEquip,
    required this.figureInstance,
    this.locked = false,
    this.isSelected = false,
    required this.index,
  }) : super(key: key);

  @override
  _InventoryItemState createState() => _InventoryItemState();
}

class _InventoryItemState extends State<InventoryItem> {
  late List<Skin> listOfSkins;
  late List<SkinInstance> listOfSkinInstances;
  late List<FigureInstance> listOfFigureInstances;
  late List<Figure> listOfFigures;

  @override
  void initState() {
    super.initState();
    _initializeSkinData();
  }

  void _initializeSkinData() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    try {
      User? databaseUser = await auth.getUserDBInfo();
      final skins = await auth.getSkins();
      final skinInstances;
      if (mounted) {
        skinInstances = await auth.getSkinInstances(
            Provider.of<UserModel>(context, listen: false).user!);
      } else {
        skinInstances = null;
      }
      final figures = await auth.getFigures().then((value) => value.figures);
      final figureInstances = await auth
          .getFigureInstances(databaseUser!)
          .then((value) => value.figureInstances);
      if (mounted) {
        setState(() {
          listOfSkins = skins.skins;
          listOfSkinInstances = skinInstances.skinInstances ?? [];
          listOfFigureInstances = figureInstances;
          listOfFigures = figures;
        });
      }
    } catch (e) {
      logger.e(e);
    }
  }

  void _showSkinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            child: SkinViewer(
              listOfSkins: listOfSkins,
              listOfSkinInstances: listOfSkinInstances,
              figureName: widget.figureInstance!.figureName,
              listOfFigureInstances: listOfFigureInstances,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.locked
        ? Image.asset("lib/assets/images/locked_figure.png",
            height: MediaQuery.of(context).size.height * 0.33)
        : Consumer<FigureModel>(
            builder: (context, figureModel, _) {
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
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.455,
                              height:
                                  MediaQuery.of(context).size.height * 0.333,
                              decoration: BoxDecoration(
                                  border: widget.isSelected
                                      ? Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 3)
                                      : null,
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                          // FitnessIcon as the main container
                          Center(
                            child: FitnessIcon(
                                type: FitnessIconType.figure_full,
                                size: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.35),
                          ),
                          // Original elements positioned over the FitnessIcon
                          if (widget.figureInstance != null)
                            Positioned(
                              left: size * 0.05,
                              top: size * 0.05,
                              child: GestureDetector(
                                onTap: () {
                                  if (!widget.isSelected) {
                                    figureModel
                                        .setFigure(widget.figureInstance!);
                                    Provider.of<SelectedFigureProvider>(context,
                                            listen: false)
                                        .setSelectedFigureIndex(widget.index);
                                    widget.onEquip(context);
                                  }
                                  _showSkinDialog(context);
                                },
                                child: Icon(
                                  Icons.swap_horiz,
                                  size: size * 0.15,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          Positioned(
                            left: size * 0.05,
                            bottom: size * 0.05,
                            child: _buildChargeBar(context, size),
                          ),
                          Positioned(
                            right: size * 0.05,
                            bottom: size * 0.05,
                            child: _buildEvBar(context, size),
                          ),
                          Center(
                            child: _buildFigureImage(context, size),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          );
  }

  Widget _buildChargeBar(BuildContext context, double size) {
    if (widget.figureInstance != null) {
      return ChargeBar(
        showDashedLines: false,
        currentCharge: widget.figureInstance!.charge,
        fillColor: Theme.of(context).colorScheme.primary,
        barHeight: size * 0.03,
        barWidth: size * 0.2,
      );
    } else {
      return Text(
        "--",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      );
    }
  }

  Widget _buildEvBar(BuildContext context, double size) {
    if (widget.figureInstance != null) {
      return EvBar(
        currentXp: widget.figureInstance!.evPoints,
        maxXp: figure1.EvCutoffs[widget.figureInstance!.evLevel],
        fillColor: Theme.of(context).colorScheme.secondary,
        barHeight: size * 0.03,
        barWidth: size * 0.2,
      );
    } else {
      return Text(
        "--",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
      );
    }
  }

  Widget _buildFigureImage(BuildContext context, double size) {
    if (widget.locked) {
      return Icon(
        Icons.lock,
        size: size * 0.5,
        color: Theme.of(context).colorScheme.onSurface,
      );
    } else {
      return RobotImageHolder(
        url: widget.photoPath,
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.height * 0.25,
      );
    }
  }
}
