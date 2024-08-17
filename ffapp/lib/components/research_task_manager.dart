import 'dart:math';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResearchTask {
  final String id;
  final String title;
  final int chance;
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
}

class ResearchTaskManager {
  List<ResearchTask> _availableTasks = [];
  Set<String> _completedTaskIds = {};
  final int _dailyTaskLimit = 5;
  int _tasksCompletedToday = 0;
  DateTime _lastResetDate = DateTime.now();
  final random = Random.secure();

  final List<String> _taskTitles = [
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

  Future<void> init() async {
    await _loadSavedData();
    _resetIfNewDay();
    if (_availableTasks.isEmpty) {
      _generateNewTasks();
    }
  }

  List<ResearchTask> getAvailableTasks() {
    return _availableTasks
        .where((task) => !_completedTaskIds.contains(task.id))
        .toList();
  }

  void completeTask(String taskId) {
    _completedTaskIds.add(taskId);
    _tasksCompletedToday++;
    _saveData();

    if (_tasksCompletedToday >= _dailyTaskLimit ||
        getAvailableTasks().isEmpty) {
      _generateNewTasks();
    }
  }

  void _generateNewTasks() {
    _availableTasks =
        List.generate(_dailyTaskLimit, (_) => _createRandomTask());
    _saveData();
  }

  ResearchTask _createRandomTask() {
    int chance = 5 + random.nextInt(36);
    int durationMinutes = 15 + random.nextInt(31);
    Duration duration =
        Duration(seconds: durationMinutes); // seconds for the time being

    double evMultiplier = 0.5 + (1 / (chance / 100));
    double randomFactor = 2 + (random.nextDouble() * 0.3);
    double durationFactor = duration.inSeconds * 0.008;

    int ev = 10 + (0.5 * evMultiplier * randomFactor * durationFactor).round();

    return ResearchTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _taskTitles[random.nextInt(_taskTitles.length)],
      chance: chance, // 5-40% chance
      ev: ev.clamp(10, 200), // Ensure EV is between 10 and 50
      duration: duration, // 15-45 minutes
    );
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    _completedTaskIds =
        Set<String>.from(prefs.getStringList('completedTaskIds') ?? []);
    _tasksCompletedToday = prefs.getInt('tasksCompletedToday') ?? 0;
    _lastResetDate = DateTime.parse(
        prefs.getString('lastResetDate') ?? DateTime.now().toIso8601String());

    final savedTasks = prefs.getStringList('availableTasks') ?? [];
    _availableTasks = savedTasks.map((taskString) {
      final parts = taskString.split('|');
      return ResearchTask(
        id: parts[0],
        title: parts[1],
        chance: int.parse(parts[2]),
        ev: int.parse(parts[3]),
        duration: Duration(seconds: int.parse(parts[4])),
        startTime: parts[5] != 'null' ? DateTime.parse(parts[5]) : null,
      );
    }).toList();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('completedTaskIds', _completedTaskIds.toList());
    prefs.setInt('tasksCompletedToday', _tasksCompletedToday);
    prefs.setString('lastResetDate', _lastResetDate.toIso8601String());

    final tasksToSave = _availableTasks
        .map((task) =>
            '${task.id}|${task.title}|${task.chance}|${task.ev}|${task.duration.inSeconds}|${task.startTime?.toIso8601String()}')
        .toList();
    prefs.setStringList('availableTasks', tasksToSave);
  }

  void _resetIfNewDay() {
    final now = DateTime.now();
    if (now.day != _lastResetDate.day ||
        now.month != _lastResetDate.month ||
        now.year != _lastResetDate.year) {
      _availableTasks.clear();
      _completedTaskIds.clear();
      _tasksCompletedToday = 0;
      _lastResetDate = now;
      _generateNewTasks();
    }
  }

  void resetUnconditionally() {
    final now = DateTime.now();
    _completedTaskIds.clear();
    _tasksCompletedToday = 0;
    _lastResetDate = now;
    _generateNewTasks();
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
