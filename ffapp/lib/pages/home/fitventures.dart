import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Fitventures extends StatefulWidget {
  const Fitventures({Key? key}) : super(key: key);
  

  @override
  _FitventuresState createState() => _FitventuresState();
}

class _FitventuresState extends State<Fitventures> {
  final FIGURE_SIZE_OFFSET = 100.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Consumer<FigureModel>(
          builder: (context, figureModel, _) {
            return Stack(
              children: [
                Image(image: AssetImage('lib/assets/fitventures/FitventuresPrototype.png'), height: 400, width: 400), // Map Image
                Positioned(
                  top: 200 - FIGURE_SIZE_OFFSET,
                  left: 30,
                  child: RobotImageHolder(
                    url: '${figureModel.figure!.figureName}/${figureModel.figure!.figureName}_skin${figureModel.figure!.curSkin}_evo${figureModel.EVLevel}_cropped_happy',
                    height: 100,
                    width: 100,
                  ), // Robot Image
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
