import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habit_tracker/datetime/date_time.dart';

class MonthlySummary extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDate;

  const MonthlySummary(
      {super.key, required this.datasets, required this.startDate});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: HeatMap(
      startDate: createDateTimeObject(startDate),
      endDate: DateTime.now().add(
        Duration(days: 0),
      ),
      datasets: datasets,
      colorMode: ColorMode.color,
      defaultColor: Colors.grey[200],
      textColor: Colors.white,
      showColorTip: false,
      showText: true,
      scrollable: true,
      size: 30,
      colorsets: const {
        1: Color.fromARGB(19, 179, 2, 96),
        2: Color.fromARGB(40, 179, 2, 79),
        3: Color.fromARGB(58, 179, 2, 102),
        4: Color.fromARGB(80, 179, 2, 79),
        5: Color.fromARGB(98, 179, 2, 73),
        6: Color.fromARGB(120, 179, 2, 85),
        7: Color.fromARGB(148, 179, 2, 102),
        8: Color.fromARGB(180, 179, 2, 73),
        9: Color.fromARGB(220, 179, 2, 70),
        10: Color.fromARGB(255, 179, 2, 79),
      },
      onClick: (value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(value.toString())));
      },
    ));
  }
}
