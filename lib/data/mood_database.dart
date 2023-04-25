import 'package:hive/hive.dart';

import '../datetime/date_time.dart';

final _myBox = Hive.box("Mood_Database");

class MoodDatabase {
  List todaysMoodList = [];
  Map<DateTime, int> heatMapDataSet = {};

  //create initial default data
  void createDefaultData() {
    todaysMoodList = [
      ["Calm", false, "🙂", 1],
      ["Happy", false, "😄", 2],
      ["Energized", false, "🔋", 3],
      ["Sad", false, "😢", 4],
      ["Stressed", false, "😩", 5],
      ["Angry", false, "😡", 6],
    ];

    _myBox.put("START_DATE", todaysDateFormatted());
  }

  //load the data if it already exists
  void loadData() {
    //if it's a new day, get habit list from database
    if (_myBox.get(todaysDateFormatted()) == null) {
      todaysMoodList = _myBox.get("CURRENT_MOOD_LIST");
      //set all the habits completed to false sinse it's a new day
      for (int i = 0; i < todaysMoodList.length; i++) {
        todaysMoodList[i][1] = false;
      }
    }

    //if it's not a new day, load today's list
    else {
      todaysMoodList = _myBox.get(todaysDateFormatted());
    }
  }

  //update the data
  void updateDatabase() {
    //update todays entry
    _myBox.put(todaysDateFormatted(), todaysMoodList);

    //update universal habit list in case its changed
    //(new habit, updated habit, deleted habit )
    _myBox.put("CURRENT_MOOD_LIST", todaysMoodList);

    //calculate habit completed percentage for each day
    calculateMoodPercentage();

    //load heatmap
    loadHeatMap();
  }

  void calculateMoodPercentage() {
    int intensity = 0;

    for (int i = 0; i < todaysMoodList.length; i++) {
      if (todaysMoodList[i][1] == true) {
        intensity += todaysMoodList[i][3] as int;
      }
    }

    String percentage = todaysMoodList.isEmpty
        ? '0.0'
        : (intensity / todaysMoodList.length).toStringAsFixed(1);

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
