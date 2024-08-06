import 'dart:async';
import 'dart:math';

import 'package:ffapp/assets/data/figure_ev_data.dart';
import 'package:ffapp/components/admin_panel.dart';
import 'package:ffapp/components/animated_points.dart';
import 'package:ffapp/components/backed_figure_holder.dart';
import 'package:ffapp/components/button_themes.dart';
import 'package:ffapp/components/charge_bar.dart';
import 'package:ffapp/components/ev_bar.dart';
import 'package:ffapp/components/ff_alert_dialog.dart';
import 'package:ffapp/components/progress_bar.dart';
import 'package:ffapp/components/resuables/chat_bubble.dart';
import 'package:ffapp/components/resuables/gradiented_container.dart';
import 'package:ffapp/components/resuables/streak_shower.dart';
import 'package:ffapp/components/resuables/week_to_go_shower.dart';
import 'package:ffapp/components/resuables/workout_time_shower.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/components/workout_calendar.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/local_notification_service.dart';
import 'package:ffapp/services/robotDialog.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkoutAdder extends StatefulWidget {
  const WorkoutAdder({super.key});

  @override
  State<WorkoutAdder> createState() => _WorkoutAdderState();
}

class _WorkoutAdderState extends State<WorkoutAdder> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final logger = Logger();
  bool _logging = false;
  Timer _timer = Timer(Duration.zero, () {});
  Int64 time = Int64(0);
  Int64 _timePassed = Int64(0);
  late Int64 _timegoal = Int64(0);
  late String _startTime, _endTime;
  late AuthService auth;
  late String figureURL = "robot1_skin0_cropped";
  RobotDialog robotDialog = RobotDialog();
  final int RANDRANGE = 100;
  final double OFFSET = 250 / 4;
  late double scoreIncrement;
  final int sigfigs = 2;
  bool _goalMet = false;

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
  }

  void startTimer() {
    UserModel? userModel = Provider.of<UserModel>(context, listen: false);
    User user = userModel.user != null ? userModel.user! : User();
    Int64 timegoal = user.workoutMinTime;
    scoreIncrement = 1 / (timegoal.toDouble() * 60);
    logger.i(timegoal);
    setState(() {
      if (timegoal != Int64.ZERO) {
        _timegoal = timegoal * 60; //convert to seconds
      }
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        time++;
        if (time == _timegoal) {
          _goalMet = true;
          LocalNotificationService().showNotification(
            id: 0,
            title: "Goal Met!",
            body: "You have met your workout goal.",
          );
          logger.i('Goal met, sending user notification');
        }
      });
    });
  }

  String formatSeconds(int seconds) {
    final formatter = NumberFormat('00');
    String hours = formatter.format((seconds / 3600).floor());
    String minutes = formatter.format(((seconds % 3600) / 60).floor());
    String second = formatter.format((seconds % 60));
    return "$hours:$minutes:$second";
  }

  void startLogging() {
    setState(() {
      states["logging"] = true;
      states["pre-logging"] = false;
      _logging = true;
      _startTime = DateTime.now().toString();
    });
  }

  void resumeTimer() {
    setState(() {
      states['paused'] = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        
        time++;
        if (time == _timegoal) {
          _goalMet = true;
          LocalNotificationService().showNotification(
            id: 0,
            title: "Goal Met!",
            body: "You have met your workout goal.",
          );
          logger.i('Goal met, sending user notification');
        }
      });
    });
  }

  void pauseTimer() {
    _timer.cancel();
    setState(() {
      states["paused"] = true;
    });
  }

  //function that does all the awarding in one
  Future<void> awardAll({required bool weeklyGoalMet}) async {
    User user = Provider.of<UserModel>(context, listen: false).user!;
    FigureInstance figureInstance =
        Provider.of<FigureModel>(context, listen: false).figure!;
    Figure figure =
        await auth.getFigure(Figure(figureName: figureInstance.figureName));
    int currency =
        int.parse(Provider.of<CurrencyModel>(context, listen: false).currency);
    int addableCurrency = _timePassed.toInt() ~/ 10;
    currency += addableCurrency;

    int figureEV = figure.baseEvGain;
    double eVConcistencyBonus = (figureEV * 0.1) * user.weekComplete.toInt();
    int addableEV = _timePassed.toInt() ~/ 10;
    int ev = figureEV + eVConcistencyBonus.toInt() + addableEV;

    int figureCharge = 5; // needs to be replaced with the figure provider.
    double chargeConcistencyBonus =
        (figureCharge * 0.1) * user.weekComplete.toInt();
    int addableCharge = _timePassed.toInt() ~/ user.workoutMinTime.toInt();
    int charge = figureCharge + chargeConcistencyBonus.toInt() + addableCharge;

    await auth.updateUserDBInfo(Routes.User(
        email: user.email,
        currency: Int64(currency),
        weekComplete: Int64(user.weekComplete.toInt() + 1)));

    Provider.of<CurrencyModel>(context, listen: false)
        .setCurrency(currency.toString());
    Provider.of<FigureModel>(context, listen: false)
        .setFigureEv(figureInstance.evPoints + ev);
    Provider.of<FigureModel>(context, listen: false)
        .setFigureCharge(!weeklyGoalMet
            ? ((figureInstance.charge + charge) > 100)
                ? 100
                : figureInstance.charge + charge
            : figureInstance.charge);
    Provider.of<UserModel>(context, listen: false)
        .setUserWeekCompleted(Int64(user.weekComplete.toInt() + 1));
    figureInstance = Provider.of<FigureModel>(context, listen: false).figure!;
    user = Provider.of<UserModel>(context, listen: false).user!;
    await auth.updateFigureInstance(FigureInstance(
        figureId: figureInstance.figureId,
        userEmail: user.email,
        figureName: figureInstance.figureName,
        charge: (figureInstance.charge).toInt(),
        evPoints: (figureInstance.evPoints).toInt()));
    // Routes.FigureInstance? databaseFigure = await auth.getFigureInstance(
    //       Routes.FigureInstance(
    //         userEmail: Provider.of<UserModel>(context, listen: false).user?.email,
    //         figureName: Provider.of<UserModel>(context, listen: false).user?.curFigure));
    // Provider.of<FigureModel>(context, listen: false).setFigure(databaseFigure);

    final SharedPreferences prefs = await _prefs;
    if (prefs.getBool("hasSurveyed") == null ||
        prefs.getBool("hasSurveyed") == true) {
      // showDialog(
      //   context: context,
      //   builder: (context) => const PopupWidget(
      //     message:
      //         'Congratulations on completing your workout, would you like to take a quick 3 minute survey on how you\'re liking Fitness Figure so far?',
      //   ),
      // );
    }
  }

  Future<void> endLogging() async {
    states["logging"] = false; 
    _timePassed = time;
    time = Int64.ZERO;
    _endTime = DateTime.now().toString();
    Workout workout = Workout(
      startDate: _startTime,
      endDate: _endTime,
      elapsed: _timePassed,
      email: await auth.getUser().then((value) => value!.email.toString()),
      chargeAdd: Int64(Random.secure().nextInt(100)),
      currencyAdd: Int64(Random.secure().nextInt(1000)),
    );
    await auth.createWorkout(workout);
    var user = Provider.of<UserModel>(context, listen: false).user;
    if (user!.weekComplete >= user.weekGoal) {
      setState(() {
        _logging = false;
        _timer.cancel();
      });
      await awardAll(weeklyGoalMet: true);
      return;
    }
    await awardAll(weeklyGoalMet: false);
    setState(() {
      _logging = false;
      _timer.cancel();
    });
  }


  add30Seconds() {
    setState(() {
      time += Int64(30);
    });
  }

  add10Minutes() {
    setState(() {
      time += Int64(600);
    });
  }

  void endWorkout() async {
    if (time < _timegoal.toInt()) {
      showFFDialogBinary("Hold on!", "You havent worked out at least as long as ${formatSeconds(_timegoal.toInt())}! If you stop now, this workout won't contribute to your weekly goal and you'll gain no charge, you will still recieve evo for the time you worked out.", context, 
        FfButton(height: 50, text: "I'll keep at it!", textStyle: Theme.of(context).textTheme.displayMedium!, textColor: Theme.of(context).colorScheme.onPrimary, backgroundColor: Theme.of(context).colorScheme.primary, onPressed: () => { Navigator.of(context).pop()}),
        FfButton(height: 50, text: "End workout", textStyle: Theme.of(context).textTheme.displayMedium!, textColor: Theme.of(context).colorScheme.onSurface, backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(126), onPressed: () => {setState((){ states['chatting'] = true;
        states['logging'] = false;}),Navigator.of(context).pop()}),
      );
    }
    else{
      setState(() {
        states['chatting'] = true;
        states['logging'] = false;
      });
    } 
  }

  void chatMore() async {
    showFFDialogBinary("FF+ Premium Feature", "Subscribe now to FF+ to gain acess to chatting with your figure. Your figure can help you with all your fitness goals as well as assist in managing your growth! \n \nAdditionally, you earn extra rewards and cosmetics while you're subscribed!", context,
    FfButton(height: 50, text: "Subscribe Now \$1.99", textStyle: Theme.of(context).textTheme.displayMedium!, textColor: Theme.of(context).colorScheme.onPrimary, backgroundColor: Theme.of(context).colorScheme.primary, onPressed: () => { Navigator.of(context).pop()},),
    FfButton(height: 50, text: "No Thanks", textStyle: Theme.of(context).textTheme.displayMedium!, textColor: Theme.of(context).colorScheme.onSurface, backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(126), onPressed: () => { Navigator.of(context).pop()})
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Map<String, bool> states = {"pre-logging" : true, "logging": false, "paused": false, "chatting": false, "post-logging" : false};

  @override
  Widget build(BuildContext context) {
      return Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            states['post-logging']! ? Container() : Positioned(
                top: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width.clamp(0, 375),
                  child: const WorkoutCalendar(
                    calendarFormat: CalendarFormat.week,
                    isInteractable: false,
                  ),
                )),
            states['post-logging']! ? 
            Column(
              children: [
                Expanded(
                  child: GradientedContainer(
                    radius: 2,
                    margin: EdgeInsets.all(2),
                    padding: EdgeInsets.all(20),
                    child:
                  Column(
                    children: [
                      Row(children: [
                       Consumer<FigureModel>(
                        builder: (_, figure, __) {
                          return RobotImageHolder(
                            height: MediaQuery.of(context).size.height / 4,
                            width: MediaQuery.of(context).size.width /2,
                            url: figure.composeFigureUrl(),
                          );
                        },
                      ),
                      Consumer<UserModel>(
                        builder: (_, user, __) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                            WorkoutTimeShower(textStyle: Theme.of(context).textTheme.displayMedium!, workoutMinTime: user.user!.workoutMinTime.toInt(),),
                            SizedBox(height: 10,),
                            StreakShower(textStyle: Theme.of(context).textTheme.displayMedium!, streak: user.streak,),
                            SizedBox(height: 10,),
                                                            Consumer<HistoryModel>(
                        builder: (_, workoutHistory, __) {
                            return Row(children:[ WeekToGoShower(weekGoal: user.user!.weekGoal.toInt() ,boxSize: Size(16,16), workouts: workoutHistory.currentWeek)]);}),
                          ],);
                        }
                      )
                      ],),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ChargeBar(
                                barHeight: 10,
                                barWidth:
                                    MediaQuery.of(context).size.width / 2,
                                fillColor:
                                    Theme.of(context).colorScheme.primary,
                                currentCharge: 30,
                              ),
                              Text("[+7%]", style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.primary),)
                            ],
                          ),
                          SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          EvBar(
                            currentXp: 350,
                            maxXp: 1000,
                            fillColor:
                                Theme.of(context).colorScheme.secondary,
                            barHeight: 10,
                            barWidth:
                                MediaQuery.of(context).size.width / 2,
                          ),
                          Text("(+340)", style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.secondary),)
                        ],
                      ),
                        ],
                      ),
                      
                    
                    ],
                  )),
                ),
                 FfButton(height: 90, text: "Awesome!", textStyle: Theme.of(context).textTheme.headlineLarge!,textColor: Theme.of(context).colorScheme.onPrimary, backgroundColor: Theme.of(context).colorScheme.primary, onPressed: () => {setState(() {states['post-logging'] = false; states['pre-logging'] = true;})}),
              const SizedBox(
                  height: 10,
                ),
              ],
            )
            : 
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: states['chatting']! ? 
              [
                const ChatBubble(
                 message: "Great workout today, were really keeping our charge in tip top shape! Just a few more workouts and we will be on track to meet our weekly goal. I can't wait to evolve!"
                ),
                Container(
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<FigureModel>(
                  builder: (_, figure, __) {
                    return RobotImageHolder(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width /2,
                      url: figure.composeFigureUrl(),
                    );
                  },
                ),
                FfButton(height: 45, width: MediaQuery.sizeOf(context).width /2, text: "Chat More >", textStyle: Theme.of(context).textTheme.displaySmall!,textColor: Theme.of(context).colorScheme.onPrimary, backgroundColor: Theme.of(context).colorScheme.primary, onPressed: () => {chatMore()})
                  ],
                )),
                FfButton(height: 90, text: "Awesome!", textStyle: Theme.of(context).textTheme.headlineLarge!,textColor: Theme.of(context).colorScheme.onPrimary, backgroundColor: Theme.of(context).colorScheme.primary, onPressed: () => {setState(() {states['chatting'] = false; states['post-logging'] = true;})}),
              const SizedBox(
                  height: 10,
                ),
              ]
              : [
                Consumer<FigureModel>(
                  builder: (_, figure, __) {
                    return RobotImageHolder(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      url: figure.composeFigureUrl(),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: GradientedContainer(
                    height: 100,
                    doWeBinkTheBorder: false,
                    radius: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: 
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: states["logging"]! ? 
                        [
                          GestureDetector(onTap: () => {endWorkout()},child: Icon(Icons.stop, color: Theme.of(context).colorScheme.primary, size: 60,),),
                          Text(
                          formatSeconds(time.toInt()),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                        ),
                        GestureDetector(onTap: () => {states["paused"]! ? resumeTimer() : pauseTimer()}, child: states["paused"]! ? Icon(Icons.play_arrow, color: Theme.of(context).colorScheme.primary, size: 60,): Icon(Icons.pause, color: Theme.of(context).colorScheme.primary, size: 60,),),
                        ]
                          : 
                        [
                          Consumer<FigureModel>(
                            builder: (_, figure, __) {
                              return Consumer<HistoryModel>(
                                builder: (_, workoutHistory, __) {
                                    return Column(
                                    children: [
                                      ChargeBar(
                                        didWeWorkoutToday: workoutHistory.workedOutToday,
                                        areWeShadowing: true,
                                        simulateCurrentGains: true,
                                        barHeight: 10,
                                        barWidth:
                                            MediaQuery.of(context).size.width / 2,
                                        fillColor:
                                            Theme.of(context).colorScheme.primary,
                                        currentCharge: figure.figure!.charge,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      EvBar(
                                        didWeWorkoutToday: workoutHistory.workedOutToday,
                                        simulateCurrentGains: true,
                                        areWeShadowing: true,
                                        currentXp: figure.figure!.evPoints,
                                        maxXp: figure1.EvCutoffs[figure.EVLevel],
                                        fillColor:
                                            Theme.of(context).colorScheme.secondary,
                                        barHeight: 10,
                                        barWidth:
                                            MediaQuery.of(context).size.width / 2,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  );

                                  
                                }
                              );
                            },
                          ),
                          Consumer<UserModel>(
                            builder: (_, user, __) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  WorkoutTimeShower(textStyle: Theme.of(context).textTheme.displayMedium!, workoutMinTime: user.user!.workoutMinTime.toInt(),),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  StreakShower(textStyle: Theme.of(context).textTheme.displayMedium!, streak: user.streak,),
                                ],
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: states['logging']! ? 
                  FfButtonProgressable(progress: (time.toDouble() / _timegoal.toDouble()).clamp(0, 1), disabled: false, height: 90, icon: Icons.add, iconSize: 50, text: 'Complete Workout', textStyle: Theme.of(context).textTheme.headlineLarge!, textColor: Theme.of(context).colorScheme.onPrimary, backgroundColor: Theme.of(context).colorScheme.primary, onPressed: () => {endLogging()})
                  : FfButton(
                    icon: Icons.add,
                    iconSize: 50,
                    text: "Start Workout",
                    textStyle: Theme.of(context).textTheme.headlineLarge!,
                    height: 90,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      startLogging();
                      startTimer();
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      );
    
    }
  }

