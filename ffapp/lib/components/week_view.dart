import 'package:ffapp/icons/fitness_icon.dart';
import 'package:flutter/material.dart';


// This is just a static week view for testing. It doesn't have any functionality.
class WeekView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildWeekView(context);
  }
Widget buildWeekView(BuildContext context) {
  return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.chevron_left, color: Theme.of(context).colorScheme.onSurface),
              Text(
                "June, 2024",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontFamily: 'Roboto', fontSize: 15),
              ),
              Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurface),
            ],
          ),
        ),
        Divider(color: Colors.grey, height: 0.5, indent: 32, endIndent: 32),
        Padding(padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDayCell(context, "21", "Su", false, true),
            _buildDayCell(context, "22", "Mo", true, true),
            _buildDayCell(context, "23", "Tu", false, true),
            _buildDayCell(context, "24", "We", false, true),
            _buildDayCell(context, "25", "Th", true, true),
            _buildDayCell(context, "26", "Fr", false, false),
            _buildDayCell(context, "27", "Sa", false, false),
          ],
        ),
        )
      ],
  );
}

Widget _buildDayCell(BuildContext context, String date, String day, bool isLogged, bool isDayYet) {
  return Column( 
  children: [
    Text(
          date,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
                fontFamily: 'Roboto',
                fontSize: 17
          ),
        ),
    Stack(
      alignment: Alignment.center,
    children: [ 
      
      Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          day,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 22,
          ),
        ),
        
        
      ],
      
    ),
    Opacity(
      opacity: 0.6,
    child: FitnessIcon(
        type: isDayYet ? isLogged ? FitnessIconType.calendar_slot_logged : FitnessIconType.calendar_slot : FitnessIconType.calendar_slot_unlogged,
        size: 48,
      ),
    ),
  ]),
  ]);
}
}