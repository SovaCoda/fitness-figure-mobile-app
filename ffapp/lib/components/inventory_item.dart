import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/icons/fitness_icon.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/pages/home/store.dart';
import 'package:ffapp/services/providers.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryItem extends StatefulWidget {
  final bool equipped;
  final Function(BuildContext) onEquip;
  final bool locked;
  final FigureInstance? figureInstance;
  final bool isSelected;
  final int index;

  const InventoryItem({
    super.key,
    required this.equipped,
    required this.onEquip,
    required this.figureInstance,
    this.locked = false,
    this.isSelected = false,
    required this.index,
  });

  @override
  InventoryItemState createState() => InventoryItemState();
}

class InventoryItemState extends State<InventoryItem> {
  // late List<Skin> listOfSkins;
  // late List<SkinInstance> listOfSkinInstances;
  // late List<FigureInstance> listOfFigureInstances;
  // late List<Figure> listOfFigures;

  @override
  void initState() {
    super.initState();
    // _initializeSkinData();
  }

  // void _initializeSkinData() async {
  //   final auth = Provider.of<AuthService>(context, listen: false);
  //   try {
       // User? databaseUser = await auth.getUserDBInfo();
       // final skins = await auth.getSkins();
       // final skinInstances;
       // if (mounted) {
       //   skinInstances = await auth.getSkinInstances(
       //       Provider.of<UserModel>(context, listen: false).user!);
       // } else {
       //   skinInstances = null;
       // }
       // final figures = await auth.getFigures().then((value) => value.figures);
       // final figureInstances = await auth
       //     .getFigureInstances(databaseUser!)
       //     .then((value) => value.figureInstances);
  //     if (mounted) {
  //       setState(() {
           // listOfSkins = skins.skins;
           // listOfSkinInstances = skinInstances.skinInstances ?? [];
           // listOfFigureInstances = figureInstances;
           // listOfFigures = figures;
  //       });
  //     }
  //   } catch (e) {
  //     logger.e(e);
  //   }
  // }

  void _showSkinPage(BuildContext context) {
    Provider.of<HomeIndexProvider>(context, listen: false).setIndex(6);
  }

  @override
  Widget build(BuildContext context) {
    return widget.locked
        ? Image.asset("lib/assets/images/locked_figure.png",
            height: MediaQuery.of(context).size.height * 0.33,)
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
                                          width: 3,)
                                      : null,
                                  borderRadius: BorderRadius.circular(15),),
                            ),
                          ),
                          // FitnessIcon as the main container
                          Center(
                            child: FitnessIcon(
                                type: FitnessIconType.figure_full,
                                size: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.35,),
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
                            child: _buildChargeBar(context, size, figureInstances.listOfFigureInstances.isNotEmpty ? figureInstances.listOfFigureInstances[widget.index] : widget.figureInstance!),
                          ),
                          Positioned(
                            right: size * 0.05,
                            bottom: size * 0.05,
                            child: _buildEvBar(context, size, figureInstances.listOfFigureInstances.isNotEmpty ? figureInstances.listOfFigureInstances[widget.index] : widget.figureInstance!),
                          ),
                          Center(
                            child: _buildFigureImage(context, size, figureInstances.listOfFigureInstances.isNotEmpty ? figureInstances.listOfFigureInstances[widget.index] : widget.figureInstance!),
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

  Widget _buildChargeBar(BuildContext context, double size, FigureInstance figure) {
    if (widget.figureInstance != null) {
      return Padding(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.01),
        child: Row(children: [
        const FitnessIcon(type: FitnessIconType.charge, size: 17, height: 28),
        Text('${figure.charge}%', style: const TextStyle(fontFamily: 'Roboto', fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFE18F4D))),
      ],),);
    } else {
      return Text(
        "--",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      );
    }
  }

  Widget _buildEvBar(BuildContext context, double size, FigureInstance figure) {
    if (widget.figureInstance != null) {
      return Padding(
        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
        child: Row(children: [
        const FitnessIcon(type: FitnessIconType.evo, size: 17, height: 28),
        Text('${figure.evPoints}', style: const TextStyle(fontFamily: 'Roboto', fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF00A7E1))),
      ],),);
    } else {
      return Text(
        "--",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
      );
    }
  }

  Widget _buildFigureImage(BuildContext context, double size, FigureInstance figure) {
    if (widget.locked) {
      return Icon(
        Icons.lock,
        size: size * 0.5,
        color: Theme.of(context).colorScheme.onSurface,
      );
    } else {
      return RobotImageHolder(
        url: "${figure.figureName}/${figure.figureName}_skin0_evo${figure.evLevel}_cropped",
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.height * 0.25,
      );
    }
  }
}
