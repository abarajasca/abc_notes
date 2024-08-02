import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:abc_notes/mixins/custom_forms.dart';
import 'package:abc_notes/util/general_preferences.dart';
import 'package:abc_notes/util/preferences.dart';
import '../l10n/l10n.dart';


class SettingsForm extends StatefulWidget {
  SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> with CustomForms {
  final backgrounColor = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showLastUpdate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(l10n.loc!.configurations, style: TextStyle(fontSize: 18,color: Colors.white)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text(l10n.loc!.showLastUpdate),
                      Checkbox(value: showLastUpdate,
                          onChanged: (bool? value){
                        setState((){
                          showLastUpdate = value!;
                        });
                      }),],
                  ),
            ]),
          ),
        ),
      ),
    );
  }


  @override
  initState() {
    super.initState();
    Preferences.readGeneralPreferences().then((generalPreferences) {
      setState(() {
        showLastUpdate = generalPreferences.showLastUpdate;
      });
    });
  }

  void _save(BuildContext context) async {
    GeneralPreferences generalPreferences = GeneralPreferences(
      backgroundColor: 'Blue',
      showLastUpdate: showLastUpdate
        );
    await Preferences.saveGeneralPreferences(generalPreferences);

    Navigator.pop(context, generalPreferences);

  }
}
