import 'package:abc_notes/util/general_preferences.dart';
import 'package:abc_notes/util/hidden_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  static Future<GeneralPreferences> readGeneralPreferences() async {
    final pref = await SharedPreferences.getInstance();
    return GeneralPreferences(
        backgroundColor: pref.getString('gen.background_color') ?? 'blue',
        showLastUpdate: pref.getBool('gen.showLastUpdate') ?? true,
        closeNoteAfterSave: pref.getBool('gen.closeNoteAfterSave') ?? true
    );
  }

  static Future<void> saveGeneralPreferences(GeneralPreferences generalPreferences) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('gen.background_color', generalPreferences.backgroundColor);
    pref.setBool('gen.showLastUpdate', generalPreferences.showLastUpdate);
    pref.setBool('gen.closeNoteAfterSave', generalPreferences.closeNoteAfterSave);
  }

  static Future<HiddenPreferences> readHiddenPreferences() async {
    final pref = await SharedPreferences.getInstance();
    return HiddenPreferences(
        sortType : pref.getString('hid.sort_type') ?? 'sort_category',
        sortTitle: pref.getBool('hid.sort_title') ?? true,
        sortTime: pref.getBool('hid.sort_time') ?? false,
        sortCategory: pref.getBool('hid.sort_category') ?? false
    );
  }

  static Future<void> saveHiddenPreferences(HiddenPreferences hiddenPreferences) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('hid.sort_type', hiddenPreferences.sortType);
    pref.setBool('hid.sort_title', hiddenPreferences.sortTitle);
    pref.setBool('hid.sort_time', hiddenPreferences.sortTime);
    pref.setBool('hid.sort_category', hiddenPreferences.sortCategory);
  }

}