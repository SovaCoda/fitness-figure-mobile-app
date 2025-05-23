import 'dart:math';

import 'package:ffapp/components/animated_figure.dart';
import 'package:ffapp/components/ff_app_button.dart';
import 'package:ffapp/components/ff_app_coin.dart';
import 'package:ffapp/components/button_themes.dart';
import 'package:ffapp/components/fail_animation.dart';
import 'package:ffapp/components/research_progress_bar.dart';
import 'package:ffapp/components/research_task_manager.dart';
import 'package:ffapp/components/resuables/ff_app_slider.dart';
import 'package:ffapp/components/resuables/gradiented_container.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/components/success_animation.dart';
import 'package:ffapp/components/utils/time_utils.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResearchOption extends StatefulWidget {
  final ResearchTask task;
  final Function(String) onComplete;
  final Function(String, BuildContext) onStart;
  final Future<bool> Function(double) onSubtractCurrency;
  final Function releaseLockedTasks;
  final Function lockAllInactiveTasks;

  const ResearchOption({
    super.key,
    required this.task,
    required this.onComplete,
    required this.onStart,
    required this.onSubtractCurrency,
    required this.releaseLockedTasks,
    required this.lockAllInactiveTasks,
  });

  @override
  State<ResearchOption> createState() => _ResearchOptionState();
}

class _ResearchOptionState extends State<ResearchOption> {
  late AuthService _auth;
  late FigureModel _figure;
  late ResearchTask task;
  late SharedPreferences prefs;
  late PersistantTimer _timer;

  bool _isCountdown = false;
  bool _isExpanded = false;
  bool _isCompleted = false;
  bool _isDelete = false;
  bool _isInitialized = false;
  // bool _isLocked = false;
  bool _isSuccess = false; // added for handling failure button in stack

  double _investmentAmount = 0;
  int _currentChance = 0;
  int _currentEv = 0;
  int _cost = 0;
  int _currentCountdown = 0;
  int _time = 0;
  int _randValue = 0;
  int _tickSpeed = 1000;

  @override
  void initState() {
    Provider.of<FigureModel>(context, listen: false)
        .addListener(() => _uponFigureChange(_figure, _time));
    super.initState();
    _initializeState();
  }

  void _uponFigureChange(FigureModel figureModel, int time) {
    if (!_isInitialized) return;
    final Map<String, bool> capabilities = figureModel.capabilities;
    _tickSpeed = 1000;
    if (capabilities['Research 20% Faster'] == true) {
      _tickSpeed = 800;
    }
    if (capabilities['Halve Research Time'] == true) {
      _tickSpeed = 500;
    }

    if (capabilities['Task EV +20%']!) {
      _currentEv = (widget.task.ev * 1.2).round();
    } else {
      _currentEv = widget.task.ev;
    }

    _timer.changeTickSpeedMS(_tickSpeed);
  }

  Future<void> _initializeState() async {
    task = widget.task;
    prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final Map<String, bool> capabilities =
        Provider.of<FigureModel>(context, listen: false).capabilities;
    if (capabilities['Research 20% Faster'] == true) {
      _tickSpeed = 800;
    }
    if (capabilities['Halve Research Time'] == true) {
      _tickSpeed = 500;
    }

    if (capabilities['Task EV +20%']!) {
      _currentEv = (widget.task.ev * 1.2).round();
    } else {
      _currentEv = widget.task.ev;
    }
    _timer = PersistantTimer(
      timerName: task.title,
      prefs: prefs,
      tickSpeedMS: _tickSpeed,
      onTick: _updateTimer,
    );
    if (_timer.hasStoredTime()) {
      if (hasStoredInvestment()) {
        _updateInvestment(prefs.getDouble('${task.title} investment')!);
      }
      await _timer.loadTime();
      setState(() {
        _timer.stop();
        _startTimer();
        _isExpanded = false;
        _currentCountdown =
            widget.task.duration.inSeconds - _timer.getTimeInSeconds();
        _time = _timer.getTimeInSeconds();
        _isCountdown = true;
        widget.onStart(widget.task.id, context);
      });
    } else {
      _currentCountdown = widget.task.duration.inSeconds;
      _currentChance = widget.task.chance;
    }
    if (mounted) {
      _auth = Provider.of<AuthService>(context, listen: false);
      _figure = Provider.of<FigureModel>(context, listen: false);
    }

    _randValue = Random().nextInt(100);
    _isInitialized = true;
  }

  bool hasStoredInvestment() {
    return prefs.containsKey('${task.title} investment');
  }

  void _updateInvestment(double value) {
    prefs.setDouble('${task.title} investment', value);
    setState(() {
      _isCountdown = false;
      _investmentAmount = value;
      _cost = value.round();
      _currentChance =
          (widget.task.chance + (value / 100).round()).clamp(0, 100);
    });
  }

  void _startTimer() {
    setState(() {
      _isCountdown = true;
    });
    if (widget.task.startTime == null) {
      widget.onStart(widget.task.id, context);
    }

    _timer.start();
  }

  void _updateTimer() {
    if (mounted) {
      setState(() {
        _currentCountdown -= 1;
        _time = _timer.getTimeInSeconds();
        if (_currentCountdown <= 0) {
          _isCompleted = true;
        }
      });
    }
  }

  Future<void> _giveRewards() async {
    FigureInstance figureInstance = _figure.figure!;
    final int totalEV = figureInstance.evPoints + _currentEv;
    _figure.setFigureEv(totalEV);
    final UserModel user = Provider.of<UserModel>(context, listen: false);
    figureInstance = _figure.figure!;

    await _auth.updateFigureInstance(
      FigureInstance(
        figureId: figureInstance.figureId,
        userEmail: user.user!.email,
        figureName: figureInstance.figureName,
        charge: figureInstance.charge,
        evPoints: figureInstance.evPoints,
      ),
    );
    widget.onComplete(widget.task.id);
  }

  Future<void> _startResearch() async {
    if (await widget.onSubtractCurrency(_investmentAmount)) {
      setState(() {
        _startTimer();
        _isExpanded = false;
        _currentCountdown = widget.task.duration.inSeconds;
        _isCountdown = true;
      });
    }
  }

  String _getRobotImageUrl({required bool happy}) {
    if (_figure.figure != null) {
      final String emotion = happy ? 'happy' : 'sad';
      return "${_figure.figure!.figureName}/${_figure.figure!.figureName}_skin0_evo${_figure.EVLevel}_cropped_$emotion";
    }
    return "robot1/robot1_skin0_evo0_cropped_happy";
  }

  void _handleSuccessCompletion() {
    _timer.deleteTimer();
    prefs.remove('${task.title} investment');
    setState(() {
      _giveRewards();
      _isDelete = true;
      _isExpanded = false;
    });
  }

  void _handleFailureCompletion() {
    _timer.deleteTimer();
    prefs.remove('${task.title} investment');
    setState(() {
      _isDelete = true;
      _isExpanded = false;
      widget.onComplete(widget.task.id);
    });
  }

  // void _cancelTask() {
  //   _timer.deleteTimer();
  //   prefs.remove('${task.title} investment');

  //   _isDelete = false;
  //   _isExpanded = false;
  //   _isCountdown = false;
  //   _isExpanded = false;
  //   widget.onComplete(widget.task.id);
  // }

  @override
  void dispose() {
    _timer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isDelete) return Container();

    return Stack(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: MediaQuery.of(context).size.width * 0.95,
              height: _getContainerHeight(),
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(255, 91, 103, 100),
                    width: 2,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: _isExpanded
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: [
                  if (_isExpanded)
                    _buildExpandedContent()
                  else
                    _buildCollapsedContent(),
                ],
              ),
            ),
            if (_isExpanded && !_isCompleted)
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.025,
                left: MediaQuery.of(context).size.width * 0.10,
                child: Semantics(
                  identifier: "begin-btn",
                  child: FFAppButton(
                  text: "BEGIN",
                  fontSize: 20,
                  onPressed: _startResearch,
                  size: MediaQuery.of(context).size.width *
                      0.79389312977099236641221374045802,
                  height: MediaQuery.of(context).size.height *
                      0.08098591549295774647887323943662,
                )),
              )
            else
              Container(),
            if (_isExpanded && _isCompleted)
              _isSuccess
                  ? Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.035,
                      left: MediaQuery.of(context).size.width * 0.10,
                      child: FFAppButton(
                        text: "AWESOME",
                        fontSize: 20,
                        onPressed: _handleSuccessCompletion,
                        size: MediaQuery.of(context).size.width *
                            0.79389312977099236641221374045802,
                        height: MediaQuery.of(context).size.height *
                            0.08098591549295774647887323943662,
                      ),
                    )
                  : Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.035,
                      left: MediaQuery.of(context).size.width * 0.10,
                      child: FFAppButton(
                        text: "OK",
                        fontSize: 20,
                        onPressed: _handleFailureCompletion,
                        size: MediaQuery.of(context).size.width *
                            0.79389312977099236641221374045802,
                        height: MediaQuery.of(context).size.height *
                            0.08098591549295774647887323943662,
                      ),
                    )
            else
              Container(),
          ],
        ),
        if (widget.task.locked)
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: _getContainerHeight(),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, size: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Multi-Tasking Unlocks at ',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(fontSize: 16),
                      ),
                      Text(
                        'EVO 2',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  double _getContainerHeight() {
    if (!_isExpanded) {
      return MediaQuery.of(context).size.height *
          0.13754694835680751173708920187793;
    }
    return _isCompleted
        ? MediaQuery.of(context).size.height * 0.39
        : MediaQuery.of(context).size.height * 0.38;
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.only(bottom: 2),
      width: MediaQuery.of(context).size.width *
          0.90839694656488549618320610687023,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Semantics(
                identifier: "task-title",
              child: Text(
                widget.task.title,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                    ),
              )),
              if (!_isCompleted) _buildTimer(),
            ],
          ),
          _buildChanceAndEVInfo(),
        ],
      ),
    );
  }

  Widget _buildCollapsedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // _buildTimerAndButton(),
        _buildTitle(),
        _buildActionButton(),
      ],
    );
  }

  Widget _buildChanceAndEVInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          identifier: "task-chance",
        child: Text(
          '$_currentChance% Chance',
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Color.fromARGB(
                  255,
                  255 - (2.55 * _currentChance).round(),
                  0 + (2.55 * _currentChance).round(),
                  0,
                ),
                fontSize: 14,
                fontFamily: 'Roboto',
              ),
        )),
        const SizedBox(height: 4),
        Semantics(
          identifier: "task-ev-gain",
        child: Text(
          '+$_currentEv EVO',
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 14,
                fontFamily: 'Roboto',
              ),
        )),
      ],
    );
  }

  // Widget _buildTimerAndButton() {
  //   // currently unused
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     crossAxisAlignment: CrossAxisAlignment.end,
  //     children: [if (!_isCompleted) _buildTimer(), _buildActionButton()],
  //   );
  // }

  Widget _buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_tickSpeed != 1000)
          Text(
            "+${(1000 - _tickSpeed) / 10}%  ",
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: _isExpanded ? 20 : 14,
                  fontFamily: 'Roboto',
                ),
          ),
        Semantics(
          identifier: "timerInfo",
          child: Text(
          _isCountdown
              ? _formatDuration(Duration(seconds: _currentCountdown))
              : _formatDuration(widget.task.duration),
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: _isExpanded ? 20 : 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
              ),
        )),
        const SizedBox(width: 2),
        Icon(Icons.access_time, size: _isExpanded ? 29 : 20, weight: 700),
      ],
    );
  }

  Widget _buildActionButton() {
    if (!_isCountdown) {
      return _buildBeginButton();
    } else if (!_isCompleted) {
      return _buildProgressButton();
    } else {
      return _buildCompletedButton();
    }
  }

  Widget _buildBeginButton() {
    return FFAppButton(
      text: "BEGIN",
      size: MediaQuery.of(context).size.width *
          0.47697201017811704834605597964377,
      height: MediaQuery.of(context).size.height *
          0.04865023474178403755868544600939,
      fontSize: 14,
      onPressed: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
    );
  }

  Widget _buildProgressButton() {
    return FlowingProgressBar(
      text: 'In Progress',
      textColor: Colors.white,
      width: MediaQuery.of(context).size.width * 0.4,
      height: 40,
      progress: _time / widget.task.duration.inSeconds,
      onPressed: () {},
      textStyle: Theme.of(context).textTheme.displaySmall!,
    );
  }

  Widget _buildCompletedButton() {
    // return ElevatedButton(
    //   onPressed: () {
    //     setState(() {
    //       _isExpanded = !_isExpanded;
    //     });
    //   },
    //   style: _getButtonStyle(color: Theme.of(context).colorScheme.primary),
    //   child: Text('Completed', style: _getButtonTextStyle()),
    // );
    return ResearchProgressBar(
      text: 'Complete',
      onPressed: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
    );
  }

  // ButtonStyle _getButtonStyle({Color? color}) {
  //   return ElevatedButton.styleFrom(
  //     backgroundColor: color ?? Theme.of(context).colorScheme.onSurface,
  //     foregroundColor: Theme.of(context).colorScheme.onPrimary,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  //     minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 40),
  //   );
  // }

  // _getExpandedButtonStyle({Color? color}) {
  //   return ElevatedButton.styleFrom(
  //     backgroundColor: color ?? Theme.of(context).colorScheme.onSurface,
  //     foregroundColor: Theme.of(context).colorScheme.onPrimary,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  //     minimumSize: Size(MediaQuery.of(context).size.width * 0.82, 40),
  //   );
  // }

  // TextStyle _getButtonTextStyle() {
  //   return Theme.of(context).textTheme.displaySmall!.copyWith(
  //         color: Theme.of(context).colorScheme.onPrimary,
  //       );
  // }

  // TextStyle _getBackButtonTextStyle() {
  //   return Theme.of(context).textTheme.displaySmall!.copyWith(
  //         color: Theme.of(context).colorScheme.onSurface,
  //       );
  // }

  Widget _buildExpandedContent() {
    if (!_isCompleted) {
      return _buildInvestmentContent();
    } else if (_currentChance >= _randValue || _currentChance == 100) {
      setState(() {
        _isSuccess = true;
      });
      return _buildSuccessContent();
    } else {
      return _buildFailureContent();
    }
  }

  Widget _buildInvestmentContent() {
    return GradientedContainer(
      height: MediaQuery.of(context).size.height *
          0.2934272300469483568075117370892,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Semantics(
                identifier: "expanded-task-title",
              child: Text(
                widget.task.title,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(fontSize: 16, fontWeight: FontWeight.w400),
                textAlign: TextAlign.left,
              )),
              Semantics(
                identifier: "back-btn",
              child: FFAppButton(
                text: "",
                isBack: true,
                size: MediaQuery.of(context).size.width *
                    0.10178117048346055979643765903308,
                onPressed: () {
                  setState(() {
                    _isExpanded = false;
                  });
                },
              )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                'Invest funds to improve chances of research success!',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontSize: 14, fontFamily: 'roboto'),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FFCoin(
                size: MediaQuery.of(context).size.height * 0.058685,
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              Semantics(
                identifier: "curr-investment",
                child: Text(
                '$_cost',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              )),
            ],
          ),
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.05, // Adjust this value as needed
              child: Center(
                child: FFAppSlider(
                  divisions: 100,
                  value: _investmentAmount,
                  max: 10000,
                  onChanged: _updateInvestment,
                  label: _cost.toString(),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              '$_currentChance% Chance',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(
                  255,
                  255 - (2.55 * _currentChance).round(),
                  0 + (2.55 * _currentChance).round(),
                  0,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "+ ${widget.task.ev} EVO",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              _buildTimer(),
            ],
          ),
          // if you are looking for begin button, look in the stack in the main widget build function
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return ConfettiSuccessWidget(
      child: GradientedContainer(
        height: MediaQuery.of(context).size.height *
            0.2934272300469483568075117370892,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.title,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            Center(
              child: Image.asset(
                'lib/assets/images/success.png',
                width: MediaQuery.of(context).size.width *
                    0.55470737913486005089058524173028,
                height: MediaQuery.of(context).size.height *
                    0.05286384976525821596244131455399,
              ),
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<FigureModel>(builder: (_, figure, __) {
                      return AnimatedFigure(
                        figureLevel: figure.EVLevel,
                        figureName: figure.figure!.figureName,
                        height: MediaQuery.of(context).size.height * 0.17,
                        width: MediaQuery.of(context).size.width * 0.27,
                        animation: "happy",
                      );
                    }),
                    Text(
                      "+ ${widget.task.ev} EVO",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: _handleSuccessCompletion,
            //   style: _getButtonStyle(),
            //   child: Text('Awesome!', style: _getButtonTextStyle()),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildFailureContent() {
    return GradientedContainer(
      height: MediaQuery.of(context).size.height *
          0.2934272300469483568075117370892,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.task.title,
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Stack(
            children: [
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<FigureModel>(builder: (_, figure, __) {
                            return AnimatedFigure(
                              figureLevel: figure.EVLevel,
                              figureName: figure.figure!.figureName,
                              animation: "sad",
                              height: MediaQuery.of(context).size.height * 0.17,
                              width: MediaQuery.of(context).size.width * 0.27,
                            );
                          }),
                          Text(
                            "+ 0 EVO",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -MediaQuery.of(context).size.height * 0.06,
                child: const AnimatedFitnessIcon(),
              ),
            ],
          ),
          // ElevatedButton(
          //   onPressed: _handleFailureCompletion,
          //   style: _getExpandedButtonStyle(),
          //   child: Text('Okay', style: _getButtonTextStyle()),
          // ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String twoDigitHours = twoDigits(duration.inHours.remainder(60));
    final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }
}

class ResearchButton extends StatefulWidget {
  final VoidCallback onPressed;

  const ResearchButton({super.key, required this.onPressed});

  @override
  ResearchButtonState createState() => ResearchButtonState();
}

class ResearchButtonState extends State<ResearchButton> {
  bool _isButtonDisabled = false;

  void _handleButtonPress() {
    if (!_isButtonDisabled) {
      setState(() {
        _isButtonDisabled = true;
      });
      widget.onPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isButtonDisabled ? null : _handleButtonPress,
      style: _getExpandedButtonStyle(),
      child: Text('Begin', style: _getButtonTextStyle()),
    );
  }

  ButtonStyle? _getExpandedButtonStyle({Color? color}) {
    return ElevatedButton.styleFrom(
      backgroundColor: color ?? Theme.of(context).colorScheme.onSurface,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      minimumSize: Size(MediaQuery.of(context).size.width * 0.82, 40),
    );
  }

  TextStyle _getButtonTextStyle() {
    return Theme.of(context).textTheme.displaySmall!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        );
  }
}
