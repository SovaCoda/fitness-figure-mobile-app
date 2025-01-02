import 'package:ffapp/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../icons/fitness_icon.dart';
import 'chat_bubble.dart';

class RobotResponse extends StatelessWidget {
  const RobotResponse({
    super.key,
    required this.text,
    required this.figureName,
    required this.datetime,
    this.isInitialChat = false,
    this.width = 100,
  });
  final String text;
  final String figureName;
  final String datetime;
  final bool isInitialChat;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
        Stack(alignment: AlignmentDirectional.center, children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.145,
            height: MediaQuery.of(context).size.width * 0.145,
            decoration: const BoxDecoration(
                color: Colors.black, shape: BoxShape.circle),
          ),
          Consumer<FigureModel>(builder:
              (BuildContext context, FigureModel figureModel, Widget? child) {
            return Image.asset(
                figureModel.figure!.figureName == 'robot1'
                    ? 'lib/assets/art/1_head.png'
                    : 'lib/assets/art/2_head.png',
                width: MediaQuery.of(context).size.width * 0.14,
                height: MediaQuery.of(context).size.height * 0.06);
          }),
          FitnessIcon(
              type: FitnessIconType.chat_icon,
              size: MediaQuery.of(context).size.width * 0.1653944020356234),
        ]),
        Column(
          children: <Widget>[
            BinaryGlowChatBubble(
              width: MediaQuery.of(context).size.width * 0.6513994910941476,
              margin: const EdgeInsets.only(top: 30, right: 25, left: 25),
              message: text,
            ),
            // const SizedBox(height: 20),
            // Text(
            //   datetime, unused for now bc not in figma and messes with spacing
            //   style: Theme.of(context).textTheme.bodySmall!.copyWith(
            //         color: Theme.of(context).colorScheme.onPrimary,
            //       ),
            // ),
          ],
        ),
      ]),
    ]);
  }
}
