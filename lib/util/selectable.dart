class Selectable<T> {
  final T model;
  bool isSelected;

  Selectable({required this.model, required this.isSelected});

  void checked(bool value) {
    isSelected = value;
  }
}
