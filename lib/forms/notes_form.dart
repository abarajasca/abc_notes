import 'package:abc_notes/database/models/category.dart';
import 'package:abc_notes/database/models/note.dart';
import 'package:abc_notes/forms/edit_note_form.dart';
import 'package:flutter/material.dart';
import 'package:abc_notes/database/providers/model_provider.dart';
import 'package:abc_notes/actions/app_actions.dart';
import '../mixins/settings.dart';
import '../util/selectable.dart';
import '../l10n/l10n.dart';
import 'form_modes.dart';

class NotesForm extends StatefulWidget implements FormActions {
  late FormModes mode;
  late _NotesFormState _notesFormState;

  NotesForm({Key? key,required this.mode}) : super(key: key);

  @override
  State<NotesForm> createState() {
    _notesFormState =  _NotesFormState();
    return _notesFormState;
  }

  @override
  void onAction(AppActions action) {
    switch ( action ){
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
  bool refreshData=true;
  late ModelProvider<Note> noteProvider;

  _NotesFormState(){
    noteProvider = ModelProvider<Note>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: FutureBuilder<List<Selectable>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.connectionState == ConnectionState.done ) {
              return ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: dataModel.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      title: Text('${dataModel[index].model.title}'),
                      onTap: (){
                        if (widget.mode == FormModes.select) {
                          Navigator.pop(context,dataModel[index]);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditNoteForm(note: dataModel[index].model)))
                              .then((value) {
                            setState(() {
                              refreshData = true;
                            });
                          });
                        }
                      },
                      trailing: Checkbox(
                        value: dataModel[index].isSelected,
                        onChanged: (bool? value) {
                          dataModel[index].isSelected = value!;
                          setState(() { });
                        },
                      )
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
    );
  }

  Future<List<Selectable>> fetchData() async {
    if (refreshData) {
      dataModel =  (await noteProvider.getAll(Note.getDummyReference() ))
          .map((note) => Selectable(model: note, isSelected: false))
          .toList();
      dataModel.sort((a,b){
        return a.model.title.compareTo(b.model.title);
      });
      refreshData = false;
    }
    return dataModel;
  }

  void addNote(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditNoteForm()))
        .then((value) {
      setState(() {
        refreshData = true;
      });
    });
  }

  void delete(){
    if (deleteItems(dataModel)){
      refreshData = true;
      setState(() {});
    }
  }

  bool deleteItems(List<Selectable> dataModel) {
    bool deleted = false;

    dataModel.forEach((item)  {
      if (item.isSelected) {
        deleted = true;
        noteProvider.delete(item.model);
      }
    });
    return deleted;
  }

  PreferredSizeWidget? getAppBar(){
    if (widget.mode == FormModes.select){
      return AppBar(
          title: Text( l10n.loc!.notes,style: TextStyle(fontSize: 18)),
          centerTitle: false
      );
    } else {
      return null;
    }
  }

  void openSettings(){
    showSettings(context,(value){});
  }
}
