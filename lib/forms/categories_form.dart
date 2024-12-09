import 'package:abc_notes/database/providers/model_provider.dart';
import 'package:flutter/material.dart';

import 'package:abc_notes/actions/app_actions.dart';
import 'package:abc_notes/database/models/category.dart';
import 'package:abc_notes/forms/edit_category_form.dart';

import '../database/store/store.dart';
import '../mixins/settings.dart';
import '../util/selectable.dart';
import '../l10n/l10n.dart';
import 'form_modes.dart';
import 'main_form.dart';

class CategoriesForm extends StatefulWidget implements FormActions {
  late FormModes mode;
  late _CategoriesFormState _categoriesFormState;
  late MainFormState _mainForm;

  CategoriesForm({Key? key, required this.mode}) : super(key: key);

  @override
  State<CategoriesForm> createState() {
    _categoriesFormState = _CategoriesFormState();
    _categoriesFormState.registerParent(_mainForm);
    return _categoriesFormState;
  }

  @override
  void onAction(AppActions action) {
    switch (action) {
      case AppActions.add:
        {
          _categoriesFormState.addCategory();
        }
        break;
      case AppActions.delete:
        {
          _categoriesFormState.delete();
        }
        break;
      case AppActions.settings:
        {
          _categoriesFormState.openSettings();
        }
        break;
      case AppActions.select:
        {
          _categoriesFormState.updateSelect();
        }
        break;
    }
  }

  @override
  void registerParent(MainFormState mainForm) {
    _mainForm = mainForm;
  }
}

class _CategoriesFormState extends State<CategoriesForm> with Settings {
  late List<Selectable> dataModel;
  late List<int> categoriesUsed;
  bool refreshData = true;
  late MainFormState _mainForm;

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
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 90,
                              child: Text('${dataModel[index].model.name}')),
                          Expanded(
                              flex: 10,
                              child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: new BoxDecoration(
                                    color: Color(dataModel[index].model.color),
                                    shape: BoxShape.circle,
                                  ))),
                        ],
                      ),
                      onTap: () {
                        if (widget.mode == FormModes.select) {
                          Navigator.pop(context, dataModel[index]);
                        } else {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditCategoryForm(
                                          category: dataModel[index].model)))
                              .then((value) {
                            setState(() {
                              refreshData = true;
                            });
                          });
                        }
                      },
                      trailing: _mainForm.select == true ?  Checkbox(
                          value: dataModel[index].isSelected,
                          onChanged: (bool? value) {
                            dataModel[index].isSelected = value!;
                            setState(() {});
                          },
                      ) : null,
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
          addCategory();
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<List<Selectable>> fetchData() async {
    if (refreshData) {
      categoriesUsed = (await Store.categories.rawQuery(
              'select distinct( id_category ) as idCategory from notes'))
          .map((item) {
        return item['idCategory'] as int;
      }).toList();
      dataModel = (await  Store.categories.getAll())
          .map((category) => Selectable(model: category, isSelected: false))
          .toList();
      dataModel.sort((a, b) {
        return a.model.name.compareTo(b.model.name);
      });
      refreshData = false;
    }
    return dataModel;
  }

  void addCategory() {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => EditCategoryForm()))
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
        if (!categoriesUsed.contains(item.model.id)) {
          if (item.model.id != 1) {
            deleted = true;
            Store.categories.delete(item.model);
          } else
            {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(l10n.loc!.categoryCantBeDeleted),
              ));
            }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(l10n.loc!.categoryUsedInNotes(item.model.name)),
          ));
        }
      }
    });
    return deleted;
  }

  PreferredSizeWidget? getAppBar() {
    if (widget.mode == FormModes.select) {
      return AppBar(
          backgroundColor: Colors.green,
          title: Text(l10n.loc!.categories, style: TextStyle(fontSize: 18)),
          centerTitle: false);
    } else {
      return null;
    }
  }

  void openSettings() {
    showSettings(context, (value) {});
  }

  void registerParent(MainFormState mainForm) {
    _mainForm = mainForm;
  }

  void updateSelect() {
    setState(() {
      _mainForm.changeVisibility();
        });
  }
}
