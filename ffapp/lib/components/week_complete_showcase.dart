import 'package:ffapp/assets/data/figure_ev_data.dart';
import 'package:ffapp/components/charge_bar.dart';
import 'package:ffapp/components/ev_bar.dart';
import 'package:ffapp/components/resuables/streak_shower.dart';
import 'package:ffapp/components/resuables/week_to_go_shower.dart';
import 'package:ffapp/components/utils/history_model.dart';
import 'package:ffapp/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeekCompleteShowcase extends StatelessWidget {
  final bool isUserFirstWeek;

  const WeekCompleteShowcase({super.key, this.isUserFirstWeek = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (_, user, __) {
        return Consumer<HistoryModel>(
          builder: (_, history, __) {
            int investmentAdd = (history.lastWeekInvestment / 100).toInt();
            int numComplete =
                history.lastWeek.where((element) => element == 2).length;
            int chargeGain = numComplete * 3;
            int evGain = numComplete * 50 + investmentAdd;

            bool isComplete = isUserFirstWeek
                ? true
                : history.lastWeek.where((element) => element == 2).length >=
                    user.user!.weekGoal.toInt();
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WeekToGoShower(
                        showChevron: false,
                        boxSize: Size(12, 12),
                        weekGoal: user.user!.weekGoal.toInt(),
                        workouts: history.lastWeek),
                    StreakShower(
                        goalMet: isComplete,
                        streak: user.user!.streak.toInt(),
                        textStyle: Theme.of(context).textTheme.displaySmall!)
                  ],
                ),
                isComplete
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'Completion Bonuses!',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                          Center(
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 15, bottom: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      shape: BoxShape.rectangle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                  width: MediaQuery.sizeOf(context).width * 0.6,
                                  height: 2)),
                          Consumer<FigureModel>(
                            builder: (_, figure, __) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ChargeBar(
                                      overrideGains: chargeGain,
                                      simulateCurrentGains: true,
                                      currentCharge: figure.figure!.charge,
                                      fillColor:
                                          Theme.of(context).colorScheme.primary,
                                      barHeight: 10,
                                      barWidth: 200),
                                  SizedBox(height: 10),
                                  EvBar(
                                      overrideGains: evGain - investmentAdd,
                                      simulateCurrentGains: true,
                                      currentXp: figure.figure!.evPoints,
                                      maxXp: figure1
                                          .EvCutoffs[figure.figure!.evLevel],
                                      fillColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      barHeight: 10,
                                      barWidth: 200),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Investment!',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                          Center(
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 15, bottom: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      shape: BoxShape.rectangle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                  width: MediaQuery.sizeOf(context).width * 0.6,
                                  height: 2)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  textAlign: TextAlign.center,
                                  "\$${history.lastWeekInvestment}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface)),
                              Text(
                                  textAlign: TextAlign.center,
                                  "=>",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface)),
                              Text(
                                  textAlign: TextAlign.center,
                                  "+${(history.lastWeekInvestment / 100).toInt()} EVO",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary)),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              textAlign: TextAlign.center,
                              "\nInvestment Lost! \n -\$${history.lastWeekInvestment.toString()} "),
                          Text(
                              textAlign: TextAlign.center,
                              "\nMissed out on \n ${history.lastWeekInvestment / 100} EVO",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                        ],
                      ),
              ],
            );
          },
        );
      },
    );
  }
}
