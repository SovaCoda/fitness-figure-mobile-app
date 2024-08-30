import 'package:ffapp/assets/data/figure_ev_data.dart';
import 'package:ffapp/components/button_themes.dart';
import 'package:ffapp/components/resuables/gradiented_container.dart';
import 'package:ffapp/components/utils/history_model.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/pages/home/store.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkoutCalendar extends StatefulWidget {
  final CalendarFormat calendarFormat;
  final bool isInteractable;
  final int workoutMinTime;
  final bool showWorkoutData;
  const WorkoutCalendar(
      {super.key,
      this.showWorkoutData = false,
      this.workoutMinTime = 30,
      this.calendarFormat = CalendarFormat.week,
      this.isInteractable = true});

  @override
  WorkoutCalendarState createState() => WorkoutCalendarState();
}

class WorkoutCalendarState extends State<WorkoutCalendar> {
  int _workoutMinTime = 30;
  bool showWorkoutData = true;
  Color _selectedColor = Colors.blue;
  List<int> indicatorsShown = [];
  Map<String, List<FlSpot>> weekData = {};
  int maxEv = 0;

  @override
  void initState() {
    super.initState();

    DateTime weekStart = mostRecentSunday(DateTime.now());
    DateTime weekEnd = weekStart.add(Duration(days: 6));

    setState(() {
      if (widget.isInteractable) {
        _rangeStart = weekStart;
        _rangeEnd = weekEnd;
      }
      showWorkoutData = widget.showWorkoutData;
      _workoutMinTime = widget.workoutMinTime;
      _selectedDay = _focusedDay;
      _calendarFormat = widget.calendarFormat;
      _interactable = widget.isInteractable;
    });

    initialize();
  }

  DateTime mostRecentSunday(DateTime date) {
    return DateTime(date.year, date.month, date.day - date.weekday % 7);
  }

  void initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _selectedColor = Theme.of(context).colorScheme.primary;
    });
    getWeekDataForDate(DateTime.now());
  }

  int? _chargeChange;
  int? _evChange;
  int? _streakChange;
  int? _goal;
  DateTime? _weekOfDate;

  void getWeekDataForDate(DateTime date) async {
    date = date.toUtc();
    User user = Provider.of<UserModel>(context, listen: false).user!;
    FigureInstance figure =
        Provider.of<FigureModel>(context, listen: false).figure!;
    weekData = await Provider.of<HistoryModel>(context, listen: false)
        .getWeekData(
            user.email,
            figure1.EvCutoffs[figure.evLevel],
            user.curFigure,
            date,
            figure.charge,
            figure.evPoints,
            user.streak.toInt(),
            user.weekComplete.toInt());

    indicatorsShown = weekData['charge']!.map((e) {
      return weekData['charge']!.indexWhere((element) => element == e);
    }).toList();

    setState(() {
      if (weekData['charge']!.isEmpty) {
        weekData['charge']!.add(FlSpot(1, 0));
        _chargeChange = null;
        _evChange = null;
        _streakChange = null;
        _goal = null;
      } else {
        _chargeChange = weekData['changes']![0].x.toInt();
        _evChange = weekData['changes']![0].y.toInt();
        _streakChange = weekData['streakAndGoal']![0].x.toInt();
        _goal = weekData['streakAndGoal']![0].y.toInt();
        _weekOfDate = (date);
      }

      maxEv = figure1.EvCutoffs[figure.evLevel];
      lineBarsData = [
        LineChartBarData(
          showingIndicators: indicatorsShown,
          spots: evTrueChargeFalse ? weekData['ev']! : weekData['charge']!,
          color: _selectedColor,
          isCurved: false,
        ),
      ];
    });
  }

  Widget _buildSelectedCellDate(
    DateTime day,
  ) {
    day = day.toUtc();
    return Center(
      child: Consumer<HistoryModel>(
        builder: (_, workoutHistory, __) {
          bool hasWorkout = false;
          for (var workout in workoutHistory.workouts) {
            DateTime date = DateTime.parse(workout.endDate).toLocal();
            if (date.year == day.year &&
                date.month == day.month &&
                date.day == day.day &&
                (workout.countable == 1)) {
              hasWorkout = true;
              break;
            }
          }
          return Container(
            margin: const EdgeInsets.all(0),
            width: 40,
            height: 40,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: hasWorkout
                    ? Theme.of(context).colorScheme.primary
                    : day.isBefore(DateTime.now().toUtc())
                        ? (day.day == DateTime.now().toUtc().day &&
                                day.month == DateTime.now().toUtc().month &&
                                day.year == DateTime.now().toUtc().year)
                            ? Theme.of(context).colorScheme.surface
                            : Theme.of(context).colorScheme.primaryFixedDim
                        : Theme.of(context).colorScheme.surface,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                    strokeAlign: BorderSide.strokeAlignOutside,
                    width: 2,
                    color: Theme.of(context).colorScheme.primary)),
            child: Text(day.day.toString(),
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: hasWorkout
                        ? Theme.of(context).colorScheme.onPrimary
                        : day.isBefore(DateTime.now().toUtc())
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSurface)),
          );
        },
      ),
    );
  }

  Widget _buildCellDate(DateTime day) {
    return Consumer<HistoryModel>(
      builder: (_, workoutHistory, __) {
        DateTime parsedDay = day.toUtc();
        bool hasWorkout = false;
        for (var workout in workoutHistory.workouts) {
          DateTime date = DateTime.parse(workout.endDate).toLocal();
          if (date.year == parsedDay.year &&
              date.month == parsedDay.month &&
              date.day == parsedDay.day &&
              (workout.countable == 1)) {
            hasWorkout = true;
            logger.i("hasWorkout: $hasWorkout for $day");
            break;
          }
        }
        return Center(
          child: Container(
            margin: const EdgeInsets.all(0),
            width: 40,
            height: 40,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: hasWorkout
                  ? Theme.of(context).colorScheme.primary
                  : day.isBefore(DateTime.now().toUtc())
                      ? (day.day == DateTime.now().toUtc().day &&
                              day.month == DateTime.now().toUtc().month &&
                              day.year == DateTime.now().toUtc().year)
                          ? Theme.of(context).colorScheme.surface
                          : Theme.of(context).colorScheme.primaryFixedDim
                      : Theme.of(context).colorScheme.surface,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text(day.day.toString(),
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: hasWorkout
                        ? Theme.of(context).colorScheme.onPrimary
                        : day.isBefore(DateTime.now().toUtc())
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSurface)),
          ),
        );
      },
    );
  }

  CalendarFormat _calendarFormat = CalendarFormat.week;
  bool _interactable = true;
  List<Workout> _workouts = [];
  Workout? workoutData = null;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart = DateTime(2010, 10, 16);
  DateTime? _rangeEnd = DateTime(2010, 10, 22);

  bool evTrueChargeFalse = false;
  List<LineChartBarData> lineBarsData = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          rangeStartDay: _rangeStart,
          rangeEndDay: _rangeEnd,
          calendarFormat: _calendarFormat,
          calendarBuilders: CalendarBuilders(
            rangeStartBuilder: (context, day, focusedDay) {
              return _buildCellDate(day);
            },
            rangeEndBuilder: (context, day, focusedDay) {
              return _buildCellDate(day);
            },
            rangeHighlightBuilder: (context, day, focusedDay) {
              return ((day.isAfter(_rangeStart!) ||
                          (isSameDay(_rangeStart, day))) &&
                      day.isBefore(_rangeEnd!))
                  ? Container(
                      margin: const EdgeInsets.only(top: 1, bottom: 1),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: isSameDay(day, _rangeStart)
                                  ? Radius.circular(5)
                                  : Radius.circular(0),
                              bottomLeft: isSameDay(day, _rangeStart)
                                  ? Radius.circular(5)
                                  : Radius.circular(0),
                              topRight: isSameDay(day, _rangeEnd)
                                  ? Radius.circular(5)
                                  : Radius.circular(0),
                              bottomRight: isSameDay(day, _rangeEnd)
                                  ? Radius.circular(5)
                                  : Radius.circular(0)),
                          border: Border(
                            top: BorderSide(
                                strokeAlign: BorderSide.strokeAlignInside,
                                width: 2,
                                color: Theme.of(context).colorScheme.primary),
                            bottom: BorderSide(
                                strokeAlign: BorderSide.strokeAlignInside,
                                width: 2,
                                color: Theme.of(context).colorScheme.primary),
                            left: isSameDay(day, _rangeStart)
                                ? BorderSide(
                                    strokeAlign: BorderSide.strokeAlignInside,
                                    width: 2,
                                    color:
                                        Theme.of(context).colorScheme.primary)
                                : BorderSide.none,
                            right: isSameDay(day, _rangeEnd)
                                ? BorderSide(
                                    strokeAlign: BorderSide.strokeAlignInside,
                                    width: 2,
                                    color:
                                        Theme.of(context).colorScheme.primary)
                                : BorderSide.none,
                          )),
                    )
                  : Container();
            },
            withinRangeBuilder: (context, day, focusedDay) {
              return _buildCellDate(day);
            },
            todayBuilder: (context, day, focusedDay) {
              return _buildCellDate(day);
            },
            outsideBuilder: (context, day, focusedDay) {
              return _buildCellDate(day);
            },
            defaultBuilder: (context, day, focusedDay) {
              return _buildCellDate(day);
            },
            selectedBuilder: (context, day, focusedDay) {
              return _buildSelectedCellDate(day);
            },
          ),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay) && _interactable) {
              DateTime weekStart = mostRecentSunday(selectedDay);
              DateTime weekEnd = weekStart.add(Duration(days: 6));

              getWeekDataForDate(selectedDay);

              evTrueChargeFalse
                  ? _showEvoData(context)
                  : _showChargeData(context);
              Color selectedColor = evTrueChargeFalse
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary;
              setState(() {
                if (_interactable) {
                  _selectedColor = selectedColor;
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _rangeStart = weekStart;
                  _rangeEnd = weekEnd;
                }
              });
            }
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          daysOfWeekHeight: 20,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: Theme.of(context).textTheme.displayMedium!,
            weekendStyle: Theme.of(context).textTheme.displayMedium!,
            dowTextFormatter: (date, locale) =>
                DateFormat.E(locale).format(date)[0] +
                DateFormat.E(locale).format(date)[1],
          ),
          calendarStyle: CalendarStyle(
            tablePadding: const EdgeInsets.all(4),
            // Customize the calendar style here
            outsideTextStyle: Theme.of(context).textTheme.displaySmall!,
            defaultTextStyle: Theme.of(context).textTheme.displaySmall!,
            todayTextStyle: Theme.of(context).textTheme.displaySmall!,
            weekendTextStyle: Theme.of(context).textTheme.displaySmall!,
            selectedTextStyle: Theme.of(context).textTheme.displaySmall!,
            outsideDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            weekendDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            defaultDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            selectedDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: Theme.of(context).colorScheme.primary),
            ),
            todayDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.rectangle,
              border: Border.all(
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            headerPadding: const EdgeInsets.all(0),
            rightChevronPadding: const EdgeInsets.all(4),
            leftChevronPadding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1,
                      color: Theme.of(context).colorScheme.onSurface)),
            ),
          ),
        ),
        if (showWorkoutData)
          _chargeChange != null
              ? GradientedContainer(
                  height: 275,
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Week of ${_weekOfDate!.month}/${_weekOfDate!.day}/${_weekOfDate!.year}",
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.onSurface),
                      ),
                      Center(
                          child: Container(
                        margin: const EdgeInsets.only(top: 0, bottom: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            shape: BoxShape.rectangle,
                            color: Theme.of(context).colorScheme.onSurface),
                        height: 2,
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<UserModel>(
                            builder: (_, user, __) {
                              return Row(
                                children: [
                                  Text('Weekly Goal ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface)),
                                  Text('${"$_goal/${user.user!.weekGoal}"}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary)),
                                ],
                              );
                            },
                          ),
                          // cant figure out a good way to track this so just waysiding it for now
                          // Text(
                          //     'Streak\n ${_streakChange! < 0 ? "BROKEN" : "+$_streakChange"}',
                          //     style: Theme.of(context)
                          //         .textTheme
                          //         .displayMedium!
                          //         .copyWith(
                          //             color: Theme.of(context)
                          //                 .colorScheme
                          //                 .tertiary))
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.only(top: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        child: LineChart(
                          LineChartData(
                              showingTooltipIndicators:
                                  indicatorsShown.map((index) {
                                return ShowingTooltipIndicators([
                                  LineBarSpot(
                                      lineBarsData[0],
                                      lineBarsData.indexOf(lineBarsData[0]),
                                      lineBarsData[0].spots[index])
                                ]);
                              }).toList(),
                              lineTouchData: LineTouchData(
                                enabled: true,
                                handleBuiltInTouches: false,
                                touchCallback: (FlTouchEvent event,
                                    LineTouchResponse? response) {
                                  if (response == null ||
                                      response.lineBarSpots == null) {
                                    return;
                                  }
                                  if (event is FlTapUpEvent) {
                                    final spotIndex =
                                        response.lineBarSpots!.first.spotIndex;
                                  }
                                },
                                mouseCursorResolver: (FlTouchEvent event,
                                    LineTouchResponse? response) {
                                  if (response == null ||
                                      response.lineBarSpots == null) {
                                    return SystemMouseCursors.basic;
                                  }
                                  return SystemMouseCursors.click;
                                },
                                getTouchedSpotIndicator:
                                    (LineChartBarData barData,
                                        List<int> spotIndexes) {
                                  return spotIndexes.map((index) {
                                    return TouchedSpotIndicatorData(
                                      FlLine(
                                        color: _selectedColor,
                                      ),
                                      FlDotData(
                                        show: true,
                                        getDotPainter:
                                            (spot, percent, barData, index) =>
                                                FlDotCirclePainter(
                                          radius: 2,
                                          color: _selectedColor,
                                          strokeWidth: 2,
                                          strokeColor: _selectedColor,
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
                                touchTooltipData: LineTouchTooltipData(
                                  getTooltipColor: (touchedSpot) =>
                                      Colors.transparent,
                                  tooltipRoundedRadius: 8,
                                  tooltipMargin: 0,
                                  getTooltipItems:
                                      (List<LineBarSpot> lineBarsSpot) {
                                    return lineBarsSpot.map((lineBarSpot) {
                                      return LineTooltipItem(
                                        evTrueChargeFalse
                                            ? lineBarSpot.y == maxEv.toDouble()
                                                ? "MAX"
                                                : lineBarSpot.y.toString()
                                            : lineBarSpot.y.toString(),
                                        TextStyle(
                                            color: _selectedColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                              lineBarsData: lineBarsData,
                              minX: 1,
                              maxX: 7,
                              minY: evTrueChargeFalse ? 0 : 0,
                              maxY: evTrueChargeFalse ? maxEv.toDouble() : 100,
                              titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                          getTitlesWidget:
                                              (double value, TitleMeta meta) {
                                            return dayOfWeekLabel(value, meta);
                                          },
                                          interval: 1,
                                          showTitles: true,
                                          reservedSize: 40)),
                                  leftTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)))),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FfButton(
                              width: 120,
                              height: 40,
                              text:
                                  "Charge ${_chargeChange! > 0 ? "+$_chargeChange" : "$_chargeChange"}%",
                              textStyle:
                                  Theme.of(context).textTheme.displaySmall!,
                              textColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              onPressed: () => {_showChargeData(context)}),
                          FfButton(
                              width: 120,
                              height: 40,
                              text:
                                  "Evo ${_evChange! > 0 ? "+$_evChange" : "$_evChange"}",
                              textStyle:
                                  Theme.of(context).textTheme.displaySmall!,
                              textColor:
                                  Theme.of(context).colorScheme.onSecondary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              onPressed: () => {_showEvoData(context)})
                        ],
                      ),
                    ],
                  ),
                )
              : Text("No data available for this week"),
      ],
    );
  }

  void _showChargeData(context) {
    setState(() {
      evTrueChargeFalse = false;
      _selectedColor = Theme.of(context).colorScheme.primary;
      lineBarsData = [
        LineChartBarData(
          showingIndicators: indicatorsShown,
          spots: weekData['charge']!,
          isCurved: false,
          color: _selectedColor,
        ),
      ];
    });
  }

  void _showEvoData(context) {
    setState(() {
      evTrueChargeFalse = true;
      _selectedColor = Theme.of(context).colorScheme.secondary;
      lineBarsData = [
        LineChartBarData(
          showingIndicators: indicatorsShown,
          spots: weekData['ev']!,
          isCurved: false,
          color: _selectedColor,
        ),
      ];
    });
  }
}

Widget dayOfWeekLabel(double value, TitleMeta meta) {
  switch (value.toInt()) {
    case 2:
      return Text('Mo');
    case 3:
      return Text('Tu');
    case 4:
      return Text('We');
    case 5:
      return Text('Th');
    case 6:
      return Text('Fr');
    case 7:
      return Text('Sa');
    case 1:
      return Text('Su');
    default:
      return Text('');
  }
}
