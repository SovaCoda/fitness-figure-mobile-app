import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ffapp/components/button_themes.dart';
import 'dart:async';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:fixnum/fixnum.dart';

class ResearchOption extends StatefulWidget {
  final String title;
  final int chance;
  final int ev;
  final Duration duration;

  const ResearchOption({
    Key? key,
    required this.title,
    required this.chance,
    required this.ev,
    required this.duration,
  }) : super(key: key);

  @override
  _ResearchOptionState createState() => _ResearchOptionState();
}

class _ResearchOptionState extends State<ResearchOption> {
  late AuthService auth;
  bool _isCountdown = false;
  bool _isExpanded = false;
  double _investmentAmount = 0;
  int _currentChance = 0;
  int _cost = 0;
  int _currentCountdown = 0;
  int _time = 0;
  bool _isCompleted = false;
  int _randValue = 0;
  bool _isDelete = false;
  Timer _timer = Timer(Duration.zero, () {});
  late FigureModel figure = FigureModel();

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
    _currentCountdown = widget.duration.inSeconds;
    _currentChance = widget.chance;
    _randValue = Random().nextInt(100);
    figure = Provider.of<FigureModel>(context, listen: false);
  }

  void _updateInvestment(double value) {
    setState(() {
      _isCountdown = false;
      _investmentAmount = value;
      _cost = value.round();
      // Increase chance based on investment. This is a simple linear increase,
      // you might want to adjust the formula based on your game's mechanics.
      _currentChance = widget.chance + (value / 100).round();
      // Ensure chance doesn't exceed 100%
      _currentChance = _currentChance.clamp(0, 100);
    });
  }

  void startTimer() {
    setState(() {
      _isCountdown = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentCountdown--;
        _time++;
        if (_currentCountdown == 0) {
          _isCompleted = true;
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void giveRewards() async {
    FigureInstance figureInstance =
        Provider.of<FigureModel>(context, listen: false).figure!;
    int totalEV = figureInstance.evPoints + widget.ev;
    Provider.of<FigureModel>(context, listen: false).setFigureEv(totalEV);
    UserModel user = Provider.of<UserModel>(context, listen: false);
    figureInstance = Provider.of<FigureModel>(context, listen: false).figure!;

    await auth.updateFigureInstance(FigureInstance(
        figureId: figureInstance.figureId,
        userEmail: user.user!.email,
        figureName: figureInstance.figureName,
        charge: (figureInstance.charge).toInt(),
        evPoints: (figureInstance.evPoints).toInt()));
  }

  Future<bool> subtractCurrency() async {
    User? user = await auth.getUserDBInfo();
    int currentCurrency = user!.currency.toInt();
    logger.i(
        "Subtracting user's currency on purchase. Amount subtracted: $subtractCurrency");
    int updateCurrency = currentCurrency - _investmentAmount.round();
    if (updateCurrency < 0) {
      logger.i("Not enough currency to complete transaction.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Not enough currency to complete this purchase!")),
        );
        return false;
      }
    }
    user.currency = Int64(updateCurrency);
    await auth.updateUserDBInfo(user);
    if (mounted) {
      Provider.of<CurrencyModel>(context, listen: false)
          .setCurrency(updateCurrency.toString());
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return !_isDelete
        ? AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: MediaQuery.of(context).size.width * 0.87,
            height: _isExpanded
                ? MediaQuery.of(context).size.height * 0.45
                : MediaQuery.of(context).size.height * 0.162,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 3),
                  decoration: _isExpanded
                      ? BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  width: 1)))
                      : const BoxDecoration(),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
                !_isExpanded
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '    $_currentChance% Chance',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                        color: Color.fromARGB(
                                            255,
                                            255 -
                                                (2.55 * _currentChance).round(),
                                            0 + (2.55 * _currentChance).round(),
                                            0)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '   +${widget.ev} EV',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                              ),
                            ],
                          ),
                          Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!_isCompleted)
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                            _formatDuration(Duration(
                                                seconds: _currentCountdown)),
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall),
                                        const Icon(Icons.access_time, size: 20)
                                      ]),
                                !_isCountdown
                                    ? ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _isExpanded = !_isExpanded;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          minimumSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              40),
                                        ),
                                        child: Text('Begin',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary)))
                                    : !_isCompleted
                                        ? FfButtonProgressableResearch(
                                            text: 'In Progress',
                                            textColor: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            disabledColor: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            height: 40,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            progress: _time /
                                                widget.duration.inSeconds,
                                            onPressed: () => {},
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .displaySmall!)
                                        : ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _isExpanded = !_isExpanded;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              foregroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              minimumSize: Size(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  40),
                                            ),
                                            child: Text('Completed',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary)))
                              ]),
                        ],
                      )
                    : !_isCompleted
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                const SizedBox(height: 3),
                                Text(
                                    'Invest funds to improve chances of research success!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.attach_money, size: 24),
                                    Text('$_cost'),
                                  ],
                                ),
                                Slider(
                                    divisions: 100,
                                    value: _investmentAmount,
                                    min: 0,
                                    max: 10000,
                                    onChanged: _updateInvestment,
                                    label: _cost.toString()),
                                Text('$_currentChance% Chance',
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            255,
                                            255 -
                                                (2.55 * _currentChance).round(),
                                            0 + (2.55 * _currentChance).round(),
                                            0))),
                                ElevatedButton(
                                    onPressed: () async {
                                      await subtractCurrency()
                                          ? setState(() {
                                              startTimer();
                                              _isExpanded = !_isExpanded;
                                              _isCountdown = true;
                                            })
                                          : setState(() {});
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      minimumSize: Size(
                                          MediaQuery.of(context).size.width *
                                              0.9,
                                          40),
                                    ),
                                    child: Text('Begin',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary))),
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _isExpanded = !_isExpanded;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[900],
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      minimumSize: Size(
                                          MediaQuery.of(context).size.width *
                                              0.9,
                                          40),
                                    ),
                                    child: Text('Back',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface)))
                              ])
                        : (_currentChance >= _randValue) ||
                                (_currentChance == 100)
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('SUCCESS',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary)),
                                  Row(children: [
                                    RobotImageHolder(
                                      url: (figure.figure != null)
                                          ? ("${figure.figure!.figureName}/${figure.figure!.figureName}_skin${figure.figure!.curSkin}_evo${figure.EVLevel}_cropped_happy")
                                          : "robot1/robot1_skin0_evo0_cropped_happy",
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                    ),
                                    Text('+${widget.ev} EV',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary))
                                  ]),
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          giveRewards(); // Award the user on victory
                                          _isDelete = true;
                                          _isExpanded = !_isExpanded;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                            40),
                                      ),
                                      child: Text('Awesome!',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary)))
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('FAILURE',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error)),
                                  Row(children: [
                                    RobotImageHolder(
                                      url: (figure.figure != null)
                                          ? ("${figure.figure!.figureName}/${figure.figure!.figureName}_skin${figure.figure!.curSkin}_evo${figure.EVLevel}_cropped_sad")
                                          : "robot1/robot1_skin0_evo0_cropped_happy",
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                    ),
                                    Text('+0 EV',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary))
                                  ]),
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isDelete = true;
                                          _isExpanded = !_isExpanded;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                            40),
                                      ),
                                      child: Text('Okay',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary)))
                                ],
                              )
              ],
            ),
          )
        : Container();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
