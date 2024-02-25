import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:abc_notes/mixins/custom_forms.dart';
import 'package:abc_notes/util/general_preferences.dart';
import 'package:abc_notes/util/preferences.dart';
import '../l10n/l10n.dart';

class SettingsForm extends StatelessWidget with CustomForms {
  final backgrounColor = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SettingsForm({Key? key}) : super(key: key) {
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.loc!.configurations, style: TextStyle(fontSize: 18)),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.save, color: Colors.white),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _save(context);
                }
              }),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              BasicField(
                  'TODO-HERE',
                  'backgroundColor',
                  backgrounColor,
                  TextInputType.numberWithOptions(decimal: false),
                  FilteringTextInputFormatter.allow(RegExp("^\\d*")))
            ]),
          ),
        ),
      ),
    );
  }

  void _load() async {
    GeneralPreferences generalPreferences =
        await Preferences.readGeneralPreferences();
    //TODO: backgrounColor.text = generalPreferences.backgroundColor.toString();
  }

  void _save(BuildContext context) async {
    //TODO
    /*GeneralPreferences generalPreferences = GeneralPreferences(
        decimalPlaces: int.parse(decimalPlaces.text),
        inflation: double.parse(inflation.text));
    await Preferences.saveGeneralPreferences(generalPreferences);

    Navigator.pop(context, generalPreferences);
    */
  }
}
