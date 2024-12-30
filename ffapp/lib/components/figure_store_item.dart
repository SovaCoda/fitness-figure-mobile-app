import 'package:flutter/material.dart';
import 'package:ffapp/components/robot_image_holder.dart';

class FigureStoreItem extends StatefulWidget {
  const FigureStoreItem({
    super.key,
    required this.photoPath,
    required this.itemPrice,
    required this.onOpenSkin,
    required this.owned,
    required this.skinName,
    required this.figureName,
    this.onViewSkin,
    this.isLocked = false,
  });

  final String photoPath;
  final String figureName;
  final int itemPrice;
  final String skinName;
  final Function(BuildContext, int, String?) onOpenSkin;
  final Function(BuildContext, String)? onViewSkin;
  final bool owned;
  final bool isLocked;

  @override
  FigureStoreItemState createState() => FigureStoreItemState();
}

class FigureStoreItemState extends State<FigureStoreItem> {
  late bool owned;

  @override
  void initState() {
    super.initState();
    owned = widget.owned;
  }

  void _buyFigure() {
    setState(() {
      owned = true;
    });
    widget.onOpenSkin(context, widget.itemPrice, null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 280,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(
                    "lib/assets/${widget.photoPath}.gif",
                    fit: BoxFit.contain,
                  ),
                ),
                if (widget.isLocked)
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.lock,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.teal.shade700,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
            ),
            child: Column(
              children: [
                if (!owned)
                  Text(
                    'Price: ${widget.itemPrice}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: !widget.isLocked
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      widget.isLocked
                          ? 'Locked'
                          : (owned ? 'Owned' : 'Available'),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (widget.isLocked)
                      IconButton(
                        icon: const Icon(Icons.question_mark, color: Colors.white),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(children: [
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: "Reach ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    TextSpan(
                                        text: "Evo 5",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary)),
                                    TextSpan(
                                        text:
                                            ' on your figure to unlock a workout partner',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium)
                                  ])),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03),
                                  Stack(children: [
                                    RobotImageHolder(
                                      url:
                                          'robot2/robot2_skin0_evo0_cropped_happy',
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.548,
                                      width: MediaQuery.of(context).size.width *
                                          0.73,
                                    ),
                                    Opacity(
                                      opacity: 0.65,
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.548,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.20,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.24,
                                        child: const Icon(Icons.lock,
                                            size: 100, color: Colors.white))
                                  ])
                                ]),
                                actions: [
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withAlpha(100),
                                            blurRadius: 10.0,
                                            spreadRadius: 1.0,
                                            offset: const Offset(
                                              0.0,
                                              0.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                        ),
                                        child: Text("Get Fit",
                                            style: (Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium)!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary)),
                                      )),
                                ],
                              );
                            },
                          );
                        },
                      )
                  ],
                ),
                if (!owned && !widget.isLocked)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[900],
                        foregroundColor: Colors.white),
                    onPressed: _buyFigure,
                    child: const Text("Buy Figure"),
                  ),
                if (owned)
                  ElevatedButton(
                    onPressed: widget.isLocked
                        ? null
                        : () => widget.onViewSkin != null
                            ? widget.onViewSkin!(context, widget.skinName)
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade900,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('View Skins'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
