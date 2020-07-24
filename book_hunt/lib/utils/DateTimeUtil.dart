convertDateTime(srcDtStr) {
  var dateAndTime = srcDtStr.split(" ");
  var now = new DateTime.now();
  String today = getYMD(now);
  String yesterday = getYMD(now.add(new Duration(days: -1)));
  if (dateAndTime[0] == today) {
    return '今天 ' + dateAndTime[1];
  } else if (dateAndTime[0] == yesterday) {
    return '昨天 ' + dateAndTime[1];
  } else {
    return dateAndTime[0];
  }
}

getYMD(DateTime d) {
  String year = d.year.toString();
  String month = d.month.toString().padLeft(2, '0');
  String day = d.day.toString().padLeft(2, '0');
  return "${year}-${month}-${day}";
  ;
}
