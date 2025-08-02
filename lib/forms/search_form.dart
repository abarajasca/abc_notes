import 'package:abc_notes/l10n/l10n.dart';
import 'package:flutter/material.dart';
import '../util/selectable.dart';

class SearchForm extends SearchDelegate {
  List<Selectable> dataModel;

  @override
  String get searchFieldLabel => l10n.loc!.search;

  SearchForm({required this.dataModel});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          // When pressed here the query will be cleared from the search bar.
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Map<String,dynamic>> searchResults = dataModel
        .where((Selectable item) {
          return item.model.body.toLowerCase().contains(query.toLowerCase()) ||
              item.model.title.toLowerCase().contains(query.toLowerCase());
        })
        .map<Map<String,dynamic>>((Selectable item) => {'id': item.model.id,'title': item.model.title })
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index]['title']),
          onTap: () {
            // Handle the selected search result.
            //close(context, searchResults[index]);
            Navigator.of(context).pop(searchResults[index]['id']);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Map<String,dynamic>> suggestionList = query.isEmpty
        ? []
        : dataModel
            .where((Selectable item) {
              return item.model.body
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  item.model.title.toLowerCase().contains(query.toLowerCase());
            })
            .map<Map<String,dynamic>>((Selectable item) => {'id': item.model.id, 'title': item.model.title })
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]['title'],style: TextStyle(fontFamily: 'Quicksand')),
          onTap: () {
            query = suggestionList[index]['title'];
            // Show the search results based on the selected suggestion.
            Navigator.of(context).pop(suggestionList[index]['id']);
          },
        );
      },
    );
  }

  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        titleTextStyle: TextStyle(color:Colors.white,fontFamily: 'Quicksand'),
        toolbarTextStyle: theme.textTheme.bodyMedium,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: 'Quicksand'
        ),

      ),

      hintColor: Colors.white,

      inputDecorationTheme: searchFieldDecorationTheme ??
          InputDecorationTheme(
            hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
            border: InputBorder.none,
          ),
    );
  }

}
