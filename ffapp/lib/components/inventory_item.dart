import 'package:ffapp/assets/data/figure_ev_data.dart';
import 'package:ffapp/components/charge_bar.dart';
import 'package:ffapp/components/ev_bar.dart';
import 'package:ffapp/components/resuables/gradiented_container.dart';
import 'package:ffapp/components/skin_view.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ffapp/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/main.dart';

class InventoryItem extends StatefulWidget {
  final String photoPath;
  final bool equiped;
  final Function(BuildContext) onEquip;
  final bool locked;
  final FigureInstance? figureInstance;
  final bool isSelected;

  const InventoryItem({
    Key? key,
    required this.photoPath,
    required this.equiped,
    required this.onEquip,
    required this.figureInstance,
    this.locked = false,
    this.isSelected = false,
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
    User? databaseUser = await auth.getUserDBInfo();
    final skins = await auth.getSkins();
    final skinInstances;
    if(mounted) {
      skinInstances = await auth.getSkinInstances(Provider.of<UserModel>(context, listen: false).user!);
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
    return Consumer<FigureModel>(
      builder: (context, figureModel, _) {
        return GradientedContainer(
          height: MediaQuery.of(context).size.height * 0.35, // ensure the same height on each device and no overflow
          borderColor: widget.isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          radius: 1.3,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.figureInstance != null)
                Positioned(
                  left: 10,
                  top: 10,
                  child: GestureDetector(
                    onTap: () => {_showSkinDialog(context)},
                    child: Icon(Icons.swap_horiz,
                        size: 40, color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              Positioned(
                left: 10,
                bottom: 10,
                child: (widget.figureInstance != null)
                    ? ChargeBar(
                        showDashedLines: false,
                        currentCharge: widget.figureInstance!.charge,
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
                child: (widget.figureInstance != null)
                    ? EvBar(
                        currentXp: widget.figureInstance!.evPoints,
                        maxXp: figure1.EvCutoffs[widget.figureInstance!.evLevel],
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
                  widget.locked
                      ? Icon(
                          size: MediaQuery.of(context).size.width / 4,
                          Icons.lock,
                          color: Theme.of(context).colorScheme.onSurface,
                        )
                      : RobotImageHolder(
                          url: widget.photoPath,
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