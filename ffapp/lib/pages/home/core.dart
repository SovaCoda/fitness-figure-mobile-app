// ignore_for_file: unused_field

import 'dart:async';
import 'dart:ui';
import 'package:ffapp/assets/data/figure_ev_data.dart';
import 'package:ffapp/components/animated_figure.dart';
import 'package:ffapp/components/ff_app_button.dart';
import 'package:ffapp/components/resuables/animated_border_painter.dart';
import 'package:ffapp/components/utils/time_utils.dart';
import 'package:ffapp/icons/fitness_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:fixnum/fixnum.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart' as routes;
import 'package:ffapp/components/research_option.dart';
import 'package:ffapp/components/research_task_manager.dart';
import 'package:ffapp/components/research_glass_panel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Core extends StatefulWidget {
  const Core({super.key});

  @override
  State<Core> createState() => _CoreState();
}

class _CoreState extends State<Core> {
  late ResearchTaskManager _taskManager;
  late FigureModel _figure;
  late CurrencyModel _currency;
  late PersistantTimer _currencyGenTimer;
  late UserModel _user;
  late double? _currencyIncrement;
  late AuthService _auth;
  late Future<void> _intializationFuture;
  late final AppLifecycleListener _listener;
  late AppLifecycleState? _lifeState;

  @override
  void initState() {
    _user = UserModel();
    _figure = FigureModel();
    _auth = Provider.of<AuthService>(context, listen: false);

    super.initState();

    _currencyIncrement = 0;

    _lifeState = SchedulerBinding.instance.lifecycleState;
    _listener = AppLifecycleListener(
      onHide: () {
        //_currencyGenTimer.storeDisposalTime();
      },
      onDetach: () {
        //_currencyGenTimer.storeDisposalTime();
      },
      onResume: () async {
        logger.i("resumed");
        int? currencyRecoupSeconds = await _currencyGenTimer.loadTime();
        if (currencyRecoupSeconds != null) {
          _currency.addToCurrency(
              _currencyIncrement! * currencyRecoupSeconds, context);
          logger.i(
              "Found $currencyRecoupSeconds seconds of currency gen offline, totaling ${_currencyIncrement! * currencyRecoupSeconds}");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "Found $currencyRecoupSeconds seconds of currency gen offline FROM RESUME, totaling ${_currencyIncrement! * currencyRecoupSeconds!}")));
        }
        _currencyGenTimer.storeDisposalTime();
      },
      onExitRequested: () async {
        //_currencyGenTimer.storeDisposalTime();
        return AppExitResponse.exit;
      },
    );

    _intializationFuture = _initialize();
  }

  Future<void> _initializeTaskManager() async {
    _taskManager = ResearchTaskManager(figureModel: _figure);
    return _taskManager.init();
  }

  Future<void> _initialize() async {
    _currency = Provider.of<CurrencyModel>(context, listen: false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Calls _handleCurrencyUpdate every second

    // Start up task manager for research tasks
    await _initializeTaskManager();

    // mounted guard
    if (!mounted) {
      return;
    }

    await _initializeServices();

    Provider.of<SelectedFigureProvider>(context, listen: false)
        .addListener(() => lockOrUnlock());
    Provider.of<FigureModel>(context, listen: false).addListener(() {
      _auth = Provider.of<AuthService>(context, listen: false);
      _user = Provider.of<UserModel>(context, listen: false);
      _figure = Provider.of<FigureModel>(context, listen: false);
      _getCurrencyIncrement(_figure, _user.isPremium());
    });

    final routes.User? user =
        Provider.of<UserModel>(context, listen: false).user;
    if (user == null) {
      return;
    }
    _currency.setCurrency(user.currency.toString());
    _currencyGenTimer = PersistantTimer(
        timerName: "currency",
        prefs: prefs,
        onTick: () {
          logger.i(
              "Currency timer original start: ${prefs!.getString('currency timerStarted')}");
          logger.i(
              "Currency timer last disposal: ${prefs!.getString('currency disposedAt')}");
          _handleCurrencyUpdate();
        });
    await Future.delayed(Duration(seconds: 3));
    int? currencyRecoupSeconds = await _currencyGenTimer.start();
    while (_currencyIncrement == 0.0) {
      await Future.delayed(Duration(seconds: 3));
    }
    logger.i(
        "Found $currencyRecoupSeconds seconds of currency gen offline, totaling ${_currencyIncrement! * currencyRecoupSeconds!}");
    _currency.addToCurrency(
        _currencyIncrement! * currencyRecoupSeconds!, context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Found $currencyRecoupSeconds seconds of currency gen offline FROM STATE, totaling ${_currencyIncrement! * currencyRecoupSeconds!}")));
    //await _initializeServices();
    // Add listeners to trigger function calls once a provider has changed
  }

  /// Initializes the currency generation
  Future<void> _initializeServices() async {
    if (!mounted) {
      return;
    }
    _auth = Provider.of<AuthService>(context, listen: false);
    _user = Provider.of<UserModel>(context, listen: false);
    _figure = Provider.of<FigureModel>(context, listen: false);
    _getCurrencyIncrement(_figure, _user.isPremium());

    // Start up the currency generator
    //await _reactivateGenerationServer();
  }

  void _handleCurrencyUpdate() {
    _currency.addToCurrency(_currencyIncrement!, context);
    if (_currencyGenTimer.getDisposalDifferenceInSeconds() < 2) {
      _currencyGenTimer.storeDisposalTime();
    }
  }

  /// Gets the value of currency generation from [figure1] currencyGens list,
  /// multiplies by the [figure] charge percentage, and doubles if [isPremium] is true
  ///
  /// Returns the currency increment to be added to the user's balance
  double _getCurrencyIncrement(FigureModel figure, bool isPremium) {
    _currencyIncrement =
        (figure1.currencyGens[figure.EVLevel]) * (isPremium ? 2 : 1);

    _currencyIncrement = _currencyIncrement! * (figure.figure!.charge / 100);
    return _currencyIncrement!;
  }

  /// Initializes the currency generation and awards the user currency during
  /// the time that they are offline
  Future<void> _reactivateGenerationServer() async {
    try {
      // Get user's last online date
      final Future<routes.OfflineDateTime> futureLastLoggedGeneration = _auth
          .getOfflineDateTime(routes.OfflineDateTime(email: _user.user!.email));
      // TODO: Figure out how to do currency when a user switches figures
      // * Issue: When user switches figures, their currency rounds down as user.currency is Int64
      // * First solution: only set currencymodel to usermodel on startup
      // * Problem: Adds bug where user can swap figures rapidly for double currency rewards
      // if (Provider.of<CurrencyModel>(context, listen: false).currency ==
      //     '0000') {
      //   final routes.User? user =
      //       Provider.of<UserModel>(context, listen: false).user;

      //   if (user == null) {
      //     return;
      //   }

      //   _currency.setCurrency(user.currency.toString());
      // }

      // Set the currency provider to the user DB info
      final routes.User? user =
          Provider.of<UserModel>(context, listen: false).user;
      if (user == null) {
        return;
      }
      _currency.setCurrency(user.currency.toString());

      // Compare the difference with the last logged generation and now
      final routes.OfflineDateTime lastLoggedGeneration =
          await futureLastLoggedGeneration;
      final DateTime parsedDateTime =
          DateTime.parse(lastLoggedGeneration.currency);
      final Duration difference = DateTime.now().difference(parsedDateTime);

      // Difference can be negative based on the timezone of the user
      // in this case, we set the currency to zero
      if (difference.inSeconds < 0) {
        //await _auth.updateCurrency(0);
      } else {
        // Add to the currency for the time the user is offline

        final double currencyToAdd = difference.inSeconds * _currencyIncrement!;
        if (mounted) {
          _currency.addToCurrency(currencyToAdd, context);
        }
      }
    } catch (e) {
      // TODO: handle gRPC empty rows / bad connection error
      logger.e('Error activating generation server $e');
    }
  }

  /// Disposes the currency generator and saves last currency gen date to database
  void _deactivateGenerationServer() {
    _auth.updateCurrency(double.parse(_currency.currency));
    _auth.updateOfflineDateTime(
      routes.OfflineDateTime(
        email: _user.user!.email,
        currency: DateTime.now().toString(),
      ),
    );
  }

  /// Resets task manager to the initial state
  ///
  /// Used for the debug Widget [_buildResetTasksButton]
  void _resetTasks() {
    _taskManager.resetUnconditionally();
  }

  /// Completes the task by id
  ///
  /// Passed to [ResearchOption] Widget to allow it to set state in the Research page
  void _onTaskComplete(String taskId) {
    setState(() {
      // removes the task from available tasks and adds it to completed tasks
      _taskManager.completeTask(taskId);
    });
  }

  /// Subtracts the user's currency by [investmentAmount] to invest into research
  /// Passed into [ResearchOption] Widget to allow the user to invest to increase research odds
  ///
  /// Returns `true` if successful, `false` otherwise
  Future<bool> _subtractCurrency(double investmentAmount) async {
    final routes.User? user = await _auth.getUserDBInfo();
    if (user == null) {
      return false;
    }

    final double currentCurrency = double.parse(_currency.currency);
    logger.i(
      "Subtracting user's currency on purchase. Amount subtracted: ${investmentAmount.round()} from $currentCurrency",
    );

    final double updateCurrency = currentCurrency - investmentAmount.round();
    if (updateCurrency < 0) {
      logger.i('Not enough currency to complete transaction.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Not enough currency to complete this purchase!'),
          ),
        );
        return false;
      }
    }

    // Run currency updates concurrently
    await Future.wait([
      _auth.updateUserDBInfo(user..currency = updateCurrency),
      Future(() {
        if (mounted) {
          Provider.of<CurrencyModel>(context, listen: false)
              .setCurrency(updateCurrency.toString());
        }
      }),
    ]);

    return true;
  }

  @override
  void dispose() {
    _currencyGenTimer.storeDisposalTime();
    //_deactivateGenerationServer();
    super.dispose();
  }

  /// Contains logic on whether to unlock or lock the available research tasks
  /// after the user starts a research task
  ///
  /// Unlocks all tasks if the current figure has 'Multi Tasking' capability
  /// Otherwise, it locks all tasks
  Future<void> lockOrUnlock() async {
    // debouncer
    await Future.delayed(const Duration(milliseconds: 100));

    // mounted guard check before checking provider
    if (!mounted) {
      return;
    }
    final FigureModel figure = Provider.of<FigureModel>(context, listen: false);
    for (int i = 0; i < _taskManager.getAvailableTasks().length; i++) {
      if (_taskManager.getAvailableTasks()[i].startTime != null) {
        if (figure.capabilities['Multi Tasking']!) {
          await _taskManager.releaseLockedTasks();
        } else {
          await _taskManager.lockAllInactiveTasks();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final screenWidth = size.width;
    final screenHeight = size.height;
    return FutureBuilder(
      future: _intializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildTopSection(screenWidth, screenHeight),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildResearchSection(screenWidth, screenHeight),
              )
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildTopSection(double screenWidth, double screenHeight) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // hidden widget that updates currency increments when user changes figures
        Consumer<UserModel>(
          builder: (context, figureModel, _) {
            return Consumer<FigureModel>(
              builder: (context, figureModel, _) {
                _getCurrencyIncrement(figureModel, _user.isPremium());

                return Container();
              },
            );
          },
        ),
        Positioned(
          right: _figure.EVLevel == 0 ? screenWidth * 0.4 : screenWidth * 0.275,
          child: FitnessIcon(
            type: FitnessIconType.evolution_circuits,
            size:
                _figure.EVLevel == 0 ? screenWidth * 0.25 : screenWidth * 0.375,
          ),
        ),
        Positioned(
          right: _figure.EVLevel == 0 ? screenWidth * 0.1 : screenWidth * 0.05,
          child: _buildCurrencyDisplay(screenWidth, screenHeight),
        ),
        // Positioned widget breaks this, so I just add padding
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.125),
          child: AnimatedFigure(
            useEquippedFigure: false,
            figureLevel: _figure.EVLevel,
            figureName: _figure.figure!.figureName,
            height: screenHeight * 0.4,
            width: screenWidth * 0.4,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyDisplay(double screenWidth, double screenHeight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10, right: 30),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBorderContainer(
            borderColor: Theme.of(context).colorScheme.primary,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'lib/assets/images/evolution_panel_circle.png',
                height: screenWidth * 0.35,
                width: screenWidth * 0.35,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'EVO ${_figure.EVLevel + 1}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 24,
                ),
              ),
              Text(
                '${_figure.figure!.charge}%',
                style: const TextStyle(
                  color: Color(0xFFFF9E45),
                  fontSize: 20,
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '\$${_getCurrencyIncrement(_figure, _user.isPremium()).toStringAsFixed(3)}/sec',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          fontFamily: 'Roberto',
                        ),
                      ),
                      const FitnessIcon(
                        type: FitnessIconType.up_arrow,
                        size: 10,
                        height: 30,
                        color: Color.fromARGB(255, 255, 158, 69),
                      )
                    ],
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 125),
                    child: Text(
                      '\$${Provider.of<CurrencyModel>(context, listen: true).currency}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                        fontFamily: 'Roberto',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the gradiented container and the research tasks inside of it
  Widget _buildResearchSection(double screenWidth, double screenHeight) {
    return Consumer<FigureModel>(
      builder: (_, figure, __) {
        return SizedBox(
          width: screenWidth,
          height: screenHeight * 0.45,
          child: ResearchGlassPanel(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      _buildResearchHeader(screenWidth, screenHeight),
                      if (_taskManager.isDailyLimitReached())
                        _buildDailyLimitReachedMessage(
                            screenWidth, screenHeight)
                      else
                        _buildAvailableTasks(),
                      _buildResetTasksButton(
                          screenWidth, screenHeight), // debug widget
                    ],
                  ),
                  if (!figure.capabilities['Research Unlocked']!)
                    // adds a locked overlay on this page
                    Container(
                      width: screenWidth,
                      height: screenHeight * 0.51,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock, size: 75),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Research unlocks at ',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(fontSize: 24),
                              ),
                              Text(
                                'EVO 2',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: 24,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds the RESEARCH title bar
  Widget _buildResearchHeader(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth,
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.01,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 91, 103, 100),
            width: 2,
          ),
        ),
      ),
      child: Text(
        'RESEARCH',
        style:
            Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 24),
      ),
    );
  }

  /// Builds the daily limit when the user has done all tasks for the day
  Widget _buildDailyLimitReachedMessage(
      double screenWidth, double screenHeight) {
    return Column(
      children: [
        Container(
          width: screenWidth * 0.85,
          margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.02,
            vertical: screenHeight * 0.02,
          ),
          padding: const EdgeInsets.all(5),
          child: Text(
            'Daily limit reached. Come back tomorrow!',
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(fontSize: 24),
          ),
        ),
      ],
    );
  }

  /// Builds all the available tasks in the [_taskManager]
  Widget _buildAvailableTasks() {
    return Expanded(
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics().applyTo(
              const BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.all(8),
            itemCount: _taskManager.getAvailableTasks().length,
            itemBuilder: (BuildContext context, int index) {
              return ResearchOption(
                key: ValueKey(_taskManager.getAvailableTasks()[index].id),
                task: _taskManager.getAvailableTasks()[index],
                onComplete: _onTaskComplete,
                releaseLockedTasks: _taskManager.releaseLockedTasks,
                onStart: _taskManager.startTask,
                onSubtractCurrency: _subtractCurrency,
                lockAllInactiveTasks: _taskManager.lockAllInactiveTasks,
              );
            }));

    // final List<Widget> content = _taskManager.getAvailableTasks().map((task) {
    //   return ResearchOption(
    //     key: ValueKey(task.id),
    //     task: task,
    //     onComplete: _onTaskComplete,
    //     releaseLockedTasks: _taskManager.releaseLockedTasks,
    //     onStart: _taskManager.startTask,
    //     onSubtractCurrency: _subtractCurrency,
    //     lockAllInactiveTasks: _taskManager.lockAllInactiveTasks,
    //   );
    // }).toList();

    // return Expanded(
    //   child: SingleChildScrollView(
    //     physics: const AlwaysScrollableScrollPhysics().applyTo(
    //       const BouncingScrollPhysics(),
    //     ), // quick fix for this https://github.com/flutter/flutter/issues/138940
    //     child: Column(
    //       children: content,
    //     ),
    //   ),
    // );
  }

  /// This widget creates a button that resets the tasks for debugging.
  /// Set [isDebugging] to true to enable it, but keep it disabled on the main branch.
  Widget _buildResetTasksButton(double screenWidth, double screenHeight,
      {bool isDebugging = false}) {
    return isDebugging
        ? FFAppButton(
            onPressed: _resetTasks,
            text: 'Reset tasks (for debugging)',
            size: screenWidth * 0.55,
            height: screenHeight * 0.06,
            fontSize: 14,
          )
        : Container();
  }
}
