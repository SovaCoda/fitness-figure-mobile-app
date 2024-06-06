import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SubscribePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'FF',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
              ),
              Padding(padding: EdgeInsets.only(left: 100.0)),
            ],
          ),
        ),    
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Subscribe to Fitness Figure Plus!", style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Theme.of(context).colorScheme.primary)),
          ElevatedButton(onPressed: () => {}, child: Text("Subscribe Now", style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Theme.of(context).buttonTheme.colorScheme!.primary),), ),
          Stack(
            children: [
              Positioned(
                top: 60,
                left: 0,
                child: Text(
                  "+10% Charge Rate!",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 10,
                child: Text(
                  "+50% EVO Gain!",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
                left: 0,
                child: Text(
                  "+100% Currency Gain!",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              Positioned(
                top: 30,
                right: 0,
                child: Text(
                  "Exclusive Figure Cosmetics!",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Center(
                child: Consumer<FigureModel>(
                  builder: (context, figure, child) {
                    return RobotImageHolder(
                    url: (figure.figure != null) ? ("${figure.figure!.figureName}/${figure.figure!.figureName}_skin${figure.figure!.curSkin}_evo${0}_cropped_happy") : "robot1/robot1_skin0_evo0_cropped_happy",
                    height: 400,
                    width: 400,
                    );
                  },
                ),
              )
            ],
          ),
          SizedBox(height: 100.0),
          Positioned(left:30, child: ElevatedButton(onPressed: () => {context.goNamed("Home")}, child: Text("Back", style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).buttonTheme.colorScheme!.primary),),)),
        ],
        
      ),
      
    );
  }
}