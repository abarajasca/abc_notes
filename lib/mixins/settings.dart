import 'package:flutter/material.dart';
import 'package:abc_notes/forms/settings_form.dart';

mixin Settings {

  void showSettings(BuildContext context,Function thenAction){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>  SettingsForm())
    ).then((value) {
        thenAction.call(value);
    });
  }
}