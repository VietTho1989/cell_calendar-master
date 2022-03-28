import 'package:align_positioned/align_positioned.dart';
import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lunar_calendar/lunar_calendar.dart';

import '../../controllers/calendar_state_controller.dart';
import '../../controllers/cell_height_controller.dart';
import 'event_labels.dart';
import 'measure_size.dart';

/// Show the row of [_DayCell] cells with events
class DaysRow extends StatelessWidget {
  const DaysRow({
    required this.visiblePageDate,
    required this.dates,
    required this.dateTextStyle,
    Key? key,
  }) : super(key: key);

  final List<DateTime> dates;
  final DateTime visiblePageDate;
  final TextStyle? dateTextStyle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: dates.map((date) {
          return _DayCell(
            date,
            visiblePageDate,
            dateTextStyle,
          );
        }).toList(),
      ),
    );
  }
}

/// Cell of calendar.
///
/// Its height is circulated by [MeasureSize] and notified by [CellHeightController]
class _DayCell extends StatelessWidget {
  _DayCell(this.date, this.visiblePageDate, this.dateTextStyle);

  final DateTime date;
  final DateTime visiblePageDate;
  final TextStyle? dateTextStyle;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final isToday = date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;

    bool isCurrentMonth = today.month == date.month && today.year == date.year;
// strLunar
    String strLunar = '';
    Color lunarColor = Color.fromARGB(255, 112, 112, 112);
    {
      List<int> lunarVi = CalendarConverter.solarToLunar(
          date.year, date.month, date.day, Timezone.Vietnamese);
      print(lunarVi);
      // text
      if (lunarVi.length > 2) {
        if (lunarVi[0] == 1) {
          strLunar = '${lunarVi[0]}/${lunarVi[1]}';
        } else {
          strLunar = '${lunarVi[0]}';
        }
      }
      // color
      if (isCurrentMonth) {
        if (lunarVi[0] == 1) {
          lunarColor = Color.fromARGB(255, 235, 55, 43);
        } else {
          lunarColor = Color.fromARGB(255, 102, 102, 102);
        }
      } else {
        lunarColor = Color.fromARGB(255, 229, 229, 229);
      }
    }
    // ngay hoang dao
    bool isNgayHoangDao = date.day % 2 == 0;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          Provider.of<CalendarStateController>(context, listen: false)
              .onCellTapped(date);
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
              right:
                  BorderSide(color: Theme.of(context).dividerColor, width: 1),
            ),
          ),
          child: MeasureSize(
            onChange: (size) {
              if (size == null) return;
              Provider.of<CellHeightController>(context, listen: false)
                  .onChanged(size);
            },
            child: Stack(
              children: [
                // tvDay
                AlignPositioned(
                  alignment: Alignment.center,
                  dy: -16,
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                        color: isCurrentMonth
                            ? Color.fromARGB(255, 31, 31, 31)
                            : Color.fromARGB(255, 212, 212, 212),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // tvLunarDay
                AlignPositioned(
                  alignment: Alignment.center,
                  dy: 8,
                  child: Text(
                    strLunar,
                    style: TextStyle(
                      color: lunarColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                // today
                AlignPositioned(
                    alignment: Alignment.center,
                    dy: -16,
                    dx: 15.5,
                    childWidth: isToday ? 7 : 0,
                    childHeight: isToday ? 7 : 0,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 41, 57),
                          shape: BoxShape.circle),
                    )),
                // ngay hoang dao
                AlignPositioned(
                    alignment: Alignment.center,
                    dy: 9.5,
                    dx: 15.5,
                    childWidth: 7,
                    childHeight: 7,
                    child: Container(
                      // margin: EdgeInsets.all(100.0),
                      decoration: BoxDecoration(
                          color: isNgayHoangDao
                              ? Color.fromARGB(255, 243, 166, 37)
                              : Color.fromARGB(255, 153, 153, 153),
                          shape: BoxShape.circle),
                    )),
              ],
            ),
            /*child: Column(
              children: [
                isToday
                    ? _TodayLabel(
                        date: date,
                        dateTextStyle: dateTextStyle,
                      )
                    : _DayLabel(
                        date: date,
                        visiblePageDate: visiblePageDate,
                        dateTextStyle: dateTextStyle,
                      ),
                EventLabels(date),
              ],
            ),*/
          ),
        ),
      ),
    );
  }
}

class _TodayLabel extends StatelessWidget {
  const _TodayLabel({
    Key? key,
    required this.date,
    required this.dateTextStyle,
  }) : super(key: key);

  final DateTime date;
  final TextStyle? dateTextStyle;

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<TodayUIConfig>(context, listen: false);
    final caption = Theme.of(context)
        .textTheme
        .caption!
        .copyWith(fontWeight: FontWeight.w500);
    final textStyle = caption.merge(dateTextStyle);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: config.todayMarkColor,
      ),
      child: Center(
        child: Text(
          date.day.toString(),
          textAlign: TextAlign.center,
          style: textStyle.copyWith(
            color: config.todayTextColor,
          ),
        ),
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  const _DayLabel({
    Key? key,
    required this.date,
    required this.visiblePageDate,
    required this.dateTextStyle,
  }) : super(key: key);

  final DateTime date;
  final DateTime visiblePageDate;
  final TextStyle? dateTextStyle;

  @override
  Widget build(BuildContext context) {
    final isCurrentMonth = visiblePageDate.month == date.month;
    final caption = Theme.of(context).textTheme.caption!.copyWith(
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface);
    final textStyle = caption.merge(dateTextStyle);
    return Container(
      margin: EdgeInsets.symmetric(vertical: dayLabelVerticalMargin.toDouble()),
      height: dayLabelContentHeight.toDouble(),
      child: Text(
        date.day.toString(),
        textAlign: TextAlign.center,
        style: textStyle.copyWith(
          color: isCurrentMonth
              ? textStyle.color
              : textStyle.color!.withOpacity(0.4),
        ),
      ),
    );
  }
}
