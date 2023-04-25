import 'package:flutter/material.dart';

class MoodTile extends StatelessWidget {
  final String moodIcon;
  final String moodName;
  final bool moodCheck;
  final Function(bool?)? onChanged;

  const MoodTile(
      {super.key,
      required this.moodIcon,
      required this.moodName,
      required this.moodCheck,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Checkbox(value: moodCheck, onChanged: onChanged),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(moodIcon, style: TextStyle(fontSize: 18)),
            ),
            Text(
              moodName,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
