import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../icons/fitness_icon.dart';
import 'chat_bubble.dart';

class UserMessage extends StatelessWidget {
  const UserMessage({super.key, required this.text, required this.datetime});
  final String text;
  final String datetime;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Column(
          children: [
            BinaryGlowChatBubble(
              width: MediaQuery.of(context).size.width * 0.6513994910941476,
              margin: EdgeInsets.only(top: 30, right: 25, left: 25),
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
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
          FitnessIcon(
              type: FitnessIconType.chat_icon,
              size: MediaQuery.of(context).size.width * 0.1653944020356234),
          FitnessIcon(
              type: FitnessIconType.logo,
              size: MediaQuery.of(context).size.width * 0.1272264631043257)
        ]),
      ]),
    ]);
  }
}
