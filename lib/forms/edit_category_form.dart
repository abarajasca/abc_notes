import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../database/models/category.dart';
import '../database/models/note.dart';
import '../database/providers/model_provider.dart';
import '../mixins/custom_forms.dart';
import '../util/preferences.dart';
import '../util/selectable.dart';
import '../l10n/l10n.dart';

class EditCategoryForm extends StatefulWidget {
  Category? category;

  EditCategoryForm({Key? key, this.category}) : super(key: key);

  @override
  State<EditCategoryForm> createState() =>
      _EditCategoryFormState(category: category);
}

class _EditCategoryFormState extends State<EditCategoryForm>
    with CustomForms {
  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();

  Category? category;
  late ModelProvider<Category> categoryProvider;

  late List<Selectable> dataModel = [];
  bool refreshData = true;
  int dataLength = 0;

  _EditCategoryFormState({this.category}) {
    loadFields();
    categoryProvider = ModelProvider<Category>();
  }

  void loadFields() {
    name.text = category != null ? category!.name : '';
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
        title: Text(
          _editMode() ? l10n.loc!.editCategory : l10n.loc!.addCategory,
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.save, color: Colors.white),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  save(
                      context,
                      name.text,
                      );
                }
              }),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    editDescriptionForm(name),
                    BasicField(
                        l10n.loc!.categoryName,
                        'name',
                        name,
                        TextInputType.text,
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^.{0,50}$'))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> save(
      BuildContext context,
      String name
      ) async {
    int? newId = 0;
    String message = '';

    newId = await categoryProvider.insert(Category(
        id: _editMode() ? category!.id : null,
        name: name,
        ));
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

}
