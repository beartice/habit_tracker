import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../components/habit_tile.dart';
import '../components/monthly_summary.dart';
import '../components/my_alert_box.dart';
import '../components/my_fab.dart';
import '../data/habit_database.dart';

class HabitTrackerPage extends StatefulWidget {
  const HabitTrackerPage({super.key});

  @override
  State<HabitTrackerPage> createState() => _HabitTrackerPageState();
}

class _HabitTrackerPageState extends State<HabitTrackerPage> {
  //data structure for todays list
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");

  //create New Habit
  final _newHabitNameController = TextEditingController();

  @override
  void initState() {
    //if there is no current habit list
    //then it is the 1 time the app is opened EVER
    //then create default data
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
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
      db.todaysHabitList[index][1] = value;
    });
    db.updateDatabase();
  }

  void deleteHabit(int index) {
    //delete index
    setState(() {
      db.todaysHabitList.removeAt(index);
    });

    db.updateDatabase();
  }

  //open habit settings to edit
  void openHabitSettings(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertBox(
              controller: _newHabitNameController,
              hintText: db.todaysHabitList[index][0],
              onSave: () => saveExistingHabit(index),
              onCancel: cancelDialogBox);
        });
  }

  void createNewHabit() {
    //show alert dialog for users to enter habit details
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertBox(
            controller: _newHabitNameController,
            hintText: 'Enter Habit Name',
            onCancel: cancelDialogBox,
            onSave: saveNewHabit,
          );
        });
  }

  void cancelDialogBox() {
    //clear text field
    _newHabitNameController.clear();
    //pop dialog box
    Navigator.of(context).pop();
  }

  void saveNewHabit() {
    //add new habit to todaysHabitList
    //set state per notificare alla UI che deve refresharsi
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text.toString(), false]);
    });
    //clear text field
    _newHabitNameController.clear();
    //pop dialog box
    Navigator.of(context).pop();

    db.updateDatabase();
  }

  //edit existing habit
  void saveExistingHabit(int index) {
    //update index habitName
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text.toString();
    });
    //clear text field
    _newHabitNameController.clear();
    //pop dialog box
    Navigator.of(context).pop();

    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
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
          MonthlySummary(
              datasets: db.heatMapDataSet, startDate: _myBox.get("START_DATE")),

          //list of habits
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: db.todaysHabitList.length,
              itemBuilder: (context, index) {
                //habit tiles
                return HabitTile(
                  habitName: db.todaysHabitList[index][0],
                  habitCompleted: db.todaysHabitList[index][1],
                  onChanged: (value) => checkboxTapped(value, index),
                  settingsTapped: (context) => openHabitSettings(index),
                  deleteTapped: (context) => deleteHabit(index),
                );
              })
        ],
      ),
      floatingActionButton: MyFloatingActionButton(
        onPressed: createNewHabit,
      ),
      backgroundColor: Colors.grey[300],
    );
  }
}
