import 'package:ffapp/components/button_themes.dart';
import 'package:ffapp/components/resuables/gradiented_container.dart';
import 'package:flutter/material.dart';

class FfAlertDialog extends StatelessWidget {
  final Widget child;
  const FfAlertDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(children: [
      SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.7,
          height: MediaQuery.sizeOf(context).height / 2,
        child: GradientedContainer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          ),
        ),
      ),
    ]
    ));
    }
  }

void showFFDialog( String title, String message, BuildContext context) {
  showDialog(context: context, builder: (context) {
    return FfAlertDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, textAlign: TextAlign.start,style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface),),
          Container(margin: EdgeInsets.only(top: 2, bottom: 2), decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), shape: BoxShape.rectangle, color: Theme.of(context).colorScheme.onSurface), width: MediaQuery.sizeOf(context).width * 0.65, height: 3,),
          Text(message, textAlign: TextAlign.start, style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.onSurface),),
          Expanded(child: Align(alignment: Alignment.bottomCenter, child: FfButton(height: 50, text: "Get Fit", textStyle: Theme.of(context).textTheme.displayMedium!, textColor: Theme.of(context).colorScheme.onPrimary, backgroundColor: Theme.of(context).colorScheme.primary, onPressed: () => Navigator.of(context).pop())))
       ],
    ),
    );
  });
}