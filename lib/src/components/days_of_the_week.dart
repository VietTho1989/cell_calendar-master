import 'package:align_positioned/align_positioned.dart';
import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';

/// Days of the week
///
// TODO: Internationalize the days of the week
const List<String> _DaysOfTheWeek = [
  'CN', //'Sun',
  'HAI', //'Mon',
  'BA', //'Tue',
  'TƯ', //'Wed',
  'NĂM', //'Thu',
  'SÁU', //'Fry',
  'BẢY', //'Sat'
];

/// Show the row of text from [_DaysOfTheWeek]
class DaysOfTheWeek extends StatelessWidget {
  DaysOfTheWeek(this.daysOfTheWeekBuilder);

  final daysBuilder? daysOfTheWeekBuilder;

  Widget defaultLabels(index) {
    return Container(
      color: index == 0
          ? const Color.fromARGB(255, 255, 0, 0)
          : const Color.fromARGB(255, 104, 128, 179),
      height: 40,
      child: Center(
        child: Text(
          _DaysOfTheWeek[index],
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        7,
        (index) {
          return Expanded(
            child: daysOfTheWeekBuilder?.call(index) ?? defaultLabels(index),
          );
        },
      ),
    );
  }
}
