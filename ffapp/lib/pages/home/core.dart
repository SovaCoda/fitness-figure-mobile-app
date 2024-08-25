import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixnum/fixnum.dart';

import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/components/research_option.dart';
import 'package:ffapp/components/robot_line_painter.dart';
import 'package:ffapp/components/research_task_manager.dart';

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
  late int? _currencyIncrement;
  late AuthService _auth;

  @override
  void initState() {
    _user = UserModel();
    _figure = FigureModel();
    super.initState();
    _taskManager = ResearchTaskManager();
    _initTaskManager();
    _currencyIncrement = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  Future<void> _initTaskManager() async {
    await _taskManager.init();
  }

  Future<void> _initialize() async {
    _currency = Provider.of<CurrencyModel>(context, listen: false);
    _currencyGenTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _handleCurrencyUpdate(),
    );

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    _auth = Provider.of<AuthService>(context, listen: false);
    _user = Provider.of<UserModel>(context, listen: false);
    _figure = Provider.of<FigureModel>(context, listen: false);
    _currencyIncrement = _getCurrencyIncrement(_figure, _user.isPremium());
    await _reactivateGenerationServer();
  }

  void _handleCurrencyUpdate() {
    _currency.addToCurrency(_currencyIncrement!);
  }

  int _getCurrencyIncrement(FigureModel figure, bool isPremium) {
    return (figure.EVLevel + 1) * (isPremium ? 2 : 1);
  }

  Future<void> _reactivateGenerationServer() async {
    Routes.User? user = await _auth.getUserDBInfo();
    _currency.setCurrency(user!.currency.toString());
    Routes.OfflineDateTime lastLoggedGeneration =
        await _auth.getOfflineDateTime(
      Routes.OfflineDateTime(email: user.email),
    );
    DateTime parsedDateTime = DateTime.parse(lastLoggedGeneration.currency);
    Duration difference = DateTime.now().difference(parsedDateTime);

    if (difference.inSeconds < 0) {
      _auth.updateCurrency(0);
    } else {
      _currency.addToCurrency(difference.inSeconds * _currencyIncrement!);
      _auth.updateCurrency(int.parse(_currency.currency));
    }
  }

  void _deactivateGenerationServer() {
    _auth.updateCurrency(int.parse(_currency.currency));
    _auth.updateOfflineDateTime(Routes.OfflineDateTime(
      email: _user.user!.email,
      currency: DateTime.now().toString(),
    ));
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
    Routes.User? user = await _auth.getUserDBInfo();
    int currentCurrency = int.parse(_currency.currency);
    logger.i(
        "Subtracting user's currency on purchase. Amount subtracted: ${investmentAmount.round()} from $currentCurrency");

    int updateCurrency = currentCurrency - investmentAmount.round();
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

    user!.currency = Int64(updateCurrency);
    await _auth.updateUserDBInfo(user);
    if (mounted) {
      Provider.of<CurrencyModel>(context, listen: false)
          .setCurrency(updateCurrency.toString());
    }
    return true;
  }

  @override
  void dispose() {
    _currencyGenTimer.cancel();
    _deactivateGenerationServer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopSection(),
        _buildResearchSection(),
      ],
    );
  }

  Widget _buildTopSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width * 0.5,
                    MediaQuery.of(context).size.height * 0.3),
                painter: RobotLinePainter(),
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
        _buildCurrencyDisplay(),
      ],
    );
  }

  Widget _buildCurrencyDisplay() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10, right: 30),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        minRadius: 75,
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            Text('EVO ${_figure.EVLevel + 1}',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary)),
            Text('\$${_getCurrencyIncrement(_figure, _user.isPremium())}/sec',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface)),
            Text(
                '\$${Provider.of<CurrencyModel>(context, listen: true).currency}',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          ],
        ),
      ),
    );
  }

  Widget _buildResearchSection() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.51,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildResearchHeader(),
          _taskManager.isDailyLimitReached()
              ? _buildDailyLimitReachedMessage()
              : _buildAvailableTasks(),
          _buildResetTasksButton(),
        ],
      ),
    );
  }

  Widget _buildResearchHeader() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.02,
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.onSurface,
            width: 1,
          ),
        ),
      ),
      child: Text(
        'Research',
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
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: _taskManager.getAvailableTasks().map((task) {
            return ResearchOption(
              key: ValueKey(task.id),
              task: task,
              onComplete: _onTaskComplete,
              onStart: _taskManager.startTask,
              onSubtractCurrency: _subtractCurrency,
            );
          }).toList(),
        ),
      ),
    );
  }

  /*
   * This widget creates a button that resets the tasks for debugging.
   * Set [isDebugging] to true to enable it, but keep it disabled on the main branch.
   */
  Widget _buildResetTasksButton({bool isDebugging = false}) {
    return isDebugging ? ElevatedButton(
      onPressed: _resetTasks,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 40),
      ),
      child: Text(
        'Reset tasks (for debugging)',
        style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
      ),
    ): Container();
  }
}
