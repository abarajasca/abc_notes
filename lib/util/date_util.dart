import 'package:intl/intl.dart';

class DateUtil {
  static String getCurrentDateTime(){
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd-HH-mm-ss');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  static String formatUIDateTime(String datetime){
    if (datetime.length > 10) {
      String year = datetime.substring(0, 10);
      String time = datetime.substring(11).replaceAll('-', ':');
      return '$year $time';
    } else {
      return '';
    }
  }

}