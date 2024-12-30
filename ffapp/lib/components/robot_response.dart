import 'package:ffapp/components/robot_image_holder.dart';
import 'package:flutter/material.dart';

class RobotResponse extends StatelessWidget {
  final String text;
  final String figureUrl;
  final String datetime;
  final bool isInitialChat;
  final double width;

  

  const RobotResponse(
      {super.key,
      required this.text,
      required this.figureUrl,
      required this.datetime,
      this.isInitialChat = false,
      this.width = 100,});

  @override
  Widget build(BuildContext context) {
    const double robotImageSize = 100;
    
    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: MediaQuery.of(context).size.width - robotImageSize,
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      text,
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(
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
          visible: !isInitialChat,
          child: Positioned(
              left: 0,
              child: RobotImageHolder(
                url: figureUrl,
                height: robotImageSize,
                width: robotImageSize,
              ),),
        ),
      ],
    );
  }
}
