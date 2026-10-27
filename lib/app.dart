import 'package:flutter/material.dart';

// O IMPORT ABAIXO É OBRIGATÓRIO PARA O DART ENCONTRAR A TELA:
import 'features/localizacoes/presentation/screens/tela_coleta.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coleta de Localizações',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: TelaColeta(),
    );
  }
}
