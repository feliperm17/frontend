import 'package:flutter/material.dart';
import 'screens/produto_screen.dart';  // Adicione essa importação

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const ProdutoScreen(),  // Agora ProdutoScreen deve estar disponível
    );
  }
}
