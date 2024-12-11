import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../database/models/category.dart';
import '../database/models/note.dart';
import '../database/store/store.dart';
import '../mixins/custom_forms.dart';
import '../util/preferences.dart';
import '../l10n/l10n.dart';
import '../util/DateUtil.dart';
import '../widgets/floating_button.dart';

class EditNoteForm extends StatefulWidget {
  Note? note;

  EditNoteForm({Key? key, this.note}) : super(key: key);

  @override
  State<EditNoteForm> createState() => _EditNoteFormState(note: note);
}

class _EditNoteFormState extends State<EditNoteForm> with CustomForms {
  final _formKey = GlobalKey<FormState>();
  late List<Category> _categoriesData;

  final title = TextEditingController();
  final body = TextEditingController();
  String created_at = '';
  String updated_at = '';
  int idCategory = 0;

  Note? note;

  _EditNoteFormState({this.note}) {
    loadFields();
  }

  void loadFields() {
    title.text = note != null ? note!.title : '';
    body.text = note != null ? note!.body : '';
    created_at = note != null ? note!.created_at : '';
    updated_at = note != null ? note!.updated_at : '';
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
        backgroundColor: Colors.green,
        title: Text(
          _editMode() ? l10n.loc!.editNote : l10n.loc!.addNote,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        centerTitle: false,
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
                    Text(''),
                    Text(
                        'Last update: ${DateUtil.formatUIDateTime(updated_at)}'),
                    FutureBuilder<List<Category>>(
                        future: fetchCategories(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                    flex: 50, child: Text(l10n.loc!.category)),
                                Expanded(
                                    flex: 50,
                                    child: DropdownButtonFormField(
                                        items: _categoriesData
                                            .map((Category category) =>
                                                DropdownMenuItem(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .center,
                                                    child: Text(
                                                      category.name,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          background: Paint()
                                                            ..color = Color(
                                                                category.color)
                                                            ..strokeWidth = 18
                                                            ..strokeJoin =
                                                                StrokeJoin.round
                                                            ..strokeCap =
                                                                StrokeCap.round
                                                            ..style =
                                                                PaintingStyle
                                                                    .stroke,
                                                          color: Colors.white),
                                                    ),
                                                    value: category.id))
                                            .toList(),
                                        value: idCategory,
                                        onChanged: (dynamic value) {
                                          setState(() {
                                            idCategory = value;
                                          });
                                        }))
                              ],
                            );
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
                          child: TextField(
                            controller: body,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: l10n.loc!.body,
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey)),
                            ),
                          ),
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
      floatingActionButton:
          FloatingButton(onPressed: () => {saveNote()}, icon: Icons.save),
      // FloatingActionButton(
      //   onPressed: () {
      //     saveNote();
      //   },
      //   backgroundColor: Colors.green,
      //   child: Icon(Icons.save,color: Colors.white),
      // ),
    );
  }

  void saveNote() {
    if (_formKey.currentState!.validate()) {
      save(context, title.text, body.text, idCategory);
    }
  }

  Future<void> save(
    BuildContext context,
    String title,
    String body,
    int idCategory,
  ) async {
    int? newId = 0;
    String message = '';

    if (_editMode()) {
      updated_at = DateUtil.getCurrentDateTime();
    } else {
      created_at = DateUtil.getCurrentDateTime();
      updated_at = created_at;
    }
    newId = await Store.notes.insert(Note(
        id: _editMode() ? note!.id : null,
        title: title,
        body: body,
        created_at: created_at,
        updated_at: updated_at,
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
    _categoriesData = (await Store.categories.getAll())
        .map((category) => Category(
            id: category.id, name: category.name, color: category.color))
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
