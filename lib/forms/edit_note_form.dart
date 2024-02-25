import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
  State<EditNoteForm> createState() =>
      _EditNoteFormState(note: note);
}

class _EditNoteFormState extends State<EditNoteForm>
    with CustomForms {
  final _formKey = GlobalKey<FormState>();

  final title = TextEditingController();
  final body = TextEditingController();
  final date = TextEditingController();

  Note? note;
  late ModelProvider<Note> noteProvider;

  late List<Selectable> dataModel = [];
  bool refreshData = true;
  int dataLength = 0;

  _EditNoteFormState({this.note}) {
    loadFields();
    noteProvider = ModelProvider<Note>();
  }

  void loadFields() {
    title.text = note != null ? note!.title : '';
    body.text = note != null ? note!.body : '';
    date.text = note != null ? note!.date : '2000-01-01';
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
                  save(
                      context,
                      title.text,
                      body.text,
                      date.text);
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
                    editDescriptionForm(title),
                    BasicField(
                        l10n.loc!.title,
                        'title',
                        title,
                        TextInputType.text,
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^.{0,50}$'))),
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
      ) async {
    int? newId = 0;
    String message = '';

    newId = await noteProvider.insert(Note(
        id: _editMode() ? note!.id : null,
        title: title,
        body: body,
        date: date,
        idCategory: 1));
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

  bool _editMode() {
    return note != null;
  }

}
