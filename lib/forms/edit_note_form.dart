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

class EditNoteForm extends StatefulWidget {
  Note? note;

  EditNoteForm({Key? key, this.note}) : super(key: key);

  @override
  State<EditNoteForm> createState() => _EditNoteFormState(note: note);
}

class _EditNoteFormState extends State<EditNoteForm> with CustomForms {
  final _formKey = GlobalKey<FormState>();
  late ModelProvider<Category> categoryProvider;
  late List<Category> _categoriesData;

  final title = TextEditingController();
  final body = TextEditingController();
  final date = TextEditingController();
  int idCategory = 0;

  Note? note;
  late ModelProvider<Note> noteProvider;

  _EditNoteFormState({this.note}) {
    loadFields();
    noteProvider = ModelProvider<Note>();
    categoryProvider = ModelProvider<Category>();
  }

  void loadFields() {
    title.text = note != null ? note!.title : '';
    body.text = note != null ? note!.body : '';
    date.text = note != null ? note!.date : '2000-01-01';
    idCategory = note != null ? note!.idCategory : 1;
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
          _editMode() ? l10n.loc!.editNote : l10n.loc!.addNote,
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.save, color: Colors.white),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  save(context, title.text, body.text, date.text, idCategory);
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
                    BasicField(
                        l10n.loc!.title,
                        'title',
                        title,
                        TextInputType.text,
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^.{0,50}$'))),
                    FutureBuilder<List<Category>>(
                        future: fetchCategories(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            return DropdownButtonFormField(
                                decoration: InputDecoration(
                                    labelText: l10n.loc!.category,
                                    labelStyle: TextStyle(color: Colors.black),
                                    fillColor: Colors.lightBlue),
                                items: _categoriesData
                                    .map((Category category) =>
                                        DropdownMenuItem(
                                            child: Text(category.name),
                                            value: category.id))
                                    .toList(),
                                value: idCategory,
                                onChanged: (dynamic value) {
                                  setState(() {
                                    idCategory = value;
                                  });
                                });
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        }),
                    Row(
                      children: [
                        Expanded(
                          flex: 50,
                          child: BasicField(
                              l10n.loc!.body,
                              'body',
                              body,
                              TextInputType.text,
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^.{0,50}$'))),
                        ),
                      ],
                    ),
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
    String title,
    String body,
    String date,
    int idCategory,
  ) async {
    int? newId = 0;
    String message = '';

    newId = await noteProvider.insert(Note(
        id: _editMode() ? note!.id : null,
        title: title,
        body: body,
        date: date,
        idCategory: idCategory));
    if (newId != 0) {
      message = l10n.loc!.noteSaved(title);
      Navigator.pop(context);
    } else {
      message = l10n.loc!.errorNoteNotSave;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<List<Category>> fetchCategories() async {
    _categoriesData =
        (await categoryProvider.getAll(Category.getDummyReference()))
            .map((category) => Category(id: category.id, name: category.name))
            .toList();
    _categoriesData.sort((a, b) {
      return a.name.compareTo(b.name);
    });

    return _categoriesData;
  }

  bool _editMode() {
    return note != null;
  }
}
