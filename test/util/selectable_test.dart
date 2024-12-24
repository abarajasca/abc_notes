import 'package:abc_notes/util/selectable.dart';
import 'package:test/test.dart';

void main(){
  group('Test on selectable,', (){
    test('should show initial state', (){
      var testObject = TestObject();
      testObject.value = 10;
      var selectable = Selectable<TestObject>(model: testObject, isSelected:  false);

      expect( selectable.model, testObject);
      expect( selectable.model.value,10);
      expect( selectable.isSelected , false);
    });
  });
}

class TestObject {
  int value = 0 ;
}