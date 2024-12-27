import 'package:abc_notes/actions/popup_menu.dart';
import 'package:abc_notes/util/hidden_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abc_notes/actions/app_actions.dart';

import '../util/preferences.dart';
import 'categories_form.dart';
import '../l10n/l10n.dart';
import 'form_modes.dart';
import 'notes_form.dart';

// Create a Main Form widget.
class MainForm extends StatefulWidget {
  const MainForm();

  @override
  MainFormState createState() {
    return MainFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MainFormState extends State<MainForm> {
  late List<Widget> _forms;
  late List<List<Widget>> _actions;
  int _currentForm = 0;
  bool select = false;
  bool sort_title = true;
  bool sort_category = true;
  bool sort_time = true;
  AppActions sort_type = AppActions.sort_title;
  late final AppLifecycleListener _listener;

  MainFormState() {
    _forms = [
      NotesForm(mode: FormModes.edit),
      CategoriesForm(mode: FormModes.edit)
    ];
    _actions = _buildActions();
    _forms.forEach((form) {
      (form as FormActions).registerParent(this);
    });
  }

  @override
  initState() {
    super.initState();

    _readHiddenPreferences();

    _listener = AppLifecycleListener(
        onShow: () => print('onShow'),
        onDetach: () => print('onDetach'),
        onInactive: () {
          _saveHiddenPreferences();
        },
        onPause: () => print('onPause'),
        onResume: () => {
          _readHiddenPreferences()
        },

    );
  }

  @override
  dispose() {
    _saveHiddenPreferences();
    _listener.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _saveHiddenPreferences();
    super.deactivate();
  }


  AppActions _getSortType(String sortType){
    AppActions sortT = AppActions.sort_title;
    switch(sortType){
      case "sort_title":
        sortT = AppActions.sort_title;
        break;
      case "sort_time":
        sortT = AppActions.sort_time;
        break;
      case "sort_category":
        sortT = AppActions.sort_category;
        break;
    }
    return sortT;
  }

  @override
  Widget build(BuildContext context) {
    l10n.loc = AppLocalizations.of(context);
    var appTitle = l10n.loc!.appTitle;

    return MaterialApp(
      theme: ThemeData(
          appBarTheme:
              AppBarTheme(iconTheme: IconThemeData(color: Colors.white))),
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(appTitle,
              style: TextStyle(fontSize: 18, color: Colors.white)),
          actions: _actions[_currentForm],
        ),
        body: _forms[_currentForm],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              key: ValueKey('bnbi-notes'),
              icon: Icon(Icons.notes),
              label: AppLocalizations.of(context)!.notes,
            ),
            BottomNavigationBarItem(
              key: ValueKey('bnbi-categories'),
              icon: Icon(Icons.category),
              label: AppLocalizations.of(context)!.categories,
            ),
          ],
          currentIndex: _currentForm,
          selectedItemColor: Colors.white,
          backgroundColor: Colors.green,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    _currentForm = index;
    setState(() {});
  }

  // Update Icons from the forms
  List<List<Widget>> _buildActions() {
    final List<List<Widget>> actionList = [[], []];

    // Notes Icon Buttons
    actionList[0].add(IconButton(
        icon: const Icon(Icons.search, color: Colors.white),
        onPressed: () {
          _callOnAction(0, AppActions.search);
        }));

    actionList[0].add(Visibility(
        visible: select,
        child: IconButton(
            key: ValueKey('icon-delete'),
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              _callOnAction(0, AppActions.delete);
            })));
    actionList[0].add(IconButton(
        key: ValueKey('icon-select'),
        icon: const Icon(Icons.select_all, color: Colors.white),
        onPressed: () {
          _callOnAction(0, AppActions.select);
        }));

    // Notes sort options popup menu
    actionList[0].add(
      PopupMenuButton<int>(
        icon: Icon(Icons.sort, color: Colors.white),
        onSelected: (index) => _callOnAdditionalMenu(PopupMenu.note_sort.index, index),
        itemBuilder: (context) => [
          PopupMenuItem<int>(
            value: NoteSortMenuItem.sort_by_time.index ,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.loc!.sortByTime),
                Icon( sort_time ?  Icons.arrow_downward: Icons.arrow_upward   , color: Colors.black, size: 18),
              ],
            ),
          ),
          PopupMenuItem<int>(
            value: NoteSortMenuItem.sort_by_title.index,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.loc!.sortByTitle),
                Icon( sort_title ? Icons.arrow_downward : Icons.arrow_upward , color: Colors.black, size: 18),
              ],
            ),
          ),
          PopupMenuItem<int>(
            value: NoteSortMenuItem.sort_by_category.index,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.loc!.sortByCategory),
                  Icon(sort_category ? Icons.arrow_downward : Icons.arrow_upward  , color: Colors.black, size: 18)
                ]),
          )
        ],
      ),
    );

    // add additional popup menu for notes.

    actionList[0].add(
      PopupMenuButton<int>(
        icon: Icon(Icons.more_vert, color: Colors.white),
        onSelected: (index) => _callOnAdditionalMenu(PopupMenu.note_options.index , index),
        itemBuilder: (context){
          List<PopupMenuEntry<int>> menuItemsAdditional = [];
          if (select ) {
            menuItemsAdditional = [
              PopupMenuItem<int>(value: NoteOptionsMenuItem.export.index, child: Text(l10n.loc!.export)),
              PopupMenuItem<int>(value: NoteOptionsMenuItem.import.index, child: Text(l10n.loc!.import)),
              PopupMenuDivider(),
              PopupMenuItem<int>(value: NoteOptionsMenuItem.select_all.index, child: Text('Select all')),
              PopupMenuItem<int>(value: NoteOptionsMenuItem.unselect_all.index, child: Text('Unselect all')),
              PopupMenuDivider(),
              PopupMenuItem<int>(value: NoteOptionsMenuItem.settings.index, child: Text(l10n.loc!.settings)),
            ];
          } else {
            menuItemsAdditional = [
              PopupMenuItem<int>(value: NoteOptionsMenuItem.import.index, child: Text(l10n.loc!.import)),
              PopupMenuDivider(),
              PopupMenuItem<int>(value: NoteOptionsMenuItem.settings.index, child: Text(l10n.loc!.settings))
            ];
          }
          return menuItemsAdditional;
        },
      ),
    );

    // Categories Icon buttons
    actionList[1].add(Visibility(
        visible: select,
        child: IconButton(
            key: ValueKey('icon-delete'),
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              _callOnAction(1, AppActions.delete);
            })));
    actionList[1].add(IconButton(
        key: ValueKey('icon-select'),
        icon: const Icon(Icons.select_all, color: Colors.white),
        onPressed: () {
          _callOnAction(1, AppActions.select);
        }));

    // Popup menu for Categories.
    actionList[1].add(
      PopupMenuButton<int>(
        onSelected: (index) => _callOnAdditionalMenu(PopupMenu.category_settings.index, index),
        itemBuilder: (context) => [
          PopupMenuItem<int>(value: CategorySettingsMenuItem.settings.index, child: Text(l10n.loc!.settings)),
        ],
      ),
    );
    return actionList;
  }

  void _callOnAction(int index, AppActions action) {
    (_forms[index] as FormActions).onAction(action);
  }

  void _callOnAdditionalMenu(int popupId, int index) {
    switch (popupId) {
      case 0 :  // Note sort menu
        switch (index) {
          case 0 :
            (_forms[0] as FormActions).onAction(AppActions.sort_time);
            break;
          case 1:
            (_forms[0] as FormActions).onAction(AppActions.sort_title);
            break;
          case 2:
            (_forms[0] as FormActions).onAction(AppActions.sort_category);
            break;
        }
        break;
      case 1:  // Notes options menu
        switch (index) {
          case 0:
            (_forms[0] as FormActions).onAction(AppActions.export);
            break;
          case 1:
            (_forms[0] as FormActions).onAction(AppActions.import);
            break;
          case 2:
            (_forms[0] as FormActions).onAction(AppActions.select_all);
            break;
          case 3:
            (_forms[0] as FormActions).onAction(AppActions.unselect_all);
            break;
          case 4:
            (_forms[0] as FormActions).onAction(AppActions.settings);
            break;
        }
        break;
      case 2:  // Settings category menu
        switch (index) {
          case 0:
            (_forms[1] as FormActions).onAction(AppActions.settings);
            break;
        }
        break;
    }
  }

  void changeVisibility() {
    setState(() {
      select = !select;
      _actions = _buildActions();
    });
  }

  void changeSortType(AppActions action) {
    setState(() {
      select = !select;
      switch(action){
        case AppActions.sort_title:
          sort_title = !sort_title;
          break;
        case AppActions.sort_category:
          sort_category = !sort_category;
          break;
        case AppActions.sort_time:
          sort_time = !sort_time;
          break;
      }
      sort_type = action;
      _actions = _buildActions();
    });
  }

  void _readHiddenPreferences(){
    Preferences.readHiddenPreferences().then( (hiddenPreferences) {
      setState(() {
        sort_type = _getSortType(hiddenPreferences.sortType);
        sort_title = hiddenPreferences.sortTitle;
        sort_time = hiddenPreferences.sortTime;
        sort_category = hiddenPreferences.sortCategory;
      });
    });
  }

  void _saveHiddenPreferences() {
    HiddenPreferences hiddenPreferences = HiddenPreferences(
        sortType: sort_type.name,
        sortTitle: sort_title,
        sortTime: sort_time,
        sortCategory: sort_category);
    Preferences.saveHiddenPreferences(hiddenPreferences);
  }
}
