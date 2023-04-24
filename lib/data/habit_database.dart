//reference the box

import 'package:habit_tracker/datetime/date_time.dart';
import 'package:hive/hive.dart';

final _myBox = Hive.box("Habit_Database");

class HabitDatabase {
  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

  //create initial default data
  void createDefaultData() {
    todaysHabitList = [
      ["Read 10 pages", false],
      ["Skincare", false],
    ];

    _myBox.put("START_DATE", todaysDateFormatted());
  }

  //load the data if it already exists
  void loadData() {
    //if it's a new day, get habit list from database
    if (_myBox.get(todaysDateFormatted()) == null) {
      todaysHabitList = _myBox.get("CURRENT_HABIT_LIST");
      //set all the habits completed to false sinse it's a new day
      for (int i = 0; i < todaysHabitList.length; i++) {
        todaysHabitList[i][1] = false;
      }
    }

    //if it's not a new day, load today's list
    else {
      todaysHabitList = _myBox.get(todaysDateFormatted());
    }
  }

  //update the data
  void updateDatabase() {
    //update todays entry
    _myBox.put(todaysDateFormatted(), todaysHabitList);

    //update universal habit list in case its changed
    //(new habit, updated habit, deleted habit )
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);

    //calculate habit completed percentage for each day
    calculateHabitPercentage();

    //load heatmap
    loadHeatMap();
  }

  void calculateHabitPercentage() {
    int countCompleted = 0;

    for (int i = 0; i < todaysHabitList.length; i++) {
      if (todaysHabitList[i][1] == true) {
        countCompleted++;
      }
    }

    String percentage = todaysHabitList.isEmpty
        ? '0.0'
        : (countCompleted / todaysHabitList.length).toStringAsFixed(1);

    //key: "PERCENTAGE_SUMMARY_yyyymmdd"
    //value: sting of 1dp number between 0.0-1.0  inclusive
    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percentage);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    //count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    //go from startDate to today and add each percentage to the dataset
    //PERCENTAGE_SUMMARY_yyyymmdd will be the key
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd =
          convertDateTimeToString(startDate.add(Duration(days: i)));

      double strengthAsPercent =
          double.parse(_myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? '0.0');

      //split the datetime so it doesnt worry with hours min etc
      // year
      int year = startDate.add(Duration(days: i)).year;

      // month
      int month = startDate.add(Duration(days: i)).month;

      // day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }
}
