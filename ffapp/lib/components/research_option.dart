import 'dart:math';
import 'package:ffapp/components/utils/time_utils.dart';
import 'package:flutter/material.dart';
import 'package:ffapp/components/button_themes.dart';
import 'dart:async';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:ffapp/components/research_task_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResearchOption extends StatefulWidget {
  final ResearchTask task;
  final Function(String) onComplete;
  final Function(String) onStart;
  final Function(double) onSubtractCurrency;

  const ResearchOption({
    super.key,
    required this.task,
    required this.onComplete,
    required this.onStart,
    required this.onSubtractCurrency,
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

  double _investmentAmount = 0;
  int _currentChance = 0;
  int _cost = 0;
  int _currentCountdown = 0;
  int _time = 0;
  int _randValue = 0;
  int _tickSpeed = 1000;
  

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  void _uponFigureChange(FigureModel figureModel, int time) {
    if (!_isInitialized) return;
    Map<String, bool> capabilities = figureModel.capabilities;
    if (capabilities['Research 20% Faster'] == true) {
      _tickSpeed = 800;
    } else if (capabilities['Halve Research Time'] == true) {
      _tickSpeed = 500;
    } else {
      _tickSpeed = 1000;
    }

    _timer.changeTickSpeedMS(_tickSpeed);
    
  }

  void _initializeState() async {
    task = widget.task;
    prefs = await SharedPreferences.getInstance();

    Map<String, bool> capabilities =
        Provider.of<FigureModel>(context, listen: false).capabilities;
    if (capabilities['Research 20% Faster'] == true) {
      _tickSpeed = 800;
    }
    if (capabilities['Halve Research Time'] == true) {
      _tickSpeed = 500;
    }
    _timer = PersistantTimer(
        timerName: task.title,
        prefs: prefs,
        milliseconds: 0,
        tickSpeedMS: _tickSpeed,
        onTick: _updateTimer);
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
        widget.onStart(widget.task.id);
      });
    } else {
      _currentCountdown = widget.task.duration.inSeconds;
      _currentChance = widget.task.chance;
    }
    _auth = Provider.of<AuthService>(context, listen: false);
    _figure = Provider.of<FigureModel>(context, listen: false);

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
      widget.onStart(widget.task.id);
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

  void _giveRewards() async {
    FigureInstance figureInstance = _figure.figure!;
    int totalEV = figureInstance.evPoints + widget.task.ev;
    _figure.setFigureEv(totalEV);
    UserModel user = Provider.of<UserModel>(context, listen: false);
    figureInstance = _figure.figure!;

    await _auth.updateFigureInstance(FigureInstance(
      figureId: figureInstance.figureId,
      userEmail: user.user!.email,
      figureName: figureInstance.figureName,
      charge: figureInstance.charge.toInt(),
      evPoints: figureInstance.evPoints.toInt(),
    ));
    widget.onComplete(widget.task.id);
  }

  void _startResearch() async {
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
      String emotion = happy ? 'happy' : 'sad';
      return "${_figure.figure!.figureName}/${_figure.figure!.figureName}_skin${_figure.figure!.curSkin}_evo${_figure.EVLevel}_cropped_$emotion";
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

  void _cancelTask() {
    _timer.deleteTimer();
    prefs.remove('${task.title} investment');

    _isDelete = false;
    _isExpanded = false;
    _isCountdown = false;
    _isExpanded = false;
    widget.onComplete(widget.task.id);
  }

  @override
  void dispose() {
    _timer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isDelete) return Container();

    Provider.of<FigureModel>(context, listen: false)
        .addListener(() => _uponFigureChange(_figure, _time));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: MediaQuery.of(context).size.width * 0.87,
      height: _getContainerHeight(),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: _isExpanded
            ? MainAxisAlignment.start
            : MainAxisAlignment.spaceBetween,
        children: [
          _buildTitle(),
          _isExpanded ? _buildExpandedContent() : _buildCollapsedContent(),
        ],
      ),
    );
  }

  double _getContainerHeight() {
    if (!_isExpanded) return MediaQuery.of(context).size.height * 0.14;
    return _isCompleted
        ? MediaQuery.of(context).size.height * 0.4
        : MediaQuery.of(context).size.height * 0.4;
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.only(bottom: 3),
      decoration: _isExpanded
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 1,
                ),
              ),
            )
          : null,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Text(
        widget.task.title,
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
    );
  }

  Widget _buildCollapsedContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChanceAndEVInfo(),
        _buildTimerAndButton(),
      ],
    );
  }

  Widget _buildChanceAndEVInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\t\t\t$_currentChance% Chance',
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Color.fromARGB(
                  255,
                  255 - (2.55 * _currentChance).round(),
                  0 + (2.55 * _currentChance).round(),
                  0,
                ),
              ),
        ),
        const SizedBox(height: 4),
        Text(
          '\t\t+${widget.task.ev} EV',
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
      ],
    );
  }

  Widget _buildTimerAndButton() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!_isCompleted) _buildTimer(),
        _buildActionButton(),
      ],
    );
  }

  Widget _buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_tickSpeed != 1000)
          Text("+${(1000 - _tickSpeed) / 10}%  ",
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: Theme.of(context).colorScheme.onSurface)),
        Text(
          _isCountdown
              ? _formatDuration(Duration(seconds: _currentCountdown))
              : _formatDuration(widget.task.duration),
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const Icon(Icons.access_time, size: 20),
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
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      style: _getButtonStyle(),
      child: Text('Begin', style: _getButtonTextStyle()),
    );
  }

  Widget _buildProgressButton() {
    return FfButtonProgressableResearch(
      text: 'In Progress',
      textColor: Theme.of(context).colorScheme.onPrimary,
      disabledColor: Theme.of(context).colorScheme.onSurface,
      width: MediaQuery.of(context).size.width * 0.4,
      height: 40,
      backgroundColor: Theme.of(context).colorScheme.primary,
      progress: _time / widget.task.duration.inSeconds,
      onPressed: () {},
      textStyle: Theme.of(context).textTheme.displaySmall!,
    );
  }

  Widget _buildCompletedButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      style: _getButtonStyle(color: Theme.of(context).colorScheme.primary),
      child: Text('Completed', style: _getButtonTextStyle()),
    );
  }

  ButtonStyle _getButtonStyle({Color? color}) {
    return ElevatedButton.styleFrom(
      backgroundColor: color ?? Theme.of(context).colorScheme.onSurface,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 40),
    );
  }

  _getExpandedButtonStyle({Color? color}) {
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

  TextStyle _getBackButtonTextStyle() {
    return Theme.of(context).textTheme.displaySmall!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        );
  }

  Widget _buildExpandedContent() {
    if (!_isCompleted) {
      return _buildInvestmentContent();
    } else if (_currentChance >= _randValue || _currentChance == 100) {
      return _buildSuccessContent();
    } else {
      return _buildFailureContent();
    }
  }

  Widget _buildInvestmentContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Text(
          'Invest funds to improve chances of research success!',
          style: Theme.of(context).textTheme.displaySmall,
        ),
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
          label: _cost.toString(),
        ),
        Text(
          '$_currentChance% Chance',
          style: TextStyle(
            color: Color.fromARGB(
              255,
              255 - (2.55 * _currentChance).round(),
              0 + (2.55 * _currentChance).round(),
              0,
            ),
          ),
        ),
        ResearchButton(onPressed: _startResearch),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isExpanded = false;
            });
          },
          style: _getExpandedButtonStyle(color: Colors.grey[900]),
          child: Text('Back', style: _getBackButtonTextStyle()),
        ),
      ],
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'SUCCESS',
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Row(
          children: [
            RobotImageHolder(
              url: _getRobotImageUrl(happy: true),
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            Text(
              '+${widget.task.ev} EV',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: _handleSuccessCompletion,
          style: _getButtonStyle(),
          child: Text('Awesome!', style: _getButtonTextStyle()),
        ),
      ],
    );
  }

  Widget _buildFailureContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Text(
          'FAILURE',
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
        ),
        Row(
          children: [
            RobotImageHolder(
              url: _getRobotImageUrl(happy: false),
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            Text(
              '+0 EV',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: _handleFailureCompletion,
          style: _getExpandedButtonStyle(),
          child: Text('Okay', style: _getButtonTextStyle()),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

class ResearchButton extends StatefulWidget {
  final VoidCallback onPressed;

  const ResearchButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  _ResearchButtonState createState() => _ResearchButtonState();
}

class _ResearchButtonState extends State<ResearchButton> {
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

  _getExpandedButtonStyle({Color? color}) {
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
