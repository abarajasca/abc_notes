class GeneralPreferences {
  String backgroundColor;
  bool showLastUpdate;

  GeneralPreferences({required this.backgroundColor,required this.showLastUpdate});

  @override
  String toString() {
    return "{ backgroudColor: ${ this.backgroundColor }, showLastUpdate: ${ this.showLastUpdate} }";
  }
}