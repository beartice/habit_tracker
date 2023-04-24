import 'package:flutter/material.dart';
import 'package:habit_tracker/components/monthly_summary.dart';
import 'package:habit_tracker/data/habit_database.dart';
import 'package:hive/hive.dart';

import '../components/habit_tile.dart';
import '../components/my_fab.dart';
import '../components/my_alert_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //data structure for todays list
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");

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

  //create New Habit
  final _newHabitNameController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: MyFloatingActionButton(
          onPressed: createNewHabit,
        ),
        body: ListView(
          children: [
            //monthly summary heatmap
            MonthlySummary(
                datasets: db.heatMapDataSet,
                startDate: _myBox.get("START_DATE")),

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
        ));
  }
}
