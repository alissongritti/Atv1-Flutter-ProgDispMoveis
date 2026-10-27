import 'package:flutter_test/flutter_test.dart';
import 'package:atv01/app.dart'; // Importa o widget principal do seu app

void main() {
  testWidgets('Teste básico de inicialização', (WidgetTester tester) async {
    // Instancia o widget principal do seu aplicativo (ex: App ou ColetaApp)
    await tester.pumpWidget(const App());
  });
}
