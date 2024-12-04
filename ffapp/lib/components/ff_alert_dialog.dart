import 'package:ffapp/components/button_themes.dart';
import 'package:ffapp/components/resuables/gradiented_container.dart';
import 'package:flutter/material.dart';
import 'package:ffapp/components/animated_button.dart';

class FfAlertDialog extends StatelessWidget {
  final Widget? child;
  final String? title;
  final String? description;

  const FfAlertDialog({
    Key? key,
    this.child,
    this.title,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          minHeight: MediaQuery.of(context).size.height * 0.3,
        ),
        child: GradientedContainer(
          padding: const EdgeInsets.all(16),
          showTopRectangle: true,
          title: title,
          description: description,
          child: child,
        ),
      ),
    );
  }
}

// In the showFFDialog function:
void showFFDialog(
  String title,
  String message,
  bool dismissable,
  BuildContext context,
) {
  showDialog(
    barrierDismissible: dismissable,
    context: context,
    builder: (context) {
      return FfAlertDialog(
        title: title,
        description: message,
        child: Align(
          alignment: Alignment.bottomCenter,
          // child: FfButton(
          //   height: 50,
          //   text: "Get Fit",
          //   textStyle: Theme.of(context).textTheme.displayMedium!,
          //   textColor: Theme.of(context).colorScheme.onPrimary,
          //   backgroundColor: Theme.of(context).colorScheme.primary,
          //   onPressed: () => Navigator.of(context).pop(),
          // ),
          child: FFAppButton(onPressed: () => Navigator.of(context).pop(), text: "Get Fit")
        ),
      );
    },
  );
}

void showFFDialogBinary(
  String title,
  String message,
  bool dismissable,
  BuildContext context,
  FfButton yesButton,
  FfButton noButton,
) {
  showDialog(
    barrierDismissible: dismissable,
    context: context,
    builder: (context) {
      return FfAlertDialog(
        title: title,
        description: message,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            yesButton,
            const SizedBox(height: 12),
            noButton,
          ],
        ),
      );
    },
  );
}

void showFFDialogWithChildren(
  String title,
  List<Widget> children,
  bool dismissable,
  FfButton doneButton,
  BuildContext context,
) {
  showDialog(
    barrierDismissible: dismissable,
    context: context,
    builder: (context) {
      return Dialog(
        child: FfAlertDialog(
          title: title,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...children,
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: doneButton,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
