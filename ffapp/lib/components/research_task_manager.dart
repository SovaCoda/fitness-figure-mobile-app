import 'dart:math';
import 'package:ffapp/main.dart';
import 'package:ffapp/pages/home/store.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ResearchTask {
  final String id;
  final String title;
  bool locked = false;
  int chance;
  int ev;
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
  final FigureModel figureModel;
  ResearchTaskManager({required this.figureModel});
  static const int _dailyTaskLimit = 5;
  static const List<String> _taskTitles = [
    // made uppercase to match design
    'OPTIMIZE PROCESSORS',
    'SHINE TRACKS',
    'UPGRADE COOLANTS',
    'ENHANCE AI ALGORITHMS',
    'REINFORCE CHASSIS',
    'REFINE ENGINES',
    'BOOST SIGNAL RANGE',
    'FORTIFY SHIELDS',
    'CALIBRATE SENSORS',
    'STREAMLINE CIRCUITS',
    'AMPLIFY POWER OUTPUT',
    'SYNCHRONIZE NETWORKS',
    'ELEVATE SYSTEM SECURITY',
    'TUNE PROPULSION',
    'OPTIMIZE DATA STREAMS',
    'MAXIMIZE EFFICIENCY',
    'STABILIZE POWER GRIDS',
    'UPGRADE FIRMWARE',
    'ENHANCE VISION SYSTEMS',
    'OPTIMIZE HEAT DISSIPATION',
    'IMPROVE HYDRAULIC SYSTEMS',
    'REINFORCE ARMOR PLATING',
    'UPGRADE SOFTWARE PROTOCOLS',
    'INCREASE PAYLOAD CAPACITY',
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
    final List<ResearchTask> availableTasks = _availableTasks
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
    for (final task in _availableTasks) {
      task.locked = false;
    }
    _tasksCompletedToday++;
    _saveData();
  }

  void _generateNewTasks() {
    _availableTasks =
        List.generate(_dailyTaskLimit, (_) => _createRandomTask());
    _saveData();
  }

  ResearchTask _createRandomTask() {
    final String id = _uuid.v4();
    final int chance = 5 + _random.nextInt(46);
    final int durationMinutes = (30 * (figureModel.EVLevel + 1)) +
        (_random.nextInt(10) * (figureModel.EVLevel + 1));
    final Duration duration = Duration(minutes: durationMinutes);

    final double evMultiplier = 0.5 + (1 / (chance / 100));
    final double randomFactor = 2 + (_random.nextDouble() * 0.3);
    final double durationFactor = duration.inSeconds * 0.004;

    final int ev =
        10 + (0.5 * evMultiplier * randomFactor * durationFactor).round();

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
    _completedTaskIds =
        Set<String>.from(prefs.getStringList('completedTaskIds') ?? []);
    _tasksCompletedToday = prefs.getInt('tasksCompletedToday') ?? 0;
    _lastResetDate = DateTime.parse(
      prefs.getString('lastResetDate') ?? DateTime.now().toIso8601String(),
    );

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

  Future<void> releaseLockedTasks() async {
    for (final task in _availableTasks) {
      task.locked = false;
    }
    // _saveData();
  }

  Future<void> lockAllInactiveTasks() async {
    final List<ResearchTask> startedTasks =
        _availableTasks.where((task) => task.startTime != null).toList();
    if (startedTasks.isEmpty) {
      return;
    }
    for (int i = 0; i < _availableTasks.length; i++) {
      if (_availableTasks[i].startTime == null) {
        _availableTasks[i].locked = true;
        logger.i('Locking task ${_availableTasks[i].title}');
      }
    }
  }

  void startTask(String taskId, BuildContext context) {
    final taskIndex = _availableTasks.indexWhere((task) => task.id == taskId);
    if (!figureModel.capabilities['Multi Tasking']!) {
      _availableTasks
          .where((task) => (task.startTime == null) && (task.id != taskId))
          .forEach((task) => task.locked = true);
    } else {
      for (final task in _availableTasks) {
        task.locked = false;
      }
    }
    if (taskIndex != -1) {
      _availableTasks[taskIndex].startTime = DateTime.now();
      _saveData();
    }
  }

  bool isDailyLimitReached() {
    return _tasksCompletedToday >= _dailyTaskLimit;
  }
}
