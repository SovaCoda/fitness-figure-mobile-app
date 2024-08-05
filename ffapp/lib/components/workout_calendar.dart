import 'package:ffapp/main.dart';
import 'package:ffapp/pages/home/store.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkoutCalendar extends StatefulWidget {
  final CalendarFormat calendarFormat;
  final bool isInteractable;
  const WorkoutCalendar(
      {super.key,
      this.calendarFormat = CalendarFormat.week,
      this.isInteractable = true});

  @override
  WorkoutCalendarState createState() => WorkoutCalendarState();
}

class WorkoutCalendarState extends State<WorkoutCalendar> {
  @override
  void initState() {
    super.initState();

    setState(() {
      _selectedDay = _focusedDay;
      _calendarFormat = widget.calendarFormat;
      _interactable = widget.isInteractable;
    });
  }

  Widget _buildCellDate(DateTime day) {
    return Consumer<HistoryModel>(
      builder: (_, workoutHistory, __) {
        bool hasWorkout = false;
        for (var workout in workoutHistory.workouts) {
          DateTime date = DateTime.parse(workout.endDate);
          if (date.year == day.year &&
              date.month == day.month &&
              date.day == day.day) {
            hasWorkout = true;
            logger.i("hasWorkout: $hasWorkout for $day");
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
                : day.isBefore(DateTime.now())
                    ? Theme.of(context).colorScheme.primaryFixedDim
                    : Theme.of(context).colorScheme.surface,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(day.day.toString(),
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: hasWorkout
                      ? Theme.of(context).colorScheme.onPrimary
                      : day.isBefore(DateTime.now())
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onSurface)),
        );
      },
    );
  }

  CalendarFormat _calendarFormat = CalendarFormat.week;
  bool _interactable = true;
  List<Workout> _workouts = [];

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      calendarBuilders: CalendarBuilders(
        outsideBuilder: (context, day, focusedDay) {
          return _buildCellDate(day);
        },
        selectedBuilder: (context, day, focusedDay) {
          return _buildCellDate(day);
        },
        defaultBuilder: (context, day, focusedDay) {
          return _buildCellDate(day);
        },
      ),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay) && _interactable) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        }
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
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
        tablePadding: const EdgeInsets.all(0),
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
                  width: 1, color: Theme.of(context).colorScheme.onSurface)),
        ),
      ),
    );
  }
}
