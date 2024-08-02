import 'dart:io';
import 'dart:math';

import 'package:abc_notes/database/models/category.dart';
import 'package:abc_notes/database/models/note.dart';
import 'package:abc_notes/forms/edit_note_form.dart';
import 'package:abc_notes/forms/search_form.dart';
import 'package:abc_notes/util/general_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:abc_notes/database/providers/model_provider.dart';
import 'package:abc_notes/actions/app_actions.dart';
import '../mixins/settings.dart';
import '../util/preferences.dart';
import '../util/selectable.dart';
import '../l10n/l10n.dart';
import 'form_modes.dart';
import 'package:permission_handler/permission_handler.dart';

import 'main_form.dart';
import '../util/DateUtil.dart';

class NotesForm extends StatefulWidget implements FormActions {
  late FormModes mode;
  late _NotesFormState _notesFormState;
  late MainFormState _mainForm;

  NotesForm({Key? key, required this.mode}) : super(key: key);

  @override
  State<NotesForm> createState() {
    _notesFormState = _NotesFormState();
    _notesFormState.registerParent(_mainForm);
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
      case AppActions.import:
        _notesFormState.importNotes();
        break;
      case AppActions.settings:
        {
          _notesFormState.openSettings();
        }
        break;
      case AppActions.select:
        {
          _notesFormState.updateSelect();
        }
        break;
      case AppActions.search:
        _notesFormState.search();
        break;
      case AppActions.sort_title:
        _notesFormState.sort_title();
        break;
      case AppActions.sort_category:
        _notesFormState.sort_category();
        break;
      case AppActions.sort_time:
        _notesFormState.sort_time();
        break;
      case AppActions.select_all:
        _notesFormState.select_all();
        break;
      case AppActions.unselect_all:
        _notesFormState.unselect_all();
        break;
    }
  }

  @override
  void registerParent(MainFormState mainForm) {
    _mainForm = mainForm;
  }
}

class _NotesFormState extends State<NotesForm> with Settings {
  late List<Selectable> dataModel;
  bool refreshData = true;
  late ModelProvider<Note> noteProvider;
  late ModelProvider<Category> categoryProvider;
  late MainFormState _mainForm;
  bool showLastUpdate = false;

  _NotesFormState() {
    noteProvider = ModelProvider<Note>();
    categoryProvider = ModelProvider<Category>();
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
                    title: Column(children: [
                      Row(
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
                                    ..strokeWidth = 18
                                    ..strokeJoin = StrokeJoin.round
                                    ..strokeCap = StrokeCap.round
                                    ..style = PaintingStyle.stroke,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Row(children: [
                        if (showLastUpdate)
                          Text('${DateUtil.formatUIDateTime(dataModel[index].model.updated_at)}',
                              style: TextStyle(fontSize: 10))
                      ])
                    ]),
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
                    trailing: _mainForm!.select == true
                        ? StatefulBuilder(
                      builder: (BuildContext context,StateSetter setStateInternal) {
                        return Checkbox(
                          value: dataModel[index].isSelected,
                          onChanged: (bool? value) {
                            setStateInternal(() {
                              dataModel[index].isSelected = value!;
                              refreshData = false;
                            });
                          },
                        );
                      }
                    )
                        : null,
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
        foregroundColor: Colors.white,
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
      dataModel.forEach((item) {
        item.model.category = categories
            .firstWhere((element) => element.id == item.model.idCategory);
      });
      refreshData = false;
    }
    sort_data();
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
    showSettings(context, (GeneralPreferences generalPreferences) async {
      setState(() {
        showLastUpdate = generalPreferences.showLastUpdate;
      });
    });
  }

  Future<void> exportNotes() async {
    if (dataModel.any((element) => element.isSelected)) {
      String? selectedDirectory = await FilePicker.platform
          .getDirectoryPath(dialogTitle: l10n.loc!.selectFolder);
      if (selectedDirectory != null) {
        if (await Permission.manageExternalStorage.request().isGranted) {
          dataModel
              .where((element) => element.isSelected)
              .forEach((element) async {
            String nameFilePath =
                '$selectedDirectory/${element.model.title}.txt';
            String bodyContent =
                'category:${element.model.category.name}\n\n${element.model.body}';
            await File(nameFilePath).writeAsString(bodyContent);
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(l10n.loc!.notesExporterIn(selectedDirectory))));
        }
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.loc!.selectNotesToExport)));
    }
  }

  Future<void> importNotes() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true, type: FileType.custom, allowedExtensions: ['txt']);

    if (result != null) {
      int idCategory = 1;
      List<File> files = result.paths.map((path) => File(path!)).toList();
      files.forEach((file) async {
        var nameFile = file.path.split('/').last;
        var body = await file.readAsStringSync();
        var bodyClean = body.split('\n').first;
        if (bodyClean.contains('category:')) {
          var categoryName = bodyClean.split(':').last;
          var categoryList = await categoryProvider.getAll(
              Category.getDummyReference(),
              where: "name='${categoryName}'");
          if (categoryList.isEmpty) {
            // Create category
            var randColor = Random().nextInt(Colors.primaries.length);
            idCategory = (await categoryProvider.insert(Category(
                name: categoryName,
                color: Colors.primaries[randColor].value)))!;
          } else {
            idCategory = categoryList.first.id!;
          }
          body = body.replaceFirst(bodyClean + '\n\n', '');
        }
        var now = DateUtil.getCurrentDateTime();
        await noteProvider.insert(Note(
            title: nameFile.split('.').first,
            body: body,
            idCategory: idCategory,
            created_at: now,
            updated_at: now));
      });
      setState(() {
        refreshData = true;
      });
    } else {
      // User canceled the picker
    }
  }

  void updateSelect() {
    setState(() {
      if (_mainForm != null) {
        _mainForm!.changeVisibility();
      }
    });
  }

  void registerParent(MainFormState mainForm) {
    _mainForm = mainForm;
  }

  void search() {
    showSearch(context: context, delegate: SearchForm(dataModel: dataModel))
        .then((idQuery) {
      if (idQuery != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditNoteForm(
                    note: dataModel
                        .where((item) => item.model.id == idQuery)
                        .first
                        .model))).then((value) {
          setState(() {
            refreshData = true;
          });
        });
      }
    });
  }

  void sort_data() {
    bool sort_order = false;
    switch (_mainForm.sort_type) {
      case AppActions.sort_time:
        sort_order = _mainForm.sort_time;
        break;
      case AppActions.sort_title:
        sort_order = _mainForm.sort_title;
        break;
      case AppActions.sort_category:
        sort_order = _mainForm.sort_category;
        break;
    }
    dataModel.sort((a, b) {
      var x = a;
      var y = b;
      int sort_result = 0;
      if (sort_order == false) {
        x = b;
        y = a;
      }
      switch (_mainForm.sort_type) {
        case AppActions.sort_time:
          sort_result = x.model.created_at.compareTo(y.model.created_at);
          break;
        case AppActions.sort_title:
          sort_result = x.model.title.compareTo(y.model.title);
          break;
        case AppActions.sort_category:
          sort_result = x.model.category.name.compareTo(y.model.category.name);
          break;
      }
      return sort_result;
    });
  }

  void sort_title() {
    setState(() {
      refreshData = false;
      _mainForm.changeSortType(AppActions.sort_title);
    });
  }

  void sort_category() {
    setState(() {
      refreshData = false;
      _mainForm.changeSortType(AppActions.sort_category);
    });
  }

  void sort_time() {
    setState(() {
      refreshData = false;
      _mainForm.changeSortType(AppActions.sort_time);
    });
  }

  void select_all() {
    mark_select(true);
  }

  void unselect_all() {
    mark_select(false);
  }

  void mark_select(bool value) {
    setState(() {
      refreshData = false;
      dataModel.forEach((element) {
        element.isSelected = value;
      });
    });
  }
}
