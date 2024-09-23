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
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height / 2,
          child: GradientedContainer(
            padding: const EdgeInsets.all(16),
            radius: 0,
            borderColor: Theme.of(context).colorScheme.onSurface,
            borderWidth: 1,
            child: SingleChildScrollView( // Add this
              child: child,
            ),
          ),
        ),
      ]),
    );
  }
}

// In the showFFDialog function:
void showFFDialog(String title, String message, bool dismissable, BuildContext context) {
  showDialog(
    barrierDismissible: dismissable,
    context: context,
    builder: (context) {
      return FfAlertDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Add this
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 15, bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  shape: BoxShape.rectangle,
                  color: Theme.of(context).colorScheme.onSurface
                ),
                width: MediaQuery.of(context).size.width * 0.6,
                height: 2,
              )
            ),
            Text(
              message,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface
              ),
            ),
            const SizedBox(height: 16), // Add some spacing
            Align(
              alignment: Alignment.bottomCenter,
              child: FfButton(
                height: 50,
                text: "Get Fit",
                textStyle: Theme.of(context).textTheme.displayMedium!,
                textColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
                onPressed: () => Navigator.of(context).pop()
              )
            )
          ],
        ),
      );
    }
  );
}

void showFFDialogBinary(String title, String message, bool dismissable,
    BuildContext context, FfButton yesButton, FfButton noButton) {
  showDialog(
      barrierDismissible: dismissable,
      context: context,
      builder: (context) {
        return FfAlertDialog(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.45, // Adjust as needed
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                Center(
                    child: Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      shape: BoxShape.rectangle,
                      color: Theme.of(context).colorScheme.onSurface),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 2,
                )),
                Text(
                  message,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            yesButton,
                            SizedBox(
                              height: 10,
                            ),
                            noButton,
                          ],
                        )))
              ],
            ),
          ),
        );
      });
}

void showFFDialogWithChildren(String title, List<Widget> children,
    bool dismissable, FfButton doneButton, BuildContext context) {
  showDialog(
    barrierDismissible: dismissable,
      context: context,
      builder: (context) {
        return FfAlertDialog(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface)),
              Center(
                  child: Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          shape: BoxShape.rectangle,
                          color: Theme.of(context).colorScheme.onSurface),
                      width: MediaQuery.sizeOf(context).width * 0.6,
                      height: 2)),
              Column(children: children),
              Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter, child: doneButton))
            ],
          ),
        );
      });
}
