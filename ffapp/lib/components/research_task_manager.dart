import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ResearchTask {
  final String id;
  final String title;
  int chance;
  final int ev;
  final Duration duration;
  DateTime? startTime;

  ResearchTask({
    required this.id,
    required this.title,
    required this.chance,
    required this.ev,
    required this.duration,
    this.startTime,
  });


  factory ResearchTask.fromString(String taskString) {
    final parts = taskString.split('|');
    return ResearchTask(
      id: parts[0],
      title: parts[1],
      chance: int.parse(parts[2]),
      ev: int.parse(parts[3]),
      duration: Duration(seconds: int.parse(parts[4])),
      startTime: parts[5] != 'null' ? DateTime.parse(parts[5]) : null,
    );
  }

  @override
  String toString() {
    return '$id|$title|$chance|$ev|${duration.inSeconds}|${startTime?.toIso8601String()}';
  }
}

class ResearchTaskManager {
  static const int _dailyTaskLimit = 5;
  static const List<String> _taskTitles = [
    'Optimize Processors',
    'Shine Tracks',
    'Upgrade Coolants',
    'Enhance AI Algorithms',
    'Reinforce Chassis',
    'Refine Engines',
    'Boost Signal Range',
    'Fortify Shields',
    'Calibrate Sensors',
    'Streamline Circuits',
    'Amplify Power Output',
    'Synchronize Networks',
    'Elevate System Security',
    'Tune Propulsion',
    'Optimize Data Streams',
    'Maximize Efficiency',
    'Stabilize Power Grids',
    'Upgrade Firmware',
    'Enhance Vision Systems',
    'Optimize Heat Dissipation',
    'Improve Hydraulic Systems',
    'Reinforce Armor Plating',
    'Upgrade Software Protocols',
    'Enhance Communication Channels',
    'Increase Payload Capacity',
  ];

  List<ResearchTask> _availableTasks = [];
  Set<String> _completedTaskIds = {};
  int _tasksCompletedToday = 0;
  DateTime _lastResetDate = DateTime.now();
  final Random _random = Random.secure();
  final Uuid _uuid = const Uuid();

  Future<void> init() async {
    await _loadSavedData();
    _resetIfNewDay();
    if (_availableTasks.isEmpty) {
      _generateNewTasks();
      await _saveData();
    }
  }

  List<ResearchTask> getAvailableTasks() {
    List<ResearchTask> availableTasks = _availableTasks
        .where((task) => !_completedTaskIds.contains(task.id))
        .toList();

    if (availableTasks.isEmpty) {
      _generateNewTasks();
      return _availableTasks
          .where((task) => !_completedTaskIds.contains(task.id))
          .toList();
    }

    return availableTasks;
  }

  void completeTask(String taskId) {
    _completedTaskIds.add(taskId);
    _tasksCompletedToday++;
    _saveData();
  }

  void _generateNewTasks() {
    _availableTasks = List.generate(_dailyTaskLimit, (_) => _createRandomTask());
    _saveData();
  }

  ResearchTask _createRandomTask() {
    String id = _uuid.v4();
    int chance = 5 + _random.nextInt(46);
    int durationMinutes = (1 + _random.nextInt(1));
    Duration duration = Duration(minutes: durationMinutes);

    double evMultiplier = 0.5 + (1 / (chance / 100));
    double randomFactor = 2 + (_random.nextDouble() * 0.3);
    double durationFactor = duration.inSeconds * 0.004;

    int ev = 10 + (0.5 * evMultiplier * randomFactor * durationFactor).round();

    return ResearchTask(
      id: id,
      title: _taskTitles[_random.nextInt(_taskTitles.length)],
      chance: chance,
      ev: ev.clamp(10, 200),
      duration: duration,
    );
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    _completedTaskIds = Set<String>.from(prefs.getStringList('completedTaskIds') ?? []);
    _tasksCompletedToday = prefs.getInt('tasksCompletedToday') ?? 0;
    _lastResetDate = DateTime.parse(prefs.getString('lastResetDate') ?? DateTime.now().toIso8601String());

    final savedTasks = prefs.getStringList('availableTasks') ?? [];
    _availableTasks = savedTasks.map(ResearchTask.fromString).toList();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('completedTaskIds', _completedTaskIds.toList());
    await prefs.setInt('tasksCompletedToday', _tasksCompletedToday);
    await prefs.setString('lastResetDate', _lastResetDate.toIso8601String());

    final tasksToSave = _availableTasks.map((task) => task.toString()).toList();
    await prefs.setStringList('availableTasks', tasksToSave);
  }

  void _resetIfNewDay() {
    final now = DateTime.now();
    if (now.day != _lastResetDate.day ||
        now.month != _lastResetDate.month ||
        now.year != _lastResetDate.year) {
      _resetTasks(now);
    }
  }

  void resetUnconditionally() {
    _resetTasks(DateTime.now());
  }

  void _resetTasks(DateTime now) {
    _availableTasks.clear();
    _completedTaskIds.clear();
    _tasksCompletedToday = 0;
    _lastResetDate = now;
    _generateNewTasks();
    _saveData();
  }

  void startTask(String taskId) {
    final taskIndex = _availableTasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _availableTasks[taskIndex].startTime = DateTime.now();
      _saveData();
    }
  }

  bool isDailyLimitReached() {
    return _tasksCompletedToday >= _dailyTaskLimit;
  }
}