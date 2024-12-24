import 'package:abc_notes/util/general_preferences.dart';
import 'package:abc_notes/util/hidden_preferences.dart';
import 'package:test/test.dart';

void main(){
  group('Hidden preferences, ', (){
    test('Verify initial state', (){
      var hiddenPreferences = HiddenPreferences(sortType: "title",sortCategory: false,sortTime: true,sortTitle: false);
      expect(hiddenPreferences.sortType,"title");
      expect(hiddenPreferences.sortCategory,false);
      expect(hiddenPreferences.sortTime,true);
      expect(hiddenPreferences.sortTitle,false);
    });
  });
}