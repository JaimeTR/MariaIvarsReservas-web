import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Set<DateTime> reservedDates;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;

  CalendarView({
    required this.focusedDay,
    required this.selectedDay,
    required this.reservedDates,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width * 0.3,
      child: TableCalendar(
        locale: 'es_ES', // Establece el idioma en español
        daysOfWeekVisible: false,
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(selectedDay, day);
        },
        onDaySelected: onDaySelected,

        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            if (reservedDates.any((d) => isSameDay(d, day))) {
              return Container(
                margin: const EdgeInsets.all(6.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  day.day.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }
}
