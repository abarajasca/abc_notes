
import 'package:abc_notes/database/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import '../database/models/category.dart';
import '../mixins/custom_forms.dart';
import '../util/preferences.dart';
import '../util/selectable.dart';
import '../l10n/l10n.dart';
import '../widgets/floating_button.dart';

class EditCategoryForm extends StatefulWidget {
  Category? category;

  EditCategoryForm({Key? key, this.category}) : super(key: key);

  @override
  State<EditCategoryForm> createState() =>
      _EditCategoryFormState(category: category);
}

class _EditCategoryFormState extends State<EditCategoryForm> with CustomForms {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  int _color = Colors.blue.value;

  Category? category;

  late List<Selectable> dataModel = [];
  bool refreshData = true;
  int dataLength = 0;

  _EditCategoryFormState({this.category}) {
    loadFields();
  }

  void loadFields() {
    _name.text = category != null ? category!.name : '';
    _color = category != null ? category!.color : Colors.blue.value;
  }

  initState() {
    super.initState();
    Preferences.readGeneralPreferences().then((generalPreferences) {
      // to define
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            _editMode() ? l10n.loc!.editCategory : l10n.loc!.addCategory,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          centerTitle: false,
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                categoryForm(),
              ],
            ),
          ),
        ),
        floatingActionButton:
            FloatingButton(onPressed: () => {saveCategory()}, icon: Icons.save)
        );
  }

  Form categoryForm(){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BasicField(
              l10n.loc!.categoryName,
              'name',
              _name,
              TextInputType.text,
              FilteringTextInputFormatter.allow(
                  RegExp(r'^.{0,50}$'))),
          SizedBox.square(dimension: 20),
          Text('Color', style: TextStyle(color: Colors.black)),
          ColorPicker(
              showColorValue: true,
              color: Color(_color),
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.accent: false
              },
              onColorChanged: onColorChanged)
        ],
      ),
    );
  }

  void saveCategory() {
    if (_formKey.currentState!.validate()) {
      save(
        context,
        _name.text,
        _color,
      );
    }
  }

  Future<void> save(BuildContext context, String name, int color) async {
    int? newId = 0;
    String message = '';

    newId = await Store.categories.insert(Category(
        id: _editMode() ? category!.id : null, name: name, color: color));
    if (newId != 0) {
      message = l10n.loc!.categorySaved(name);
      Navigator.pop(context);
    } else {
      message = l10n.loc!.errorCategoryNotSave;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool _editMode() {
    return category != null;
  }

  void onColorChanged(Color colorRef) {
    _color = colorRef.value;
  }
}
