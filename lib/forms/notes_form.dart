import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../database/models/category.dart';
import '../database/models/note.dart';
import '../util/general_preferences.dart';
import '../actions/app_actions.dart';
import '../database/store/store.dart';
import '../mixins/settings.dart';
import '../util/preferences.dart';
import '../util/selectable.dart';
import '../l10n/l10n.dart';
import '../util/DateUtil.dart';
import '../widgets/floating_button.dart';
import '../export/export_as_text.dart';
import '../export/export_note.dart';


import 'form_modes.dart';
import 'main_form.dart';
import 'edit_note_form.dart';
import 'search_form.dart';

class NotesForm extends StatefulWidget implements FormActions {
  late FormModes mode;
  late _NotesFormState _notesFormState;
  late MainFormState _mainForm;
  late Map<AppActions, void Function()> _formActions;

  NotesForm({Key? key, required this.mode}) : super(key: key);

  @override
  State<NotesForm> createState() {
    _notesFormState = _NotesFormState();
    _notesFormState.registerParent(_mainForm);
    _formActions = _mapFormActions();
    return _notesFormState;
  }

  Map<AppActions, void Function()> _mapFormActions() {
    Map<AppActions, void Function()> formActions = {
      AppActions.add: _notesFormState.addNote,
      AppActions.delete: _notesFormState.delete,
      AppActions.export: _notesFormState.exportNotes,
      AppActions.import: _notesFormState.importNotes,
      AppActions.settings: _notesFormState.openSettings,
      AppActions.select: _notesFormState.updateSelect,
      AppActions.search: _notesFormState.search,
      AppActions.sort_title: _notesFormState.sort_title,
      AppActions.sort_category: _notesFormState.sort_category,
      AppActions.sort_time: _notesFormState.sort_time,
      AppActions.select_all: _notesFormState.select_all,
      AppActions.unselect_all: _notesFormState.unselect_all,
    };

    return formActions;
  }


  @override
  void onAction(AppActions action) {
    _formActions[action]!();
  }

  @override
  void registerParent(MainFormState mainForm) {
    _mainForm = mainForm;
  }
}

class _NotesFormState extends State<NotesForm> with Settings {
  late List<Selectable> dataModel;
  bool refreshData = true;
  late MainFormState _mainForm;
  bool showLastUpdate = false;
  late Map<AppActions,int Function(Selectable<dynamic>, Selectable<dynamic>)>  _sortComparators;
  late Map<AppActions,bool Function()> _sortTypes;


  _NotesFormState(){
    _sortComparators =  _mapSortComparators();
    _sortTypes = _mapSortTypes();
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
                  return ListTile(
                    title: noteTitle(dataModel[index].model),
                    onTap: () {
                      noteOnTap(dataModel[index]);
                    },
                    trailing: noteTrailing(dataModel[index]),
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
      floatingActionButton: FloatingButton(onPressed: () {
        addNote();
      }),
    );
  }

  Widget noteTitle(Note note){
    return
      Column(children: [
        Row(
          children: [
            Expanded(
                flex: 75,
                child: Text('${note.title}')),
            Expanded(
              flex: 25,
              child: Text(
                note.category.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10,
                    background: Paint()
                      ..color = Color(note.category.color)
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
            Text(
                '${DateUtil.formatUIDateTime(note.updated_at)}',
                style: TextStyle(fontSize: 10))
        ])
      ]);
  }

  StatefulBuilder? noteTrailing(Selectable<dynamic> model){
    return _mainForm.select == true
        ? StatefulBuilder(builder: (BuildContext context,
            StateSetter setStateInternal) {
            return Checkbox(
              value: model.isSelected,
              onChanged: (bool? value) {
                setStateInternal(() {
                  model.isSelected = value!;
                  refreshData = false;
                });
              },
            );
          })
        : null;
  }

  void noteOnTap(Selectable<dynamic> model) {
    if (widget.mode == FormModes.select) {
      Navigator.pop(context, model);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditNoteForm(
                  note: model.model)))
          .then((value) {
        setState(() {
          refreshData = true;
        });
      });
    }
  }

  Future<List<Selectable>> fetchData() async {
    if (refreshData) {
      List<Category> categories = (await Store.categories.getAll());
      dataModel =
          (await Store.notes.getAll()).map<Selectable<Note>>((Note note) {
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
        Store.notes.delete(item.model);
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
      await _saveNotesAsFiles(selectedDirectory);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.loc!.selectNotesToExport)));
    }
  }

  Future<void> _saveNotesAsFiles(String? selectedDirectory) async {
    ExportAsText exportAsText = new ExportAsText();
    ExportNote exportNote = ExportNote(selectedDirectory!,exportAsText);

    if (await Permission.manageExternalStorage.request().isGranted) {
      dataModel
          .where((element) => element.isSelected)
          .forEach((element) async {
            exportNote.export(element.model);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.loc!.notesExporterIn(selectedDirectory!))));
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
          var categoryList =
              await Store.categories.getAll(where: "name='${categoryName}'");
          if (categoryList.isEmpty) {
            // Create category
            var randColor = Random().nextInt(Colors.primaries.length);
            idCategory = (await Store.categories.insert(Category(
                name: categoryName,
                color: Colors.primaries[randColor].value)))!;
          } else {
            idCategory = categoryList.first.id!;
          }
          body = body.replaceFirst(bodyClean + '\n\n', '');
        }
        var now = DateUtil.getCurrentDateTime();
        await Store.notes.insert(Note(
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
      _mainForm.changeVisibility();
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

  Map<AppActions,bool Function()> _mapSortTypes() {
    return {
      AppActions.sort_time: () => _mainForm.sort_time ,
      AppActions.sort_title: () => _mainForm.sort_title ,
      AppActions.sort_category: () => _mainForm.sort_category ,
    };
  }

  Map<AppActions, int Function(Selectable<dynamic>,Selectable<dynamic>) > _mapSortComparators(){
    return {
      AppActions.sort_time: (x,y) => x.model.updated_at.compareTo(y.model.updated_at),
      AppActions.sort_title: (x,y) => x.model.title.compareTo(y.model.title) ,
      AppActions.sort_category: (x,y) => x.model.category.name.compareTo(y.model.category.name),
    };
  }

  void sort_data() {
    bool sort_order = _sortTypes[_mainForm.sort_type]!();

    dataModel.sort((a, b) {
      var x = a;
      var y = b;
      if (sort_order == false) {
        // true: ascending , false: descending  Change this please !! for 'asc' 'desc'
        x = b;
        y = a;
      }
      return _sortComparators[_mainForm.sort_type]!(x,y);
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
