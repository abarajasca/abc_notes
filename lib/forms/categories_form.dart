import 'package:abc_notes/database/models/category.dart';
import 'package:abc_notes/forms/edit_category_form.dart';
import 'package:flutter/material.dart';
import 'package:abc_notes/database/providers/model_provider.dart';
import 'package:abc_notes/actions/app_actions.dart';
import '../mixins/settings.dart';
import '../util/selectable.dart';
import '../l10n/l10n.dart';
import 'form_modes.dart';

class CategoriesForm extends StatefulWidget implements FormActions {
  late FormModes mode;
  late _CategoriesFormState _categoriesFormState;

  CategoriesForm({Key? key,required this.mode}) : super(key: key);

  @override
  State<CategoriesForm> createState() {
    _categoriesFormState =  _CategoriesFormState();
    return _categoriesFormState;
  }

  @override
  void onAction(AppActions action) {
    switch ( action ){
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
    }
  }
}

class _CategoriesFormState extends State<CategoriesForm> with Settings {
  late List<Selectable> dataModel;
  bool refreshData=true;
  late ModelProvider<Category> categoryProvider;

  _CategoriesFormState(){
    categoryProvider = ModelProvider<Category>();
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
                      title: Text('${dataModel[index].model.name}'),
                      onTap: (){
                        if (widget.mode == FormModes.select) {
                          Navigator.pop(context,dataModel[index]);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditCategoryForm(category: dataModel[index].model)))
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
      dataModel =  (await categoryProvider.getAll(Category.getDummyReference() ))
          .map((category) => Selectable(model: category, isSelected: false))
          .toList();
      dataModel.sort((a,b){
        return a.model.name.compareTo(b.model.name);
      });
      refreshData = false;
    }
    return dataModel;
  }

  void addCategory(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditCategoryForm()))
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
        categoryProvider.delete(item.model);
      }
    });
    return deleted;
  }

  PreferredSizeWidget? getAppBar(){
    if (widget.mode == FormModes.select){
      return AppBar(
          title: Text( l10n.loc!.categories,style: TextStyle(fontSize: 18)),
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
