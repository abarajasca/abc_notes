import 'package:flutter/material.dart';

import '../database/models/note.dart';
import '../database/models/category.dart';
import '../database/providers/model_provider.dart';
import '../util/selectable.dart';

class SearchForm extends SearchDelegate {
  List<Selectable> dataModel;
  final List<String> searchList = [
    "Apple",
    "Banana",
    "Cherry",
    "Date",
    "Fig",
    "Grapes",
    "Kiwi",
    "Lemon",
    "Mango",
    "Orange",
    "Papaya",
    "Raspberry",
    "Strawberry",
    "Tomato",
    "Watermelon",
  ];

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
          title: Text(suggestionList[index]['title']),
          onTap: () {
            query = suggestionList[index]['title'];
            // Show the search results based on the selected suggestion.
            Navigator.of(context).pop(suggestionList[index]['id']);
          },
        );
      },
    );
  }
}
