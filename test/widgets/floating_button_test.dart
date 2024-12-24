import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:abc_notes/widgets/floating_button.dart';

@GenerateNiceMocks([MockSpec<FakeButton>()])
import 'floating_button_test.mocks.dart';

class FakeButton {
  void onPressed(){
    print("fake onPressed");
  }
}

Future setupApp(WidgetTester tester,Function() onPressed) async {
  await tester.pumpWidget(MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('es'), // Spanish
      ],
      home: FloatingButton(onPressed: onPressed)
  ));
}

void main(){
  group("Test Floating button", (){

    testWidgets('Should validate initial state.', ( tester ) async {
      var fb = MockFakeButton();
      await setupApp(tester,fb.onPressed);
      final floatingButton = await find.byType(FloatingActionButton);
      await tester.tap(floatingButton);

      expect(floatingButton, findsOneWidget);
      expect(tester.widget(floatingButton),isA<FloatingActionButton>().having((f)=> f.backgroundColor,'backgroundColor',Colors.green ));
      expect(tester.widget(floatingButton),isA<FloatingActionButton>().having((f)=> f.foregroundColor,'foregroundColor',Colors.white ));
      expect(tester.widget(floatingButton),isA<FloatingActionButton>().having((f)=> f.onPressed,'onPressed', fb.onPressed ));
    });

    testWidgets('Should call onPressed after click.', ( tester ) async {
      var fb = MockFakeButton();
      await setupApp(tester,fb.onPressed);
      final floatingButton = await find.byType(FloatingActionButton);
      await tester.tap(floatingButton);
      verify(fb.onPressed()).called(1);
    });

  });

}