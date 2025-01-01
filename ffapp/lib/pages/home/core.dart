import 'dart:async';
import 'dart:math';
import 'package:ffapp/assets/data/figure_ev_data.dart';
import 'package:ffapp/components/animated_button.dart';
import 'package:ffapp/components/resuables/animated_border_painter.dart';
import 'package:ffapp/icons/fitness_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixnum/fixnum.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart' as routes;
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/components/research_option.dart';
import 'package:ffapp/components/research_task_manager.dart';
import 'package:ffapp/components/research_glass_panel.dart';

class Core extends StatefulWidget {
  const Core({super.key});

  @override
  State<Core> createState() => _CoreState();
}

class _CoreState extends State<Core> {
  late ResearchTaskManager _taskManager;
  late FigureModel _figure;
  late CurrencyModel _currency;
  late Timer _currencyGenTimer;
  late UserModel _user;
  late double? _currencyIncrement;
  late AuthService _auth;
  late Future<void> _intializationFuture;

  @override
  void initState() {
    _user = UserModel();
    _figure = FigureModel();

    super.initState();

    _currencyIncrement = 0;
    _intializationFuture = _initialize();
  }

  Future<void> _initializeTaskManager() async {
    _taskManager = ResearchTaskManager(figureModel: _figure);
    return _taskManager.init();
  }

  Future<void> _initialize() async {
    _currency = Provider.of<CurrencyModel>(context, listen: false);
    _currencyGenTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _handleCurrencyUpdate(),
    );

    // Run multiple initialization tasks concurrently
    await Future.wait([
      _initializeServices(),
      _initializeTaskManager(),
    ]);

    if (!mounted) return;

    Provider.of<SelectedFigureProvider>(context, listen: false)
        .addListener(() => lockOrUnlock());
  }

  Future<void> _initializeServices() async {
    if (!mounted) return;

    _auth = Provider.of<AuthService>(context, listen: false);
    _user = Provider.of<UserModel>(context, listen: false);
    _figure = Provider.of<FigureModel>(context, listen: false);
    _getCurrencyIncrement(_figure, _user.isPremium());

    // Run currency reactivation concurrently with other initialization tasks
    await _reactivateGenerationServer();
  }

  void _handleCurrencyUpdate() {
    _currency.addToCurrency(_currencyIncrement!);
  }

  double _getCurrencyIncrement(FigureModel figure, bool isPremium) {
    _currencyIncrement =
        (figure1.currencyGens[figure.EVLevel]) * (isPremium ? 2 : 1);
    return _currencyIncrement!;
  }

  Future<void> _reactivateGenerationServer() async {
    // Run user info and offline datetime fetching concurrently
    final futures = await Future.wait([
      _auth.getUserDBInfo(),
      _auth.getOfflineDateTime(
        routes.OfflineDateTime(email: _user.user!.email),
      ),
    ]);

    final routes.User? user = futures[0] as routes.User?;
    final routes.OfflineDateTime lastLoggedGeneration =
        futures[1] as routes.OfflineDateTime;

    if (user == null) return;

    _currency.setCurrency(user.currency.toString());
    final DateTime parsedDateTime =
        DateTime.parse(lastLoggedGeneration.currency);
    final Duration difference = DateTime.now().difference(parsedDateTime);

    if (difference.inSeconds < 0) {
      await _auth.updateCurrency(0);
    } else {
      final double currencyToAdd = difference.inSeconds * _currencyIncrement!;
      _currency.addToCurrency(currencyToAdd);
      await _auth.updateCurrency(double.parse(_currency.currency).ceil());
    }
  }

  void _deactivateGenerationServer() {
    _auth.updateCurrency(double.parse(_currency.currency).toInt());
    _auth.updateOfflineDateTime(
      routes.OfflineDateTime(
        email: _user.user!.email,
        currency: DateTime.now().toString(),
      ),
    );
  }

  void _resetTasks() {
    _taskManager.resetUnconditionally();
  }

  void _onTaskComplete(String taskId) {
    setState(() {
      _taskManager.completeTask(taskId);
    });
  }

  Future<bool> _subtractCurrency(double investmentAmount) async {
    final routes.User? user = await _auth.getUserDBInfo();
    if (user == null) return false;

    final double currentCurrency = double.parse(_currency.currency);
    logger.i(
      "Subtracting user's currency on purchase. Amount subtracted: ${investmentAmount.round()} from $currentCurrency",
    );

    final double updateCurrency = currentCurrency - investmentAmount.round();
    if (updateCurrency < 0) {
      logger.i("Not enough currency to complete transaction.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Not enough currency to complete this purchase!"),
          ),
        );
        return false;
      }
    }

    // Run currency updates concurrently
    await Future.wait([
      _auth.updateUserDBInfo(user..currency = Int64(updateCurrency.ceil())),
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
    _currencyGenTimer.cancel();
    _deactivateGenerationServer();
    super.dispose();
  }

  Future<void> lockOrUnlock() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;

    final FigureModel figure = Provider.of<FigureModel>(context, listen: false);
    if (figure.capabilities['Multi Tasking']!) {
      await _taskManager.releaseLockedTasks();
    } else {
      await _taskManager.lockAllInactiveTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _intializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              _buildTopSection(),
              _buildResearchSection(),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildTopSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
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
            Expanded(
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // CustomPaint(
                  //   size: Size(MediaQuery.of(context).size.width * 0.5,
                  //       MediaQuery.of(context).size.height * 0.3),
                  //   painter: RobotLinePainter(),
                  // ),

                  Positioned(
                    right: MediaQuery.of(context).size.width * 0.3,
                    child: const FitnessIcon(
                      type: FitnessIconType.evolution_circuits,
                      size: 120,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: _buildCurrencyDisplay(),
                  ),
                  RobotImageHolder(
                    url: (_figure.figure != null)
                        ? "${_figure.figure!.figureName}/${_figure.figure!.figureName}_skin${_figure.figure!.curSkin}_evo${_figure.EVLevel}_cropped_happy"
                        : "robot1/robot1_skin0_evo0_cropped_happy",
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrencyDisplay() {
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
                "lib/assets/images/evolution_panel_circle.png",
                height: 150,
                width: 150,
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
              Column(
                children: [
                  Text(
                    '\$${_getCurrencyIncrement(_figure, _user.isPremium())}/sec',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      fontFamily: 'Roberto',
                    ),
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

  Widget _buildResearchSection() {
    return Consumer<FigureModel>(
      builder: (_, figure, __) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.5,
          child: ResearchGlassPanel(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      _buildResearchHeader(),
                      _taskManager.isDailyLimitReached()
                          ? _buildDailyLimitReachedMessage()
                          : _buildAvailableTasks(),
                      _buildResetTasksButton(),
                    ],
                  ),
                  if (!figure.capabilities['Research Unlocked']!)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.51,
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

  Widget _buildResearchHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: MediaQuery.of(context).size.height * 0.01,
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

  Widget _buildDailyLimitReachedMessage() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.85,
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02,
            vertical: MediaQuery.of(context).size.height * 0.02,
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

  Widget _buildAvailableTasks() {
    List<Widget> content = _taskManager.getAvailableTasks().map((task) {
      return ResearchOption(
        key: ValueKey(task.id),
        task: task,
        onComplete: _onTaskComplete,
        releaseLockedTasks: _taskManager.releaseLockedTasks,
        onStart: _taskManager.startTask,
        onSubtractCurrency: _subtractCurrency,
        lockAllInactiveTasks: _taskManager.lockAllInactiveTasks,
      );
    }).toList();

    return Expanded(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics().applyTo(
          const BouncingScrollPhysics(),
        ), // quick fix for this https://github.com/flutter/flutter/issues/138940
        child: Column(
          children: content,
        ),
      ),
    );
  }

  /*
   * This widget creates a button that resets the tasks for debugging.
   * Set [isDebugging] to true to enable it, but keep it disabled on the main branch.
   */
  Widget _buildResetTasksButton({bool isDebugging = false}) {
    return isDebugging
        ? FFAppButton(
            onPressed: _resetTasks,
            text: 'Reset tasks (for debugging)',
            size: MediaQuery.of(context).size.width * 0.55,
            height: MediaQuery.of(context).size.height * 0.06,
            fontSize: 14,
          )
        : Container();
  }
}
