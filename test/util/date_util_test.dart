import 'package:abc_notes/util/date_util.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

void main(){
  group("Test date util properties",(){
    test('get current time formated',(){
      var now = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd-HH');
      var dateFormatted = formatter.format(now);
      expect(DateUtil.getCurrentDateTime().substring(0,13),dateFormatted);
    });

    test('Get current time formated for UI',(){
      var now = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd-HH-mm-ss');
      var formatterUi = DateFormat('yyyy-MM-dd HH:mm:ss');
      expect(DateUtil.formatUIDateTime(formatter.format(now)),formatterUi.format(now));
    });
  });
}