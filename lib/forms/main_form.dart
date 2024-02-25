import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abc_notes/actions/app_actions.dart';

import 'categories_form.dart';
import '../l10n/l10n.dart';
import 'form_modes.dart';
import 'notes_form.dart';

// Create a Main Form widget.
class MainForm extends StatefulWidget {
  const MainForm();

  @override
  _MainFormState createState() {
    return _MainFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class _MainFormState extends State<MainForm> {
  late List<Widget> _forms;
  late List <List<Widget>> _actions;
  int _currentForm = 0 ;

  _MainFormState(){
    _forms = [NotesForm(mode: FormModes.edit),CategoriesForm(mode: FormModes.edit)];
    _actions = _buildActions();
  }

  @override
  Widget build(BuildContext context) {
    l10n.loc = AppLocalizations.of(context);
    var appTitle = l10n.loc!.appTitle;

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle,style: TextStyle(fontSize: 18)),
          actions: _actions[_currentForm],
        ),
        body: _forms[_currentForm],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.insights),
              label: AppLocalizations.of(context)!.notes,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet),
              label: AppLocalizations.of(context)!.categories,
            ),
          ],
          currentIndex: _currentForm,
          selectedItemColor: Colors.blue[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index){
    _currentForm = index;
    setState(() {

    });
  }

  // Update Icons from the forms
  List <List<Widget>> _buildActions(){
    final List <List<Widget>> actionList = [
        [IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              _callOnAction(1,AppActions.add);
            }),
          IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                _callOnAction(1,AppActions.delete);
              })
        ],
        [IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              _callOnAction(2,AppActions.add);
            }),
          IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                _callOnAction(2,AppActions.delete);
              })
        ]
      ];
    for (var index in [0,1]){
      actionList[index].add(IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            _callOnAction(index,AppActions.settings);
          }));
      actionList[index].add(IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            _callOnAction(index,AppActions.settings);
          }));
      actionList[index].add(IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            _callOnAction(index,AppActions.settings);
          }));
    }
    return actionList;
  }

  void _callOnAction(int index,AppActions action){
    (_forms[index] as FormActions).onAction(action);
  }
}