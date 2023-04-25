import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../components/monthly_mood_summary.dart';
import '../components/mood_tile.dart';
import '../data/mood_database.dart';

class MoodTrackerPage extends StatefulWidget {
  const MoodTrackerPage({super.key});

  @override
  State<MoodTrackerPage> createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
  //data structure for todays list
  MoodDatabase db = MoodDatabase();
  final _myBox = Hive.box("Mood_Database");

  @override
  void initState() {
    //if there is no current habit list
    //then it is the 1 time the app is opened EVER
    //then create default data
    if (_myBox.get("CURRENT_MOOD_LIST") == null) {
      db.createDefaultData();
    }
    //there already exists some data
    else {
      db.loadData();
    }

    //update the database
    db.updateDatabase();

    super.initState();
  }

  //checkbox was tapped
  void checkboxTapped(bool? value, int index) {
    setState(() {
      db.todaysMoodList[index][1] = value;
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView(children: [
        Center(
            child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
            decoration: BoxDecoration(
                color: Colors.pink[500],
                borderRadius: BorderRadius.circular(12)),
            child: const Text(
              "Welcome back!",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(-1.0, 1.0),
                    blurRadius: 5.0,
                    color: Color.fromARGB(24, 0, 0, 0),
                  ),
                ],
              ),
            ),
          ),
        )),
        //monthly summary heatmap
        MonthlyMoodSummary(
            datasets: db.heatMapDataSet, startDate: _myBox.get("START_DATE")),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: db.todaysMoodList.length,
            itemBuilder: (context, index) {
              //habit tiles
              return MoodTile(
                moodIcon: db.todaysMoodList[index][2],
                moodName: db.todaysMoodList[index][0],
                moodCheck: db.todaysMoodList[index][1],
                onChanged: (value) => checkboxTapped(value, index),
              );
            })
      ]),
    );
  }
}
