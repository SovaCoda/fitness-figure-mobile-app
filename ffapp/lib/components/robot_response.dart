import 'dart:ui';

import 'package:ffapp/components/robot_image_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RobotResponse extends StatelessWidget {
  final String text;
  final String figure_url;
  final String datetime;
  final bool isInitialChat;
  final double width;

  final double ROBOT_IMAGE_SIZE = 100;

  const RobotResponse(
      {super.key,
      required this.text,
      required this.figure_url,
      required this.datetime,
      this.isInitialChat = false,
      this.width = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width:
                (MediaQuery.of(context).size.width - ROBOT_IMAGE_SIZE),
            margin: isInitialChat!
                ? const EdgeInsets.only(top: 0)
                : EdgeInsets.only(top: ROBOT_IMAGE_SIZE),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        text,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  datetime,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !isInitialChat!,
            child: Positioned(
                left: 0,
                top: 0,
                child: RobotImageHolder(
                  url: figure_url,
                  height: ROBOT_IMAGE_SIZE + 25,
                  width: ROBOT_IMAGE_SIZE + 25,
                )),
          )
        ],
      ),
    );
  }
}
