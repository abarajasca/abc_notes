import 'package:abc_notes/util/general_preferences.dart';
import 'package:abc_notes/util/hidden_preferences.dart';
import 'package:abc_notes/util/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main(){
  group('Preferences, ', () {

    test('Should save and read general preferences', () async {
      var color = "red";
      var lastUpdate = true;
      var closeAfterSave = true;
      SharedPreferences.setMockInitialValues({
        "gen.background_color": "blue" ,
        "gen.showLastUpdate": false,
        "gen.closeAfterSave": true
      });
      var generalPreferences = GeneralPreferences(backgroundColor: color, showLastUpdate: lastUpdate, closeNoteAfterSave:  closeAfterSave);
      await Preferences.saveGeneralPreferences(generalPreferences);
      await Preferences.readGeneralPreferences().then(( generalPreferences ){
        expect(generalPreferences.backgroundColor,color);
        expect(generalPreferences.showLastUpdate,lastUpdate);
        expect(generalPreferences.closeNoteAfterSave,closeAfterSave);
      });
    });

    test('Should save and read hidden preferences', () async {
      SharedPreferences.setMockInitialValues({
        "hid.sort_type": "other",
        "hid.sort_title": true,
        "hid.sort_time": false,
        "hid.sort_category": true,
      });

      var hiddenPreferences = HiddenPreferences(sortType: "title",sortCategory: false,sortTime: true,sortTitle: false);

      await Preferences.saveHiddenPreferences(hiddenPreferences);
      await Preferences.readHiddenPreferences().then(( hiddenPreferences ){
        expect(hiddenPreferences.sortType,"title");
        expect(hiddenPreferences.sortCategory,false);
        expect(hiddenPreferences.sortTime,true);
        expect(hiddenPreferences.sortTitle,false);
      });
    });

  });
}