import 'package:ffapp/components/progress_bar.dart';
import 'package:flutter/material.dart';

class WorkoutHistoryView extends StatelessWidget {
  final String dateTime;
  final String robotUrl;
  final String elapsedTime;
  final int chargeGain;
  final int evoGain;
  final int currencyGain;

  const WorkoutHistoryView(
      {super.key, required this.dateTime,
      required this.elapsedTime,
      required this.chargeGain,
      required this.evoGain,
      required this.currencyGain,
      required this.robotUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 14, 99, 1),
            Color.fromARGB(253, 0, 5, 4)
          ])),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Opacity(
              //     opacity: 0.5,
              //     child: Positioned(
              //         bottom: 0,
              //         left: 0,
              //         child: Image.asset(robotUrl,
              //             width: MediaQuery.sizeOf(context).width * 0.2,
              //             height: 300, fit: BoxFit.none,))),

              Column(
                children: [
                  Text(
                    dateTime,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: Colors.lime[800]),
                  ),
                  Text(
                    elapsedTime,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProgressBar(
                        icon: Icon(
                          Icons.battery_charging_full,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        progressPercent: 1,
                        fillColor: Theme.of(context).colorScheme.primary,
                        barWidth: 140,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '$chargeGain',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(color: Colors.green),
                      ),
                      Icon(
                        Icons.battery_charging_full,
                        color: Theme.of(context).colorScheme.primary,
                        size: 34,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProgressBar(
                        icon: Icon(
                          Icons.ev_station,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        progressPercent: 1,
                        fillColor: Theme.of(context).colorScheme.secondary,
                        barWidth: 140,
                      ),
                      const SizedBox(width: 5),
                      Text('$currencyGain',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                color: Colors.white,
                              )),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.currency_exchange,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 34,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProgressBar(
                        icon: Icon(
                          Icons.upgrade,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        progressPercent: 1,
                        fillColor: Theme.of(context).colorScheme.tertiary,
                        barWidth: 140,
                      ),
                      const SizedBox(width: 5),
                      Text('30',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                color: Colors.cyan,
                              )),
                      Icon(
                        Icons.upgrade,
                        color: Theme.of(context).colorScheme.tertiary,
                        size: 34,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
