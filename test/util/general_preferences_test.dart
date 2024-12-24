import 'package:abc_notes/util/general_preferences.dart';
import 'package:test/test.dart';

void main(){
  group('General preferences, ', (){
    test('Verify initial state', (){
      var genPreferences = GeneralPreferences(backgroundColor: "background", showLastUpdate: true);
      expect(genPreferences.backgroundColor,"background");
      expect(genPreferences.showLastUpdate,true);
    });
  });
}