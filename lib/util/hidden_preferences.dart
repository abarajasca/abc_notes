class HiddenPreferences {
  String sortType;
  bool sortTitle;
  bool sortTime;
  bool sortCategory;

  HiddenPreferences({required this.sortType,required this.sortTitle,required this.sortTime,required this.sortCategory});

  @override
  String toString() {
    return "{ sortType: ${ this.sortType }, sortTitle: ${ this.sortTitle}, sortTime: ${ this.sortTime }, sortCategory: ${this.sortCategory} }";
  }
}