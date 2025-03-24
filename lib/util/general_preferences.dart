class GeneralPreferences {
  String backgroundColor;
  bool showLastUpdate;
  bool closeNoteAfterSave;

  GeneralPreferences({required this.backgroundColor,required this.showLastUpdate, required this.closeNoteAfterSave});

  @override
  String toString() {
    return "{ backgroudColor: ${ this.backgroundColor }, showLastUpdate: ${ this.showLastUpdate} closeNoteAfterSave: ${ this.closeNoteAfterSave } }";
  }
}