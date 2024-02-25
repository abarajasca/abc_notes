import 'package:abc_notes/util/general_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  static Future<GeneralPreferences> readGeneralPreferences() async {
    var pref = await SharedPreferences.getInstance();
    return GeneralPreferences(
        backgroundColor: pref.getString('gen.background_color') ?? 'blue');
  }

  static Future<void> saveGeneralPreferences(GeneralPreferences generalPreferences) async {
    var pref = await SharedPreferences.getInstance();
    pref.setString('gen.background_color', generalPreferences.backgroundColor);
  }

}