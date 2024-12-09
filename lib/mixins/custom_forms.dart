import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../l10n/l10n.dart';

mixin CustomForms {
  Widget editDescriptionForm(TextEditingController descriptionController) {
     return Column(children: [
       TextFormField(
         decoration: InputDecoration(
             labelText: l10n.loc!.categoryName,
             labelStyle: TextStyle(color: Colors.black),
             fillColor: Colors.lightBlue),
         validator: (value) {
           //print(" key: " + key.toString() + ' validation: ' + (key.toString().contains(switchState.selectedValue) && value != '').toString() + " selected value :" + switchState.selectedValue );
           if (value == null || value.isEmpty) {
             return l10n.loc!.valueRequired;
           }
           return null;
         },
         controller: descriptionController,
         //onTap: () => descriptionController.selection = TextSelection(
         //    baseOffset: 0, extentOffset: descriptionController.value.text.length),
         autofocus: false,
       )
     ]);
  }

  Widget BasicField(String label, String key, TextEditingController controller,
      TextInputType? keyboadType, TextInputFormatter formatter, {bool validateZero = false, bool readOnlyParam = false, String defaltValueIfEmpty = ''}) {
    return Row(children: [
      Expanded(
        flex: 100,
        child: TextFormField(
          key: ValueKey(key),
          readOnly: readOnlyParam,
          decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.black),
              fillColor: Colors.lightBlue),
          keyboardType: keyboadType,
          inputFormatters: [formatter],
          validator: (value) {
            //print(" key: " + key.toString() + ' validation: ' + (key.toString().contains(switchState.selectedValue) && value != '').toString() + " selected value :" + switchState.selectedValue );
            if (value == null || value.isEmpty) {
              controller.text = defaltValueIfEmpty;
              return null;
            }
            if (keyboadType != TextInputType.text) {
              if (validateZero && double.parse(value) == 0 ){
                return '';
              }
            }
            return null;
          },
          controller: controller,
          onTap:   () {},
            //=> controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.value.text.length),
          autofocus: false,
        ),
      ),
    ]);
  }

  Widget DateBasicField(BuildContext context,Function updateState,String label, String key, TextEditingController controller,
      TextInputType? keyboadType, TextInputFormatter formatter, {bool validateZero = false, bool readOnlyParam = false, String defaltValueIfEmpty = ''}) {
    return Row(children: [
      Expanded(
        flex: 100,
        child: TextFormField(
          key: ValueKey(key),
          readOnly: readOnlyParam,
          decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.black),
              fillColor: Colors.lightBlue),
          keyboardType: keyboadType,
          inputFormatters: [formatter],
          validator: (value) {
            //print(" key: " + key.toString() + ' validation: ' + (key.toString().contains(switchState.selectedValue) && value != '').toString() + " selected value :" + switchState.selectedValue );
            if (value == null || value.isEmpty) {
              controller.text = defaltValueIfEmpty;
              return null;
            }
            if (keyboadType != TextInputType.text) {
              if (validateZero && double.parse(value) == 0 ){
                return 'TODO-HERE';
              }
            }
            return null;
          },
          controller: controller,
          onTap: () async {
            // controller.selection = TextSelection(
            //     baseOffset: 0, extentOffset: controller.value.text.length);
            DateTime? pickedDate = await showDatePicker(
                context: context, initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101)
            );

            if (pickedDate != null ) {
              String formattedDate = DateFormat('yyyy-MM-dd').format(
                  pickedDate);
              updateState(formattedDate);
            }
          },
          autofocus: true,
        ),
      ),
    ]);
  }

}