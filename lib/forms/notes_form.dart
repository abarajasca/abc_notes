import 'dart:io';

import 'package:abc_notes/database/models/category.dart';
import 'package:abc_notes/database/models/note.dart';
import 'package:abc_notes/forms/edit_note_form.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:abc_notes/database/providers/model_provider.dart';
import 'package:abc_notes/actions/app_actions.dart';
import 'package:flutter/widgets.dart';
import '../mixins/settings.dart';
import '../util/selectable.dart';
import '../l10n/l10n.dart';
import 'form_modes.dart';
import 'package:path_provider/path_provider.dart';

class NotesForm extends StatefulWidget implements FormActions {
  late FormModes mode;
  late _NotesFormState _notesFormState;

  NotesForm({Key? key, required this.mode}) : super(key: key);

  @override
  State<NotesForm> createState() {
    _notesFormState = _NotesFormState();
    return _notesFormState;
  }

  @override
  void onAction(AppActions action) {
    switch (action) {
      case AppActions.add:
        {
          _notesFormState.addNote();
        }
        break;
      case AppActions.delete:
        {
          _notesFormState.delete();
        }
        break;
      case AppActions.export:
        _notesFormState.exportNotes();
        break;
      case AppActions.settings:
        {
          _notesFormState.openSettings();
        }
        break;
    }
  }
}

class _NotesFormState extends State<NotesForm> with Settings {
  late List<Selectable> dataModel;
  bool refreshData = true;
  late ModelProvider<Note> noteProvider;
  late ModelProvider<Category> categoryProvider;

  _NotesFormState() {
    noteProvider = ModelProvider<Note>();
    categoryProvider = ModelProvider<Category>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: FutureBuilder<List<Selectable>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: dataModel.length,
                itemBuilder: (BuildContext context, int index) {
                  Category category = dataModel[index].model.category;
                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(
                            flex: 75,
                            child: Text('${dataModel[index].model.title}')),
                        Expanded(
                          flex: 25,
                          child: Text(
                            category.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10,
                                background: Paint()
                                  ..color = Color(category.color)
                                  ..strokeWidth = 15
                                  ..strokeJoin = StrokeJoin.round
                                  ..strokeCap = StrokeCap.round
                                  ..style = PaintingStyle.stroke,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      if (widget.mode == FormModes.select) {
                        Navigator.pop(context, dataModel[index]);
                      } else {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditNoteForm(
                                        note: dataModel[index].model)))
                            .then((value) {
                          setState(() {
                            refreshData = true;
                          });
                        });
                      }
                    },
                    trailing:
                        Checkbox(
                        value: dataModel[index].isSelected,
                        onChanged: (bool? value) {
                          dataModel[index].isSelected = value!;
                          setState(() {});
                        },
                      ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return const Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNote();
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<List<Selectable>> fetchData() async {
    if (refreshData) {
      List<Category> categories =
          (await categoryProvider.getAll(Category.getDummyReference()));
      dataModel = (await noteProvider.getAll(Note.getDummyReference()))
          .map<Selectable<Note>>((Note note) {
        return Selectable(model: note, isSelected: false);
      }).toList();
      dataModel.sort((a, b) {
        return a.model.title.compareTo(b.model.title);
      });
      dataModel.forEach((item) {
        item.model.category = categories
            .firstWhere((element) => element.id == item.model.idCategory);
      });
      refreshData = false;
    }
    return dataModel;
  }

  void addNote() {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => EditNoteForm()))
        .then((value) {
      setState(() {
        refreshData = true;
      });
    });
  }

  void delete() {
    if (deleteItems(dataModel)) {
      refreshData = true;
      setState(() {});
    }
  }

  bool deleteItems(List<Selectable> dataModel) {
    bool deleted = false;

    dataModel.forEach((item) {
      if (item.isSelected) {
        deleted = true;
        noteProvider.delete(item.model);
      }
    });
    return deleted;
  }

  PreferredSizeWidget? getAppBar() {
    if (widget.mode == FormModes.select) {
      return AppBar(
          backgroundColor: Colors.green,
          title: Text(l10n.loc!.notes, style: TextStyle(fontSize: 18)),
          centerTitle: false);
    } else {
      return null;
    }
  }

  void openSettings() {
    showSettings(context, (value) {});
  }

  Future<void> exportNotes() async {
    if (dataModel.any((element) => element.isSelected)){
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath(dialogTitle: 'Select Folder to save exported notes.');
      if (selectedDirectory != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(selectedDirectory)),
        );

        if (await Permission.manageExternalStorage.request().isGranted) {
          dataModel.where((element) => element.isSelected).forEach((
              element) async {
            String nameFilePath = '$selectedDirectory/${element.model
                .title}.txt';
            await File(nameFilePath).writeAsString(element.model.body);
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Select first notes to export.'))
      );
    }
  }
}
