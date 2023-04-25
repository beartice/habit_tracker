import 'package:flutter/material.dart';

class HabitAlertBox extends StatelessWidget {
  final List habitList;
  final String dateSelected;

  const HabitAlertBox(
      {super.key, required this.habitList, required this.dateSelected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[100],
      content: Container(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Center(
              child: Text(
                dateSelected,
                style: TextStyle(
                    color: Colors.pink.shade700, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: habitList.length,
                itemBuilder: (context, index) {
                  //habit tiles
                  return Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Checkbox(
                            value: habitList[index][1],
                            onChanged: (context) {}),
                        Text(
                          habitList[index][0],
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
